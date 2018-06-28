@isTest
private class Milestone1_Time_Trigger_Tst  
{
    static testMethod void testTimeTrigger()
    {
        Milestone1_Project__c proj = Milestone1_Test_Utility.sampleProject('proj');
        insert proj;
        
        Milestone1_Milestone__c ms1 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms1');
        ms1.Alias__c = 'unit_test';
        insert ms1;
       
        Milestone1_Task__c task1 = Milestone1_Test_Utility.sampleTask(ms1.Id);
        insert task1;
        
        Milestone1_Time__c msTime = new Milestone1_Time__c();
        msTime.Hours__c = 12.00;
        msTime.Description__c = 'Unit Test ABCDEFG 123 XYZ 999';
        msTime.Project_Task__c = task1.Id;
        insert msTime;
        
        msTime = [Select Id, Name, Incurred_By__c from Milestone1_Time__c where Project_Task__c =: msTime.Project_Task__c ];
        
        System.assertEquals(UserInfo.getUserId(),msTime.Incurred_By__c);
        
    }

}