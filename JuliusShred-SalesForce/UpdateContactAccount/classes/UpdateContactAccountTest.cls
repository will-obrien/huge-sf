@isTest
public class UpdateContactAccountTest 
{
	private static testMethod void setData()
	{
		Account testAccount = new Account();
		testAccount.Name = 'testAccount';
		insert testAccount;

		Contact testContact = new Contact();
		testContact.AccountId = testAccount.Id;
		testContact.FirstName = 'Rick';
		testContact.LastName = 'James';
		testContact.Phone = '555';
		insert testContact;
	}

	static testMethod void openPageWithNoId()
	{
		UpdateContactAccountTest.setData();
		PageReference pageRef = Page.UpdateContactAccount;
		Test.setCurrentPage(pageRef);

		Test.startTest();
			UpdateContactAccount controller = new UpdateContactAccount();
		Test.stopTest();

		System.assertEquals(TRUE, ApexPages.getMessages().get(0).getDetail().contains('Account Id was not given.'), 'Apex Message was not added.');
		System.assertEquals(NULL, controller.updateContactAccount, 'Account Record should be NULL');
	}

	static testMethod void openPageWithWrongId()
	{
		UpdateContactAccountTest.setData();
		String wrongId = '0015800000C9X50';
		PageReference pageRef = Page.UpdateContactAccount;
		pageRef.getParameters().put('Id', wrongId);
		Test.setCurrentPage(pageRef);

		Test.startTest();
			UpdateContactAccount controller = new UpdateContactAccount();
		Test.stopTest();

		System.assertEquals(TRUE, ApexPages.getMessages().get(0).getDetail().contains('There is no Account with Id: ' + wrongId), 'Apex Message was not added.');
		System.assertEquals(NULL, controller.updateContactAccount, 'Account Record should be NULL');
	}

	static testMethod void openPageWithInvalidId()
	{
		UpdateContactAccountTest.setData();
		PageReference pageRef = Page.UpdateContactAccount;
		pageRef.getParameters().put('Id', '00000');
		Test.setCurrentPage(pageRef);

		Test.startTest();
			UpdateContactAccount controller = new UpdateContactAccount();
		Test.stopTest();

		System.assertEquals(TRUE, ApexPages.getMessages().get(0).getDetail().contains('Invalid Id.'), 'Apex Message was not added.');
		System.assertEquals(NULL, controller.updateContactAccount, 'Account Record should be NULL');
	}

	static testMethod void openPageWithEmptyId()
	{
        UpdateContactAccountTest.setData();

		Test.startTest();
			UpdateContactAccount controller = new UpdateContactAccount();
		Test.stopTest();

		System.assertEquals(TRUE, ApexPages.getMessages().get(0).getDetail().contains('Account Id was not given.'), 'Apex Message was not added.');
		System.assertEquals(NULL, controller.updateContactAccount, 'Account Record should be NULL');
	}

	static testMethod void openPageWithNullId()
	{
		UpdateContactAccountTest.setData();
		PageReference pageRef = Page.UpdateContactAccount;
		pageRef.getParameters().put('Id', NULL);
		Test.setCurrentPage(pageRef);

		Test.startTest();
			UpdateContactAccount controller = new UpdateContactAccount();
		Test.stopTest();

		System.assertEquals(TRUE, ApexPages.getMessages().get(0).getDetail().contains('Account Id was not given.'), 'Apex Message was not added.');
		System.assertEquals(NULL, controller.updateContactAccount, 'Account Record should be NULL');
	}

	static testMethod void openPageWithId()
	{
		UpdateContactAccountTest.setData();
		Account testAccount = [SELECT Id, Name, (SELECT FirstName, LastName, Phone FROM Contacts) 
					FROM Account][0];

		PageReference pageRef = Page.UpdateContactAccount;								
		pageRef.getParameters().put('Id',testAccount.Id);
		Test.setCurrentPage(pageRef);

		Test.startTest();
			UpdateContactAccount controller = new UpdateContactAccount();
		Test.stopTest();

		System.assertEquals(testAccount.Id, controller.updateContactAccount.Id, 'Account Id does not match.');
		System.assertEquals(testAccount.Name, controller.updateContactAccount.Name, 'Account Name does not match.');
		System.assertEquals(testAccount.Contacts[0].FirstName, controller.updateContactAccount.Contacts[0].FirstName, 'Contact FirstName does not match.');
		System.assertEquals(testAccount.Contacts[0].LastName, controller.updateContactAccount.Contacts[0].LastName, 'Contact LastName does not match.');
		System.assertEquals(testAccount.Contacts[0].Phone, controller.updateContactAccount.Contacts[0].Phone, 'Contact Phone does not match.');
		System.assertEquals(ApexPages.getMessages().size(), 0, 'Apex Message should not be added.');
	}
    
	static testMethod void saveRecordTest()
	{
		UpdateContactAccountTest.setData();
		Account testAccount = [SELECT Id, Name, (SELECT FirstName, LastName, Phone FROM Contacts) 
					FROM Account][0];
								
		PageReference pageRef = Page.UpdateContactAccount;								
		pageRef.getParameters().put('Id',testAccount.Id);
		Test.setCurrentPage(pageRef);

		Test.startTest();
			UpdateContactAccount upCnt = new UpdateContactAccount();
			upCnt.updateContactAccount.Name = 'Prison';
			upCnt.updateContactAccount.Contacts[0].FirstName = 'Dick';
			upCnt.updateContactAccount.Contacts[0].LastName = 'Johnson';
			upCnt.updateContactAccount.Contacts[0].Phone = '000';
			upCnt.saveRecord();
		Test.stopTest();

		System.assertEquals('Prison', upCnt.updateContactAccount.Name, 'Account Name does not match.');
		System.assertEquals('Dick', upCnt.updateContactAccount.Contacts[0].FirstName, 'Contact FirstName does not match.');
		System.assertEquals('Johnson', upCnt.updateContactAccount.Contacts[0].LastName, 'Contact LastName does not match.');
		System.assertEquals('000', upCnt.updateContactAccount.Contacts[0].Phone, 'Contact Phone does not match.');
	}
	//having troubles testing that
	static testMethod void revertChangesTest()
	{
		UpdateContactAccountTest.setData();
		Account testAccount = [SELECT Id, Name, (SELECT FirstName, LastName, Phone FROM Contacts) 
					FROM Account][0];
								
		PageReference pageRef = Page.UpdateContactAccount;								
		pageRef.getParameters().put('Id',testAccount.Id);
		Test.setCurrentPage(pageRef);

		Test.startTest();
			UpdateContactAccount upCnt = new UpdateContactAccount();
			upCnt.revertChanges();
		Test.stopTest();
	}
}