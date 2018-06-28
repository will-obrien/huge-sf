//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//  Test Class for TestDataUtility 
//  9 March 2014     Virendra (Appirio)     

//**********************************************************************/
@isTest
private class TestDataUtilityTest {
    
     @IsTest
      static  void testUtilityMethods() {
      	 rC_Giving__Account_Setting__c mc = rC_Giving__Account_Setting__c.getInstance(UserInfo.getProfileId());
            mc.rC_Giving__Disable_All__c = true;
            upsert mc;
            
         rC_Giving__Campaign_Setting__c cSetting =  rC_Giving__Campaign_Setting__c.getInstance(UserInfo.getProfileId());  
          cSetting.rC_Giving__Disable_All__c = true;
            upsert cSetting;
            
        TestDataUtility testData = new TestDataUtility();
        testData.createOpportunityFieldSetting();
        testData.createNewPlannedGiving();
        testData.createNewGivingOpportunity();
        testData.createNewGivingGAU();
        testData.getAccountRecordTypeId('Household');
        testData.getOpportunityRecordTypeId('Proposal');
        Account act = testData.createNewAccount(false,'Test Account2','Household');
        testData.createNewContact(false, 'FirstName', 'LastName', null,act.Id);
        testData.createNewInvalidAccountAddress(false);
        testData.createNewValidAccountAddress(false);
        testData.createNewContact(true, 'FirstName', 'LastName', null, null);   
        testData.createNewAddress(true);
        testData.createNewValidAccountAddress(false);
        testData.createNewValidContactAddress(false);
        testData.createNewInvalidAccountAddress(false);
        testData.createNewInvalidContactAddress(false);
        testData.createNewInvalidAddress(false);
        testData.createNewValidAddress(false);
        testData.createNewGivingGAU();
        testData.createNewGivingOpportunity();
        testData.createNewCampaign();
        testData.createNewPlannedGiving();
        testData.createOpportunityFieldSetting();
        TestDataUtility.createBDSUser();
        
    }

}