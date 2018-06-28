@isTest
private class PhonebankPDFControllerTest {
    private static final Id listsTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Lists').getRecordTypeId();

    static testMethod void myUnitTest() {
		
		TestrCSettingUtility.createrCSettings();
		ClubEventTriggerHandler.testing = true;
		
		Campaign camp1 = new Campaign(
			RecordTypeId = listsTypeId,
			Name = 'TestCamp1'
		);
		insert camp1;
    	
    	PhonebankPDFController ctl = new PhonebankPDFController();
    	Boolean isEventCampaign = ctl.getIsEventCampaign();
    	System.assertEquals(false, isEventCampaign);
    	
		PageReference pageRef = Page.PhonebankPDF;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id', camp1.Id);
		
		Campaign camp = ctl.getCamp();
		System.assertEquals(camp1.Id, camp.Id);
    	
        isEventCampaign = ctl.getIsEventCampaign();
        System.assertEquals(false, isEventCampaign);
        
		List<CampaignMember> campMbrList = ctl.getCampMbrList();
		System.assert(campMbrList.isEmpty());
    }
}