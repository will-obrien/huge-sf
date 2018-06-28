global class Lesson3Batch implements Database.Batchable<sObject>{
   
   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('SELECT id, name FROM Account');
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
       List<Account> updateAccountList = new List<Account>();
                           for(Account item : (List<Account>)scope){ 
                               item.name = item.name.remove(' Batch Was Here');
                               updateAccountList.add(item);
      }
       System.debug(updateAccountList);
       update updateAccountList;
   }

   global void finish(Database.BatchableContext BC){

   }

}