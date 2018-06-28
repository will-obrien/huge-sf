@isTest
private class Milestone1_XML_Export_Utility_Test {
    
        static TestMethod void testSOQLQueries()
    {
        Milestone1_XML_Export_Utility m1exportutility = new Milestone1_XML_Export_Utility();
        Milestone1_Project__c testProject = Milestone1_Test_Utility.sampleProject('UNIT_TEST_PROJECT_NAME_ABC123XYZ_UNIQUE' + System.now());
        insert testProject;
        testProject = [select Id, Name from Milestone1_Project__c where Name = :testProject.Name limit 1];
        
        Milestone1_Log__c testLog = new Milestone1_Log__c();
        testLog.Project__c = testProject.Id;
        testLog.Subject__c = 'UNIT TEST LOG SUBJECT ABC123XYZ UNIQUE' + System.now();
        insert testLog;
        testLog = [select Id, Name from Milestone1_Log__c where Subject__c = :testLog.Subject__c limit 1];
        
        Milestone1_Milestone__c testMilestone = Milestone1_Test_Utility.sampleMilestone(testProject.Id,null,'UNIT_TEST_MILESTONE_NAME_ACB123XYZ_UNIQUE' + System.now());
        insert testMilestone;
        testMilestone = [select Id, Name from Milestone1_Milestone__c where Name = :testMilestone.Name limit 1];
        
        Milestone1_Milestone__c testSubMilestone = Milestone1_Test_Utility.sampleMilestone(null,testMilestone.Id,'UNIT_TEST_SUB_MILESTONE_1_NAME_ACB123XYZ_UNIQUE' + System.now());
        insert testSubMilestone;
        testSubMilestone = [select Id, Name from Milestone1_Milestone__c where Name = :testSubMilestone.Name limit 1];
        
        Milestone1_Task__c task1 = Milestone1_Test_Utility.sampleTask(testMilestone.Id);
        insert task1;
        Milestone1_Task__c task2 = Milestone1_Test_Utility.sampleTask(testMilestone.Id);
        insert task2;
        
        String xmlString = m1exportutility.buildProjectXmlString(testProject.Id);
        System.assertNotEquals(xmlString, null);
        Integer projectNamePos = xmlString.indexOf('UNIT_TEST_PROJECT_NAME_ABC123XYZ_UNIQUE');
        Integer milestoneNamePos = xmlString.indexOf('UNIT_TEST_MILESTONE_NAME_ACB123XYZ_UNIQUE');
        Integer subMilestoneNamePos = xmlString.indexOf('UNIT_TEST_SUB_MILESTONE_1_NAME_ACB123XYZ_UNIQUE');
        System.assert(projectNamePos > 0);
        System.assert(milestoneNamePos > 0);
        System.assert(subMilestoneNamePos > 0);
        System.assert(projectNamePos < milestoneNamePos);
        System.assert(projectNamePos < subMilestoneNamePos);

        
    }
}