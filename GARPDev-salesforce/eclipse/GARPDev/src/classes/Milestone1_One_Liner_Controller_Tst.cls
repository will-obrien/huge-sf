@isTest
private class Milestone1_One_Liner_Controller_Tst {
    
    static testMethod void testSuccessfulTaskLine()
    {
        Milestone1_XML_Export_Utility m1exportutility = new Milestone1_XML_Export_Utility();
        Milestone1_Project__c testProject = Milestone1_Test_Utility.sampleProject('UNIT_TEST_PROJECT_NAME_ABC123XYZ_UNIQUE' + System.now());
        insert testProject;
        testProject = [select Id, Name from Milestone1_Project__c where Name = :testProject.Name limit 1];
        
        Milestone1_Milestone__c testMilestone = Milestone1_Test_Utility.sampleMilestone(testProject.Id,null,'UNIT_TEST_MILESTONE_NAME_ACB123XYZ_UNIQUE' + System.now());
        testMilestone.Alias__c = 'utalias';
        insert testMilestone;
        testMilestone = [select Id, Name from Milestone1_Milestone__c where Name = :testMilestone.Name limit 1];
        
        Milestone1_One_Line_Controller controller = new Milestone1_One_Line_Controller();
        controller.line = 'utalias --- NEW DESCRIPTION';
        controller.executeLine();
        System.assert(controller.task != null);
        System.assert(controller.task.Id != null);
        System.assert(controller.task.Description__c == 'NEW DESCRIPTION');
    }
    
    static testMethod void testSuccessfulTaskLineOver80Char()
    {
        Milestone1_XML_Export_Utility m1exportutility = new Milestone1_XML_Export_Utility();
        Milestone1_Project__c testProject = Milestone1_Test_Utility.sampleProject('UNIT_TEST_PROJECT_NAME_ABC123XYZ_UNIQUE' + System.now());
        insert testProject;
        testProject = [select Id, Name from Milestone1_Project__c where Name = :testProject.Name limit 1];
        
        Milestone1_Milestone__c testMilestone = Milestone1_Test_Utility.sampleMilestone(testProject.Id,null,'UNIT_TEST_MILESTONE_NAME_ACB123XYZ_UNIQUE' + System.now());
        testMilestone.Alias__c = 'utalias';
        insert testMilestone;
        testMilestone = [select Id, Name from Milestone1_Milestone__c where Name = :testMilestone.Name limit 1];
        
        Milestone1_One_Line_Controller controller = new Milestone1_One_Line_Controller();
        controller.line = 'utalias --- NEW DESCRIPTION 1234567890 ABCDEFGHIJKLMNOPQRSTUVWXYZ THIS IS LONG DESCRIPTION GREATER THAN 80 CHARACTER LIMIT FOR NAME TEST TRUNCATING';
        controller.executeLine();
        System.assert(controller.task != null);
        System.assert(controller.task.Id != null);
        System.assertEquals('NEW DESCRIPTION 1234567890 ABCDEFGHIJKLMNOPQRSTUVWXYZ THIS IS LONG...',controller.task.Name);
        System.assertEquals('NEW DESCRIPTION 1234567890 ABCDEFGHIJKLMNOPQRSTUVWXYZ THIS IS LONG DESCRIPTION GREATER THAN 80 CHARACTER LIMIT FOR NAME TEST TRUNCATING',controller.task.Description__c);
    }
    
    static testMethod void testAliasNotFound()
    {
        
        Milestone1_One_Line_Controller controller = new Milestone1_One_Line_Controller();
        controller.line = 'XY()BC#1? --- NEW DESCRIPTION';
        controller.executeLine();
        System.assert(controller.task == null);
        List<ApexPages.Message> messages = ApexPages.getMessages();
        system.assertEquals(messages.size(),1);
        system.assertEquals(messages.get(0).getDetail(),'The alias( XY()BC#1?) did not match any milestone.');
    }
    
    static testMethod void testInvalidLineFound()
    {
        
        Milestone1_One_Line_Controller controller = new Milestone1_One_Line_Controller();
        controller.line = 'XY()BC#1?@#$JKKSD';
        controller.executeLine();
        System.assert(controller.task == null);
        List<ApexPages.Message> messages = ApexPages.getMessages();
        system.assertEquals(messages.size(),1);
        system.assertEquals(messages.get(0).getDetail(),'The line command was incorrect. Please use format <Alias> --- <DESCRIPTION>');
    }

}