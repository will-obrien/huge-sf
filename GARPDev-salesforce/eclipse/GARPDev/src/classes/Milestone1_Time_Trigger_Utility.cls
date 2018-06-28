public with sharing class Milestone1_Time_Trigger_Utility {

    public static void handleTimeBeforeTrigger(List<Milestone1_Time__c> recs)
    {
        for(Milestone1_Time__c rec : recs)
        {
            if(rec.Incurred_By__c == null)
            {
                rec.Incurred_By__c = UserInfo.getUserId();
            }
            if(rec.Date__c == null)
            {
                rec.Date__c = Date.today();
            }
        }
    }
    
    static testMethod void testTriggerUtility()
    {
        List<Milestone1_Time__c> recs = new List<Milestone1_Time__c>{new Milestone1_Time__c()};
        Milestone1_Time_Trigger_Utility.handleTimeBeforeTrigger(recs);
        for(Milestone1_Time__c rec : recs)
        {
            System.assertEquals(UserInfo.getUserId(),rec.Incurred_By__c);
            System.assertEquals(Date.today(),rec.Date__c);
        }
    }
}