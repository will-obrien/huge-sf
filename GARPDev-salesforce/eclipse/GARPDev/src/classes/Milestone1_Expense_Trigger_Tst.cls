@isTest
private class Milestone1_Expense_Trigger_Tst 
{
    static testMethod void testExpenseTrigger()
    {
        Milestone1_Project__c proj = Milestone1_Test_Utility.sampleProject('proj');
        insert proj;
        
        Milestone1_Milestone__c ms1 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms1');
        ms1.Alias__c = 'unit_test';
        insert ms1;
       
        Milestone1_Task__c task1 = Milestone1_Test_Utility.sampleTask(ms1.Id);
        insert task1;
        
        Milestone1_Expense__c msExpense = new Milestone1_Expense__c();
        msExpense.Amount__c = 100.00;
        msExpense.Description__c = 'Unit Test ABCDEFG 123 XYZ 999';
        msExpense.Project_Task__c = task1.Id;
        insert msExpense;
        
        msExpense = [Select Id, Name, Incurred_By__c from Milestone1_Expense__c where Project_Task__c =: msExpense.Project_Task__c ];
        
        System.assertEquals(UserInfo.getUserId(),msExpense.Incurred_By__c);
        
    }
}