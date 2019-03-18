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
@isTest(SeeAllData=true)
private class Test_CyclicalNumberManager {
	
    static testMethod void accountTest() {
        Account testAcct = new Account();
        testAcct.Name = 'test account';
        insert testAcct;
        
        Test.startTest();
        CyclicalNumberManager.generateValue(testAcct, 5);
        System.assert(testAcct.Random_1_100__c != null);
        Test.stopTest();
    }
    
    static testMethod void accountListTest() {
    	List<Account> acctList = new List<Account>();
    	Account testAcct;
    	for (Integer i = 0; i < 200; i++) {
        	testAcct = new Account();
        	testAcct.Name = 'test account';
        	acctList.add(testAcct);
    	}
        insert acctList;
        
        Test.startTest();
        CyclicalNumberManager.generateValue(acctList, 100);
        for (Account a : acctList) {
        	System.assert(a.Random_1_100__c != null);
        }
        Test.stopTest();
    }
    
    static testMethod void leadTest() {
        Lead testLead = new Lead();
        testLead.FirstName = 'test';
        testLead.LastName = 'lead';
        insert testLead;
        
        Test.startTest();
        CyclicalNumberManager.generateValue(testLead, 5);
        System.assert(testLead.Random_1_100__c != null);
        Test.stopTest();
    }
    
    static testMethod void leadListTest() {
        List<Lead> leadList = new List<Lead>();
    	Lead testLead;
    	for (Integer i = 0; i < 200; i++) {
        	testLead = new Lead();
        	testLead.FirstName = 'test' + String.valueOf(i+1);
        	testLead.LastName = 'lead';
        	leadList.add(testLead);
    	}
        insert leadList;
        
        Test.startTest();
        CyclicalNumberManager.generateValue(leadList, 100);
        for (Lead l : leadList) {
        	System.assert(l.Random_1_100__c != null);
        }
        Test.stopTest();
    }
}