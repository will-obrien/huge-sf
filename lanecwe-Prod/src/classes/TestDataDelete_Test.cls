@isTest
private class TestDataDelete_Test {
	
	@isTest 
	static void testDeleteRequest() {
		// set up the request object

		Account a = new Account();
		a.Name = 'PGi Test Automation';
		insert a;

		Contact c = PGITestUtilities.getContactDetails(a.id);
		insert c;

		CONMAN_Contract__c con = new CONMAN_Contract__c();
		con.Account_Name__c = a.id;
		insert con;
		
		Attachment att = new Attachment();
		att.ParentId = a.id;
		att.Name = 'Test';
		Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        att.body = bodyBlob;
        insert att;

		Opportunity o = PGITestUtilities.getOpportunityDetails();
		o.AccountId = a.id;
		insert o;

		Lead lead = new Lead();
		lead.Company = 'PGi Test Automation';	
		lead.firstName = 'Matt';
		lead.lastName = 'Santy';
		lead.leadSource = 'eCommerce';
		lead.CreatedDate = Date.today();
		insert lead;

		System.debug('Lead: ' + Lead);

		LicenseSet__c l = new LicenseSet__c();
		l.Name = '123 Product';
		l.Opportunity__c = o.id;
		insert l;

		List<sObject> sObjectList = new List<sObject>();

		sObjectList.add(lead);
		sObjectList.add(a);
		sObjectList.add(con);
		sObjectList.add(c);
		sObjectList.add(att);
		sObjectList.add(o);
		sObjectList.add(l);

        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/TestDataDelete/';
        RestContext.request.httpMethod = 'DELETE';
        // Invoke the method directly
        System.debug('TestDataDelete.deleteTestData(): ' + TestDataDelete.deleteTestData());
        try {
        	TestDataDelete.deleteTestData();
        } catch (DmlException d) {
        	System.debug('sObjectList DmlException: ' + d.getMessage());
        }

        List<Account> deletedAccountList = [SELECT Id FROM Account WHERE Name = 'PGi Test Automation'];
        List<Opportunity> deletedOpportunityList = [SELECT Id FROM Opportunity WHERE Opportunity.Account.Name = 'PGi Test Automation'];
        System.debug('deletedAccountList: ' + deletedAccountList);

        System.assert(deletedAccountList.size() == 0);
        System.assert(deletedOpportunityList.size() == 0);
	}
}