global class updateRecurinPayments implements Database.Batchable<sObject>, Database.Stateful{

   global final String Query;
   global updateRecurinPayments(){
     
     String strStatus = 'Active';
     Query = 'select id,pymt__Subscription_Status__c,pymt__Account__c,pymt__Amount__c from pymt__Payment_Profile__c where pymt__Subscription_Status__c =: strStatus and Bought_Student__c =: true';
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }
   
   global void execute(Database.BatchableContext BC,List<pymt__Payment_Profile__c> scope){
      //Set<Id> setAccountIds = new Set<Id>();
      Map<Id,pymt__Payment_Profile__c> mapPayments = new Map<Id,pymt__Payment_Profile__c>();
      for(pymt__Payment_Profile__c objScope : scope){
         //setAccountIds.add(objScope.pymt__Account__c);
         mapPayments.put(objScope.pymt__Account__c,objScope);
      }
      
      id memRecTypeId  = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
      List<pymt__Payment_Profile__c> lstUpdatePayments = new List<pymt__Payment_Profile__c>();
      AggregateResult[] groupedResults = [select SUM(ContractTerm)term,accountId from Contract where accountId in: mapPayments.keySet() and recordTypeId =: memRecTypeId  and Membership_Type__c='Student' and Technically_Zero__c != true group by accountId];
      for(AggregateResult Result : groupedResults)
      {
        Decimal dTermSum = (Decimal)Result.get('term');
        Id acctId = (Id)Result.get('accountId');
        if(dTermSum >= 24.0)
        {
            pymt__Payment_Profile__c objPayment = mapPayments.get(acctId);
            objPayment.pymt__Amount__c = 195;
            lstUpdatePayments.add(objPayment);
        }
            
      }
      if(!lstUpdatePayments.isEmpty())              
          update lstUpdatePayments;
       
   }

global void finish(Database.BatchableContext BC){
   }
}