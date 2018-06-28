@isTest
private class ListTagControllerTest {

    static testMethod void myUnitTest() {
        Id listTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Lists').getRecordTypeId();
    	BulkEntryController bec = new BulkEntryController();
    	ListTagController ltc = new ListTagController();
    	ltc.pageController = bec;
    	
    	Campaign camp = new Campaign(
    		Name='Test Campaign',
            RecordTypeId = listTypeId
    	);
    	insert camp;
    	
    	ltc.selectedCampaignId = camp.Id;
    	ltc.setSelectedCampaign();
    	
    	ltc.setDtStartString('1/1/2017');
    	ltc.setDtEndString('12/31/2017');
    	ltc.getDtStartString();
    	ltc.getDtEndString();
    	
    	ltc.campaignName = 'Test Campaign';

		Schema.DescribeFieldResult fieldResult = Campaign.National_Campaign_Global__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		ltc.camp.National_Campaign_Global__c = ple.get(0).getValue();
		
		fieldResult = Campaign.Campaign_Strategy_Global__c.getDescribe();
		ple = fieldResult.getPicklistValues();
		ltc.camp.Campaign_Strategy_Global__c = ple.get(0).getValue();

		fieldResult = Campaign.Local_Campaign_Global__c.getDescribe();
		ple = fieldResult.getPicklistValues();
		ltc.camp.Local_Campaign_Global__c = ple.get(0).getValue();

		fieldResult = Campaign.State_Global__c.getDescribe();
		ple = fieldResult.getPicklistValues();
		ltc.camp.State_Global__c = ple.get(0).getValue();

		fieldResult = Campaign.Tactic_Owner_Category_Global__c.getDescribe();
		ple = fieldResult.getPicklistValues();
		ltc.camp.Tactic_Owner_Category_Global__c = ple.get(0).getValue();

		fieldResult = Campaign.Tactic_Owner_Global__c.getDescribe();
		ple = fieldResult.getPicklistValues();
		ltc.camp.Tactic_Owner_Global__c = ple.get(0).getValue();
		
		ltc.camp.Promo_Description__c = 'Test Campaign';
		ltc.entityName = 'Test';
		ltc.localGrassrootsCampName = 'Test';
		
		ltc.search();
		
		ltc.saveTag();
		ltc.cancelListTag();
		ltc.resetCampaign();
		ltc.getCloseList();
		
		ltc.setDtStartString(null);
		ltc.setDtEndString(null);  	
    }
}