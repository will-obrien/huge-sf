public with sharing class Milestone1_Expense_Trigger_Utility 
{
    public static void handleExpenseBeforeTrigger(List<Milestone1_Expense__c> recs)
    {
        for(Milestone1_Expense__c rec : recs)
        {
            if(rec.Incurred_By__c == null)
            {
                rec.Incurred_By__c = UserInfo.getUserId();
            }
            if(rec.Date_Incurred__c == null)
            {
                rec.Date_Incurred__c = Date.today();
            }
        }
    }
    
    static testMethod void testTriggerUtility()
    {
        List<Milestone1_Expense__c> recs = new List<Milestone1_Expense__c>{new Milestone1_Expense__c()};
        Milestone1_Expense_Trigger_Utility.handleExpenseBeforeTrigger(recs);
        for(Milestone1_Expense__c rec : recs)
        {
            System.assertEquals(UserInfo.getUserId(),rec.Incurred_By__c);
            System.assertEquals(Date.today(),rec.Date_Incurred__c);
        }
    }
    
}