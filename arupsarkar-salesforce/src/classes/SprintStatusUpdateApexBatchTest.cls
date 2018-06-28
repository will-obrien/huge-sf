@isTest(seeAllData=true)
public class SprintStatusUpdateApexBatchTest{
	
    static testMethod void sprintStatusUpdateBatchTest(){
        Test.startTest();
        
        SchedulableContext ctx;
        SprintStatusUpdateApexSchedule sprintStatusUpdateNotificationSchedule = 
            			new SprintStatusUpdateApexSchedule();
        sprintStatusUpdateNotificationSchedule.execute(ctx);
        
    	Test.stopTest();
    }        
}