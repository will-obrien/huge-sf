//*********************************************************************//
// (c) 2014 Appirio, Inc.
//
//	Test  Class for account trigger.
//	18 March 2014   KapiL Choudhary(Jaipur D.C.)
//  Updated: 
//**********************************************************************//   


@isTest
private class AccountTriggerTest {

    static testMethod void defaultCampaignTest() {
    	TestDataUtility tDu = new TestDataUtility();
    	Campaign camp = new Campaign (Name='Z17Z567890');
    	Original_Campaign__c oCampName = new Original_Campaign__c(Campaign_Name__c = camp.Name);
    	insert oCampName;
    	
    	account acc = tDu.createNewAccount(true,'testAccName',null);
    	list<account> accList = [select Original_Campaign__c from account where id=:acc.id];
    	// original campaign is set.
    	system.assertEquals(accList[0].Original_Campaign__c, camp.id);
    }
}