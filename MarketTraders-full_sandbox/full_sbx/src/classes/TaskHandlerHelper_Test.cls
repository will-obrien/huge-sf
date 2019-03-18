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
private class TaskHandlerHelper_Test {

    static testMethod void incrementTest() {
    	
    	// INIT DATA
    	
        // create account
        Account testAcct = new Account();
        testAcct.Name = 'test acct';
        insert testAcct;
        
        // create opportunity
        Opportunity testOpp = new Opportunity();
        testOpp.AccountId = testAcct.Id;
        testOpp.Name = 'test opp';
        testOpp.StageName = 'New';
        testOpp.CloseDate = Date.today();
        insert testOpp;
        
        // create 5 activities
        List<Task> testTasks = new List<Task>();
        for (Integer i = 0; i < 5; i++) {
        	Task testTask = new Task();
        	testTask.CallType = 'Outbound';
        	testTask.Subject ='Call - test call ' + i;
        	testTask.WhatId = testOpp.Id;
        	testTasks.add(testTask); 
        }
        
        insert testTasks;

        // PERFORM TEST
        Test.startTest();
        
        Opportunity qOpp = [SELECT Id, Dial_Counter__c from Opportunity where Id = :testOpp.Id];
        System.debug('@@@ dial count: ' + qOpp.Dial_Counter__c);
        System.assertEquals(qOpp.Dial_Counter__c, 5.0);
        
        Test.stopTest();
    }
    
    static testMethod void incrementLimitTest() {
    	
    	// INIT DATA
    	
        // create account
        Account testAcct = new Account();
        testAcct.Name = 'test acct';
        insert testAcct;
        
        // create opportunity
        Opportunity testOpp = new Opportunity();
        testOpp.AccountId = testAcct.Id;
        testOpp.Name = 'test opp';
        testOpp.StageName = 'New';
        testOpp.CloseDate = Date.today();
        insert testOpp;
        
        // create 5 activities
        List<Task> testTasks = new List<Task>();
        for (Integer i = 0; i < 30; i++) {
        	Task testTask = new Task();
        	testTask.CallType = 'Outbound';
        	testTask.Subject ='Call - test call ' + i;
        	testTask.WhatId = testOpp.Id;
        	testTasks.add(testTask); 
        }
        
        insert testTasks;

        // PERFORM TEST
        Test.startTest();
        
        Opportunity qOpp = [SELECT Id, Dial_Counter__c from Opportunity where Id = :testOpp.Id];
        System.debug('@@@ dial count: ' + qOpp.Dial_Counter__c);
        System.assertEquals(qOpp.Dial_Counter__c, 25.0);
        
        Test.stopTest();
    }
    
    static testMethod void oppClosedTest() {
    	
    	// INIT DATA
    	
        // create account
        Account testAcct = new Account();
        testAcct.Name = 'test acct';
        insert testAcct;
        
        // create opportunity
        Opportunity testOpp = new Opportunity();
        testOpp.AccountId = testAcct.Id;
        testOpp.Name = 'test opp';
        testOpp.StageName = 'Closed Won';
        testOpp.Sub_Stage__c = 'Paid';
        testOpp.CloseDate = Date.today();
        insert testOpp;
        
        // create 5 activities
        List<Task> testTasks = new List<Task>();
        for (Integer i = 0; i < 3; i++) {
        	Task testTask = new Task();
        	testTask.CallType = 'Outbound';
        	testTask.Subject ='Call - test call ' + i;
        	testTask.WhatId = testOpp.Id;
        	testTasks.add(testTask); 
        }
        
        insert testTasks;

        // PERFORM TEST
        Test.startTest();
        
        Opportunity qOpp = [SELECT Id, Dial_Counter__c from Opportunity where Id = :testOpp.Id];
        System.debug('@@@ dial count: ' + qOpp.Dial_Counter__c);
        System.assertEquals(qOpp.Dial_Counter__c, 0.0);
        
        Test.stopTest();
    }
}