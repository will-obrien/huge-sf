global class batchUpdateOpportunityEmailAddress implements Database.Batchable<SObject>
{
    //global boolean bIsTestCall = false;
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,ChargentSFA__Billing_Email__c,Shipping_E_mail__c,GARP_Member_ID__c from Opportunity');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        String strPostFix = '@Garp.com';
        for(opportunity objOpp : scope)
        {
            objOpp.ChargentSFA__Billing_Email__c = objOpp.GARP_Member_ID__c+strPostFix;
            objOpp.Shipping_E_mail__c = objOpp.GARP_Member_ID__c+strPostFix; 
        }
       
      
        update scope;
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}