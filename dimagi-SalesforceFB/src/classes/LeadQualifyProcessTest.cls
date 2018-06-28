@isTest
public class LeadQualifyProcessTest {

    public static testMethod void triggerShouldntSetFailingProcessField() {
        Lead testLead1 = new Lead(FirstName = 'Tom', LastName = 'Smith', Company = 'Smith IT Company', Lead_Status_Reason__c = 'Working - Exploratory Call - Trying for',
                                  Status = 'Working - Talking', Follow_up_calls_held__c = 1);
        insert testLead1;
        Lead testLead2 = new Lead(FirstName = 'Tom 1', LastName = 'Smith 1', Company = 'Smith IT Company 1', Lead_Status_Reason__c = 'Working - Exploratory Call - Trying for',
                                  Status = 'Passive & Friendly', Follow_up_calls_held__c = 88);
        insert testLead2;
        Lead testLead3 = new Lead(FirstName = 'Tom 2', LastName = 'Smith 2 ', Company = 'Smith IT Company 2', Lead_Status_Reason__c = 'Working - Exploratory Call - Trying for',
                                  Status = 'Working - Talking', Follow_up_calls_held__c = 6);
        insert testLead3;
        Lead testLead4 = new Lead(FirstName = 'Tom 3', LastName = 'Smith 3 ', Company = 'Smith IT Company 3', Lead_Status_Reason__c = 'Working - Exploratory Call - Trying for',
                                  Status = 'Working - Talking', Follow_up_calls_held__c = 11);
        insert testLead4;

        testLead1.Company = 'New Company 1';
        testLead2.Company = 'New Company 2';
        testLead3.Company = 'New Company 3';
        testLead4.Company = 'New Company 4';
        List<Lead> toUpdate = new List<Lead>();
        toUpdate.add(testLead1);
        toUpdate.add(testLead2);
        toUpdate.add(testLead3);
        toUpdate.add(testLead4);

        Test.startTest();

        update toUpdate;

        Test.stopTest();

        Lead leadFromDB = [SELECT Id, Failed_Qualifying_process_at_least_once__c FROM Lead WHERE Id =: testLead1.Id LIMIT 1];
        System.debug('leadFromDB ' + leadFromDB);
        System.assertEquals(false, leadFromDB.Failed_Qualifying_process_at_least_once__c);
        leadFromDB = [SELECT Id, Failed_Qualifying_process_at_least_once__c FROM Lead WHERE Id =: testLead2.Id LIMIT 1];
        System.debug('leadFromDB ' + leadFromDB);
        System.assertEquals(false, leadFromDB.Failed_Qualifying_process_at_least_once__c);
        leadFromDB = [SELECT Id, Failed_Qualifying_process_at_least_once__c FROM Lead WHERE Id =: testLead3.Id LIMIT 1];
        System.debug('leadFromDB ' + leadFromDB);
        System.assertEquals(false, leadFromDB.Failed_Qualifying_process_at_least_once__c);
        leadFromDB = [SELECT Id, Failed_Qualifying_process_at_least_once__c FROM Lead WHERE Id =: testLead4.Id LIMIT 1];
        System.debug('leadFromDB ' + leadFromDB);
        System.assertEquals(true, leadFromDB.Failed_Qualifying_process_at_least_once__c);
    }

    public static testMethod void jobShouldSetFailingProcessField() {
        Lead testLead1 = new Lead(FirstName = 'Tom', LastName = 'Smith', Company = 'Smith IT Company', Lead_Status_Reason__c = 'Working - Exploratory Call - Trying for',
                                  Status = 'Working - Talking', Follow_up_calls_held__c = 8);
        insert testLead1;
        Lead testLead2 = new Lead(FirstName = 'Tom 1', LastName = 'Smith 1', Company = 'Smith IT Company 1', Lead_Status_Reason__c = 'Working - Exploratory Call - Trying for',
                                  Status = 'Working - Talking', Follow_up_calls_held__c = 88);
        insert testLead2;
        Lead testLead3 = new Lead(FirstName = 'Tom 2', LastName = 'Smith 2 ', Company = 'Smith IT Company 2', Lead_Status_Reason__c = 'Working - Exploratory Call - Trying for',
                                  Status = 'Working - Talking', Follow_up_calls_held__c = 6);
        insert testLead3;

        testLead1.Company = 'New Company 1';
        testLead2.Company = 'New Company 2';
        testLead3.Company = 'New Company 3';

        List<Lead> toUpdate = new List<Lead>();
        toUpdate.add(testLead1);
        toUpdate.add(testLead2);
        toUpdate.add(testLead3);

        Test.startTest();

        Database.executeBatch(new LeadQualifyProcessBatch(), 200);

        Test.stopTest();

        List<Lead> leadsFromDB = [SELECT Id, Failed_Qualifying_process_at_least_once__c FROM Lead ORDER BY Company];
        System.assertEquals(true, leadsFromDB.get(0).Failed_Qualifying_process_at_least_once__c);
        System.assertEquals(true, leadsFromDB.get(1).Failed_Qualifying_process_at_least_once__c);
        System.assertEquals(false, leadsFromDB.get(2).Failed_Qualifying_process_at_least_once__c);

    }

    public static testMethod void shouldUseSettings() {
        Lead_Qualifying_Process__c setting = Lead_Qualifying_Process__c.getOrgDefaults();
        setting.Threshold__c = 2;
        insert setting;

        Lead testLead1 = new Lead(FirstName = 'Tom', LastName = 'Smith', Company = 'Smith IT Company', Lead_Status_Reason__c = 'Working - Exploratory Call - Trying for',
                                  Status = 'Working - Talking', Follow_up_calls_held__c = 8);
        insert testLead1;
        Lead testLead2 = new Lead(FirstName = 'Tom 1', LastName = 'Smith 1', Company = 'Smith IT Company 1', Lead_Status_Reason__c = 'Working - Exploratory Call - Trying for',
                                  Status = 'Working - Talking', Follow_up_calls_held__c = 3);
        insert testLead2;
        Lead testLead3 = new Lead(FirstName = 'Tom 2', LastName = 'Smith 2 ', Company = 'Smith IT Company 2', Lead_Status_Reason__c = 'Working - Exploratory Call - Trying for',
                                  Status = 'Working - Talking', Follow_up_calls_held__c = 1);
        insert testLead3;

        testLead1.Company = 'New Company 1';
        testLead2.Company = 'New Company 2';
        testLead3.Company = 'New Company 3';

        List<Lead> toUpdate = new List<Lead>();
        toUpdate.add(testLead1);
        toUpdate.add(testLead2);
        toUpdate.add(testLead3);

        Test.startTest();

        Database.executeBatch(new LeadQualifyProcessBatch(), 200);

        Test.stopTest();

        List<Lead> leadsFromDB = [SELECT Id, Failed_Qualifying_process_at_least_once__c FROM Lead ORDER BY Company];
        System.assertEquals(true, leadsFromDB.get(0).Failed_Qualifying_process_at_least_once__c);
        System.assertEquals(true, leadsFromDB.get(1).Failed_Qualifying_process_at_least_once__c);
        System.assertEquals(false, leadsFromDB.get(2).Failed_Qualifying_process_at_least_once__c);
    }
}