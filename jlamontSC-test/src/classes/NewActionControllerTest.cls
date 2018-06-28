@isTest
private class NewActionControllerTest {
    
    private static Id actionTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Offline Action').getRecordTypeId();
    
    static testMethod void myUnitTest() {

    	Campaign actioncmp = new Campaign(
    		RecordTypeId = actionTypeId,
    		Name = '1234567890',
    		Promo_Description__c = 'Testing'
		);
    	insert actioncmp;
        
        kweos__EOCS_Data__c action = new kweos__EOCS_Data__c();
        insert action;
        
        PageReference PageRef = Page.NewAction;
		Test.setCurrentPage(PageRef);	
		NewActionController controller = new NewActionController(new ApexPages.StandardController(action));
        CampaignSearchController csc = controller.getCampSearchController();
        controller.setCampSearchController(csc);
        controller.getThis();
        controller.setSelectedCampaign(actioncmp);
        
    }

}