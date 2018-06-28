@isTest
private class CreateFBCasesBatchTest {

    static testMethod void shouldCreateCase() {
        FogBugzHTTPMock fakeHTTP = new FogBugzHTTPMock(TestFogBugzAPI.UPSERT_CASE_RESPONSE);
        Test.setMock(HttpCalloutMock.class, fakeHTTP);
        Test.startTest();
        FogBugzAPI api = new FogBugzAPI();

        Business_Unit__c bunit = new Business_Unit__c();
        bunit.Name = 'Test';
        insert bunit; 

        Opportunity opp = new Opportunity();
        opp.Name = 'CreateFBCasesBatchTest';
        opp.StageName = 'Stage 1 - Connect';
        opp.CloseDate = Date.newInstance(2015, 4, 9);
        opp.Implementing_Business_Unit__c = bunit.Id;

        insert opp;

        Opportunity oppFromDB = [SELECT Id, Name, StageName, Fogbugz_Opened_By__c, Fogbugz_Probability__c, Amount, Owner.Name,
                                        IsClosed, Fogbugz_Ticket_Number__c FROM Opportunity WHERE IsClosed = false AND Fogbugz_Ticket_Number__c = ''];
        System.assertEquals(null, oppFromDB.Fogbugz_Ticket_Number__c);

        Database.BatchableContext bc;
        List<Opportunity> scope = new List<Opportunity>();
        scope.add(oppFromDB);
        (new CreateFBCasesBatch().execute(bc, scope));
        Test.stopTest();

        Opportunity oppFromDBAfterUpdate = [SELECT Id, Fogbugz_Ticket_Number__c FROM Opportunity WHERE Id =: opp.Id];
        System.assertEquals('testFBId', oppFromDBAfterUpdate.Fogbugz_Ticket_Number__c);
    }
}