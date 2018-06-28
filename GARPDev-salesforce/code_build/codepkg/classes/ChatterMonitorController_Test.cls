@isTest
public class ChatterMonitorController_Test{
 static Content__c cont;
  
   static void testData()
   {
       cont = new Content__c(Name = 'Test Article');
       insert cont; 
       FeedItem feeditemtest = new FeedItem ();
       feeditemtest.ParentId = cont.id ;
       feeditemtest.Body = 'Test Chatter Body';
       insert feeditemtest;
   }

static testMethod void unitTest_1(){
        test.startTest();
        testData();
        ChatterMonitorController chat = new ChatterMonitorController ();
        chat.fetchRecords();
        test.stopTest();
    }
}