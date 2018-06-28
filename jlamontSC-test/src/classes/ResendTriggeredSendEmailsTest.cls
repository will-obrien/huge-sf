@isTest
public with sharing class ResendTriggeredSendEmailsTest {
   // CRON expression: midnight on March 15.
   // Because this is a test, job executes
   // immediately after Test.stopTest().
   public static String CRON_EXP = '0 0 0 15 3 ? 2022';

   static testmethod void test() {
      Test.startTest();

      // Schedule the test job
      String jobId = System.schedule('ResendTriggeredSendEmailsTest',
                        CRON_EXP, 
                        new ResendTriggeredSendEmails());
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      System.assertEquals('2022-03-15 00:00:00', 
         String.valueOf(ct.NextFireTime));
         
      TriggeredSendEmail__c email = new TriggeredSendEmail__c(
      	Email__c='test@abc.xyz',
      	Resend__c = true,
      	SendId__c = 'event-autoresponder',
      	StatusCode__c = 503
      );
      insert email; 
      
      // Verify the scheduled job hasn't run yet.
      List<TriggeredSendEmail__c> tseList = [
      	select Id from TriggeredSendEmail__c where Resend__c = true
      ];
      System.assertEquals(1, tseList.size(),1);
      Test.stopTest();

   }
}