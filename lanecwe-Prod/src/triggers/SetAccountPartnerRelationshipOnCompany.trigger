/*********************************************************************
Name : SetAccountPartnerRelationshipOnCompany 
Created On : jan 16, 2012  
Created By : Lalit Bohra
Description : Trigger on Company for creating the account object and assign it to company.account.
Task :T-22134
New Modification -> We have resolved the issue related to circular dependency Dated = 20 FEb 2012 
New Modification -> T-33761 - > Partner Integration - To manage iMeet Companies. = 24 FEb 2012 
**********************************************************************/
trigger SetAccountPartnerRelationshipOnCompany on Company__c (before insert,before update){
    // getting the PGI ntegration User Id for updating the lead.LeadSource when ever record is being inserted by PGI ntegration User.       
    Id PGIntegrationUserId;
    PGIAppStaticResources staticResources = PGIAppStaticResources.getInstance();
    if (staticResources.pgiIntegrationUser != null)
    {
        PGIntegrationUserId = staticResources.pgiIntegrationUser.Id;
    }
    if(test.isRunningTest() || PGIntegrationUserId != null && UserInfo.GetUserId() ==PGIntegrationUserId){
        Boolean isInActiveTrigger = false;
        // query form Custom setting
        for(Trigger_Settings__c ts : [Select InactivateSetAccountPartnerRelationship__c From Trigger_Settings__c]){
            // Set settting into veriable
            isInActiveTrigger = ts.InactivateSetAccountPartnerRelationship__c;
        }
        if(isInActiveTrigger == false){    
            set<String> EnterpriseIdSet = new set<String>();
            set<String> TerritoryIdSet = new set<String>();
            // creating a set for fetching the Unmatch account for assigning it to company-account.
            Set<String> NameSet= new set<String>();
            NameSet.add('NA Unmatch');
            NameSet.add('APAC Unmatch');
            NameSet.add('EMEA Unmatch');
            NameSet.add('Unidentified Region Account');         
            map<String,Id> UnMatchAccountMapByName= new map<String,Id>();
            map<Id,String> UnMatchAccountMapById= new map<Id,String>();
            map<String,Id> territoryAccountMap = new map<String,Id>();
            map<String,Id> reSellerAccountMap = new map<String,Id>();
            list<Company__c> APACAndEMEACompanies = new list<Company__c>();
            list<Company__c> NACompanies = new list<Company__c>();
            map<Company__c,Account> CompanyAccountMap= new map<Company__c,Account>();
            list<Account> AccountList = new list<Account>();
            set<Id> CompanyAccountIdSet=new set<Id>();
            map<id,Account> AccountMap=null;
            list<Account> CompanyEndUserAccount= new list<Account>();
            boolean flag= false;
            set<String> IntlCompanyIDSet= new set<String>();
            map<String,Id> InitCompanyAccountMap = new map<String,Id>();
            list<User> userList =  [Select User_can_select_Account_Partner_Type__c From User Where Id = :Userinfo.getUserId()];
            for(Account UnMatchAccount:[Select id,Name from Account where Name in:NameSet]){
                // creating a map on unmatch accounts by name basis.
                if(!UnMatchAccountMapByName.ContainsKey(UnMatchAccount.Name)){
                    UnMatchAccountMapByName.put(UnMatchAccount.Name,UnMatchAccount.Id);
                }
                // creating a map on unmatch accounts by id basis.
                if(!UnMatchAccountMapById.ContainsKey(UnMatchAccount.Id)){
                    UnMatchAccountMapById.put(UnMatchAccount.Id,UnMatchAccount.Name);
                }
            }       
            for(Company__c comp: Trigger.new){
                if(comp.TESLA_IntlCompanyID__c != null && comp.TESLA_IntlCompanyID__c !=''){
                    IntlCompanyIDSet.add(comp.TESLA_IntlCompanyID__c);
                }
            }
            if(IntlCompanyIDSet != null && IntlCompanyIDSet.size()>0){
                    for(Account acc :[Select id,TESLA_IntlCompanyID__c from Account where TESLA_IntlCompanyID__c in:IntlCompanyIDSet]){
                        if(!InitCompanyAccountMap.ContainsKey(acc.TESLA_IntlCompanyID__c)){
                            InitCompanyAccountMap.put(acc.TESLA_IntlCompanyID__c,acc.Id);
                        }
                    }
            }
            
            for(Company__c comp: Trigger.new){
                // this below condition will put company in 'Unidentified Region Account' Account.
                if((comp.Region__c==null && comp.Account__c==null)||(comp.Account__c ==null && (comp.Region__c==null || comp.Region__c=='') && UnMatchAccountMapByName.Containskey('Unidentified Region Account'))){                    
                                comp.Account__c=UnMatchAccountMapByName.get('Unidentified Region Account');
                }
                // this condition will set company account as EMEA Unmatch account
                else if(comp.Account__c==null && (comp.TESLA_EnterpriseID__c== null || comp.TESLA_EnterpriseID__c=='') && comp.Region__c=='EMEA'
                    && UnMatchAccountMapByName.Containskey('EMEA Unmatch')){
                    comp.Account__c=UnMatchAccountMapByName.get('EMEA Unmatch');
                }
                // this condition will set company account as APAC Unmatch account
                else if(comp.Account__c==null && (comp.TESLA_EnterpriseID__c== null || comp.TESLA_EnterpriseID__c=='') && comp.Region__c=='APAC'
                    && UnMatchAccountMapByName.Containskey('APAC Unmatch')){
                    comp.Account__c=UnMatchAccountMapByName.get('APAC Unmatch');
                }
                // this condition will set company account as NA Unmatch account
                else if(comp.Account__c==null && (comp.TESLA_Territory_Code__c== null || comp.TESLA_Territory_Code__c=='') && comp.Region__c=='NA'
                    && UnMatchAccountMapByName.Containskey('NA Unmatch')){
                    comp.Account__c=UnMatchAccountMapByName.get('NA Unmatch');
                }           
                // these all condition will require for checking the company-account assignment and partner assignment logic with Emea and Apac region.
                else if(comp.TESLA_EnterpriseID__c != null && comp.TESLA_EnterpriseID__c != '' && ((comp.Account__c ==null && 
                (comp.Region__c=='APAC' || comp.Region__c=='EMEA'))
                ||(comp.Account__c != null && comp.Region__c=='APAC' && UnMatchAccountMapByName.ContainsKey('APAC Unmatch') &&
                 comp.Account__c== UnMatchAccountMapByName.get('APAC Unmatch'))
                ||(comp.Account__c != null && comp.Region__c=='EMEA' && UnMatchAccountMapByName.ContainsKey('EMEA Unmatch') && 
                comp.Account__c== UnMatchAccountMapByName.get('EMEA Unmatch'))
                ||(comp.Account__c != null && comp.Region__c=='APAC')
                ||(comp.Account__c != null && comp.Region__c=='EMEA'))){                
                    EnterpriseIdSet.add(comp.TESLA_EnterpriseID__c);
                    APACAndEMEACompanies.add(comp);
                    // this below condition will work when we have a account associated with company and account does not related to unmatch accounts.
                    if(comp.Account__c != null && 
                    (UnMatchAccountMapById.size()==0 || !UnMatchAccountMapById.ContainsKey(comp.Account__c))){
                        CompanyAccountIdSet.add(comp.Account__c);
                    }       
                }       
                // these all condition will require for checking the company-account assignment and partner assignment logic with NA region.                        
                else if(comp.TESLA_Territory_Code__c != null && comp.TESLA_Territory_Code__c != '' && 
                ((comp.Account__c ==null && comp.Region__c=='NA')
                ||(comp.Account__c != null && comp.Region__c=='NA' && UnMatchAccountMapByName.ContainsKey('NA Unmatch') && 
                comp.Account__c== UnMatchAccountMapByName.get('NA Unmatch'))
                ||(comp.Account__c != null && comp.Region__c=='NA'))){
                    TerritoryIdSet.add(comp.TESLA_Territory_Code__c);
                    NACompanies.add(comp);
                    // this below condition will work when we have a account associated with company and account does not related to unmatch accounts.
                    if(comp.Account__c != null && 
                    (UnMatchAccountMapById.size()==0 || !UnMatchAccountMapById.ContainsKey(comp.Account__c))){
                        CompanyAccountIdSet.add(comp.Account__c);
                    }
                }                       
            }
            if(CompanyAccountIdSet != null && CompanyAccountIdSet.size()>0){
                // getting all company accounts.
                AccountMap= new map<Id,Account>([Select Partner__c,Id from Account where Id in: CompanyAccountIdSet]);
            }   
        /*  system.debug('------------------- AccountMap'+AccountMap);
            system.debug('------------------- EnterpriseIdSet'+EnterpriseIdSet);
            system.debug('------------------- APACAndEMEACompanies'+APACAndEMEACompanies);
            system.debug('------------------- CompanyAccountIdSet'+CompanyAccountIdSet);
            system.debug('------------------- TerritoryIdSet'+TerritoryIdSet);
            system.debug('------------------- NACompanies'+NACompanies);    */
            if(EnterpriseIdSet !=null && EnterpriseIdSet.size()>0){  
                // fetching all the resellers from the enterprise id related to company.
                for(PartnerEnterprise__c Enterprise:[Select Id,Account__c,Name from PartnerEnterprise__c where Name in:EnterpriseIdSet and (Account__r.Channel__c = 'Partners')]){
                    //system.debug('------------------------- Enterprise'+Enterprise);
                    if(!reSellerAccountMap.Containskey(Enterprise.Name)){
                        reSellerAccountMap.put(Enterprise.Name,Enterprise.Account__c);
                    }       
                }
                //system.debug('------------------- reSellerAccountMap'+reSellerAccountMap);
                        
                for(Company__c comp:APACAndEMEACompanies){
                    // in case if we have a reseller then only we will get in to this condition
                    if(reSellerAccountMap.ContainsKey(comp.TESLA_EnterpriseID__c)){
                        //system.debug('------------ Case 1');
                        // this condition works if comopany account is null or company has unmatch account associated.
                        if(comp.Account__c==null || UnMatchAccountMapById.ContainsKey(comp.Account__c)){
                        //system.debug('------------ Case 2');
                            Account acc= new Account();
                            CreateAccount(comp,acc,comp.Region__c,reSellerAccountMap.get(comp.TESLA_EnterpriseID__c));
                            if(!CompanyAccountMap.ContainsKey(comp)){
                                //system.debug('------------ Case 3');
                                CompanyAccountMap.put(comp,acc);
                                AccountList.add(acc);       
                            }           
                        }
                        // in this case we are changing the reseller from company account -partner 
                        else if(comp.Account__c!=null && AccountMap != null && AccountMap.containsKey(comp.Account__c)  && 
                            (reSellerAccountMap.get(comp.TESLA_EnterpriseID__c) != AccountMap.get(comp.Account__c).Partner__c || AccountMap.get(comp.Account__c).Partner__c==null)){
                                //system.debug('------------ Case 4');
                                if(comp.Account__c != reSellerAccountMap.get(comp.TESLA_EnterpriseID__c)){
                                    Account tempacc=AccountMap.get(comp.Account__c);
                                    tempacc.Partner__c=reSellerAccountMap.get(comp.TESLA_EnterpriseID__c);
                                    CompanyEndUserAccount.add(tempacc);
                                    //AccountMap.get(comp.Account__c).Partner__c=reSellerAccountMap.get(comp.TESLA_EnterpriseID__c);        
                                        
                                    flag= true;     
                                }
                        }
                    }
                    // this condition is redundent we can comment later and check also.
                    else if(comp.Region__c=='APAC' && comp.Account__c==null && UnMatchAccountMapByName.Containskey('APAC Unmatch')){
                        // APAC exception case                  
                            //system.debug('------------ Case 5');                          
                            comp.Account__c=UnMatchAccountMapByName.get('APAC Unmatch');                    
                    }
                    else if(comp.Region__c=='EMEA' && comp.Account__c==null && UnMatchAccountMapByName.Containskey('EMEA Unmatch')){
                        // EMEA exception case          
                        //  system.debug('------------ Case 6');
                                comp.Account__c=UnMatchAccountMapByName.get('EMEA Unmatch');                                                
                    }
                    // in below condition we are putting null for company- account - partner
                    else if((comp.Region__c=='EMEA' || comp.Region__c=='APAC'  ) 
                    && comp.Account__c!=null && !reSellerAccountMap.ContainsKey(comp.TESLA_EnterpriseID__c) &&
                    AccountMap != null && AccountMap.containsKey(comp.Account__c)){
                        //system.debug('------------ Case 7');
                        //AccountMap.get(comp.Account__c).Partner__c=null;
                        Account tempacc=AccountMap.get(comp.Account__c);
                        tempacc.Partner__c=null;
                        CompanyEndUserAccount.add(tempacc);
                        flag= true;
                    }
                }           
            }
            // this below logic works for only NA region logic
            if(TerritoryIdSet != null && TerritoryIdSet.size()>0){
            //  system.debug('------------ Case 8');
                // getting all the resellers on basis of Territory id from company objects.
                 
                for(list<Account> TerritoryAccountlist :[Select id,Territory_Code_Partner_Only__c from 
                    Account where Territory_Code_Partner_Only__c in : TerritoryIdSet and Channel__c = 'Partners']){
                    for(Account TerritoryAccount:TerritoryAccountlist){
                        if(!territoryAccountMap.Containskey(TerritoryAccount.Territory_Code_Partner_Only__c)){
                            //system.debug('------------ Case 8');
                            territoryAccountMap.put(TerritoryAccount.Territory_Code_Partner_Only__c,TerritoryAccount.Id);
                        }                           
                    }
                }
                //system.debug('------------ territoryAccountMap'+territoryAccountMap);
                for(Company__c comp:NACompanies){
                    // if we have reseller on basis of territory 
                    if(territoryAccountMap.ContainsKey(comp.TESLA_Territory_Code__c)){
                        //system.debug('------------ Case 9');
                        if((comp.Account__c==null)|| UnMatchAccountMapById.ContainsKey(comp.Account__c)){
                        //  system.debug('------------ Case 10');
                            Account acc= new Account();
                            CreateAccount(comp,acc,comp.Region__c,territoryAccountMap.get(comp.TESLA_Territory_Code__c));
                            if(!CompanyAccountMap.ContainsKey(comp)){                           
                                CompanyAccountMap.put(comp,acc);
                                AccountList.add(acc);       
                            }
                        }
                        else if(comp.Account__c!=null && AccountMap != null && AccountMap.containsKey(comp.Account__c)  && 
                            (territoryAccountMap.get(comp.TESLA_Territory_Code__c) != AccountMap.get(comp.Account__c).Partner__c || AccountMap.get(comp.Account__c).Partner__c==null)){
                            //  system.debug('------------ Case 11');
                                system.debug('------------ territoryAccountMap.get(comp.TESLA_Territory_Code__c)'+territoryAccountMap.get(comp.TESLA_Territory_Code__c));
                            //  system.debug('------------ AccountMap.get(comp.Account__c).Partner__c'+AccountMap.get(comp.Account__c).Partner__c);
                                if(comp.Account__c !=  territoryAccountMap.get(comp.TESLA_Territory_Code__c)){
                                    Account tempacc=AccountMap.get(comp.Account__c);
                                    tempacc.Partner__c=territoryAccountMap.get(comp.TESLA_Territory_Code__c);
                                    CompanyEndUserAccount.add(tempacc);
                                    //AccountMap.get(comp.Account__c).Partner__c=territoryAccountMap.get(comp.TESLA_Territory_Code__c);
                                    flag= true;                 
                                }
                        }           
                    }
                    // need to check again              
                    else if(UnMatchAccountMapByName.Containskey('NA Unmatch') && comp.Account__c==null){
                    //  system.debug('------------ Case 12');
                                comp.Account__c=UnMatchAccountMapByName.get('NA Unmatch');
                    }
                    else if(comp.Account__c!=null && !territoryAccountMap.ContainsKey(comp.TESLA_Territory_Code__c) &&
                    AccountMap != null && AccountMap.containsKey(comp.Account__c)){
                    //  system.debug('------------ Case 13');
                        //AccountMap.get(comp.Account__c).Partner__c=null;
                        Account tempacc=AccountMap.get(comp.Account__c);
                        tempacc.Partner__c=null;
                        CompanyEndUserAccount.add(tempacc);
                        flag= true;
                    }                               
                }                   
            }
            if(AccountList != null && AccountList.size()>0 && userList != null && userList.size()==1 && userList.get(0).User_can_select_Account_Partner_Type__c==true){
                insert AccountList;
                for(Company__c comp:CompanyAccountMap.KeySet()){
                    comp.Account__c=CompanyAccountMap.get(comp).Id;
                }
            }
            if(flag==true && AccountMap.size()>0 && userList != null && userList.size()==1 && userList.get(0).User_can_select_Account_Partner_Type__c==true){           
            //  system.debug('------------ Case 14');
            //  system.debug('------------ Later AccountMap'+AccountMap);           
                //update AccountMap.Values();
                system.debug('------------ CompanyEndUserAccount'+CompanyEndUserAccount);   
                upsert CompanyEndUserAccount;           
            }
            for(Company__c comp:trigger.new){
                if(UnMatchAccountMapById.ContainsKey(comp.Account__c) 
                && comp.TESLA_IntlCompanyID__c != null && comp.TESLA_IntlCompanyID__c != null && 
                InitCompanyAccountMap != null && InitCompanyAccountMap.containskey(comp.TESLA_IntlCompanyID__c)){
                    comp.Account__c=InitCompanyAccountMap.get(comp.TESLA_IntlCompanyID__c); 
                }
            }
        }       
    }
        
        // This function which will create new account on basis of new company information
    private void CreateAccount(Company__c comp,Account acc,String UserRegion,Id PartnerAccountId ){
        try{            
            acc.Name=comp.Name;                 
            acc.BillingStreet= comp.TESLA_Address1__c+ ' ' +  comp.TESLA_Address2__c+ ' ' + comp.TESLA_Address3__c;
            acc.BillingState=comp.TESLA_StateCode__c;
            acc.BillingCity=comp.TESLA_City__c;
            acc.BillingPostalCode=comp.TESLA_Zip__c;
            acc.Partner__c=PartnerAccountId;    
            acc.ChannelType__c='End User';  
            acc.Channel__c='Partners';
            acc.Owner_Region__c=UserRegion;
        }
        catch(Exception ex){
            
        }
    }       
    
    
}