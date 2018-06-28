@isTest
private class ContactIconsExtensionTest {
    static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
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
                Mobile_Subscriber__c = true,
                Phone = '415-977-5600',
                RecordTypeId = contactHouseholdTypeId,
                Grasstop__c = true
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
        ApexPages.StandardController sc = new ApexPages.standardController(contact1);
        ContactIconsExtension cie = new ContactIconsExtension(sc);
        Boolean hasCases = cie.getHasCases();
        Boolean hasActiveMembership = cie.getHasActiveMembership();
        Boolean isLeader = cie.getIsLeader();
        Boolean isDonor = cie.getIsDonor();
        Boolean isOutingsParticipant = cie.getIsOutingsParticipant();
        Boolean isDeceased = cie.getIsDeceased();
        Boolean isOnlineActivist = cie.getIsOnlineActivist();
        Boolean isOfflineActivist = cie.getIsOfflineActivist();
        Boolean isMobileSubscriber = cie.getIsMobileSubscriber();
        Boolean isMajorDonor = cie.getIsMajorDonor();
        Boolean isGrasstop = cie.getIsGrasstop();
        
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
        System.assertEquals(true, isGrasstop);

        sc = new ApexPages.standardController(contact2);
        cie = new ContactIconsExtension(sc);
        isOutingsParticipant = cie.getIsOutingsParticipant();
        isGrasstop = cie.getIsGrasstop();
        
        System.assertEquals(true, isOutingsParticipant);
        System.assertEquals(false, isGrasstop);

        Test.stopTest();
    }
}