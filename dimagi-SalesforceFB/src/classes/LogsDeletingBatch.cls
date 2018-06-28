/*
 * Batch responsible for deleting old Batch Error Logs.
 */
global class LogsDeletingBatch implements Database.Batchable<Batch_Error_Logs__c> {

    global List<Batch_Error_Logs__c> start(Database.BatchableContext context) {
       return [SELECT Id FROM Batch_Error_Logs__c WHERE CreatedDate < LAST_N_DAYS:30];
    }

    global void execute(Database.BatchableContext context, List<Batch_Error_Logs__c> oldLogs) {
        delete oldLogs;
    }

    global void finish(Database.BatchableContext context) {

    }
}