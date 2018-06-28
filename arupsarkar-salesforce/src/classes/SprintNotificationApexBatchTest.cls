@isTest(seeAllData=true)
public class SprintNotificationApexBatchTest{

    static testMethod void sprintNotificationBatchTest(){
        Test.startTest();
        
        SchedulableContext ctx;
        SprintNotificationApexSchedule sprintNotificationSchedule = new SprintNotificationApexSchedule();
        sprintNotificationSchedule.execute(ctx);
        
    	Test.stopTest();
    }
}