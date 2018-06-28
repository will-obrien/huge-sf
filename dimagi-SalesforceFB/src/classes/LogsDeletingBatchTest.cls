@isTest
public class LogsDeletingBatchTest {

    public static testMethod void shouldDeleteOldLogs() {
        Batch_Error_Logs__c newLog1 = new Batch_Error_Logs__c(Batch_Id__c = 'newLog1');
        Batch_Error_Logs__c newLog2 = new Batch_Error_Logs__c(Batch_Id__c = 'newLog2');
        Batch_Error_Logs__c oldLog1 = new Batch_Error_Logs__c(Batch_Id__c = 'oldLog1');
        Batch_Error_Logs__c oldLog2 = new Batch_Error_Logs__c(Batch_Id__c = 'oldLog2');
        Batch_Error_Logs__c oldLog3 = new Batch_Error_Logs__c(Batch_Id__c = 'oldLog3');

        insert newLog1;
        insert newLog2;
        insert oldLog1;
        insert oldLog2;
        insert oldLog3;

        Test.setCreatedDate(newLog1.Id, Datetime.now().addDays(-1));
        Test.setCreatedDate(newLog2.Id, Datetime.now().addDays(-27));
        Test.setCreatedDate(oldLog1.Id, Datetime.now().addDays(-40));
        Test.setCreatedDate(oldLog2.Id, Datetime.now().addDays(-44));
        Test.setCreatedDate(oldLog3.Id, Datetime.now().addDays(-70));

        Test.startTest();

        LogsDeletingBatch logsDeleting = new LogsDeletingBatch();
        Database.executeBatch(logsDeleting);

        Test.stopTest();

        Batch_Error_Logs__c log1 = [SELECT Id, Batch_Id__c FROM Batch_Error_Logs__c WHERE Batch_Id__c = 'newLog1'];
        System.assertNotEquals(null, log1);
        Batch_Error_Logs__c log2 = [SELECT Id, Batch_Id__c FROM Batch_Error_Logs__c WHERE Batch_Id__c = 'newLog2'];
        System.assertNotEquals(null, log2);

        List<Batch_Error_Logs__c> logs = [SELECT Id, Batch_Id__c FROM Batch_Error_Logs__c];
        System.assertEquals(2, logs.size());
    }
}