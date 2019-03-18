/*********************************************************************
Name : TestCountOfRelatedObjectBatchClass
Created On : Feb 15, 2013  
Created By : JP
Description : Test Class for CountOfRelatedObjectBatchClassAPAC, 
CountOfRelatedObjectBatchClassEMEA & CountOfRelatedObjectBatchClassNA batch class
**********************************************************************/

@isTest

private class TestCountOfRelatedObjectBatchClass{

    static testMethod void testBatch() {
        Test.StartTest();
        
        Account testAcc= PGITestUtilities.getAccountDetails();
        testAcc.Last_modified_Date_by_non_admin__c=system.today();
        insert testAcc;
        
        Contact testCon = PGITestUtilities.getContactDetails(testAcc.Id);
        testCon.Last_modified_Date_by_non_admin__c = system.today();
        insert testCon;
        
        Opportunity testOpp = PGITestUtilities.getOpportunityDetails();
        testOpp.Last_modified_Date_by_non_admin__c = system.today();
        insert testOpp;
        
        Lead testLead = PGITestUtilities.getLeadDetails();
        testLead.Account__c = testAcc.Id;
        testLead.Last_modified_Date_by_non_admin__c = system.today();
        insert testLead;
        
        Task testTask = PGITestUtilities.getTaskDetails(testAcc.Id);
        testTask.Last_modified_Date_by_non_admin__c = system.today();
        insert testTask;
        
        Event testEvent = PGITestUtilities.getEventDetails(testAcc.Id);
        testEvent.Last_modified_Date_by_non_admin__c = system.today();
        insert testEvent;
        
        Attachment testAttach = PGITestUtilities.createAttachment(testAcc.Id);
        insert testAttach;
        
        Note testNote = PGITestUtilities.createNote(testAcc.Id);
        insert testNote;
        
        CountOfRelatedObjectBatchClassAPAC countforAPAC= new CountOfRelatedObjectBatchClassAPAC();
        countforAPAC.query='SELECT ID, Name, Ownerid FROM Account LIMIT 200';
        ID batchprocessid = Database.executeBatch(countforAPAC);
        
        CountOfRelatedObjectBatchClassEMEA countforEMEA= new CountOfRelatedObjectBatchClassEMEA();
        countforEMEA.query='SELECT ID, Name, Ownerid FROM Account LIMIT 200';
        batchprocessid = Database.executeBatch(countforEMEA);
        
        CountOfRelatedObjectBatchClassNA countforNA= new CountOfRelatedObjectBatchClassNA();
        countforNA.query='SELECT ID, Name, Ownerid FROM Account LIMIT 200';
        batchprocessid = Database.executeBatch(countforNA);
        
        Test.StopTest();
    }

}