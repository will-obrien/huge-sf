@IsTest
public with sharing class AssignLeaderPermissionsTest {
    static Id accountHouseholdTypeId;
    static Id contactHouseholdTypeId;
    static Id profileId;
    static User user1, user2, user3;
    static Account account1;
    static Contact contact1, contact2, contact3, contact4;

    static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		profileId = [SELECT Id FROM profile WHERE name='AddUp User'].Id;    
    }
	@IsTest
	public static void testAssignLeaderPermissions() {
		List<PermissionSet> eventPermSet = new List<PermissionSet>([
			select Id from PermissionSet where Name = 'Club_Leader'
		]);
		if(eventPermSet.size() == 0) {
			PermissionSet EventsPermissionSet = new PermissionSet(
				Name = 'Club_Leader',
				Label = 'Club Leader'
			);
			insert EventsPermissionSet;
		}
		
		Club_Entity__c SFBayChapter = new Club_Entity__c(
			Name='SF Bay Chapter',
			Status__c='Active',
			Type__c='Chapter'
		);
		insert SFBayChapter;

		setup();
		
		//Insert preference prior to creating user
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		Test.startTest();
        System.runAs ( thisUser ) {
			rC_Bios__Preference_Code__c prefcode = new rC_Bios__Preference_Code__c(
				rC_Bios__Code_Value__c = 'SCFDNSTAFF', 
				rC_Bios__Category__c = 'Classification', 
				rC_Bios__Subcategory__c = 'Sierra Club/Foundation Staff'
			);
			insert prefcode;
			rC_Bios__Preference__c pref1 = new rC_Bios__Preference__c(
				rC_Bios__Contact__c = contact3.Id,
				rC_Bios__Code_Value__c = 'SCFDNSTAFF',
				rC_Bios__Active__c = true
			);
			insert pref1;

			List<User> userList = new List<User>();
			user1 = createUser(contact1);
			user2 = createUser(contact2);
			user3 = createUser(contact3);
			
			userList.add(user1);
			userList.add(user2);
			userList.add(user3);
			insert userList;

			//Insert preference after creating user
			rC_Bios__Preference__c pref2 = new rC_Bios__Preference__c(
				rC_Bios__Contact__c = contact2.Id,
				rC_Bios__Code_Value__c = 'SCFDNSTAFF',
				rC_Bios__Active__c = true
			);
			insert pref2;
        }
		
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
		
		Leader_Position__c SecretaryPosition = new Leader_Position__c(
			Name='Secretary',
			Code__c='SEC',
			ClubEventPermission_NonOutings__c = 'Standard',
			ClubEventPermission_Outings__c = 'None'
		);
		posList.add(SecretaryPosition);
		
		insert posList;
		
		List<Leadership__c> roleList = new List<Leadership__c>();
		
		Leadership__c ChairRole = new Leadership__c(
			Club_Entity__c = SFBayChapter.id,
 			Leader_Position__c = ChairPosition.Id,
 			Contact__c = contact1.Id,
 			Position_Active__c = true
		);
		roleList.add(ChairRole);		

		Leadership__c SecretaryRole = new Leadership__c(
			Club_Entity__c = SFBayChapter.id,
 			Leader_Position__c = SecretaryPosition.Id,
 			Contact__c = contact1.Id,
 			Position_Active__c = true
		);
		roleList.add(SecretaryRole);		

		Leadership__c TreasurerRole = new Leadership__c(
			Club_Entity__c = SFBayChapter.id,
 			Leader_Position__c = TreasurerPosition.Id,
 			Contact__c = contact2.Id,
 			Position_Active__c = true
		);
		roleList.add(TreasurerRole);		
		
		//Trigger will fire to assign permissions
		insert roleList;

		Test.stopTest();
		
		//Check that permissions were created
		Set<String> leaderPermissionNames = new Set<String>{'Club_Leader'};

		List<PermissionSet> permList = new List<PermissionSet>([
			select Id, Name from PermissionSet
			where Name in :leaderPermissionNames
		]); 
		Map<String, Id>allLeaderPermissions = new Map<String, Id>();
		for(PermissionSet perms : permList) {
			allLeaderPermissions.put(perms.Name, perms.Id);
		}
		
		List<Id> userIdList = new List<Id>();
		userIdList.add(user1.Id);
		userIdList.add(user2.Id);
		List<PermissionSetAssignment> permSetList1 = new List<PermissionSetAssignment>([
			select PermissionSetId, AssigneeId from PermissionSetAssignment
			where AssigneeId in :userIdList and PermissionSetId in :allLeaderPermissions.values()
		]);
		
		for(PermissionSetAssignment psa : permSetList1) {
			System.debug('PermissionSetId:' + psa.PermissionSetId + '   -   ' + 'AssigneeId:' + psa.AssigneeId);
		}
		System.assertEquals(2, permSetList1.size());
		
		//Deactivate some roles and check that permissions were properly adjusted
		TreasurerRole.Position_Active__c = false;
		SecretaryRole.Position_Active__c = false;
		roleList.clear();
		roleList.add(TreasurerRole);
		roleList.add(SecretaryRole);
		update roleList;

		List<PermissionSetAssignment> permSetList2 = new List<PermissionSetAssignment>([
			select PermissionSetId, AssigneeId from PermissionSetAssignment
			where AssigneeId in :userIdList and PermissionSetId in :allLeaderPermissions.values()
		]);
		
		System.assertEquals(1, permSetList2.size());
		
		//Check that routine works properly for Contact that has user attached, but no leadership roles
		List<Id> contactIdList = new List<Id>();
		contactIdList.add(Contact3.Id);
		new AssignLeaderPermissions().assignPermissions(contactIdList);

		List<PermissionSetAssignment> permSetList3 = new List<PermissionSetAssignment>([
			select PermissionSetId, AssigneeId from PermissionSetAssignment
			where AssigneeId in :userIdList and PermissionSetId in :allLeaderPermissions.values()
		]);
		
		System.assertEquals(1, permSetList3.size());

		//Check that routine works properly for Contact that has no user attached
		contactIdList.clear();
		contactIdList.add(Contact4.Id);
		new AssignLeaderPermissions().assignPermissions(contactIdList);
		
		List<PermissionSetAssignment> permSetList4 = new List<PermissionSetAssignment>([
			select PermissionSetId, AssigneeId from PermissionSetAssignment
			where AssigneeId in :userIdList and PermissionSetId in :allLeaderPermissions.values()
		]);
		
		for(PermissionSetAssignment psa : permSetList4) {
			System.debug('PermissionSetId:' + psa.PermissionSetId + '   -   ' + 'AssigneeId:' + psa.AssigneeId);
		}
		System.assertEquals(1, permSetList4.size());
	}
   	static testMethod void test2() {
   		PermissionSet eventsPermissionSet;
		List<PermissionSet> eventPermSetList = new List<PermissionSet>([
			select Id from PermissionSet where Name = 'Club_Leader'
		]);
		if(eventPermSetList.size() > 0) {
			eventsPermissionSet = eventPermSetList.get(0);
		}
		else {
			eventsPermissionSet = new PermissionSet(
				Name = 'Club_Leader',
				Label = 'Club Leader'
			);
			insert eventsPermissionSet;
		}
		
		setup();
		//Use runAs to avoid mixed dml operation exception
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
			List<User> userList = new List<User>();
			user1 = createUser(contact1);
			user2 = createUser(contact2);
			
			userList.add(user1);
			userList.add(user2);
			insert userList;

			Test.startTest();

			PermissionSetAssignment delPsa = new PermissionSetAssignment(
				AssigneeId = user1.Id,
				PermissionSetId = eventsPermissionSet.Id
			);
			insert delPsa;
			PermissionSetAssignment addPsa = new PermissionSetAssignment(
				AssigneeId = user2.Id,
				PermissionSetId = eventsPermissionSet.Id
			);
			
			List<String> permissionsToAdd = new List<String>();
			List<String> permissionsToDelete = new List<String>();
			permissionsToAdd.add(JSON.Serialize(addPsa));
			permissionsToDelete.add(JSON.Serialize(delPsa));

			AssignLeaderPermissions.adjustPermissions(permissionsToAdd, permissionsToDelete);
			
			Test.stopTest();
        }
		
		List<PermissionSetAssignment> permList1 = [
			select Id from PermissionSetAssignment
			where AssigneeId = :user1.Id and PermissionSetId = :eventsPermissionSet.Id 
		];
		System.assertEquals(0, permList1.size());
   	}
	private static User createUser(Contact ctct) {
		String FirstName = ctct.FirstName;
		String LastName = ctct.LastName;
		String Email = ctct.Email;
		
		string aliasText = '';
            if(FirstName != null && FirstName != '' && Lastname.length()>1){
                    aliasText = FirstName.substring(0,1);
            }
            if(Lastname != null && Lastname != '' && Lastname.length()>2){
                aliasText += Lastname.substring(0,3);
            }
            else{
                aliasText +=Lastname;
            }
        String myNickName = '';
        If (Email.length() > 40) {
          myNickName = Email.substring(0, 40);
        } else {
          myNickName = Email;
        }
        User usr = new User(firstName = FirstName,
                                    lastName = LastName,
                                    Email = Email,
                                    CommunityNickname = myNickName,
                                    languagelocalekey = 'en_US',
                                    localesidkey = UserInfo.getLocale(),
                                    emailEncodingKey = 'UTF-8',
                                    timeZoneSidKey = 'America/Los_Angeles', 
                                    profileId = profileId,
                                    userName = Email,
                                    //Initial_Password__c = newPassword,
                                    ContactId = ctct.Id,
                                    alias = aliasText );
        return usr;
	}
	private static void setup() {
		account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
		);
		insert account1;
		
		List<Contact> contactList = new List<Contact>();
        contact1 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact1',
            Email = 'test1.contact1@abc.com',
            RecordTypeId = contactHouseholdTypeId
        );
        contactList.add(contact1);  
		
        contact2 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact2',
            Email = 'test2.contact2@abc.com',
            RecordTypeId = contactHouseholdTypeId
        );  
		contactList.add(contact2);
		
        contact3 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact3',
            Email = 'test3.contact3@abc.com',
            RecordTypeId = contactHouseholdTypeId
        );  
		contactList.add(contact3);
		
        contact4 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact4',
            Email = 'test4.contact4@abc.com',
            RecordTypeId = contactHouseholdTypeId
        );  
		contactList.add(contact4);
		
		insert contactList;
	}
}