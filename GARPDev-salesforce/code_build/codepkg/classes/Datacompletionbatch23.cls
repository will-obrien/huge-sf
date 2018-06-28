global class Datacompletionbatch23 implements Database.Batchable<SObject>
{
    //global boolean bIsTestCall = false;
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,Shipping_Address1__c,Shipping_Address2__c,Shipping_Address3__c,Shipping_Street__c from opportunity');
     }
    
    
    global void execute(Database.BatchableContext BC, List<opportunity> scope){
        
        List<Opportunity> lstOpp = new List<Opportunity>();
        for(opportunity obj : Scope)
        {
            if(obj.Shipping_Address1__c != '' || obj.Shipping_Address2__c != '' || obj.Shipping_Address3__c != '')
            {
                 obj.Shipping_Street__c = obj.Shipping_Address1__c + obj.Shipping_Address2__c + obj.Shipping_Address3__c;       
                 lstOpp.add(obj);  
            }
        }

        update lstOpp;

    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}