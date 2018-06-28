/*********************************************************************
Name : SetAccountStatusOnOpportunity 
Created On : jan 06, 2012  
Created By : Lalit Bohra
Description : Trigger on Opportunity for updating the Opportunity.Account status if Opportunity stage is set to 'Closed Won'.
Task :T-20872
**********************************************************************/
trigger SetAccountStatusOnOpportunity on Opportunity (after insert, after update) {
    //Identified that the trigger Enable/Disabled by User in custom setting 'Trigger Settings'
    Boolean isInActiveTrigger = false;
    // query form Custom setting
    for(Trigger_Settings__c ts : [Select InactivateSetAccountStatusOnOpportunity__c From Trigger_Settings__c]){
        // Set settting into veriable
        isInActiveTrigger = ts.InactivateSetAccountStatusOnOpportunity__c;
    }
    if(isInActiveTrigger == false){   
        set<Id> AccountIdset= new set<Id>();
        for(Opportunity opp:trigger.new){
            if(opp.AccountId != null && opp.Opp_Stage__c=='Closed Won'){
                AccountIdset.add(opp.AccountId);
                
            }   
        }
        list<Account> AccountList= new list<Account>();
       // system.debug('--------------------- AccountIdset'+AccountIdset);
        for(Account acc:[Select Status__c from Account where Id in:AccountIdset]){
            if(acc.Status__c !='Customer'){
                acc.Status__c ='Customer';
                AccountList.add(acc);
            }
        }
       // system.debug('--------------------- AccountList'+AccountList);
        if(AccountList != null && AccountList.size()>0){
            update AccountList;
        }
    }
}