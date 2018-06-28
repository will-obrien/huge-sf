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
private class Test_Handler_Account {

    static testMethod void insertTest() {

		list<Account> accounts = new list<Account>();
		for(integer x = 0; x < 2; x++){
			Account account = new Account();
		    account.FirstName = 'Bruce';
		    account.LastName = 'Wayne';
		    account.PersonEmail = 'bruce' + String.valueOf(x) + '.wayne@gotham.com';
		    account.Country_List__c = 'United States of America';
		    account.RecordTypeId = '012600000005CeK';
		    accounts.add(account);
		}
		
		test.startTest();
			Database.insert(accounts);
		test.stopTest();
    }
    
    
    static testMethod void updateTest() {

		list<Account> accounts = new list<Account>();
		for(integer x = 0; x < 2; x++){
			Account account = new Account();
		    account.FirstName = 'Bruce';
		    account.LastName = 'Wayne';
		    account.PersonEmail = 'bruce' + String.valueOf(x) + '.wayne@gotham.com';
		    account.Country_List__c = 'United States of America';
		    account.RecordTypeId = '012600000005CeK';
		    accounts.add(account);
		}
		
		insert accounts;

		for (Account a : accounts) {
			a.LastName = 'Springsteen';
		}
		
		test.startTest();
			System.debug(LoggingLevel.ERROR, '@@@@ testing handler_account for update, updating accounts');
			// reset handler account info
			Handler_Account.BYPASS = false;
    		Handler_Account.BYPASSPROCESSOR = false;
    		Handler_Account.BYPASSMERGE = false;
    		Handler_Account.BEFOREFIRED = false;
    		Handler_Account.AFTERFIRED = false;
    		Handler_Account.ALLOW_WEBCHARTING_UPDATE = false;
			
			Database.update(accounts);
			System.debug(LoggingLevel.ERROR, '@@@@ testing handler_account for update, DONE updating accounts');
		test.stopTest();
    }
    
    static testMethod void updateTest2() {

		list<Account> accounts = new list<Account>();
		for(integer x = 0; x < 2; x++){
			Account account = new Account();
		    account.FirstName = 'Bruce';
		    account.LastName = 'Wayne';
		    account.PersonEmail = 'bruce' + String.valueOf(x) + '.wayne@gotham.com';
		    account.Country_List__c = 'United States of America';
		    account.RecordTypeId = '012600000005CeK';
		    accounts.add(account);
		}
		
		insert accounts;
		
		for (Account a : accounts) {
			a.LastName = 'Springsteen';
		}
		
		test.startTest();
			System.debug(LoggingLevel.ERROR, '@@@@ testing handler_account for update, updating accounts');
			// reset handler account info
			Handler_Account.BYPASS = false;
    		Handler_Account.BYPASSPROCESSOR = false;
    		Handler_Account.BYPASSMERGE = false;
    		Handler_Account.BEFOREFIRED = false;
    		Handler_Account.AFTERFIRED = false;
    		Handler_Account.ALLOW_WEBCHARTING_UPDATE = true;
			
			Database.update(accounts);
			System.debug(LoggingLevel.ERROR, '@@@@ testing handler_account for update, DONE updating accounts');
		test.stopTest();
    }
    
    static testMethod void deleteTest() {

		list<Account> accounts = new list<Account>();
		for(integer x = 0; x < 2; x++){
			Account account = new Account();
		    account.FirstName = 'Bruce';
		    account.LastName = 'Wayne';
		    account.PersonEmail = 'bruce' + String.valueOf(x) + '.wayne@gotham.com';
		    account.Country_List__c = 'United States of America';
		    account.RecordTypeId = '012600000005CeK';
		    accounts.add(account);
		}
		
		insert accounts;
		
		test.startTest();
			// reset handler account info
			Handler_Account.BYPASS = false;
    		Handler_Account.BYPASSPROCESSOR = false;
    		Handler_Account.BYPASSMERGE = false;
    		Handler_Account.BEFOREFIRED = false;
    		Handler_Account.AFTERFIRED = false;
    		Handler_Account.ALLOW_WEBCHARTING_UPDATE = false;
		
			Database.delete(accounts);
		test.stopTest();
    }
    
    static testMethod void undeleteTest() {

		list<Account> accounts = new list<Account>();
		for(integer x = 0; x < 2; x++){
			Account account = new Account();
		    account.FirstName = 'Bruce';
		    account.LastName = 'Wayne';
		    account.PersonEmail = 'bruce' + String.valueOf(x) + '.wayne@gotham.com';
		    account.Country_List__c = 'United States of America';
		    account.RecordTypeId = '012600000005CeK';
		    accounts.add(account);
		}
		
		insert accounts;
		delete accounts;
		
		test.startTest();
			// reset handler account info
			Handler_Account.BYPASS = false;
    		Handler_Account.BYPASSPROCESSOR = false;
    		Handler_Account.BYPASSMERGE = false;
    		Handler_Account.BEFOREFIRED = false;
    		Handler_Account.AFTERFIRED = false;
    		Handler_Account.ALLOW_WEBCHARTING_UPDATE = false;
			undelete accounts;
		test.stopTest();
    }
}