@IsTest
public with sharing class EntityPermissionsTest {
    static Id accountHouseholdTypeId;
    static Id contactHouseholdTypeId;

    static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    }
	@IsTest
	public static void testEntityPermissions() {
		Club_Entity__c SFBayChapter = new Club_Entity__c(
			Name='SF Bay Chapter',
			Status__c='Active',
			Type__c='Chapter'
		);
		insert SFBayChapter;
		
		Club_Entity__c SanFranciscoGroup = new Club_Entity__c(
			Name='San Francisco Group',
			Status__c='Active',
			Type__c='Group',
			Parent_Chapter__c = SFBayChapter.Id
		);
		insert SanFranciscoGroup;

		Club_Entity__c VentanaChapter = new Club_Entity__c(
			Name='Ventana Chapter',
			Status__c='Active',
			Type__c='Chapter'
		);
		insert VentanaChapter;
				
		Club_Entity__c SantaCruzGroup = new Club_Entity__c(
			Name='Santa Cruz Group',
			Status__c='Active',
			Type__c='Group',
			Parent_Chapter__c = VentanaChapter.Id
		);
		insert SantaCruzGroup;

		Club_Entity__c PaloAltoGroup = new Club_Entity__c(
			Name='Palo Alto Group',
			Status__c='Active',
			Type__c='Group'
		);
		insert PaloAltoGroup;

		Club_Entity__c AngelesChapter = new Club_Entity__c(
			Name='Angeles Chapter',
			Status__c='Active',
			Type__c='Chapter'
		);
		insert AngelesChapter;
		
		Club_Entity__c SierraClub = new Club_Entity__c(
			Name='Sierra Club',
			Status__c='Active',
			Type__c='Sierra Club',
			EntityId__c = 'CLUB'
		);
		insert SierraClub;

		Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
		);
		insert account1;
		
        Contact contact1 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact1',
            RecordTypeId = contactHouseholdTypeId
        );  
		insert contact1;
		
        Contact contact2 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact2',
            RecordTypeId = contactHouseholdTypeId
        );  
		insert contact2;
		
		List<Leader_Position__c> posList = new List<Leader_Position__c>();

		Leader_Position__c ChairPosition = new Leader_Position__c(
			Name='Chair',
			Code__c='CHR',
			ClubEventPermission_NonOutings__c = 'Administrator',
			ClubEventPermission_Outings__c = 'Administrator'
		);
		posList.add(ChairPosition);

		Leader_Position__c TreasurerPosition = new Leader_Position__c(
			Name='Treasurer',
			Code__c='TRS',
			ClubEventPermission_NonOutings__c = 'Standard',
			ClubEventPermission_Outings__c = 'None'
		);
		posList.add(TreasurerPosition);

		Leader_Position__c OutingLdrPosition = new Leader_Position__c(
			Name='Outing Leader',
			Code__c='OL',
			ClubEventPermission_NonOutings__c = 'None',
			ClubEventPermission_Outings__c = 'Standard'
		);
		posList.add(OutingLdrPosition);

		Leader_Position__c OutingChairPosition = new Leader_Position__c(
			Name='Outing Chair',
			Code__c='OC',
			ClubEventPermission_NonOutings__c = 'None',
			ClubEventPermission_Outings__c = 'Administrator'
		);
		posList.add(OutingChairPosition);

		insert posList;
		
		List<Leadership__c> roleList = new List<Leadership__c>();

		Leadership__c chairRole = new Leadership__c(
			Position_Active__c = true,
			Club_Entity__c = SFBayChapter.Id,
			Contact__c = contact1.Id,
			Leader_Position__c = ChairPosition.Id
		);
		roleList.add(chairRole);
		
		Leadership__c angelesChairRole = new Leadership__c(
			Position_Active__c = true,
			Club_Entity__c = AngelesChapter.Id,
			Contact__c = contact1.Id,
			Leader_Position__c = ChairPosition.Id
		);
		roleList.add(angelesChairRole);
		
		Leadership__c groupOutingLdrRole = new Leadership__c(
			Position_Active__c = true,
			Club_Entity__c = SantaCruzGroup.Id,
			Contact__c = contact1.Id,
			Leader_Position__c = OutingLdrPosition.Id
		);
		roleList.add(groupOutingLdrRole);
		
		Leadership__c treasurerRole = new Leadership__c(
			Position_Active__c = true,
			Club_Entity__c = PaloAltoGroup.Id,
			Contact__c = contact1.Id,
			Leader_Position__c = TreasurerPosition.Id
		);
		roleList.add(treasurerRole);
		
		Leadership__c chapterOutingLdrRole = new Leadership__c(
			Position_Active__c = true,
			Club_Entity__c = SFBayChapter.Id,
			Contact__c = contact1.Id,
			Leader_Position__c = OutingLdrPosition.Id
		);
		roleList.add(chapterOutingLdrRole);
		
		Leadership__c scGroupOutingLdrRole = new Leadership__c(
			Position_Active__c = true,
			Club_Entity__c = SantaCruzGroup.Id,
			Contact__c = contact1.Id,
			Leader_Position__c = OutingChairPosition.Id
		);
		roleList.add(scGroupOutingLdrRole);

		Leadership__c ventanaChapterTreasurerRole = new Leadership__c(
			Position_Active__c = true,
			Club_Entity__c = VentanaChapter.Id,
			Contact__c = contact1.Id,
			Leader_Position__c = TreasurerPosition.Id
		);
		roleList.add(ventanaChapterTreasurerRole);

		insert roleList;
		
		rC_Bios__Preference_Code__c prefcode = new rC_Bios__Preference_Code__c(
			rC_Bios__Code_Value__c = 'SCFDNSTAFF', 
			rC_Bios__Category__c = 'Classification', 
			rC_Bios__Subcategory__c = 'Sierra Club/Foundation Staff'
		);
		insert prefcode;
		
		rC_Bios__Preference__c pref = new rC_Bios__Preference__c(
			rC_Bios__Contact__c = contact1.Id,
			rC_Bios__Code_Value__c = 'SCFDNSTAFF'
		);
		insert pref;

        Test.startTest();
        List<EntityPermissions.EntityPermission> permList1 = EntityPermissions.getPermissions(contact1.Id);
        List<EntityPermissions.EntityPermission> permList2 = EntityPermissions.getPermissions(contact2.Id);
        Test.stopTest();

		System.assertEquals(0, permList2.size());
       	System.assertEquals(7, permList1.size());
        
        for(EntityPermissions.EntityPermission perm : permList1) {
        	System.debug(' ');
        	System.debug('clubEntityId:' + perm.clubEntityId);
        	System.debug('name:' + perm.name);
        	System.debug('ClubEventPermissionNonOutings:' + perm.ClubEventPermissionNonOutings);
        	System.debug('ClubEventPermissionOutings:' + perm.ClubEventPermissionOutings);
        	
        	if(perm.clubEntityId == SFBayChapter.Id) {
        		System.assertEquals('Administrator', perm.ClubEventPermissionNonOutings);
        		System.assertEquals('Administrator', perm.ClubEventPermissionOutings);
        	}
        	else if(perm.clubEntityId == PaloAltoGroup.Id) {
        		System.assertEquals('Standard', perm.ClubEventPermissionNonOutings);
        		System.assertEquals('None', perm.ClubEventPermissionOutings);
        	}
        	else if(perm.clubEntityId == SantaCruzGroup.Id) {
        		System.assertEquals('Standard', perm.ClubEventPermissionNonOutings);
        		System.assertEquals('Administrator', perm.ClubEventPermissionOutings);
        	}
        	else if(perm.clubEntityId == SanFranciscoGroup.Id) {
        		System.assertEquals('Administrator', perm.ClubEventPermissionNonOutings);
        		System.assertEquals('Administrator', perm.ClubEventPermissionOutings);
        	}
        	else if(perm.clubEntityId == SierraClub.Id) {
        		System.assertEquals('Administrator', perm.ClubEventPermissionNonOutings);
        		System.assertEquals('None', perm.ClubEventPermissionOutings);
        	}
        }
	}
}