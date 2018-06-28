/**********************************************************************************************************************
*   Market Traders Institute, Inc.    CONFIDENTIAL
* ---------------------------------------------------------------------------------------------------------------------
*   [2015] Market Traders Institute
*   All Rights Reserved
*
*   NOTICE:  All information contained herein is, and remains the property of Market Traders Institute, Inc. and its
*   suppliers, if any.  The intellectual and technical concepts contained herein are proprietary to Market Traders 
*   Institute, Inc. and its suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are 
*   protected by trade secret or copyright law.  Dissemination of this information or reproduction of this material
*   is strictly forbidden unless prior written permission is obtained from Market Traders Institute, Inc.
*
*   Date Created:       ???
*   Author:             ???
*   Last Modified:      5/4/2015
*   Last Modified By:   Asha Calderon
*
*   
*   
**********************************************************************************************************************/
global class AccountMerger implements Database.Batchable<sObject>{

    global final String Query;
    global final set<Id> accountIds;
    global static Account masterAccountPreMerge;
    global static Id postMergeAccountId;
    
    global class AccountMergeException extends Exception { }
    

    global AccountMerger(set<Id> accountIds){
        this.accountIds = accountIds;
        this.Query = 'SELECT id,PersonEmail,Alternate_Email__c,CreatedDate FROM Account WHERE Id IN :accountIds';
    }
    

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> accounts){
        Handler_Account.BYPASS = true;
        AccountMerger.mergeAccounts(accounts);
    }

    global void finish(Database.BatchableContext BC){
   
    }
    
    @future
    public static void mergeaccountasynch(Set<ID> accounts){
      List<Account> listofaccts = [SELECT id,PersonEmail,Alternate_Email__c,CreatedDate FROM Account WHERE Id IN :accounts];
        Handler_Account.BYPASS = true;
        AccountMerger.mergeAccounts(listofaccts);  
    }

    /****************************
    * @method mergeAccounts
    *
    * @description
    * Query accounts with the same email address as the email/alternate email in the accounts list (relatedAccounts)
    * Create a map of oldest account to email address (accountMap)
    * Iterate through the relatedAccounts and merge accounts with matching email to oldest account using the accountMap
    * - Make a copy of account before merging (masterAccountPreMerge)
    * - Check against custom setting (AccountFieldBlacklist) to see what fields on master account need to be maintained  
    *   update those fields with the data saved in the copy of the account after merging to verify retained data
    * - Only merge if the newer account does not have any Closed Won Opportunities with amounts greater than 0
    * - if there are any Opportunities that fit the above on the account then send an email to the admins 
    *   - list of admins maintained by custom setting (LoggerEmailRecipients)
    * Create a attachment of the new account object as a JSON serialized record and attach to the oldest account (PrimaryMergeAccount)
    *
    * @param accounts - list of accounts
    *
    ****************************/
    public static void mergeAccounts(list<Account> accounts){
       try{
            set<String> emails = new set<String>();
            for(Account account: accounts){
                if(account.PersonEmail != null){
                    emails.add(account.PersonEmail);
                }    
                if(account.Alternate_Email__c != null){
                    emails.add(account.Alternate_Email__c);
                }     
            }
            
            set<String> requiredFields = new set<String>{'Id','PersonEmail','Alternate_Email__c','CreatedDate'};
            list<Account_Merger__c> accountMergerSettings = Account_Merger__c.getall().values();
            list<AccountFieldBlacklist__c> leadfieldsbl = AccountFieldBlacklist__c.getall().values();
            
            String SOQL = 'SELECT ';
            
            for(String requiredField : requiredFields){
                SOQL += requiredField + ',';  
            }

            for (Account_Merger__c mergerSetting : accountMergerSettings){
                if(!requiredFields.contains(mergerSetting.Field_Name__c) && !mergerSetting.Field_Name__c.contains(' ')){
                    SOQL += mergerSetting.Field_Name__c + ',';
                    requiredFields.add(mergerSetting.Field_Name__c);
                }
            } 
            for(AccountFieldBlacklist__c fieldname : leadfieldsbl){
                if(!requiredFields.contains(fieldname.Field_APIName__c) && !fieldname.Field_APIName__c.contains(' ')){
                    SOQL += fieldname.Field_APIName__c + ',';
                    requiredFields.add(fieldname.Field_APIName__c);
                }
            }
            SOQL += ' (SELECT id,AccountId,StageName FROM Opportunities WHERE (StageName = \'Closed Won\' AND Amount > 0))';
            SOQL += ' FROM Account';
            SOQL += ' WHERE (PersonEmail IN :emails OR Alternate_Email__c IN :emails)';
            SOQL += ' ORDER by CreatedDate ASC';
            SOQL += ' LIMIT 50000'; 
            System.debug('@asha: @debug: AccountMerger : Query '+ SOQL);
            list<Account> relatedAccounts = Database.query(SOQL);
            System.debug('@asha: @debug: AccountMerger: Accounts returned: '+  relatedAccounts.size()); 
            map<String,Account> accountMap = new map<String,Account>();
            set<id> MasterAccountIds = new Set<id>();
            
            for(Account account : relatedAccounts){                
                if(account.PersonEmail != null){
                    if(accountMap.get(account.PersonEmail) == null){
                        accountMap.put(account.PersonEmail,account);
                        MasterAccountIds.add(account.id);
                    }
                }
                
                if(account.Alternate_Email__c != null){
                    if(accountMap.get(account.Alternate_Email__c) == null){
                        accountMap.put(account.Alternate_Email__c,account);
                       MasterAccountIds.add(account.id);
                    }
                }
            }
            
            //@info: aac 4.22.15 added query to prevent fields such as createddate which is read only from causing an error during merge                                  
            Map<id,Account> acctIDMap = new Map<id,Account>([Select id From Account Where id in :MasterAccountIds]);
         
            for(Integer i = 0; i < relatedAccounts.size() ; i++){
                       Account CurrentAccount = relatedAccounts[relatedAccounts.size() - (i+1)];
                       
                       //@info: determines if Closed Won Opps exist for the account
                       Boolean found = findOppsClsdWon(CurrentAccount.Opportunities);
                        
                       System.debug('@asha: @debug: AccountMerger: Current Acct id: '+CurrentAccount.id+' CreatedDate: '+ CurrentAccount.CreatedDate +' Alt Email:'+CurrentAccount.Alternate_Email__c+' Prim Email: '+CurrentAccount.PersonEmail  );
                       
                       Account PrimaryMergeAccount = null;
                       Account AlternateMergeAccount = null;
                       
                       if(CurrentAccount.PersonEmail != null && CurrentAccount.Alternate_Email__c != null){ 
                           PrimaryMergeAccount = accountMap.get(CurrentAccount.PersonEmail);
                           AlternateMergeAccount = accountMap.get(CurrentAccount.Alternate_Email__c);
                           PrimaryMergeAccount = PrimaryMergeAccount.CreatedDate <= AlternateMergeAccount.CreatedDate ? PrimaryMergeAccount : AlternateMergeAccount;
                       }else{
                           PrimaryMergeAccount = (CurrentAccount.PersonEmail != null) ? accountMap.get(CurrentAccount.PersonEmail) : null;
                           AlternateMergeAccount = (CurrentAccount.Alternate_Email__c != null) ? accountMap.get(CurrentAccount.Alternate_Email__c) : null;
                           PrimaryMergeAccount = (PrimaryMergeAccount != null) ? PrimaryMergeAccount : AlternateMergeAccount;         
                       }    
                       
                       System.debug('@asha: @debug: AccountMerger: Primary Merge '+PrimaryMergeAccount );
                       if(!found){
                           if(PrimaryMergeAccount != null){ 
                               if(PrimaryMergeAccount.id != CurrentAccount.id){
                                    
                                    //copies over data from dup if master is blank
                                    copyDupData(PrimaryMergeAccount, CurrentAccount);
                                    
                                    Attachment duplicateAccountAttachment = new Attachment();
                                    duplicateAccountAttachment.ContentType = '.json';
                                    duplicateAccountAttachment.Description = 'This document contains the values of a merged account';
                                    duplicateAccountAttachment.Name = 'Merged Account:' + DateTime.now();
                                    duplicateAccountAttachment.ParentId = PrimaryMergeAccount.id;
                                    duplicateAccountAttachment.body = Blob.valueOf(JSON.serialize(CurrentAccount));
                                    
                                    list<AccountHistory> oppFieldHistory = [SELECT Id,NewValue,OldValue,AccountId,Field,CreatedDate FROM AccountHistory WHERE AccountId = :CurrentAccount.Id ORDER BY CreatedDate limit 50000];
                                    
                                    Attachment duplicateAccountHistoryAttachment = new Attachment();
                                    duplicateAccountHistoryAttachment.ContentType = '.json';
                                    duplicateAccountHistoryAttachment.Description = 'This document contains the history of a merged account';
                                    duplicateAccountHistoryAttachment.Name = 'Merged Account History:' + CurrentAccount.Id;
                                    duplicateAccountHistoryAttachment.ParentId = PrimaryMergeAccount.id;
                                    duplicateAccountHistoryAttachment.body = Blob.valueOf(JSON.serialize(oppFieldHistory));
                                   //@info: aac 4.22.15 added to prevent fields such as createddate which is read only from causing an error during merge
                                    Account masterAcct = acctIDMap.get(PrimaryMergeAccount.id);
                                    Database.MergeResult result = Database.merge(masterAcct, CurrentAccount.ID ,false);
                                    
                                    if(result.isSuccess()){
                                        //@info: added by aac 4.10.15 to send merge email & handle account merging with specific fields
                                        postMergeAccountId = result.getId();
                                        List<String> emailstrs = new List<String>();
                                        emailstrs.add('sfdev@markettraders.com');
                                        List<LoggerEmailRecipients__c> emaillist = LoggerEmailRecipients__c.getAll().values();
                                        For(LoggerEmailRecipients__c e : emaillist){
                                            if(e.Admin__c && e.Users_Email__c != null){                 
                                                emailstrs.add(e.Users_Email__c);    
                                            }
                                        }          
                                      
                                       String adminmsg = 'Please check account record ' +postMergeAccountId + '<br/>';
                                       adminmsg += 'Check merge history in attachment = Merged Account History:'+ postMergeAccountId+ '<br/><br/>';
                                       adminmsg += 'Account can be found here: http://login.salesforce.com/'+ postMergeAccountId + '<br/>';
                                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                                        emailstrs.add('sfdev@markettraders.com');
                                        emailstrs.add(UserInfo.getUserEmail());
                                        mail.setToAddresses(emailstrs);
                                        mail.setReplyTo('sfdev@markettraders.com');
                                        mail.setSenderDisplayName('MTI Account Merger');
                                        mail.setSubject('Account Duplicate Found - Merged Account Info');
                                        mail.setHtmlBody(adminmsg);          
                            
                                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                                        updateMasterAccount(postMergeAccountId, masterAccountPreMerge);
                                        Database.insert(duplicateAccountAttachment);
                                        Database.insert(duplicateAccountHistoryAttachment);
                                    }
    
                            }else{
                               System.debug('@asha: @debug: AccountMerger: id were the same CA: '+CurrentAccount+' Master: '+PrimaryMergeAccount);  
                            } //@info:end primary and current ids match                     
                        } //@info:end primary account null
                      }else{
                            if(PrimaryMergeAccount.id != CurrentAccount.id){
                                //@info: send email if Current Account has Opps that are closed won with amounts greater than 0
                                Logger logger = new Logger('DID NOT MERGE ACCOUNT : ACCOUNTMERGER');   
                                List<String> emailstrs = new List<String>();
                                emailstrs.add('sfdev@markettraders.com');
                                List<LoggerEmailRecipients__c> emaillist = LoggerEmailRecipients__c.getAll().values();
                                For(LoggerEmailRecipients__c e : emaillist){
                                    if(e.Admin__c){
                                        emailstrs.add(e.Users_Email__c);    
                                    }
                                }   
                               String msg ='Account was not auto-merged because it has at least one opportunity in closed won status with an amount greater than 0.<br/> Possible Duplicate:' + CurrentAccount.id+'<br/>Master Account: '+PrimaryMergeAccount.id;
                               logger.log(msg);
                               logger.emailDebugResults(emailstrs);
                               system.debug('@asha: @debug: AccountMerger: Account found had closed won opp - Dup Account: '+CurrentAccount.id);
                            }
                    }   
              }          
                 
        }catch(Exception ex){
            Logger logger = new Logger('CRITICAL ERROR: AccountMerger');
            logger.log(ex.getMessage());
            logger.log(ex.getStackTraceString());
            logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});
            system.debug(ex);
        }
    }
    
    /****************************
    * @method findOppsClsdWon
    *
    * @description:
    * method added to determine if any closed won opps exist
    * if there are closed won opps the account merger does not proceed
    *
    * @params allOpps List<Opportunity> the Opportunities from the account query
    *
    ****************************/
    public static Boolean findOppsClsdWon(List<Opportunity> allOpps){
        boolean foundopps = false;
        for(Opportunity opp: allOpps){
            foundopps = true;
            break;
        }
        return foundopps;
    }
    

    /**
    * @method updateMasterAccount
    *
    * @description
    * method added to prevent any of the black listed fields from being copied from the dup
    *  
    * @since 4.9.15
    * 
    * @params oldmaster the copy of the master account
    * @params newmasterID the id of the resulting master account after the merge
    *
    */
    public static void updateMasterAccount(ID newmasterID, Account oldmaster){
    if(oldmaster != null){
        String acctqrystr = 'Select id, ';   
        
        List<AccountFieldBlacklist__c> apinames = AccountFieldBlacklist__c.getAll().values();
        
        Set<String> allfields = new Set<String>();
        
        for(AccountFieldBlacklist__c fieldname : apinames){
            if(!allfields.contains(fieldname.Field_APIName__c) && !fieldname.Field_APIName__c.contains(' ')){
             acctqrystr += fieldname.Field_APIName__c+ ',';  
                allfields.add(fieldname.Field_APIName__c);
            }    
        }
        
        acctqrystr = acctqrystr.substring(0,acctqrystr.length()-1);
        acctqrystr += ' From Account WHERE id = \''+newmasterID+'\' Limit 1';
        
        List<Account> acctList = Database.query(acctqrystr);
        
        if(acctlist.size() > 0){
            for(AccountFieldBlacklist__c fieldname : apinames){
                acctlist[0].put(fieldname.Field_APIName__c, oldmaster.get(fieldname.Field_APIName__c));
            }
            update acctlist[0];                  
        }
            
        
      }
    }
    
    /****************************
    * @method copyDupData
    *
    * @description
    * method copies over data from the dupAcct to the master if 
    *  
    * @since 4.9.15
    * 
    * @params oldmaster the copy of the master account
    * @params newmasterID the id of the resulting master account after the merge
    *
    ****************************/ 
    public static void copyDupData(Account masterAcct, Account dupAccount){
        List<Account_Merger__c> listofAcctFields = Account_Merger__c.getAll().values();
        for(Account_Merger__c am : listofAcctFields){
            if(am.copyFromDup__c){
                Object fielddata = (masterAcct.get(am.Field_Name__c) == null) ? dupAccount.get(am.Field_Name__c) : masterAcct.get(am.Field_Name__c);
                masterAcct.put(am.Field_Name__c, fielddata);
            }       
        } 
        update masterAcct;   
    }
   

   
}