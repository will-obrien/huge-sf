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
private class Test_UpdateLeadSource {
	
	static testMethod void myUnitTest() {
		
		list<Lead_Sources__c> leadSources = new list<Lead_Sources__c>();
		
		Lead superman = new Lead();
	    superman.FirstName = 'Clark';
	    superman.LastName = 'Kent';
	    superman.leadSource = 'Newspaper';
	    superman.Email = 'clark.kent@smallville.com';
	    Database.insert(superman);
	    
	    Lead_Sources__c leadSource = new Lead_Sources__c();
	    leadSource.Lead__c = superman.id;
	    leadSource.Lead_Source__c = 'test';
	    leadSource.Lead_Source_Date__c = Date.today();
	    leadSource.Lead_Source_Detail__c = 'testing again';
	    leadSources.add(leadSource);
	    
	    Account bruceWayneAccount = new Account();
	    bruceWayneAccount.FirstName = 'Bruce';
	    bruceWayneAccount.LastName = 'Wayne';
	    bruceWayneAccount.PersonEmail = 'bruce.wayne@gotham.com';
	    bruceWayneAccount.Country_List__c = 'United States of America';
	    bruceWayneAccount.RecordTypeId = '012600000005CeK';
	    Database.insert(bruceWayneAccount);
	    
	    Lead_Sources__c leadSource2 = new Lead_Sources__c();
	    leadSource2.Account__c = bruceWayneAccount.id;
	    leadSource2.Lead_Source__c = 'test';
	    leadSource2.Lead_Source_Date__c = Date.today();
	    leadSource2.Lead_Source_Detail__c = 'testing again';
	    leadSources.add(leadSource2);
	    
	    
	    test.startTest();
	    
	    	Database.insert(leadSources);
	    	
	    	Lead_Sources__c leadSource3 = new Lead_Sources__c();
		    leadSource3.Lead__c = superman.id;
		    leadSource3.Lead_Source__c = 'test';
		    leadSource3.Lead_Source_Date__c = Date.today();
		    leadSource3.Lead_Source_Detail__c = 'testing again';
		    //Database.insert(leadSource3);
	    
	    test.stopTest();
	    
	}

}