@IsTest
public with sharing class DuplicateAddressLocatorTest {
	@IsTest
	static void testDupLocator() {
		Account account1, account2;
		rC_Bios__Account_Address__c addr1, addr2, addr3, addr4;
		List<Account> accounts = new List<Account>();
		List<rC_Bios__Account_Address__c> addrs = new List<rC_Bios__Account_Address__c>();

		account1 = new Account(Name='Account1');
		account2 = new Account(Name='Account2');
		accounts.add(account1);
		accounts.add(account2);
		insert accounts;

		addr1 = new rC_Bios__Account_Address__c(
			rC_Bios__Account__c = account1.Id,
			rC_Bios__Type__c = 'HOME'
		);		
		addr2 = new rC_Bios__Account_Address__c(
			rC_Bios__Account__c = account1.Id,
			rC_Bios__Type__c = 'HOME'
		);		
		addr3 = new rC_Bios__Account_Address__c(
			rC_Bios__Account__c = account2.Id,
			rC_Bios__Type__c = 'HOME'
		);		
		addr4 = new rC_Bios__Account_Address__c(
			rC_Bios__Account__c = account2.Id,
			rC_Bios__Type__c = 'WORK'
		);
		addrs.add(addr1);
		addrs.add(addr2);
		addrs.add(addr3);
		addrs.add(addr4);
		insert addrs;
		
		Test.startTest();
		Database.executeBatch(new DuplicateAddressLocator());
		Test.stopTest();
		
       	List<DuplicateAddress__c> dupList = new List<DuplicateAddress__c>([
       		SELECT Account__c, Address__c FROM DuplicateAddress__c
       	]);
       	
       	System.assertEquals(2, dupList.size());
       	for(DuplicateAddress__c addr : dupList) {
       		System.assertEquals(account1.Id, addr.Account__c);
       	}
	}
}