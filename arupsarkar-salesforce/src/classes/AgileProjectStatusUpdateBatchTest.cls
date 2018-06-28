@isTest(seeAllData=true)
public class AgileProjectStatusUpdateBatchTest{

    static testMethod void agileProjectStatusUpdateBatchTest(){
        Test.startTest();
		CreateSprintObjects createSprintObj = new CreateSprintObjects();
        List<AgileProject__c> agileProjectList = createSprintObj.Project();
        SchedulableContext ctx;
        AgileProjectStatusUpdateApexSchedule agileProjectNotificationSchedule = 
            			new AgileProjectStatusUpdateApexSchedule();
        agileProjectNotificationSchedule.execute(ctx);
        
    	Test.stopTest();
    }    
}