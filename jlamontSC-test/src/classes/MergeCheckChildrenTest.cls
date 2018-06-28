@IsTest
public with sharing class MergeCheckChildrenTest {
	static Id accountHouseholdTypeId;
	static Id accountOrganizationTypeId;
	static Id contactHouseholdTypeId;
	static Id contactOrganizationTypeId;
	static Id opportunityProposalTypeId;
	static Id opportunityDonationTypeId;
	static Id opportunityMembershipTypeId;
	static Id opportunityTransactionTypeId;
	
	static Account account1, account2, account3, account4, account5, account6, account7, account8, account9;
	static Contact contact1, contact2, contact3, contact4, contact5, contact6, contact7, contact8, contact9, contact10, contact11;
	static rC_Giving__GAU__c givingGAU;
	static Campaign promotionCampaign;
	static Opportunity opp1, opp2, opp3, opp4, opp5;
	static rC_Bios__Preference__c preference1;
	static rC_Giving__Planned_Giving__c plannedGiving1;
	static rC_Bios__Relationship__c relationship1, relationship2, relationship3;
	static rC_Bios__Contact_Address__c contactAddr1;
	static rC_Bios__Salutation__c salutation1;
	static Task task1, task2;
	static Event event1;
	static User user1;
	
	static {
		accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		accountOrganizationTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
		contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		contactOrganizationTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Organizational').getRecordTypeId();
		opportunityProposalTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
		opportunityDonationTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
		opportunityMembershipTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();
		opportunityTransactionTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Transaction').getRecordTypeId();
	}
	
	@isTest
	static void testMergeCheckChildren() {
		setupAccounts();
		setupContacts();
		setupOpportunitiesForAccounts();
		setupPreferences();
		setupPlannedGiving();
		setupRelationships();
		setupContactAddresses();
		setupSalutations();
		setupTasks();
		setupEvents();
		setupUser();
		Merge_Request__c request1 = new Merge_Request__c(
			Retained_Contact__c = contact2.Id, 
			Retained_Account__c = account2.Id, 
			Previous_Contact__c = contact1.Id, 
			Previous_Account__c = account1.Id			
		);
		Merge_Request__c request2 = new Merge_Request__c(
			Retained_Contact__c = contact4.Id, 
			Retained_Account__c = account4.Id, 
			Previous_Contact__c = contact5.Id, 
			Previous_Account__c = account5.Id			
		);
		Merge_Request__c request3 = new Merge_Request__c(
			Retained_Contact__c = contact7.Id, 
			Retained_Account__c = account7.Id, 
			Previous_Contact__c = contact6.Id, 
			Previous_Account__c = account6.Id			
		);
		Merge_Request__c request4 = new Merge_Request__c(
			Retained_Contact__c = contact9.Id, 
			Retained_Account__c = account8.Id, 
			Previous_Contact__c = contact8.Id, 
			Previous_Account__c = account8.Id			
		);
		Merge_Request__c request5 = new Merge_Request__c(
			Retained_Contact__c = contact11.Id, 
			Retained_Account__c = account9.Id, 
			Previous_Contact__c = contact10.Id, 
			Previous_Account__c = account9.Id			
		);
		List<Merge_Request__c> mergeRequestList = new List<Merge_Request__c>();
		mergeRequestList.add(request1);
		mergeRequestList.add(request2);
		mergeRequestList.add(request3);
		mergeRequestList.add(request4);
		mergeRequestList.add(request5);
		insert mergeRequestList;
		
		Test.startTest();
		MergeCheckChildren.processMerges(mergeRequestList);
		Test.stopTest();
		
		List<Merge_Request__c> merges = new List<Merge_Request__c>([
			SELECT Id, Last_Step_Completed__c, Date_Last_Step_Completed__c, Error_Message__c FROM Merge_Request__c
		]);
		for(Merge_Request__c req : merges) {
			if(req.Id == request1.Id) {
				System.assertEquals('Opportunity, Planned Giving, Account Relationship, Contact Address, Saluation', req.Error_Message__c);
			}
			else if(req.Id == request2.Id) {
				System.assert(String.isEmpty(req.Error_Message__c));
			}
			else if(req.Id == request3.Id) {
				System.assertEquals('Account Relationship', req.Error_Message__c);
			}
			else if(req.Id == request4.Id) {
				System.assertEquals('Contact Relationship', req.Error_Message__c);
			}
			else if(req.Id == request5.Id) {
				//System.assertEquals('AddUpId, User', req.Error_Message__c);
				System.assertEquals('User', req.Error_Message__c);
			}
			System.assertEquals(MergeProcessor.checkChildrenStep, req.Last_Step_Completed__c);
			System.assert(req.Date_Last_Step_Completed__c != null);
		}
	}
	static void setupAccounts() {
		account1 = 
			new Account(
				Name='Account1',
				RecordTypeId = accountHouseholdTypeId
			);
		account2 = 
			new Account(
				Name='Account2',
				RecordTypeId = accountHouseholdTypeId
			);
		account3 = 
			new Account(
				Name='Account3',
				RecordTypeId = accountHouseholdTypeId
			);
		account4 = 
			new Account(
				Name='Account4',
				RecordTypeId = accountHouseholdTypeId
			);
		account5 = 
			new Account(
				Name='Account5',
				RecordTypeId = accountHouseholdTypeId
			);
		account6 = 
			new Account(
				Name='Account6',
				RecordTypeId = accountHouseholdTypeId
			);
		account7 = 
			new Account(
				Name='Account7',
				RecordTypeId = accountHouseholdTypeId
			);
		account8 = 
			new Account(
				Name='Account8',
				RecordTypeId = accountHouseholdTypeId
			);
		account9 = 
			new Account(
				Name='Account9',
				RecordTypeId = accountHouseholdTypeId
			);
		List<Account> accountList = new List<Account>();
		accountList.add(account1);
		accountList.add(account2);
		accountList.add(account3);
		accountList.add(account4);
		accountList.add(account5);
		accountList.add(account6);
		accountList.add(account7);
		accountList.add(account8);
		accountList.add(account9);
		insert accountList;
	}
	static void setupContacts() {
		contact1 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact1',
				RecordTypeId = contactHouseholdTypeId
			);	
		contact2 =
			new Contact(
				AccountId = account2.Id,
				FirstName = 'Test',
				LastName = 'Contact2',
				RecordTypeId = contactHouseholdTypeId
			);
		contact3 =
			new Contact(
				AccountId = account2.Id,
				FirstName = 'Test',
				LastName = 'Contact3',
				RecordTypeId = contactHouseholdTypeId
			);
		contact4 =
			new Contact(
				AccountId = account4.Id,
				FirstName = 'Test',
				LastName = 'Contact4',
				RecordTypeId = contactHouseholdTypeId
			);
		contact5 =
			new Contact(
				AccountId = account5.Id,
				FirstName = 'Test',
				LastName = 'Contact5',
				RecordTypeId = contactHouseholdTypeId
			);
		contact6 =
			new Contact(
				AccountId = account6.Id,
				FirstName = 'Test',
				LastName = 'Contact6',
				RecordTypeId = contactHouseholdTypeId
			);
		contact7 =
			new Contact(
				AccountId = account7.Id,
				FirstName = 'Test',
				LastName = 'Contact7',
				RecordTypeId = contactHouseholdTypeId
			);
		contact8 =
			new Contact(
				AccountId = account8.Id,
				FirstName = 'Test',
				LastName = 'Contact8',
				RecordTypeId = contactHouseholdTypeId
			);
		contact9 =
			new Contact(
				AccountId = account8.Id,
				FirstName = 'Test',
				LastName = 'Contact9',
				RecordTypeId = contactHouseholdTypeId
			);
		contact10 =
			new Contact(
				AccountId = account9.Id,
				FirstName = 'Test',
				LastName = 'Contact10',
				RecordTypeId = contactHouseholdTypeId,
				Website_System_Id__c = 'TestAddupId'
			);
		contact11 =
			new Contact(
				AccountId = account9.Id,
				FirstName = 'Test',
				LastName = 'Contact11',
				RecordTypeId = contactHouseholdTypeId
			);
		List<Contact> contactList = new List<Contact>();
		contactList.add(contact1);
		contactList.add(contact2);
		contactList.add(contact3);
		contactList.add(contact4);
		contactList.add(contact5);
		contactList.add(contact6);
		contactList.add(contact7);
		contactList.add(contact8);
		contactList.add(contact9);
		contactList.add(contact10);
		contactList.add(contact11);
		insert contactList;
	}
	static void setupOpportunitiesForAccounts() {
		givingGAU = new rC_Giving__GAU__c();
		givingGAU.Name = 'Test Data GAU';
		givingGAU.GivingType__c = 'Donations';
		givingGAU.Recipient__c = 'Club';
		givingGAU.FundType__c = 'Chapter Funds';
		insert givingGAU;
		
		promotionCampaign = new Campaign();
		promotionCampaign.Name = 'test opp camp';
        promotionCampaign.External_ID__c = promotionCampaign.Name;
		promotionCampaign.Type = 'Promotion';
		promotionCampaign.Status = 'Planned';
		insert promotionCampaign;
		
		List<Opportunity> oppsToInsert = new List<Opportunity>();

		opp1 = new Opportunity();
		opp1.name = 'Test Giving';
		opp1.rC_Giving__GAU__c = givingGAU.Id;
		opp1.AccountId = account1.Id;
		opp1.CloseDate = system.today().addDays(3);
		opp1.StageName = 'Completed';
		opp1.rC_Giving__Projected_Amount__c = 1000;
		opp1.Campaign = promotionCampaign;
		opp1.rC_Giving__Giving_Amount__c = 1110;
		opp1.rC_Giving__Closed_Amount__c = 1110;
		opp1.RecordTypeId = opportunityTransactionTypeId;
		opp1.rC_Giving__Giving_Years__c = 2;
		opp1.rC_Giving__Giving_Frequency__c = 'Quarterly';
		oppsToInsert.add(opp1);

		opp2 = new Opportunity();
		opp2.name = 'Test Giving2';
		opp2.rC_Giving__GAU__c = givingGAU.Id;
		opp2.AccountId = account1.Id;
		opp2.CloseDate = system.today().addDays(3);
		opp2.StageName = 'Completed';
		opp2.rC_Giving__Projected_Amount__c = 1000;
		opp2.Campaign = promotionCampaign;
		opp2.rC_Giving__Giving_Amount__c = 1110;
		opp2.rC_Giving__Closed_Amount__c = 1110;
		opp2.RecordTypeId = opportunityProposalTypeId;
		opp2.rC_Giving__Giving_Years__c = 2;
		opp2.rC_Giving__Giving_Frequency__c = 'Quarterly';
		oppsToInsert.add(opp2);

		insert oppsToInsert;
	}
	static void setupPreferences() {
		preference1 = new rC_Bios__Preference__c(
			rC_Bios__Account__c = account1.Id
		);
		insert preference1;
	}
	static void setupPlannedGiving() {
		plannedGiving1 = new rC_Giving__Planned_Giving__c(
			rC_Giving__Account__c = account1.Id
		);
		insert plannedGiving1;
	}
	static void setupRelationships() {
		List<rC_Bios__Relationship__c> relationshipList = new List<rC_Bios__Relationship__c>();
		relationship1 = new rC_Bios__Relationship__c(
			rC_Bios__Account_1__c = account1.Id,
			rC_Bios__Account_2__c = account3.Id
		);
		relationshipList.add(relationship1);

		relationship2 = new rC_Bios__Relationship__c(
			rC_Bios__Account_1__c = account1.Id,
			rC_Bios__Account_2__c = account6.Id,
			rC_Bios__Contact_1__c = contact1.Id,
			rC_Bios__Contact_2__c = contact6.Id
		);
		relationshipList.add(relationship2);		

		relationship3 = new rC_Bios__Relationship__c(
			rC_Bios__Contact_1__c = contact8.Id,
			rC_Bios__Contact_2__c = contact9.Id
		);
		relationshipList.add(relationship3);
				
		insert relationshipList;
	}
	static void setupContactAddresses() {
		contactAddr1 = new rC_Bios__Contact_Address__c(
			rC_Bios__Contact__c = contact1.Id
		);
		insert contactAddr1;
	}
	static void setupSalutations() {
		salutation1 = new rC_Bios__Salutation__c(
			rC_Bios__Account__c =  account1.Id,
			rC_Bios__Contact__c = contact1.Id 
		);
		insert salutation1;
	}
	static void setupTasks() {
		task1 = new Task(
			WhatId = account1.Id
		);
		insert task1;
	}
	static void setupEvents() {
		event1 = new Event(
			WhatId = account1.Id,
			DurationInMinutes = 10,
			ActivityDateTime = Datetime.valueOf('2014-10-08 01:02:03')
		);
		insert event1;
	}
	static void setupUser() {
		Profile addUpProfile = [SELECT Id FROM profile WHERE name='Addup User'];
		User usr = new User(
			firstName = 'Test',
            lastName = 'Contact10',
            Email = 'test@abc.com',
            Phone = '415-977-5687',
            CommunityNickname = 'Test',
            languagelocalekey = 'en_US',
            localesidkey = UserInfo.getLocale(),
            emailEncodingKey = 'UTF-8',
            timeZoneSidKey = 'America/Los_Angeles', 
            profileId = addUpProfile.Id,
            userName = 'test@abc.com',
            Initial_Password__c = 'test',
            ContactId = contact10.Id,
            alias = 'tcnt10' 
    	 );	
	     insert usr;
     }
}