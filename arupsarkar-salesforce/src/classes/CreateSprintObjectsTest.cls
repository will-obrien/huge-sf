@isTest(seeAllData=true)
public class CreateSprintObjectsTest{

    static testMethod void createObjectTest(){
    
    	CreateSprintObjects testSprintObj = new CreateSprintObjects();
        List<AgileProject__c> projList = testSprintObj.Project();
        List<Product_Backlog_Item__c> ProductBackLogList = testSprintObj.ProductBackLog();
        List<Development_Team__c> DevelopmentTeamList = testSprintObj.DevelopmentTeam();
        List<Development_Team_Member__c> DevelopmentTeamMemberList = testSprintObj.DevelopmentTeamMember();
        List<Sprint__c> sprintList = testSprintObj.Sprint();
        List<Sprint_Task__c> sprintTaskList = testSprintObj.SprintTask();
    }
}