@isTest
private class AccountIconsExtensionTest {
	private static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	private static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    private static Id offlineActionTypeId = Schema.SObjectType.kweos__EOCS_Data__c.getRecordTypeInfosByName().get('Offline').getRecordTypeId();
    private static Id onlineActionTypeId = Schema.SObjectType.kweos__EOCS_Data__c.getRecordTypeInfosByName().get('Online').getRecordTypeId();

    static testMethod void myUnitTest() {
		Account account1 = 
			new Account(
				Name='Account1',
				RecordTypeId = accountHouseholdTypeId,
				Major_Donor__c = true,
				Planned_Giving_Prospect__c = true
			);
		insert account1;
		List<Contact> contactList = new List<Contact>();
		Contact contact1 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact1',
                Phone = '415-977-5600',
				Mobile_Subscriber__c = true,
				RecordTypeId = contactHouseholdTypeId
			);
		contactList.add(contact1);
		Contact contact2 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact2',
				RecordTypeId = contactHouseholdTypeId
			);
		contactList.add(contact2);
		insert contactList;
		
		Case case1 = new Case(
			AccountId = account1.Id
		);
		insert case1;
		Membership__c mbr1 = new Membership__c(
			Member_Account__c = account1.Id
		);
		insert mbr1;
		Leader_Position__c leaderPosition = new Leader_Position__c(
			Code__c = 'CHR',
			Name = 'Chair'
		);
		insert leaderPosition;
		Club_Entity__c clubEntity = new Club_Entity__c(
			//EntityId__c = '0100',
			Name = 'SF Bay Chapter'
		);
		insert clubEntity;
		Leadership__c ldr1 = new Leadership__c(
			Contact__c = contact1.Id,
			Club_Entity__c = clubEntity.Id,
			Leader_Position__c = leaderPosition.Id,
			Position_Active__c = true
		);
		insert ldr1;
		Reservation__c resv1 = new Reservation__c(
			Contact__c = contact1.Id,
			Reservation_Status__c = 'Signed Up'
		);
		insert resv1;
		
		kweos__EOCS_Data__c onlineAction = new kweos__EOCS_Data__c(
			kwac__Contact__c = contact1.Id,
			RecordTypeId = onlineActionTypeId
		);
		insert onlineAction;
		Test.setCreatedDate(onlineAction.Id, Date.Today().addMonths(-1));
		
		kweos__EOCS_Data__c offlineAction = new kweos__EOCS_Data__c(
			kwac__Contact__c = contact1.Id,
			RecordTypeId = offlineActionTypeId
		);
		insert offlineAction;
		Test.setCreatedDate(offlineAction.Id, Date.Today().addMonths(-10));

		Campaign camp = new Campaign(
			Name = 'Test Campaign',
			Events_Category__c = 'Outing'
		);
		insert camp;
		Event_Registration__c evReg = new Event_Registration__c(
			Contact__c = contact2.Id,
			Status__c = 'Registered',
			Campaign__c = camp.Id
		);
		insert evReg;
		
		Test.startTest();
        ApexPages.StandardController sc = new ApexPages.standardController(account1);
		AccountIconsExtension aie = new AccountIconsExtension(sc);
		Boolean hasCases = aie.getHasCases();
		Boolean hasActiveMembership = aie.getHasActiveMembership();
		Boolean isLeader = aie.getIsLeader();
		Boolean isDonor = aie.getIsDonor();
		Boolean isOutingsParticipant = aie.getIsOutingsParticipant();
		Boolean isDeceased = aie.getIsDeceased();
		Boolean isOnlineActivist = aie.getIsOnlineActivist();
		Boolean isOfflineActivist = aie.getIsOfflineActivist();
		Boolean isMobileSubscriber = aie.getIsMobileSubscriber();
		Boolean isMajorDonor = aie.getIsMajorDonor();
		
		System.assertEquals(true, hasCases);
		System.assertEquals(true, hasActiveMembership);
		System.assertEquals(true, isLeader);
		System.assertEquals(true, isDonor);
		System.assertEquals(true, isOutingsParticipant);
		System.assertEquals(false, isDeceased);
		System.assertEquals(true, isOnlineActivist);
		System.assertEquals(true, isOfflineActivist);
		System.assertEquals(true, isMobileSubscriber);
		System.assertEquals(true, isMajorDonor);

		delete evReg;
		Account changedAccount = new Account(
			Id=account1.Id,
			Planned_Giving_Prospect__c = false,
			Major_Donor__c = false
		);
		update changedAccount;
        sc = new ApexPages.standardController(account1);
		aie = new AccountIconsExtension(sc);
		isOutingsParticipant = aie.getIsOutingsParticipant();
		isDonor = aie.getIsDonor();
		Test.stopTest();

		System.assertEquals(true, isOutingsParticipant);
		System.assertEquals(false, isDonor);
    }
}