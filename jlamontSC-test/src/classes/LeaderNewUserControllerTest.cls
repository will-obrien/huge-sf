@IsTest
public without sharing class LeaderNewUserControllerTest {
    static Id accountHouseholdTypeId;
    static Id contactHouseholdTypeId;
    static Id constituentProfileId;
    static Id addUpProfileId;
    static User user1;
	static Club_Entity__c SFBayChapter;
	static Contact contact1, contact2;
	static Leader_Position__c ChairPosition;
	
    static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		//constituentProfileId = [SELECT Id FROM profile WHERE name='Campfire User'].Id;
		addUpProfileId = [SELECT Id FROM profile WHERE name='AddUp User'].Id; 
    }
    @IsTest
	public static void test1() {
		setup();
		LeaderNewUserController controller = new LeaderNewUserController();
		controller.emailAddr = contact1.rC_Bios__Home_Email__c;
		controller.getContactsWithEmail();
		contact2.rC_Bios__Home_Email__c = contact1.rC_Bios__Home_Email__c;
		update contact2;
		Leadership__c ChairRole = new Leadership__c(
			Club_Entity__c = SFBayChapter.id,
 			Leader_Position__c = ChairPosition.Id,
 			Contact__c = contact2.Id,
 			Position_Active__c = true
		);
		insert ChairRole;
		controller.getContactsWithEmail();

		controller.chosenContactId = contact2.Id;
		controller.chooseContact();
		System.assertEquals(contact2.Id, controller.getChosenConstituent().Id);
		
		//Use runAs to avoid mixed dml operation exception
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
			controller.createNewLeaderUser();
        }
		User usr = [select Id, UserType from User where ContactId = :contact2.Id];
		System.assert(usr != null);
		
		controller.getContactsWithEmail();
		
		controller.chosenContactId = null;
		System.assertEquals(null, controller.getChosenConstituent());		
	}

	private static void setup() {
		SFBayChapter = new Club_Entity__c(
			EntityId__c = '0100',
			Name='SF Bay Chapter',
			Status__c='Active',
			Type__c='Chapter',
			Bypass_Validations__c = true
		);
		insert SFBayChapter;

		Account account1 = new Account(
            Name='Account1',
            RecordTypeId = accountHouseholdTypeId
		);
		insert account1;
		
		List<Contact> contactList = new List<Contact>();
        contact1 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact1',
            rC_Bios__Home_Email__c = 'test1.contact1@abc.com',
            rC_Bios__Preferred_Email__c = 'Home',
            RecordTypeId = contactHouseholdTypeId
        );
        contactList.add(contact1);  

        contact2 = new Contact(
            AccountId = account1.Id,
            FirstName = 'Test',
            LastName = 'Contact2',
            rC_Bios__Home_Email__c = 'test2.contact1@abc.com',
            rC_Bios__Preferred_Email__c = 'Home',
            RecordTypeId = contactHouseholdTypeId
        );
        contactList.add(contact2);
          
		insert contactList;

		List<Leader_Position__c> posList = new List<Leader_Position__c>();
		ChairPosition = new Leader_Position__c(
			Name='Chair',
			Code__c='CHR',
			ClubEventPermission_NonOutings__c = 'Administrator',
			ClubEventPermission_Outings__c = 'Administrator'
		);
		posList.add(ChairPosition);
		insert posList;

		//Use runAs to avoid mixed dml operation exception
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
			List<PermissionSet> eventPermSet = new List<PermissionSet>([
				select Id from PermissionSet where Name = 'Events_Community'
			]);
			if(eventPermSet.size() == 0) {
				PermissionSet EventsPermissionSet = new PermissionSet(
					Name = 'Events_Community',
					Label = 'Club Events Community'
				);
				insert EventsPermissionSet;
			}
        }
		
		List<Leadership__c> roleList = new List<Leadership__c>();
		Leadership__c ChairRole = new Leadership__c(
			Club_Entity__c = SFBayChapter.id,
 			Leader_Position__c = ChairPosition.Id,
 			Contact__c = contact1.Id,
 			Position_Active__c = true
		);
		roleList.add(ChairRole);		
		insert roleList;
	}
	
}