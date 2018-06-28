@isTest
private class ChatterAnswersAuthProviderRegTest {
	static testMethod void validateCreateUpdateUser() {
		User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs ( thisUser ) {
			Auth.UserData userData = new Auth.UserData('testId', 'testFirst', 'testLast',
			'testFirst testLast', 'no-reply@salesforce.com', null, 'testuserlong', 'en_US', 'facebook',
			null, new Map<String, String>{'language' => 'en_US'});
			ChatterAnswersAuthProviderRegistration reg = new ChatterAnswersAuthProviderRegistration();
			Profile[] p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
			User[] adminUser = [SELECT Id, Firstname, Lastname FROM User WHERE IsActive = true and ProfileId =: p[0].Id LIMIT 1];
			reg.setSiteAdminUserId(adminUser[0].Id);
			User newUser = reg.createUser(null, userData);
			System.assert(newUser != null, 'A new user should have been created');
			System.assertEquals(newUser.Firstname, 'testFirst', 'First name should have been same');
			System.assertEquals(newUser.Lastname, 'testLast', 'Last name should have been same');
			System.assertEquals(newUser.Email, 'no-reply@salesforce.com', 'Email should have been same');
			
			Contact c = new Contact();
			c.AccountId = (newUser.Username.split('@'))[0];
			c.LastName = 'contactLast';
			insert(c);
			
			newUser.Alias = 'firstusr';
			newUser.TimeZoneSidKey = 'America/Los_Angeles';
			newUser.LocaleSidKey = 'en_US';
			newUser.EmailEncodingKey = 'UTF-8';
			newUser.LanguageLocaleKey = 'en_US';
			newUser.ContactId = c.Id;
			
			insert(newUser);
			
			
			Auth.UserData updateUserData = new Auth.UserData('testId', 'updatedFirst', 'updatedLast',
			'updatedFirst updatedLast', 'no-reply@new.salesforce.com', null, 'testuserlong', 'en_US', 'facebook',
			null, new Map<String, String>{'language' => 'en_US'});
			reg.updateUser(newUser.Id, null, updateUserData);
			
			User dbUser =  [SELECT Id, Firstname, Lastname, Email FROM User WHERE Id = :newUser.Id];
			System.assertEquals(dbUser.Firstname, 'updatedFirst', 'First name should have been updated');
			System.assertEquals(dbUser.Lastname, 'updatedLast', 'Last name should have been updated');
			System.assertEquals(dbUser.Email, 'no-reply@new.salesforce.com', 'Email should have been updated');
		}
	}
}