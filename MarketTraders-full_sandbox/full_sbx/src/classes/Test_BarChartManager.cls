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
private class Test_BarChartManager {
	
	static testMethod void testBatchSubscribe() {
		
		list<Account> accounts = new list<Account>();
		for(integer x = 0; x < 1; x++){
			Account account = new Account();
	    	account.FirstName = 'test';
	    	account.LastName = 'test';
	    	account.Phone = '4078835257';
	    	account.PersonEmail = 'test@test.com';
	    	account.BillingStreet = '2350 Delaney Ave';
	    	account.BillingCity = 'Orlando';
	    	account.BillingPostalCode = '32801';
	    	account.Barchart_Location__c = 'FL';
	    	accounts.add(account);
		}
		
		Database.insert(accounts);
		map<Id,Account> accountMap = new map<Id,Account>([SELECT id FROM Account LIMIT 200]);
		
		test.startTest();
   			StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
			mock.setStaticResource('subscribe_user_response');
			mock.setStatusCode(200);
			mock.setHeader('Content-Type', 'application/json');	
			Test.setMock(HttpCalloutMock.class, mock);
	   		BarChartManager batchBarChartManager = new BarChartManager(accountMap.keySet(),'Subscribe');
			Database.executeBatch(batchBarChartManager,1);
		test.stopTest();
		
	}
	
	static testMethod void testBatchCancel() {
		
		list<Account> accounts = new list<Account>();
		for(integer x = 0; x < 1; x++){
			Account account = new Account();
	    	account.FirstName = 'test';
	    	account.LastName = 'test';
	    	account.Phone = '4078835257';
	    	account.PersonEmail = 'test@test.com';
	    	account.BillingStreet = '2350 Delaney Ave';
	    	account.BillingCity = 'Orlando';
	    	account.BillingPostalCode = '32801';
	    	account.Barchart_Location__c = 'FL';
	    	account.Charting_BARCHARTS_Username__pc = 'mti_jim';
	    	accounts.add(account);
		}
		
		Database.insert(accounts);
		map<Id,Account> accountMap = new map<Id,Account>([SELECT id FROM Account LIMIT 200]);
		
		test.startTest();
   			StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
			mock.setStaticResource('cancel_user_response');
			mock.setStatusCode(200);
			mock.setHeader('Content-Type', 'application/json');	
			Test.setMock(HttpCalloutMock.class, mock);
	   		BarChartManager batchBarChartManager = new BarChartManager(accountMap.keySet(),'Cancel');
			Database.executeBatch(batchBarChartManager,1);
		test.stopTest();
		
	}
	
    static testMethod void testGenerateMethods() {

		test.startTest();
		
			String password = BarChartManager.generatePassword();
			system.assertEquals(8,password.length());
			
			String username = BarChartManager.generateUsername();
			system.assertEquals(8,username.length());
		
		test.stopTest();

    }
    
    static testMethod void testCheckUserName() {
    	
    	String username = BarChartManager.generateUsername();
		
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('check_user_response');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		
		Test.setMock(HttpCalloutMock.class, mock);
		
		test.startTest();
			Boolean response = BarChartManager.checkUserName(username);
			system.assertEquals(true,response);
		test.stopTest();
		
    }
    
    static testMethod void testSubscribe() {
    	
    	String password = BarChartManager.generatePassword();
    	String username = BarChartManager.generateUsername();
    	
    	Account account = new Account();
    	account.FirstName = 'test';
    	account.LastName = 'test';
    	account.phone = '4078835257';
    	account.PersonEmail = 'test@test.com';
    	account.BillingStreet = '2350 Delaney Ave';
    	account.BillingCity = 'Orlando';
    	account.BillingPostalCode = '32801';
    	account.Barchart_Location__c = 'FL';
    			
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('subscribe_user_response');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		
		Test.setMock(HttpCalloutMock.class, mock);
		
		test.startTest();
			String response = BarChartManager.subscribe(account,username,password);
			system.assertEquals('{"status_code":"200","result":"OK"}',response);
		test.stopTest();
		
    }
    
    static testMethod void testCancel() {
    	
    	Account account = new Account();
    	account.FirstName = 'test';
    	account.LastName = 'test';
    	account.phone = '4078835257';
    	account.PersonEmail = 'test@test.com';
    	account.BillingStreet = '2350 Delaney Ave';
    	account.BillingCity = 'Orlando';
    	account.BillingPostalCode = '32801';
    	account.Barchart_Location__c = 'FL';
    	account.Charting_BARCHARTS_Username__pc = 'mti_jim';
    			
		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('subscribe_user_response');
		mock.setStatusCode(200);
		mock.setHeader('Content-Type', 'application/json');
		
		Test.setMock(HttpCalloutMock.class, mock);
		
		test.startTest();
			String response = BarChartManager.cancel(account);
			system.assertEquals('{"status_code":"200","result":"OK"}',response);
		test.stopTest();
		
    }
    
    static testMethod void testValidateSubscriptionRequest() {
    	
    	Account account = new Account();

		test.startTest();
			boolean response = BarChartManager.validateSubscriptionRequest(account);
			system.assertEquals(false,response);
			account.FirstName = 'test';
	    	account.LastName = 'test';
	    	account.phone = '4078835257';
	    	account.PersonEmail = 'test@test.com';
	    	account.BillingStreet = '2350 Delaney Ave';
	    	account.BillingCity = 'Orlando';
	    	account.BillingPostalCode = '32801';
	    	account.Barchart_Location__c = 'FL';
	    	account.Charting_BARCHARTS_Username__pc = 'mti_jim';
	    	response = BarChartManager.validateSubscriptionRequest(account);
			system.assertEquals(true,response);
		test.stopTest();
		
    }
    
    
}