global class BatchClass implements Database.Batchable<sObject>{
     global BatchClass(){
         // Batch Constructor
     }
     
     // Start Method
     global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id, lastName, email from Contact where lastname= \'123\'');
     }
    
     // Execute Logic
     global void execute(Database.BatchableContext BC, List<contact> contacts){
         for(contact con : contacts) {
             con.lastname += 'test';
         } 
         update contacts;
     }
     // Start finish
     global void finish(Database.BatchableContext BC){
         // Logic to be Executed at finish
     }
 }