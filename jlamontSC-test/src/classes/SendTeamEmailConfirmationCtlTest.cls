@isTest
public class SendTeamEmailConfirmationCtlTest {
    
    static testMethod void myUnitTest() {
        
        Club_Entity__c ent = new Club_Entity__c(Name = 'Test Entity');
   	 	insert ent;
        
        PageReference PageRef = Page.SendEmailConfirmation;
		Test.setCurrentPage(PageRef);
        pageRef.getParameters().put('id', ent.Id);
		SendTeamEmailConfirmationCtl controller = new SendTeamEmailConfirmationCtl();
        
        controller.previous();
        
    }

}