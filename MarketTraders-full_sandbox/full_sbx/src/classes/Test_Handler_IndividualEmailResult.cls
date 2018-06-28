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
private class Test_Handler_IndividualEmailResult {

    static testMethod void testContactResultInsert() {
       	
       	list<Account> accounts = new list<Account>();
       	for(integer x = 0; x < 200; x++){
	       	Account account = new Account();
		    account.FirstName = 'Bruce';
		    account.LastName = 'Wayne';
		    account.PersonEmail = 'bruce' + String.valueOf(x) + '.wayne@gotham.com';
		    account.Country_List__c = 'United States of America';
		    account.RecordTypeId = '012600000005CeK';
		    accounts.add(account);
       	}
	    Database.insert(accounts);
	    map<Id,Account> accountMap = new map<Id,Account>([SELECT Id FROM Account]);
	    
	    list<Contact> contacts = [SELECT id FROM Contact WHERE AccountId = :accountMap.keySet()];
	    
	    list<et4ae5__IndividualEmailResult__c> results = new list<et4ae5__IndividualEmailResult__c>();
	    for(Contact contact : contacts){
	    	et4ae5__IndividualEmailResult__c result = new et4ae5__IndividualEmailResult__c();
	    	result.et4ae5__Contact__c = contact.Id;
	    	result.et4ae5__DateOpened__c = DateTime.now();
	    	result.Name = 'test';
	   		result.et4ae5__NumberOfUniqueClicks__c = 1;
	   		results.add(result);
	    }	
	    
	    test.startTest();
	   		Database.insert(results);
	    test.stopTest();
	    
    }
    
    static testMethod void testContactResultUpdate() {
       	
       	list<Account> accounts = new list<Account>();
       	for(integer x = 0; x < 200; x++){
	       	Account account = new Account();
		    account.FirstName = 'Bruce';
		    account.LastName = 'Wayne';
		    account.PersonEmail = 'bruce' + String.valueOf(x) + '.wayne@gotham.com';
		    account.Country_List__c = 'United States of America';
		    account.RecordTypeId = '012600000005CeK';
		    accounts.add(account);
       	}
	    Database.insert(accounts);
	    map<Id,Account> accountMap = new map<Id,Account>([SELECT Id FROM Account]);
	    
	    list<Contact> contacts = [SELECT id FROM Contact WHERE AccountId = :accountMap.keySet()];
	    
	    list<et4ae5__IndividualEmailResult__c> results = new list<et4ae5__IndividualEmailResult__c>();
	    for(Contact contact : contacts){
	    	et4ae5__IndividualEmailResult__c result = new et4ae5__IndividualEmailResult__c();
	    	result.et4ae5__Contact__c = contact.Id;
	    	result.Name = 'test';
	   		results.add(result);
	    }	
	    
	    Database.insert(results);
	    
	    test.startTest();
	   		
	   		for(et4ae5__IndividualEmailResult__c result : results){
	   			result.et4ae5__DateOpened__c = DateTime.now();
	   			result.et4ae5__NumberOfUniqueClicks__c = 1;
	   		}
	   		
	   		Database.update(results);
	   		
	    test.stopTest();
	    
    }
    
    static testMethod void testLeadResultInsert() {
       	
       	list<Lead> leads = new list<Lead>();
       	for(integer x = 0; x < 200; x++){
       		Lead lead = new Lead();
            lead.FirstName = 'Bizarro';
            lead.LastName = 'Kent';
            lead.leadSource = 'Newspaper';
            lead.Email = 'clark1.kent@smallville.com';
       		leads.add(lead);
       	}
	    Database.insert(leads);
	    
	    list<et4ae5__IndividualEmailResult__c> results = new list<et4ae5__IndividualEmailResult__c>();
	    for(Lead lead : Leads){
	    	et4ae5__IndividualEmailResult__c result = new et4ae5__IndividualEmailResult__c();
	    	result.et4ae5__Lead__c = lead.Id;
	    	result.et4ae5__DateOpened__c = DateTime.now();
	    	result.Name = 'test';
	   		result.et4ae5__NumberOfUniqueClicks__c = 1;
	   		results.add(result);
	    }	
	    
	    test.startTest();
	   		Database.insert(results);
	    test.stopTest();
	    
    }
    
    static testMethod void testLeadResultUpdate() {
       	
       	list<Lead> leads = new list<Lead>();
       	for(integer x = 0; x < 200; x++){
       		Lead lead = new Lead();
            lead.FirstName = 'Bizarro';
            lead.LastName = 'Kent';
            lead.leadSource = 'Newspaper';
            lead.Email = 'clark1.kent@smallville.com';
       		leads.add(lead);
       	}
	    Database.insert(leads);
	    
	    list<et4ae5__IndividualEmailResult__c> results = new list<et4ae5__IndividualEmailResult__c>();
	    for(Lead lead : leads){
	    	et4ae5__IndividualEmailResult__c result = new et4ae5__IndividualEmailResult__c();
	    	result.et4ae5__Lead__c = lead.Id;
	    	result.Name = 'test';
	   		results.add(result);
	    }	
	    
	    Database.insert(results);
	    
	    test.startTest();
	   		
	   		for(et4ae5__IndividualEmailResult__c result : results){
	   			result.et4ae5__DateOpened__c = DateTime.now();
	   			result.et4ae5__NumberOfUniqueClicks__c = 1;
	   		}
	   		
	   		Database.update(results);
	   		
	    test.stopTest();
	    
    }
    
}