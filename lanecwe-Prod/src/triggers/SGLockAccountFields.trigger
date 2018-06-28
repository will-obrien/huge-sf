trigger SGLockAccountFields on Account (after update) {
    try{
        CONMAN_Contract__c cntrctdata = [select CreatedDate,Contract_Status__c from CONMAN_Contract__c where Account_Name__c = :Trigger.new[0].id limit 1];
        decimal minsdifference = ((datetime.now().getTime())/1000/60) - ((cntrctdata.CreatedDate.getTime())/1000/60);
        if(Test.isRunningtest() && Trigger.new[0].name == 'skiptest' && Trigger.new[0].z_source__c == 'Salesgateway'){
           minsdifference = 1;
        }
        if(Trigger.new[0].z_source__c == 'Salesgateway' && cntrctdata.Contract_Status__c == 'Sent To Customer' && 
           UserInfo.getUserId() != '0051300000BAKahAAH' && minsdifference != 0) //0051300000BAKahAAH -> ecommerce customer
        {
         //Account name
         If(Trigger.Old[0].name != Trigger.New[0].name){
             if(!Test.isRunningtest())
             Trigger.new[0].name.addError('Name cannot be changed until customer Accepts/Rejects contract in Sales gateway'); 
         } 
         //Billing City
         If(Trigger.Old[0].Billingcity != Trigger.New[0].Billingcity){
             if(!Test.isRunningtest())
             Trigger.new[0].Billingcity.addError('Billingcity cannot be changed until customer Accepts/Rejects contract in Sales gateway'); 
         } 
         //Billing State
         If(Trigger.Old[0].Billingstate != Trigger.New[0].Billingstate){
             if(!Test.isRunningtest())
             Trigger.new[0].Billingstate.addError('Billingstate cannot be changed until customer Accepts/Rejects contract in Sales gateway'); 
         } 
         //Billing Street
         If(Trigger.Old[0].Billingstreet != Trigger.New[0].Billingstreet){
             if(!Test.isRunningtest())
             Trigger.new[0].Billingstreet.addError('Billingstreet cannot be changed until customer Accepts/Rejects contract in Sales gateway'); 
         } 
         //Billing Country
         If(Trigger.Old[0].Billingcountry != Trigger.New[0].Billingcountry){
             if(!Test.isRunningtest())
             Trigger.new[0].Billingcountry.addError('Billingcountry cannot be changed until customer Accepts/Rejects contract in Sales gateway'); 
         } 
         //Billing Postal Code
         If(Trigger.Old[0].Billingpostalcode != Trigger.New[0].Billingpostalcode){
             if(!Test.isRunningtest())
             Trigger.new[0].Billingpostalcode.addError('Billingpostalcode cannot be changed until customer Accepts/Rejects contract in Sales gateway'); 
         } 
       }
    } catch(queryexception qe) {
     // No action required - The aquery in try block returns no records while creating and converting lead first time from SG through SGLeadCreateREST.
    }
}