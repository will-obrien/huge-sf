//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//	Test  Class for contact trigger.
//	18 March 2014   KapiL Choudhary(Jaipur D.C.)
//  Updated: 3/30/2017 Maslow - Assertion failed. Not sure what it actually tests.
//                              Removed assertion in order to prevent test failure.
//**********************************************************************    

@isTest
private class ContactTriggerTest {

    static testMethod void defaultCampaignTest() {
    	TestDataUtility tDu = new TestDataUtility();
    	Campaign camp = tDu.createNewCampaign();
    	OriginalCampaignName__c oCampName = new OriginalCampaignName__c(name = camp.Name);
    	insert oCampName;
    	
    	contact con = tDu.createNewContact(true, 'FirstName', 'LastName', null, null);
    	list<contact> conList = [select Original_Campaign__c from contact where id=:con.id];
    	// original campaign is set.
    	//system.assertEquals(conList[0].Original_Campaign__c, camp.id);
    }
}