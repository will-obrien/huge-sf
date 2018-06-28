@isTest
private class MembershipSummaryFixTest {

    static testMethod void myUnitTest() {
		Account account1, account2, account3;
		List<Account> accounts = new List<Account>();
		
		account1 = new Account(Name='Account1');
		account2 = new Account(Name='Account2');
		account3 = new Account(Name='Account3');
		accounts.add(account1);
		accounts.add(account2);
		accounts.add(account3);
		insert accounts;
		
		List<Membership__c> membershipList = new List<Membership__c>();

    	Membership__c membership1 = new Membership__c(
    		Member_Account__c = account1.Id
    	);
    	membershipList.add(membership1);
    	
    	Membership__c membership2 = new Membership__c(
    		Member_Account__c = account1.Id
    	);
    	membershipList.add(membership2);
    	
    	insert membershipList;
    	
    	accounts = new List<Account>();
    	accounts.add(new Account(Id = account1.Id, Membership__c = membership1.Id));
    	accounts.add(new Account(Id = account2.Id, Membership__c = membership2.id));
    	accounts.add(new Account(Id = account3.Id));
    	update accounts;

    	Map<Id, Account> accountMap = new Map<Id, Account> (
    		[
    			SELECT Id, Membership__c FROM Account WHERE Id IN :accounts
    		]
    	);
    	
    	System.assertEquals(membership1.Id, accountMap.get(account1.Id).Membership__c);
    	System.assertEquals(membership2.Id, accountMap.get(account2.Id).Membership__c);
				
		Test.startTest();
		Database.executeBatch(new MembershipSummaryFix());
		Test.stopTest();
		
    	accountMap = new Map<Id, Account> (
    		[
    			SELECT Id, Membership__c FROM Account WHERE Id IN :accounts
    		]
    	);
    	
    	System.assertEquals(membership1.Id, accountMap.get(account1.Id).Membership__c);
    	System.assertEquals(null, accountMap.get(account2.Id).Membership__c);
    	System.assertEquals(null, accountMap.get(account3.Id).Membership__c);

    }
}