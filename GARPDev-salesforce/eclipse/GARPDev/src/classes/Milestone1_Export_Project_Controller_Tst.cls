@isTest
private class Milestone1_Export_Project_Controller_Tst {

    static testMethod void testImportController() {
        Milestone1_XML_Export_Utility m1exportutility = new Milestone1_XML_Export_Utility();
        Milestone1_Project__c testProject = Milestone1_Test_Utility.sampleProject('UNIT TEST PROJECT NAME CONTROLLER UNIQUE' + System.now());
        insert testProject;
        testProject = [select Id, Name from Milestone1_Project__c where Name = :testProject.Name limit 1];
        
        Milestone1_Log__c testLog = new Milestone1_Log__c();
        testLog.Project__c = testProject.Id;
        testLog.Subject__c = 'UNIT TEST LOG SUBJECT ABC123XYZ UNIQUE' + System.now();
        insert testLog;
        testLog = [select Id, Name from Milestone1_Log__c where Subject__c = :testLog.Subject__c limit 1];
        
        Milestone1_Milestone__c testMilestone = Milestone1_Test_Utility.sampleMilestone(testProject.Id,null,'UNIT TEST MILESTONE NAME ACB123XYZ UNIQUE' + System.now());
        insert testMilestone;
        testMilestone = [select Id, Name from Milestone1_Milestone__c where Name = :testMilestone.Name limit 1];
        
        Milestone1_Milestone__c testSubMilestone = Milestone1_Test_Utility.sampleMilestone(null,testMilestone.Id,'UNIT TEST SUB MILESTONE 1 NAME ACB123XYZ UNIQUE' + System.now());
        insert testSubMilestone;
        testSubMilestone = [select Id, Name from Milestone1_Milestone__c where Name = :testSubMilestone.Name limit 1];
        
        Milestone1_Task__c task1 = Milestone1_Test_Utility.sampleTask(testMilestone.Id);
        insert task1;
        Milestone1_Task__c task2 = Milestone1_Test_Utility.sampleTask(testMilestone.Id);
        insert task2;
        
        
        Milestone1_Export_Project_Controller controller = new Milestone1_Export_Project_Controller(new ApexPages.StandardController(testProject));
        controller.createExportXML();
        System.assert(controller.doc != null);
        System.assert(controller.doc.Id != null);
        ApexPages.Pagereference docRef = controller.returnToDocument();
        system.assert(docRef != null);
        ApexPages.Pagereference projRef = controller.returnToProject();
        System.assert(projRef != null);
    }
}