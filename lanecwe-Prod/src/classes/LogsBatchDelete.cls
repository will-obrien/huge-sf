global class LogsBatchDelete implements Database.Batchable<sObject> {
   Datetime d1 = Datetime.now();
   Datetime d  = d1.addDays(-6);
   public String query = 'SELECT Id FROM Logs__c WHERE CreatedDate < '+d.format('yyyy-MM-dd')+'T'+d.format('HH:mm')+':00.000Z';

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
      System.debug('scope: ' + scope);
       delete scope;
      DataBase.emptyRecycleBin(scope);
   }

   global void finish(Database.BatchableContext BC){
   }
}