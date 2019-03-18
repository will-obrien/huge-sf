global class UnitBatch implements Database.Batchable<sObject>
{
   global Database.QueryLocator start(Database.BatchableContext BC)
   {
      return Database.getQueryLocator([SELECT ID, Name FROM Unit__c]);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope)
   {
       List<Unit__c> updateUnitList = new List<Unit__c>();
       for(Unit__c item : (List<Unit__c>) scope)
       {
           item.Health__c = 200;
           updateUnitList.add(item);
       }
	   update updateUnitList;
    }

   global void finish(Database.BatchableContext BC)
   {

   }
}