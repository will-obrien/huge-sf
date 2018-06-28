trigger MKTG_Mark_Accounts_with_Opportunities_Delete on Opportunity (after delete) {

string accountID = '';
string oppProduct = '';
string oppStage = '';
string hasDocXPre = 'n';
string hasDocxPost = 'n';
string hasEEPre = 'n';
string hasEEPost = 'n';
string has3BPre = 'n';
string has3BPost = 'n';




//Create a list of all accounts that are impacted by the opportunities in this trigger operation
//List<Account> act = [Select AccountId, Id, product__c from Opportunity where Id in :Trigger.New];
//List<opportunity> oppList = [select accountId, id, stagename, product__c from opportunity where accountId in :act.AccountId];
//List<opportunity> oppList = [select accountId, id, stagename, product__c from opportunity where Id in :Trigger.New];
List<opportunity> oppList = [select accountId, id, stagename, product__c from opportunity where Id in :Trigger.Old];

//Create a set of ALL accounts that are impacted by any opps in this trigger.
set<Id> accountIDsInTrigger = new Set<id>();
 for (opportunity opp : Trigger.old)
        accountIDsInTrigger.add(opp.AccountId);


    List<opportunity> oppList2 = [select accountId, id, stagename, product__c from opportunity where accountid in :accountIdsInTrigger];

              
    system.debug('starting to loop through opps');

            
            //List<account> accountList = new List <account>();
            map<id,account> accountMapEEPre = new Map<id, account>();
            map<id,account> accountMapEEPost = new Map<id, account>();
            map<id,account> accountMap3BPre = new Map<id, account>();
            map<id,account> accountMap3BPost = new Map<id, account>();
            map<id,account> accountMapDocXPre = new Map<id, account>();
            map<id,account> accountMapDocXPost = new Map<id, account>();
            map<id,account> accountMapResetAll = new Map<id, account>();
            map<id,account> accountMapUpdateAll = new Map<id, account>();
            for (opportunity opp : opplist2) {
            account a2 = new account(id=opp.AccountId);
//          a2.Pre_Pipeline_DocXtools__c = false;
//          a2.Pre_Pipeline_EagleEye__c = false;
//          a2.Pre_Pipeline_3BClean__c = false;
//          a2.Pipeline_DocXtools__c = false;
//          a2.Pipeline_EagleEye__c = false;
//          a2.Pipeline_3BClean__c = false;
//          accountMapResetAll.put(opp.accountId, a2);
//      if (opp.StageName == 'Not Called' || opp.StageName == 'Called/Contacted' ||opp.StageName == 'Called/No Progress' ||opp.StageName == 'Called/Not Interested' ||opp.StageName == 'Called/Follow Up Later' ||opp.StageName == 'Suspect')
    if (opp.StageName == 'Pre-Pipeline' || opp.StageName == 'Circle of Leverage')
        { 
            system.debug('In the pre-pipeline stage IF block');
            
                            if (opp.product__c == 'DocXtools')
                            {
                                hasDocXPre = 'y';
                                //a2.Pre_Pipeline_DocXtools__c = true;
                                //accountMapDocXPre.put(opp.accountId, a2);
                                system.debug('Set docxpre');
                            } else if (opp.product__c == 'EagleEye') 
                            {
                                hasEEPre = 'y';
                                //a2.Pre_Pipeline_EagleEye__c = true;
                                //accountMapEEPre.put(opp.accountId, a2);
                                system.debug('setEEpre');           
                            } else if (opp.product__c == '3BClean')
                            {
                                has3BPre = 'y';
                                //a2.Pre_Pipeline_3BClean__c = true;
                                //accountMap3BPre.put(opp.accountId, a2);
                                system.debug('set3bpre');
                            }
                        
        }           

//      if (opp.StageName == 'qualified lead' || opp.StageName == 'interest generation' ||opp.StageName == 'evaluation' ||opp.StageName == 'proposal' ||opp.StageName == 'negotiations')
if (opp.StageName == 'Pipeline' || opp.StageName == 'Best Case' ||opp.StageName == 'Commit' || opp.stagename == 'Qualified Lead' || opp.stagename == 'Needs Analysis' || opp.stagename == 'Demo Day' || opp.stagename == 'SOE' || opp.stagename == 'Evaluation' || opp.stagename == 'POC/POC Day' || opp.stagename == 'Proposal' || opp.stagename == 'Negotiations')
        { 
            system.debug('in post pipeline stage if block');
            
                            if (opp.product__c == 'DocXtools')
                            {
                                hasDocXPost = 'y';
                                //a2.Pipeline_DocXtools__c = true;
                                //accountMapDocXPost.put(opp.accountId, a2);
                                system.debug('setdocxpost');
                            } else if (opp.product__c == 'EagleEye') 
                            {
                                hasEEPost = 'y';
                                //a2.Pipeline_EagleEye__c = true;
                                //accountMapEEPost.put(opp.accountId, a2);      
                                system.debug('seteepost');  
                            } else if (opp.product__c == '3BClean')
                            {
                                has3BPost = 'y';
                                //a2.Pipeline_3BClean__c = true;
                            //  accountMap3BPost.put(opp.accountId, a2);
                                system.debug('set3bpost');
                            }
                        
        }           

  if (has3BPre == 'y')
    {
        a2.Pre_Pipeline_3bclean__C = true;
        system.debug('set account to 3bcpre');
    } else if (has3BPre == 'n'){
        a2.Pre_Pipeline_3bclean__C = false;
    }
    if (hasEEPre == 'y')
    {
        a2.Pre_Pipeline_EagleEye__c = true;
    system.debug('set account to EEpre');
    } else if (hasEEPre == 'n'){
        a2.Pre_Pipeline_EagleEye__C = false;
    }
    if (hasDocXPre == 'y')
    {
        a2.Pre_Pipeline_DocXtools__c = true;
        system.debug('set account to docxpre');
    } else if (hasDocXPre == 'n'){
        a2.Pre_Pipeline_DocXtools__c = false;
    }
  
    
    
   if (has3BPost == 'y')
   {
    a2.Pipeline_3BClean__C = true;
        system.debug('set account to 3bpost');
    } else if (has3BPost =='n') {
        a2.Pipeline_3BClean__C = false;
    }
   if (hasEEPost == 'y')
    {
        a2.Pipeline_EagleEye__c = true;
        system.debug('set account to eepost');
    } else if (hasEEPost == 'n') {
    a2.Pipeline_EagleEye__c = false;
    }



  if (hasDocXPost == 'y')
    {
        a2.Pipeline_DocXtools__c = true;
        system.debug('set account to docxpost');
    }else if (hasDocXPost =='n'){
        a2.Pipeline_DocXtools__c = false;
    }
//system.debug('just added all the ys to the account list');
//system.debug('trying to add account with id ' + a2.id +'to accountlist');

//accountlist.add(opp.accountId, a2);

accountMapUpdateAll.put(opp.accountId, a2);

        
//end opportunity loop  
    }
    system.debug('finished opp loop- trying to update the list of accounts');
//  update accountMapResetAll.values();
//    update accountMapEEPre.values();
//  update accountMapEEPost.values();
//  update accountMap3BPre.values();
//  update accountMap3BPost.values();
//  update accountMapDocXPre.values();
//  update accountMapDocXPost.values();
  update accountMapUpdateAll.values();  
    //now set the account checkboxes based on the values above.
///start working here
 //   account a2 = [select id from account where id = :accountid];
   
 
  
    
    
      
 
}