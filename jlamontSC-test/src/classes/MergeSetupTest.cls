@IsTest
public with sharing class MergeSetupTest {
	@IsTest
	static void testMergeSetup() {
		Account account1, account2, account3, account4, account5, account6, account7, account8, account9;
		Contact contact1, contact2, contact3, contact4, contact5, contact6, contact7;
		List<Account> accounts = new List<Account>();
		List<Contact> contacts = new List<Contact>();
		
		account1 = new Account(Name='Account1');
		account2 = new Account(Name='Account2');
		account3 = new Account(Name='Account3');
		account4 = new Account(Name='Account4');
		account5 = new Account(Name='Account5');
		account6 = new Account(Name='Account6');
		account7 = new Account(Name='Account7');
		account8 = new Account(Name='Account8');
		account9 = new Account(Name='Account9');
		accounts.add(account1);
		accounts.add(account2);
		accounts.add(account3);
		accounts.add(account4);
		accounts.add(account5);
		accounts.add(account6);
		accounts.add(account7);
		accounts.add(account8);
		accounts.add(account9);
		insert accounts;
		
		contact1 = new Contact(AccountId=account1.Id, LastName='Contact1');
		contact2 = new Contact(AccountId=account2.Id, LastName='Contact2');
		contact3 = new Contact(AccountId=account3.Id, LastName='Contact3');
		contact4 = new Contact(AccountId=account3.Id, LastName='Contact4');
		contact5 = new Contact(AccountId=account7.Id, LastName='Contact5');
		contact6 = new Contact(AccountId=account8.Id, LastName='Contact6');
		contact7 = new Contact(AccountId=account9.Id, LastName='Contact7');
		contacts.add(contact1);
		contacts.add(contact2);
		contacts.add(contact3);
		contacts.add(contact4);
		contacts.add(contact5);
		contacts.add(contact6);
		contacts.add(contact7);
		insert contacts;

		List<Merge_Request__c> requestList = new List<Merge_Request__c>();
		
		//Previous Account Missing
		Merge_Request__c request1 = new Merge_Request__c(
			Previous_Account__c = '',
			Retained_Account__c = '',
			Previous_Contact__c = '', 
			Retained_Contact__c = ''
		);
		requestList.add(request1);
		
		//Retained Account Missing
        // ** Nope - Changed to:
        //  Delete Accounts for Merge Requests that do not have a Retained Account
/*
		Merge_Request__c request2 = new Merge_Request__c(
			Previous_Account__c = account1.Id,
			Retained_Account__c = '',
			Previous_Contact__c = '', 
			Retained_Contact__c = ''
		);
		requestList.add(request2);
*/		
		//Good request
		Merge_Request__c request3 = new Merge_Request__c(
			Previous_Account__c = account1.Id,
			Retained_Account__c = account2.Id,
			Previous_Contact__c = contact1.Id, 
			Retained_Contact__c = contact2.Id
		);
		requestList.add(request3);
		
		//Another request found for Previous Contact
		Merge_Request__c request4 = new Merge_Request__c(
			Previous_Account__c = account1.Id,
			Retained_Account__c = account2.Id,
			Previous_Contact__c = contact1.Id, 
			Retained_Contact__c = contact2.Id
		);
		requestList.add(request4);

		//Retained Contact Missing
		Merge_Request__c request5 = new Merge_Request__c(
			Previous_Account__c = account5.Id,
			Retained_Account__c = account5.Id,
			Previous_Contact__c = contact2.Id, 
			Retained_Contact__c = ''
		);
		requestList.add(request5);
		
		//Another request has this Previous Account as Retained
		Merge_Request__c request6 = new Merge_Request__c(
			Previous_Account__c = account2.Id,
			Retained_Account__c = account3.Id
		);
		requestList.add(request6);

		//Request has Retained Contact but no Previous Contact
		Merge_Request__c request7 = new Merge_Request__c(
			Previous_Account__c = account7.Id,
			Retained_Account__c = account7.Id,
			Retained_Contact__c = contact5.Id
		);
		requestList.add(request7);
		
		//Test for Retained Contacts do not match.
		//First insert so trigger will fire		
		Merge_Request__c request8 = new Merge_Request__c(
			Previous_Account__c = account8.Id,
			Retained_Account__c = account8.Id,
			Previous_Contact__c = contact6.Id, 
			Retained_Contact__c = contact7.Id
		);
		requestList.add(request8);
		
		//Test for Retained Accounts do not match.
		//First insert so trigger will fire		
		Merge_Request__c request9 = new Merge_Request__c(
			Previous_Account__c = account8.Id,
			Retained_Account__c = account9.Id
		);
		requestList.add(request9);

		insert requestList;
		
		//Now change Retained Account and Retained Contact so that they don't match
		requestList.clear();
		request8.Retained_Contact__c = Contact1.Id;
		requestList.add(request8);
		request9.Retained_Account__c = Account1.Id;
		requestList.add(request9);
		update requestList;

		List<Merge_Request__c> testRequests = new List<Merge_Request__c> (
			[
				SELECT 
					Id,
					Previous_Account__c,
					Retained_Account__c,
					Previous_Contact__c,
					Retained_Contact__c,
					Last_Step_Completed__c,
					Date_Last_Step_Completed__c, 
					Error_Message__c,
	                Retained_Accounts_Match__c,
	                Retained_Contacts_Match__c
				FROM Merge_Request__c
				WHERE Last_Step_Completed__c < :MergeProcessor.finalStep 
			]
		);
		
		Test.startTest();
		MergeSetup.setUpMerge(testRequests);
		Test.stopTest();
		
		List<Merge_Request__c> requests = new List<Merge_Request__c> (
			[
				SELECT 
					Id,
					Previous_Account__c,
					Retained_Account__c,
					Previous_Contact__c,
					Retained_Contact__c,
					Last_Step_Completed__c,
					Date_Last_Step_Completed__c, 
					Error_Message__c
				FROM Merge_Request__c
			]
		);
		
		for(Merge_Request__c req : requests) {
			if(req.Id == request1.Id) {
				System.debug('request1:' + req.Error_Message__c);
				System.assertEquals('Previous Account Missing', req.Error_Message__c);
			}
			/*
			else if(req.Id == request2.Id) {
				System.debug('request2:' + req.Error_Message__c);
				System.assertEquals('Retained Account Missing', req.Error_Message__c);
			}
			*/
			else if(req.Id == request3.Id) {
				System.debug('request3:' + req.Error_Message__c);
				System.assert(String.isEmpty(req.Error_Message__c));
			}
			else if(req.Id == request4.Id) {
				System.debug('request4:' + req.Error_Message__c);
				System.assertEquals('Another request found for Previous Contact', req.Error_Message__c);
			}
			else if(req.Id == request6.Id) {
				System.debug('request6:' + req.Error_Message__c);
				System.assertEquals('Another request has this Previous Account as Retained', req.Error_Message__c);
			}
			else if(req.Id == request7.Id) {
				System.debug('request7:' + req.Error_Message__c);
				System.assertEquals('Request has Retained Contact but no Previous Contact', req.Error_Message__c);
			}
			else if(req.Id == request8.Id) {
				System.debug('request8:' + req.Error_Message__c);
				System.assertEquals('Retained Contacts do not match', req.Error_Message__c);
			}
			else if(req.Id == request9.Id) {
				System.debug('request9:' + req.Error_Message__c);
				System.assertEquals('Retained Accounts do not match', req.Error_Message__c);
			}
			System.assertEquals(MergeProcessor.setupStep, req.Last_Step_Completed__c);
			System.assert(req.Date_Last_Step_Completed__c != null);
		}
	}
}