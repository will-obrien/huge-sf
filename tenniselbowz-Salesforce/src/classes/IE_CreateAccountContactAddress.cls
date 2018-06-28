@RestResource(urlMapping='/CreateAccountContactAddress/*')
global class IE_CreateAccountContactAddress {
	
	global class IE_Error
	{
		webservice string ErrorCode{get;set;}
		webservice string ErrorMessage{get;set;}
		
		global IE_Error(String errCode, String errMsg)
		{
			ErrorCode = errCode;
			ErrorMessage = errMsg;
		}
	}
	
	global class SfdcContact
	{
		webservice string	FirstName	{get;set;}
		webservice string	LastName	{get;set;}
		webservice string	MiddleName	{get;set;}
		webservice string	ContactEmailAddress{get;set;}
		webservice string	CellPhone	{get;set;}
		webservice string	WorkPhone	{get;set;}
		webservice string	ContactId	{get;set;}
		webservice string   AccountId	{get;set;}
		webservice string   DTJobGUID   {get;set;}
		webservice list<IE_Error> errors{get;set;}
	}
	
	global class AccountAddress
	{
		webservice string 	AddressLine1{get;set;}
		webservice string 	AddressLine2{get;set;}
		webservice string 	AddressLine3{get;set;}
		webservice string 	AddressLine4{get;set;}
		webservice string 	City{get;set;}
		webservice string 	StateProvinceISO{get;set;}
		webservice string 	PostalCode{get;set;}
		webservice string 	CountryISO{get;set;}
		webservice string 	AddressId{get;set;}
		webservice string   AccountId{get;set;}
		webservice list<IE_Error> errors{get;set;}
	}
	
	global class SfdcAccount
	{
		webservice string 	Name{get;set;}
		//webservice string 	PhoneNumber{get;set;}
		webservice string   AccountId{get;set;}
		webservice list<IE_Error> errors{get;set;}
	}
	
	global class AccountContactAddress
	{
		webservice SfdcAccount account{get;set;}
		webservice AccountAddress accountAddress{get;set;}
		webservice SfdcContact contact{get;set;}
	}
	
	global class CreateAccountContactAddress
	{
		webservice list<AccountContactAddress> records{get;set;}
	}
	
	@HttpPost
 	global static CreateAccountContactAddress doPost(list<AccountContactAddress> records)
    {
    	TriggerUtility.limitIeServiceIntegration = true;
    	CreateAccountContactAddress response = new CreateAccountContactAddress();
    	response.records = records;
    	
    	Integer accountIndex = 0;
    	Integer addressIndex = 0;
    	Integer contactIndex = 0;
    	map<Integer, Account> accountmap = new map<Integer,Account>();
    	map<Integer, Address__c> addressMap = new map<Integer, Address__c>();// map the addresses back to the accounts
    	map<Integer, Contact> contactMap = new map<Integer, Contact>();// map the contacts back to the accounts
    	
    	map<Integer, AccountAddress> ieAddressMap = new map<Integer, AccountAddress>();// map the addresses back to the accounts
    	map<Integer, SfdcContact> ieContactMap = new map<Integer, SfdcContact>();// map the contacts back to the accounts

    	IE_Service_Configuration__c serviceConfig = IE_Service_Configuration__c.getInstance();
    	
    	//
    	// collect the values from the request ad translate them into salesforce objects
    	//
    	for(AccountContactAddress rec : records)
    	{
    		//create accounts to add to the list
    		accountMap.put(accountIndex, new Account(Name 				= rec.account.Name
											    	//,Phone 				= rec.account.PhoneNumber
												    ,RecordTypeId  		= serviceConfig.Account_RecordType__c
													,Record_Usage__c = 'IE'));
    		
    		if(rec.accountAddress != null)
    		{
    			addressMap.put(addressIndex, new Address__c(  Address_Line_1__c		= rec.accountAddress.AddressLine1
															, Address_Line_2__c		= rec.accountAddress.AddressLine2
															, Address_Line_3__c		= rec.accountAddress.AddressLine3
															, Address_Line_4__c		= rec.accountAddress.AddressLine4
															, City__c				= rec.accountAddress.City
															, Country_ISO_Code__c	= rec.accountAddress.CountryISO
															, State_Province_ISO_Code__c 	= rec.accountAddress.StateProvinceISO
                                                            , Country__c = TriggerUtility.getCountryFromIsoCode(rec.accountAddress.CountryISO)
                                                            , State_Province__c = TriggerUtility.getStateFromCountryStateIsoCode(rec.accountAddress.CountryISO, rec.accountAddress.StateProvinceISO)
															, Postal_Code__c		= rec.accountAddress.PostalCode
															, RecordTypeId 			= serviceConfig.Address_RecordType__c
															, Record_Usage__c 		= 'IE'
															));
				//add the IE Address to a map in order to alter populate the SFDC ID using the index
				ieAddressMap.put(addressIndex, rec.accountAddress);
				addressIndex++;
    		}
    		if(rec.contact != null)
    		{
	    		contactMap.put(contactIndex,  new Contact ( FirstName			=	rec.contact.FirstName
															, LastName			=	rec.contact.LastName
															, Middle_Name__c 	= 	rec.contact.MiddleName
															, Email				=	rec.contact.ContactEmailAddress
															, MobilePhone		=	rec.contact.CellPhone
															, Phone				=	rec.contact.WorkPhone
															, RecordTypeId 		= 	serviceConfig.Contact_RecordType__c
															, Record_Usage__c 	= 	'IE'
															, DTJobGUID__c 		= rec.contact.DTJobGUID
															));
				ieContactMap.put(contactIndex, rec.contact);
				contactIndex++;
    		}
    		
    		accountIndex++;
    	}
    	
    	//
    	// insert the Account Records
    	//
    	if(accountMap.size() > 0)
    	{
    		list<Database.SaveResult> results = database.insert(accountMap.values(), false);
    		accountIndex = 0;
    		for(Database.SaveResult r : results)
    		{
    			response.records[accountIndex].account.AccountId = r.getId();
    			if(!r.isSuccess())
    			{
    				//r.getErrors()[0].getTypeName();
    				response.records[accountIndex].account.errors = new list<IE_Error>(); 
    				for(Database.Error err : r.getErrors())
    				{
    					response.records[accountIndex].account.errors.add(new IE_Error('SALESFORCE_DML_ERROR', err.message));
    				}
    			}
    			accountIndex++;
    		}
    	}
    	
    	//
    	// iterate through the request objects to align the accountId with the children
    	//
    	accountIndex = 0;
    	for(AccountContactAddress rec: records)
    	{
    		if(rec.contact != null)
    		{
    			if(accountMap.get(accountIndex).Id == null)
    			{
    				rec.contact.errors = new list<IE_Error>{new IE_Error('ERROR', 'NO ORGANIZATION PAREWNT')};
    			}
    			else
    			{
    				rec.contact.AccountId = accountMap.get(accountIndex).Id;
    			}
    			
    		}
    		
    			
    		if(rec.accountAddress != null)
    		{
    			
    			if(accountMap.get(accountIndex).Id == null)
    			{
    				rec.accountAddress.errors = new list<IE_Error>{new IE_Error('ERROR', 'NO ORGANIZATION PAREWNT')};
    			}
    			else
    			{
    				rec.accountAddress.AccountId = accountMap.get(accountIndex).Id;
    			}
    			
    		}
    			
    		accountIndex++;
    	}
    	
    	for(Integer x : ieContactMap.keySet())
    	{
    		if(contactMap.containsKey(x))
    		{
    			contactMap.get(x).AccountId = ieContactMap.get(x).AccountId;
    		}
    	}
    	
    	
    	//
    	// insert the new addresses 
    	//
    	
    	//set errors on te address records that do not have parents
    	for(Integer i : ieAddressMap.keySet())
    	{
    		if(ieAddressMap.containsKey(i) && addressMap.containsKey(i) && ieAddressMap.get(i).errors != null && ieAddressMap.get(i).errors.size() >0) 
    			addressMap.get(i).addError( ieAddressMap.get(i).errors[0].ErrorMessage );   
    		
    		
    	}
    	addressIndex = 0;
    	if(addressMap.size() > 0)
    	{
    		list<Database.SaveResult> results = database.insert(addressMap.values(), false);
    		for(Database.SaveResult r : results)
    		{
    			ieAddressMap.get(addressIndex).addressId = r.getId();
    			if(!r.isSuccess())
    			{
    				ieAddressMap.get(addressIndex).errors = new list<IE_Error>();
    				for(Database.Error err : r.getErrors())
    				{
    					ieAddressMap.get(addressIndex).errors.add(new IE_Error('SALESFORCE_DML_ERROR', err.message)); 
    					//response.errors.add(new IE_IntegrationObjects.IE_Error('SALESFORCE_DML_ERROR', err.message)); 
    					
    				}
    			}
    			addressIndex++;
    		}
    	}
    	
    	//
    	// add the junction between account and address
    	//
    	map<Integer, Account_Address__c> accountAddressMap = new map<Integer, Account_Address__c>();
    	if(addressMap.size() > 0)
    	{
    		for(Integer i : ieAddressMap.keySet())
    		{
    			AccountAddress a = ieAddressMap.get(i);
    			accountAddressMap.put(i, new Account_Address__c(Account__c = a.AccountId
		    												   ,Address__c = a.AddressId
												               ,Mail_To__c = true
												               ,Primary_Mail_To__c = true));
    		}
    	}
    	
    	//
    	// Insert the Account Address Records
    	//
    	addressIndex = 0;
    	if(accountAddressMap.size() > 0)
    	{
    		list<Database.SaveResult> results = database.insert(accountAddressMap.values(), false);
    		for(Database.SaveResult r : results)
    		{
    			if(!r.isSuccess())
    			{
    				ieAddressMap.get(addressIndex).errors = new list<IE_Error>();
    				for(Database.Error err : r.getErrors())
    				{
    					ieAddressMap.get(addressIndex).errors.add(new IE_Error('SALESFORCE_DML_ERROR', err.message)); 
    					//response.errors.add(new IE_IntegrationObjects.IE_Error('SALESFORCE_DML_ERROR', err.message)); 
    					
    				}
    			}
    		}
    		addressIndex++;
    	}
    	
    	//
    	//insert the new contacts 
    	//
    	contactIndex = 0;
    	if(contactMap.size() > 0)
    	{
    		list<Database.SaveResult> results = database.insert(contactMap.values(), false);
    		for(Database.SaveResult r : results)
    		{
    			ieContactMap.get(contactIndex).contactId = r.getId();
    			if(!r.isSuccess())
    			{
    				ieContactMap.get(contactIndex).errors = new list<IE_Error>();
    				for(Database.Error err : r.getErrors())
    				{
    					ieContactMap.get(contactIndex).errors.add(new IE_Error('SALESFORCE_DML_ERROR', err.message)); 
    					//response.errors.add(new IE_IntegrationObjects.IE_Error('SALESFORCE_DML_ERROR', err.message)); 
    					
    				}
    			}
    		}
    		contactIndex++;
    	}
    	
    	//response.records.serviceAccountanizations = ierecords.serviceAccounts;
    	System.debug('::::RESPONSE:::::'+ response);
    	return response;
    	
    }
    
    public static CreateAccountContactAddress getTestRequest()
    {
    	SfdcContact c = new SfdcContact();
		c.FirstName	 = 'test first';
		c.LastName	 = 'test Last';
		c.ContactEmailAddress = 'testFirst.testLast@daikinapplied.com';
		c.CellPhone	 = '3334445566';
		c.WorkPhone	 = '8887776655';
		c.DTJobGUID  = 'ABC123';
	
	
		AccountAddress ad = new AccountAddress();
		ad.AddressLine1 = 'AddressLine1';
		ad.AddressLine2 = 'AddressLine2';
		ad.AddressLine3 = 'AddressLine3';
		ad.AddressLine4 = 'AddressLine4';
		ad.City = 'Cityville';
		ad.StateProvinceISO = 'CA';
		ad.PostalCode = '90210';
		ad.CountryISO = 'USA';
		
		SfdcAccount a = new SfdcAccount();
		
		a.Name = 'test Account';
		//a.PhoneNumber = '3334445566';
		
		AccountContactAddress aca = new AccountContactAddress();
		aca.account = a; 
		aca.AccountAddress = ad;
		aca.contact = c;
		
		CreateAccountContactAddress caca = new CreateAccountContactAddress();
		caca.records = new list<AccountContactAddress>{aca}; 
		
		System.debug(JSON.serialize(caca));
		
		return caca;
    }
}