@isTest
private class CampaignSearchControllerTest {

    static testMethod void myUnitTest() {
        Date dtStart = System.today();
        Date dtEnd = dtStart.addDays(30);
        
        Campaign testCamp = new Campaign(
            Name = 'Test Campaign',
            National_Campaign_Global__c = 'Beyond Coal',
            Tactic_Owner_Category_Global__c = 'Digital Dept',
            Tactic_Owner_Global__c = 'AddUp',
            Campaign_Strategy_Global__c = 'Clean Energy',
            Local_Campaign_Global__c = 'My Generation',
            State_Global__c = 'CA',
            Promo_Description__c = 'Test Campaign',
            StartDate = dtStart.addDays(10)
        );
        insert testCamp;
        
        CampaignSearchController controller = new CampaignSearchController();
        controller.setDtStartString(formatDate(dtStart));
        controller.setDtEndString(formatDate(dtEnd));
        controller.getDtStartString();
        controller.getDtEndString();
        Campaign camp = controller.getCampaign();
        camp.National_Campaign_Global__c = 'Beyond Coal';
        camp.Tactic_Owner_Category_Global__c = 'Digital Dept';
        camp.Tactic_Owner_Global__c = 'AddUp';
        camp.Campaign_Strategy_Global__c = 'Clean Energy';
        camp.Local_Campaign_Global__c = 'My Generation';
        camp.State_Global__c = 'CA';
        camp.Promo_Description__c = 'Test Campaign';
        controller.campaignName = 'Test Campaign';
        
        controller.search();
        
        List<Campaign> campList = controller.campList;
        System.assertEquals(1, campList.size());
        System.assertEquals(testCamp.Id, campList.get(0).Id);
        
        controller.setCampaign(testCamp);
        controller.cancel();
        
        TestDataUtility testData = new TestDataUtility();
        Id organizationRecordTypeId = testData.getAccountRecordTypeId('Organization');
        Account testOrganizationAccount = testData.createNewAccount(false,'Test Account2','Organization');
        ApexPages.StandardController sc = new ApexPages.StandardController(testOrganizationAccount);
        
        CampaignSetter setter = new NewAccountExtensionCampSearch(sc);
        controller.pageController = setter;
        controller.selectedCampaignId = testCamp.Id;
        System.assertEquals(testCamp.Id, controller.selectedCampaignId);
        controller.setSelectedCampaign();
    }
    private static String formatDate(Date input) {
        if(input == null) {
            return '';
        }
        DateTime dt = DateTime.newInstance(input.year(), input.month(), input.day());
        return dt.format('MM/dd/yyyy');
    }
}