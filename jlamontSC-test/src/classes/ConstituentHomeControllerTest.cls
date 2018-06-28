@IsTest
public without sharing class ConstituentHomeControllerTest {
    static Id accountHouseholdTypeId;
    static Id contactHouseholdTypeId;
    static Id constituentProfileId;
    static User user1;
	static Club_Entity__c SFBayChapter;
	static Contact contact1;

    static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		constituentProfileId = [SELECT Id FROM profile WHERE name='AddUp User'].Id;    
    }
    @IsTest
	public static void testConstituentHomeController() {
		setup();
		System.runAs(user1) {
	        ConstituentHomeController controller = new ConstituentHomeController();
	        System.assertEquals(true, controller.getIsLeader());
	        System.assertEquals(false, controller.getIsBod());
	        System.assertEquals(false, controller.getIsStaff());
	        controller.checkUser();
		}		
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
            Email = 'test1.contact1@abc.com',
            RecordTypeId = contactHouseholdTypeId
        );
        contactList.add(contact1);  

		insert contactList;
		
		List<User> userList = new List<User>();
		user1 = createUser(Contact1, constituentProfileId);
		userList.add(user1);
		
		insert userList;

		List<Leader_Position__c> posList = new List<Leader_Position__c>();
		Leader_Position__c ChairPosition = new Leader_Position__c(
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
	private static User createUser(Contact ctct, Id userProfileId) {
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
                                    profileId = userProfileId,
                                    userName = Email,
                                    //Initial_Password__c = newPassword,
                                    ContactId = ctct.Id,
                                    alias = aliasText );
        return usr;
	}

}