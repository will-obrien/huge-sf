@isTest
public with sharing class MembershipSummaryCreatorTest {
	@IsTest
    static void testMembershipSummary() {
		List<Id> accountList = new List<Id>();
		List<Membership__c> membershipList = new List<Membership__c>();
		
    	TestDataUtility testData = new TestDataUtility();

    	Account account1 = testData.createNewAccount(true, 'Account1', 'Household');
    	Account account2 = testData.createNewAccount(true, 'Account2', 'Household');
    	Account account3 = testData.createNewAccount(true, 'Account3', 'Household');
    	Account account4 = testData.createNewAccount(true, 'Account4', 'Household');
    	
    	accountList.add(account1.Id);
    	accountList.add(account2.Id);
    	accountList.add(account3.Id);
    	accountList.add(account4.Id);
  	
    	Membership__c membership1 = new Membership__c();
    	membership1.Member_Account__c = account1.Id;
    	membershipList.add(membership1);
    	
    	Membership__c membership2 = new Membership__c();
    	membership2.Member_Account__c = account2.Id;
    	membershipList.add(membership2);
    	
    	Membership__c membership3 = new Membership__c();
    	membership3.Member_Account__c = account3.Id;
    	membershipList.add(membership3);
    	
    	insert membershipList;

    	Map<Id, Account> accountMap = new Map<Id, Account> (
    		[
    			SELECT Id, Membership__c FROM Account WHERE Id IN :accountList
    		]
    	);
    	
    	System.assertEquals(membership1.Id, accountMap.get(account1.Id).Membership__c);
    	System.assertEquals(membership2.Id, accountMap.get(account2.Id).Membership__c);
    	System.assertEquals(membership3.Id, accountMap.get(account3.Id).Membership__c);
    	
    	new MembershipSummaryCreator().summarizeMemberships(accountList);
    	
    	accountMap = new Map<Id, Account> (
    		[
    			SELECT Id, Membership__c FROM Account WHERE Id IN :accountList
    		]
    	);
    	
    	System.assertEquals(membership1.Id, accountMap.get(account1.Id).Membership__c);
    	System.assertEquals(membership2.Id, accountMap.get(account2.Id).Membership__c);
    	System.assertEquals(membership3.Id, accountMap.get(account3.Id).Membership__c);
    	
    	membership3.Member_Account__c = account4.Id;
    	update membership3;
    	
    	accountMap = new Map<Id, Account> (
    		[
    			SELECT Id, Membership__c FROM Account WHERE Id IN :accountList
    		]
    	);

    	System.assertEquals(membership3.Id, accountMap.get(account4.Id).Membership__c);
    	System.assertEquals(null, accountMap.get(account3.Id).Membership__c);    	
    }
}