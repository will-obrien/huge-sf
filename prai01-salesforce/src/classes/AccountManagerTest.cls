@IsTest
private class AccountManagerTest {

    @isTest static void getAccountTest() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://na1.salesforce.com/services/apexrest/Accounts/'
            + recordId
            + '/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account thisAccount = AccountManager.getAccount();
        // Verify results
        System.assert(thisAccount != null);
        System.assertEquals('Test Account Name', thisAccount.Name);
        //System.assertEquals('Prakash', thisAccount.Contacts.FirstName);

    }

  // Helper method
    static Id createTestRecord() {
        // Create test record
        Account testAcc = new Account(
            Name='Test Account Name');

        insert testAcc;

        Contact testCont = new Contact(
            LastName='Rai',
            AccountId = testAcc.Id);
        insert testCont;

        return testAcc.Id;
    }          
    
}