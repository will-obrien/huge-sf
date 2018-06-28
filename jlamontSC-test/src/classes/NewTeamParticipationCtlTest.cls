@isTest
public class NewTeamParticipationCtlTest {
    
    private static Id actionTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Offline Action').getRecordTypeId();
    
    static testMethod void myUnitTest() {
        
        Club_Entity__c ent = new Club_Entity__c(
        	Name = 'Test Entity'
        );     
        insert ent;        
        
    	Campaign actioncmp = new Campaign(
    		RecordTypeId = actionTypeId,
    		Name = '1234567890',
    		Promo_Description__c = 'Testing'
		);
    	insert actioncmp;
        
        Team_Participation__c teampart = new Team_Participation__c();
        insert teampart;
        
        PageReference PageRef = Page.NewAction;
		Test.setCurrentPage(PageRef);	
		NewTeamParticipationCtl controller = new NewTeamParticipationCtl(new ApexPages.StandardController(teampart));
        CampaignSearchController csc = controller.getCampSearchController();
        controller.setCampSearchController(csc);
        controller.getThis();
        controller.setSelectedCampaign(actioncmp);
        
    }

}