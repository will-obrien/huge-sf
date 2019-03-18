/**
 * 
 */
@isTest
private class TestRetrieveContactService {

    static testMethod void runTest() {
    	
        //create an account for the assets
		Account a = new Account(Name = 'Test'
							   ,Phone = '22222222'
							   ,Rep_Office_ID__c = 'zzzzz'
								,BillingStreet = '111'
								,BillingCity = 'CA');
		insert a;
		
		Contact c = new Contact(FirstName = 'x'
								,LastName = 'y'
								,Email = 'testmatch@matchmedaikin.com'
								,MobilePhone = '3333333333'
								,Phone = '444444444'
								,Rep_ID__c = '55555555'
								,AccountId = a.Id
								,MailingStreet = '111'
								,MailingCity = 'CA'
								,MailingCountryCode='US'
								,MailingStateCode='IL');
		insert c;
		
		Address__c address = new Address__c(//Country__c = 'x'
								           Postal_Code__c = '111111'
								           //, State_Province__c = 'CA'
								           , Country__c = 'United States'
								           , State_Province__c = 'Illinois'
								           , City__c = 'LA'
								           , Address_Line_4__c = '11111'
								           , Address_Line_3__c = '222'
								           , Address_Line_2__c = '333'
								           , Address_Line_1__c = '44'
								           , IE_ID__c = '111');
		insert address;
		
		Contact_Address__c ca = new Contact_Address__c(Primary_Mail_To__c = false
								  				     , Mail_To__c = true
								  				     , Physical__c = false
								                     , Active__c = true 
								                     , Contact__c = c.Id
								                     , Address__c = address.Id);
		insert ca;
		
		Account_Address__c aa = new Account_Address__c(Primary_Mail_To__c = false
													, Mail_To__c = false
													, Physical__c = false
													, Bill_To__c = true
													, Primary_Bill_To__c = false
													, Ship_To__c = false
													, Primary_Ship_To__c = false
													//, Other_Address__c = false
													, Active__c = true 
													, Account__c = a.Id
													, Address__c = address.Id);	
		insert aa;
        
        //call the service
        
        RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();
 
		req.requestURI = 'https://cs8.salesforce.com/services/apexrest/RetrieveContact';  
		req.httpMethod = 'GET';
		RestContext.request = req;
		RestContext.response = res;
		RestContext.request.params.put('ContactEmailAddress','testmatch@matchmedaikin.com');
		
		RetrieveContactService.ServiceContact results = RetrieveContactService.getContact();
		System.debug(':::::results:::::'+results);
		
        //assert the results
        System.assertEquals(c.Id,results.ContactId);
        
        delete ca;
        delete aa;
        
		RestContext.request.params.put('ContactType','DCW');
		c.DCW_Personnel_Id__c = '11111';
		update c;
		
		results = RetrieveContactService.getContact();
		System.debug(':::::results:::::'+results);
		
        //assert the results
        System.assertEquals(c.Id,results.ContactId);
        
        
    }
}