@IsTest
public with sharing class MergeDeleteTest {
	@IsTest
	static void testMergeDelete() {
		Account account1, account2, account3;
		Contact contact1, contact2;
		List<Account> accounts = new List<Account>();
		List<Contact> contacts = new List<Contact>();
		
		account1 = new Account(Name='Account1');
		account2 = new Account(Name='Account2');
		account3 = new Account(Name='Account3');
		accounts.add(account1);
		accounts.add(account2);
		accounts.add(account3);
		insert accounts;

		rC_Bios__Account_Address__c addr = new rC_Bios__Account_Address__c(	
			rC_Bios__Account__c = account1.Id
		);
		insert addr;
		
		Membership__c mbr = new Membership__c(
			Member_Account__c = account1.Id
		);
		insert mbr;
		
        Leader_Position__c pos = new Leader_Position__c(
            Name = 'Chair',
            Code__c = 'CHR'
        );
        insert pos;
            
		Leadership__c ldr = new Leadership__c(
			Account__c = account1.Id,
            Leader_Position__c = pos.Id
		);
		insert ldr;
		
		Reservation__c resv = new Reservation__c(
			Account__c = account1.Id
		);
		insert resv;
			
		List<Merge_Request__c> requestList = new List<Merge_Request__c>();
		Merge_Request__c request1 = new Merge_Request__c(
			Previous_Account__c = account1.Id,
			Retained_Account__c = account2.Id
		);
		requestList.add(request1);
		Merge_Request__c request2 = new Merge_Request__c(
			Previous_Account__c = account3.Id
		);
		requestList.add(request2);
		insert requestList;

		List<rC_Bios__Account_Address__c> beforeAddrs = new List<rC_Bios__Account_Address__c>([
			SELECT Id, rC_Bios__Account__c FROM rC_Bios__Account_Address__c
		]);
		System.Assert(beforeAddrs.size() == 1);

		List<Membership__c> beforeMbrs = new List<Membership__c>([
			SELECT Id, Member_Account__c FROM Membership__c
		]);
		System.Assert(beforeMbrs.size() == 1);

		List<Leadership__c> beforeLdrs = new List<Leadership__c>([
			SELECT Id, Account__c FROM Leadership__c
		]);
		System.Assert(beforeLdrs.size() == 1);

		List<Reservation__c> beforeRsvs = new List<Reservation__c>([
			SELECT Id, Account__c FROM Reservation__c
		]);
		System.Assert(beforeRsvs.size() == 1);

		List<Account> beforeActs = new List<Account>([
			SELECT Id, Name FROM Account
		]);
		System.Assert(beforeActs.size() == 3);

		Test.startTest();
		MergeDelete.processMerges(requestList);
		Test.stopTest();
		
		List<rC_Bios__Account_Address__c> afterAddrs = new List<rC_Bios__Account_Address__c>([
			SELECT Id, rC_Bios__Account__c FROM rC_Bios__Account_Address__c
		]);
		System.Assert(afterAddrs.size() == 0);

		List<Membership__c> afterMbrs = new List<Membership__c>([
			SELECT Id, Member_Account__c FROM Membership__c
		]);
		System.Assert(afterMbrs.size() == 0);

		List<Leadership__c> afterLdrs = new List<Leadership__c>([
			SELECT Id, Account__c FROM Leadership__c
		]);
		System.Assert(afterLdrs.size() == 0);

		List<Reservation__c> afterRsvs = new List<Reservation__c>([
			SELECT Id, Account__c FROM Reservation__c
		]);
		System.Assert(afterRsvs.size() == 0);

		List<Account> afterActs = new List<Account>([
			SELECT Id, Name FROM Account
		]);
		System.Assert(afterActs.size() == 2);
		
		List<Merge_Request__c> afterMerges = new List<Merge_Request__c>([
			SELECT Last_Step_Completed__c, Date_Last_Step_Completed__c, Error_Message__c FROM Merge_Request__c
		]);
		for(Merge_Request__c request : afterMerges) {
			System.assertEquals(MergeProcessor.deleteObjectsStep, request.Last_Step_Completed__c);
			System.assert(request.Date_Last_Step_Completed__c != null);
			System.assert(String.isEmpty(request.Error_Message__c));
		}
		System.assert(afterMerges.size() == 2);
	}
}