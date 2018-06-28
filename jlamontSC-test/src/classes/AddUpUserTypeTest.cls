@isTest
private class AddUpUserTypeTest {
	static Id accountHouseholdTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();

    static testMethod void myUnitTest() {
		Account account1 = 
			new Account(
				Name='Account1',
				RecordTypeId = accountHouseholdTypeId
			);
		insert account1;
		
		Contact contact1 =
			new Contact(
				AccountId = account1.Id,
				FirstName = 'Test',
				LastName = 'Contact1',
				RecordTypeId = contactHouseholdTypeId,
				AddUP_User_Type__c = '1 - System Administrator'
			);
		insert contact1;
		
		RestResponse res = new RestResponse();
		RestRequest req = new RestRequest();
		
		req.requestURI = '/services/apexrest/AddUpUserType/' + contact1.Id;
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		
		AddUpUserType.AddUpUserTypeReturn results = AddUpUserType.getUserType();
		
		System.assertEquals(contact1.Id, results.contactId);
		System.assertEquals('1', results.userType);
    }
}