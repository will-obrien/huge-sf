/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_ReferralTrigger {

    static testMethod void myUnitTest() {
        Lead referredTo = new Lead();
	    referredTo.FirstName = 'Clark';
	    referredTo.LastName = 'Kent';
	    referredTo.leadSource = 'Newspaper';
	    referredTo.Email = 'clark.kent@smallville.com';
	    Database.insert(referredTo);
	    
	    Account referredBy = new Account();
	    referredBy.FirstName = 'Bruce';
	    referredBy.LastName = 'Wayne';
	    referredBy.PersonEmail = 'bruce.wayne@gotham.com';
	    referredBy.Country_List__c = 'United States of America';
	    referredBy.RecordTypeId = '012600000005CeK';
	    Database.insert(referredBy);
	    
	    test.startTest();
	    
	    	Referral__c referral = new Referral__c();
	    	referral.Referred_By_Account__c = referredBy.id;
	    	referral.referred_To_Lead__c = referredTo.id;
	    	referral.Personal_Message__c = 'test';
	    	Database.insert(referral);
	    
	    test.stopTest();
	    //	Lead lead = [SELECT id, Referred__c, Referral_Personal_Message__c FROM Lead WHERE id = :referredTo.id LIMIT 1];
	    //	system.assertEquals(true, lead.Referred__c);
	    //	system.assertEquals(lead.Referral_Personal_Message__c,'test');
	    
	    
	    
    }
    
    static testMethod void testReferredToAccount(){
    	
    	Account referredTo = new Account();
	    referredTo.FirstName = 'Clark';
	    referredTo.LastName = 'Kent';
	    referredTo.PersonEmail = 'superman@smallville.com';
	    referredTo.Country_List__c = 'United States of America';
	    referredTo.RecordTypeId = '012600000005CeK';
	    Database.insert(referredTo);
	    
	    Account referredBy = new Account();
	    referredBy.FirstName = 'Bruce';
	    referredBy.LastName = 'Wayne';
	    referredBy.PersonEmail = 'bruce.wayne@gotham.com';
	    referredBy.Country_List__c = 'United States of America';
	    referredBy.RecordTypeId = '012600000005CeK';
	    Database.insert(referredBy);
	    
	    test.startTest();
	    
	    	Referral__c referral = new Referral__c();
	    	referral.Referred_By_Account__c = referredBy.id;
	    	referral.referred_To_Account__c = referredTo.id;
	    	referral.Personal_Message__c = 'test';
	    	Database.insert(referral);
	    
	    test.stopTest();
    }
}