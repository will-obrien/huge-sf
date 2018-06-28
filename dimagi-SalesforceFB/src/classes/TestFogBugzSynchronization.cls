/**
 * Tests for the FogBugz sync high level cases
 *
 * @author  Antonio Grassi
 * @date    11/15/2012
 */

@isTest
public class TestFogBugzSynchronization {

    private static void setupSettings() {
        FogBugz_Settings__c settings = FogBugz_Settings__c.getOrgDefaults();
        settings.Sync_Filter__c = 1;
        settings.Token__c = 'test';
        settings.Sync_Script_Running__c = false;
        settings.Default_Opportunity_Owner__c = 'do@not.exist';
        settings.FB_URL__c = 'https://manage.dimagi.com/api.asp?';
        upsert settings;
    }

    static testMethod void testOpportunityToCaseWithCaseId() {
        setupSettings();
        Opportunity o = new Opportunity(
            Name = 'Test name',
            StageName = 'Test stage',
            CloseDate = Date.today(),
            Fogbugz_Ticket_Number__c = 'Should not change'
        );
        insert o;

        Opportunity refreshed = [SELECT Id, Fogbugz_Ticket_Number__c FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals('Should not change', refreshed.Fogbugz_Ticket_Number__c, 'Opportunity already had a FogBugz id and was updated');
    }

    static testMethod void testOpportunityToCaseWithoutCaseId() {
        setupSettings();
        Test.startTest();
        Opportunity o = createTestOpportunity(null);
        Test.stopTest();

        Opportunity refreshed = [SELECT Id, Fogbugz_Ticket_Number__c FROM Opportunity WHERE Id = :o.Id];
        System.assertEquals(TestFogBugzAPI.TEST_FB_ID, refreshed.Fogbugz_Ticket_Number__c, 'FogBugz id was not updated on Opportunity');
    }

    static Opportunity createTestOpportunity(String fbCaseId) {
        setupSettings();
        Opportunity o = new Opportunity(
            Name = 'Change me',
            StageName = 'Change me',
            CloseDate = Date.today(),
            Fogbugz_Assigned_To__c = 'Change me',
            Fogbugz_Ticket_Number__c = fbCaseId
        );
        insert o;
        return o;
    }

    static testMethod void testFB2SFSyncExistentCase() {
        setupSettings();
        Opportunity o = createTestOpportunity(TestFogBugzAPI.TEST_FB_ID);

        Test.startTest();
        Database.executeBatch(new FogBugzSynchronizerBatch(1, true), 1);
        Test.stopTest();

        Opportunity refreshed = [SELECT Id, Name, StageName, Fogbugz_Ticket_Number__c, Fogbugz_Assigned_To__c, Fogbugz_Last_Updated_Date__c, Amount,
                                        Probability, Fogbugz_Probability__c, Fogbugz_elapsed_time__c FROM Opportunity WHERE Id = :o.Id];

        System.assertEquals('Test area', refreshed.StageName, 'Opportunity stage not updated');
        System.assertEquals('Test assignee', refreshed.Fogbugz_Assigned_To__c, 'Assignee not updated');
        System.assertEquals('Test title', refreshed.Name, 'Name not updated');
        System.assertEquals(41.7327995300293, refreshed.Fogbugz_elapsed_time__c, 'Fogbugz_elapsed_time__c wasn\'t updated');
        System.assertEquals(Datetime.newInstanceGMT(2012, 1, 1, 0, 0, 0), refreshed.Fogbugz_Last_Updated_Date__c, 'FB last modified not updated');
    }

    static testMethod void testFB2SFSyncNotExistentCase() {
        setupSettings();
        // We checked the update on the above test case, we'll just cover the batch job code
        // here as there's nothing we can test

        Test.startTest();

        FogBugzHTTPMock fakeHTTP = new FogBugzHTTPMock(TestFogBugzAPI.GET_CASES_RESPONSE);
        Test.setMock(HttpCalloutMock.class, fakeHTTP);
        Database.executeBatch(new FogBugzSynchronizerBatch(1, true), 1);

        Test.stopTest();
    }

    static testMethod void testFB2SFSyncNote() {
        setupSettings();
        // We can just do coverage here, as we cannot perform callouts to check the
        // note was created in FB
        Opportunity o = createTestOpportunity(TestFogBugzAPI.TEST_FB_ID);

        Task t = new Task(Description = 'Test',
                          Priority = 'Normal',
                          Status = 'Test',
                          WhatId = o.Id,
                          Subject = 'Email: Test subject');

        Test.startTest();
        insert t;
        Test.stopTest();
    }
}