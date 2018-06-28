@isTest
private class ActionTagControllerTest {

    static testMethod void myUnitTest() {
    	BulkEntryController bec = new BulkEntryController();
    	ActionTagController atc = new ActionTagController();
    	atc.pageController = bec;
    	
    	Campaign camp = new Campaign(
    		Name='Test Campaign'
    	);
    	insert camp;
    	
    	atc.selectedCampaignId = camp.Id;
    	atc.setSelectedCampaign();
    	
    	atc.setDtStartString('1/1/2017');
    	atc.setDtEndString('12/31/2017');
    	atc.setDtActionString('1/1/2017');
    	atc.getDtStartString();
    	atc.getDtEndString();
    	atc.getDtActionString();
    	
    	atc.campaignName = 'Test Campaign';

		Schema.DescribeFieldResult fieldResult = Campaign.National_Campaign_Global__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		atc.camp.National_Campaign_Global__c = ple.get(0).getValue();
		
		fieldResult = Campaign.Campaign_Strategy_Global__c.getDescribe();
		ple = fieldResult.getPicklistValues();
		atc.camp.Campaign_Strategy_Global__c = ple.get(0).getValue();

		fieldResult = Campaign.Local_Campaign_Global__c.getDescribe();
		ple = fieldResult.getPicklistValues();
		atc.camp.Local_Campaign_Global__c = ple.get(0).getValue();

		fieldResult = Campaign.State_Global__c.getDescribe();
		ple = fieldResult.getPicklistValues();
		atc.camp.State_Global__c = ple.get(0).getValue();

		fieldResult = Campaign.Tactic_Owner_Category_Global__c.getDescribe();
		ple = fieldResult.getPicklistValues();
		atc.camp.Tactic_Owner_Category_Global__c = ple.get(0).getValue();

		fieldResult = Campaign.Tactic_Owner_Global__c.getDescribe();
		ple = fieldResult.getPicklistValues();
		atc.camp.Tactic_Owner_Global__c = ple.get(0).getValue();
		
		atc.camp.Promo_Description__c = 'Test Campaign';
		atc.entityName = 'Test';
		atc.localGrassrootsCampName = 'Test';
		
		atc.search();
		
		atc.saveTag();
		atc.cancelActionTag();
		atc.resetCampaign();
		atc.getCloseAction();
		
		atc.setDtStartString(null);
		atc.setDtEndString(null); 
		atc.setDtActionString(null);   	
    }
}