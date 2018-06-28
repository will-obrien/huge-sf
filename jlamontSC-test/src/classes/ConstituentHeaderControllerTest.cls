@IsTest
public without sharing class ConstituentHeaderControllerTest {
    static Id accountHouseholdTypeId;
    static Id contactHouseholdTypeId;
    static Id profileId;
    static User user1;
	static Contact contact1, contact2;
	
	static {
        accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
        contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
		profileId = [SELECT Id FROM profile WHERE name='AddUp User'].Id;    
    }
    @IsTest
	public static void testConstituentHeaderController() {
		setup();
        ConstituentHeaderController controller = new ConstituentHeaderController();
		System.runAs(user1) {
	        PageReference pageRef = Page.ConstituentHome;
	        Test.setCurrentPage(pageRef);
			controller.getIsHomePage();
			controller.resetPassword();
			controller.getLogoutLink();
		}
		controller.getLogoutLink();
	}

	private static void setup() {
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
		user1 = createUser(Contact1);
		userList.add(user1);
		insert userList;
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
}