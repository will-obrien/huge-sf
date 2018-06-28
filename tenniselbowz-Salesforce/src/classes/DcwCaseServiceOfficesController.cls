public with sharing class DcwCaseServiceOfficesController {
	
	Case cse;
	public DcwCaseServiceOfficesController(ApexPages.Standardcontroller ctl)
	{
		cse = [select Contact.AccountId
		            , Contact.Account.BillingState
		            , Contact.Account.BillingCity
		            , Contact.Account.BillingCountry
		            , Contact.Account.BillingPostalCode 
		         from Case 
		        where Id = :ctl.getId()];
	}
	
	public Address__c getAddress()
	{
		Address__c addr = new Address__c();
		if(cse.Contact.Account.BillingCountry != null)
		{
			//addr.Country__c = cse.Contact.Account.BillingCountry;
			//addr.State_Province__c = cse.Contact.Account.BillingState;
			addr.Postal_Code__c = cse.Contact.Account.BillingPostalCode;
			addr.City__c = cse.Contact.Account.BillingCity;
		}
		else
		{
			//look up the case account's Location record
			for(Address__c a : [Select City__c, Country__c, State_Province__c, Postal_Code__c 
			                      from Address__c 
			                     where Address__c.Entity_Account__c = :cse.Contact.AccountId 
			                     order by Country__c, State_Province__c desc])
			  return a;
		}
		
		return addr;
	}
	
	static testMethod void runTest()
	{
		Account a = new Account(Name = 'Test');
		a.BillingState = 'California';
		a.BillingPostalCode = '90210';
		a.BillingCountry = 'United States';
		insert a;

		Asset asset = new Asset(Name = 'test',
                           AccountId = a.Id,
                           SerialNumber='123Test'
                           );
   		insert asset;
   		
   		Contact c = TestingUtils.createContacts(1, a.Id, true)[0];
   		
   		Case webCase = new Case();
   		webCase.Subject = 'Test';
   		webCase.SuppliedCompany = 'Test';
   		webCase.SuppliedCompany_PostalCode__c = '11111';
   		webCase.SuppliedEmail = 'test@daikin.com';
   		webCase.SuppliedName = 'Tester';
   		webCase.SuppliedPhone = '3332221111';
   		webCase.Reason = 'Maintenance';
   		webCase.Description = 'Testing';
   		webCase.ContactId = c.Id;
   		insert webCase;
		ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(webCase);
		DcwCaseServiceOfficesController ctl = new DcwCaseServiceOfficesController(sc);
		ctl.getAddress();
	}

}