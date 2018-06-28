@RestResource(urlMapping='/RetrieveContact/*')
global with sharing class RetrieveContactService {
 
	global class ServiceContact
	{
		public string	FirstName	{get;set;}
		public string	LastName	{get;set;}
		public string	ContactEmailAddress	{get;set;}
		public string	CellPhone	{get;set;}
		public string	WorkPhone	{get;set;}
		public string	RepID	{get;set;}
		public string	ContactId	{get;set;}
		public DateTime	LastModifiedDate	{get;set;}
		public list<ContactAddress> Addresses{get;set;}
		public ServiceAccount Account{get;set;}
	}
	global class ContactAddress
	{
		public boolean PrimaryMailTo{get;set;}
		public boolean MailTo{get;set;}
		public boolean Physical{get;set;}
		public boolean Active{get;set;}
		public string AddressLine1{get;set;}
		public string AddressLine2{get;set;}
		public string AddressLine3{get;set;}
		public string AddressLine4{get;set;}
		public string City{get;set;}
		public string Country{get;set;}  
		public string StateProvince{get;set;}
		public string PostalCode{get;set;}
		public string StateProvinceISO{get;set;}
		public string CountryISO{get;set;}
		//public string IEId{get;set;}
		public DateTime LastModifiedDate{get;set;}
		public string AddressId{get;set;}
	}
	
	global class AccountAddress
	{
		public boolean PrimaryMailTo{get;set;}
		public boolean MailTo{get;set;}
		public boolean Physical{get;set;}
		public boolean BillTo{get;set;}
		public boolean PrimaryBillTo{get;set;}
		public boolean ShipTo{get;set;}
		public boolean PrimaryShipTo{get;set;}
		public boolean Active{get;set;}
		public string AddressLine1{get;set;}
		public string AddressLine2{get;set;}
		public string AddressLine3{get;set;}
		public string AddressLine4{get;set;}
		public string City{get;set;}
		public string Country{get;set;}  
		public string StateProvince{get;set;}
		public string PostalCode{get;set;}
		public string StateProvinceISO{get;set;}
		public string CountryISO{get;set;}
		//public string IEId{get;set;}
		public DateTime LastModifiedDate{get;set;}
		public string AddressId{get;set;}
	}
	
	global class ServiceAccount
	{
		public string Name{get;set;}
		public string PhoneNumber{get;set;}
		public string RepID{get;set;}
		public string AccountId{get;set;}
		public DateTime LastModifiedDate{get;set;}
		public list<AccountAddress> Addresses{get;set;}
	}
	
	
    @HttpGet
    global Static ServiceContact getContact()
    {
    	
    	string ContactEmailAddress = RestContext.request.params.get('ContactEmailAddress'); 
    	string ContactType = RestContext.request.params.get('ContactType'); 
    	string repId = RestContext.request.params.get('RepID'); 
		
        ServiceContact result = new ServiceContact();
        
        Id ContactId = null;
        
        if(ContactType == 'DCW')
        {
        	for(Contact c : [Select Id from Contact 
        	                  where ( (email = :ContactEmailAddress and email != null)
        	                       		or (Rep_ID__c = :repId and Rep_ID__c != null) )
        	                    and AccountId != null
								and DCW_Personnel_Id__c != null order by CreatedDate desc Limit 1])
			{
				ContactId = c.Id;
			}
        }
        else
        {
        	for(Contact c : [Select Id from Contact 
        	                  where ( (email = :ContactEmailAddress and email != null)
        	                       		or (Rep_ID__c = :repId and Rep_ID__c != null) )
        	                    and AccountId != null
        	                 order by CreatedDate desc Limit 1])
			{
				ContactId = c.Id;
			}
        }
        
        for(Contact c : [Select Contact.FirstName
								,Contact.LastName
								,Contact.Email
								,Contact.MobilePhone
								,Contact.Phone
								,Contact.Rep_ID__c
								,Contact.AccountId
								,Contact.Id
								,Contact.LastModifiedDate
								,Contact.MailingCity
								,Contact.MailingCountry
								,Contact.MailingPostalCode
								,Contact.MailingState
								,Contact.MailingStreet
								,(Select Address__r.Country__c
							           , Address__r.Postal_Code__c
							           , Address__r.State_Province__c
								       , Address__r.State_Province_ISO_Code__c
								       , Address__r.Country_ISO_Code__c
							           , Address__r.County__c
							           , Address__r.City__c
							           , Address__r.Address_Line_4__c
							           , Address__r.Address_Line_3__c
							           , Address__r.Address_Line_2__c
							           , Address__r.Address_Line_1__c
							           , Address__r.Name
							           , Address__r.IE_ID__c
							           , Address__c 
							           , Address__r.LastModifiedDate
							           , Primary_Mail_To__c
							           , Mail_To__c
							           , Physical__c
							           , Active__c
							     from Contact_Addresses__r
						        where Active__c = true
						      	  //and Primary_Mail_To__c = true
						      	  ) 
							from Contact 
						   where Id = :ContactId
						   limit 1])
		{
			result.FirstName = c.FirstName;
			result.LastName = c.LastName;
			result.ContactEmailAddress = c.Email;
			result.CellPhone = c.MobilePhone;
			result.WorkPhone = c.Phone;
			result.RepId = c.Rep_ID__c;
			//result.AccountId = c.AccountId;
			result.ContactId = c.Id;
			result.LastModifiedDate = c.LastModifiedDate;
			ServiceAccount sAcct = new ServiceAccount();
			for(Account a : [ Select Account.Name
									,Account.Phone
									,Account.Rep_Office_ID__c
									,Account.Id
									,Account.LastModifiedDate
									,Account.BillingCity
									,Account.BillingCountry
									,Account.BillingPostalCode
									,Account.BillingState
									,Account.BillingStreet
									,(Select Address__r.Country__c
								          , Address__r.Postal_Code__c
								          , Address__r.State_Province__c
								          , Address__r.County__c
								          , Address__r.City__c
								          , Address__r.Address_Line_4__c
								          , Address__r.Address_Line_3__c
								          , Address__r.Address_Line_2__c
								          , Address__r.Address_Line_1__c
								          , Address__r.Name
								          , Address__r.IE_ID__c
								          , Address__r.State_Province_ISO_Code__c
								          , Address__r.Country_ISO_Code__c
								          , Address__c 
								          , Address__r.LastModifiedDate, Mail_To__c
							           	  , Physical__c
							           	  , Bill_To__c
							           	  , Primary_Bill_To__c
							           	  , Primary_Mail_To__c
							           	  , Ship_To__c
							           	  , Primary_Ship_To__c
							           	  , Active__c
								       From Account_Addresses__r
								      where Active__c = true
								      	//and Primary_Mail_To__c = true
								      )
								from Account
							   where Id = :c.AccountId])
			{
				sAcct.Name = a.Name;
				sAcct.PhoneNumber = a.Phone;
				sAcct.RepID = a.Rep_Office_ID__c;
				sAcct.AccountId = a.Id;
				sAcct.LastModifiedDate = a.LastModifiedDate;
				list<AccountAddress> sAddr = new list<AccountAddress>();
				if(a.Account_Addresses__r.size() > 0)
				{
					for(Account_Address__c addr : a.Account_Addresses__r)
					{
						AccountAddress address = new AccountAddress();
						address.AddressLine1 = addr.Address__r.Address_Line_1__c;
						address.AddressLine2 = addr.Address__r.Address_Line_2__c;
						address.AddressLine3 = addr.Address__r.Address_Line_3__c;
						address.AddressLine4 = addr.Address__r.Address_Line_4__c;
						address.City 		 = addr.Address__r.City__c;
						address.Country 	 = addr.Address__r.Country__c;  
						address.StateProvince= addr.Address__r.State_Province__c;
						address.PostalCode 	 = addr.Address__r.Postal_Code__c;
						address.StateProvinceISO = addr.Address__r.State_Province_ISO_Code__c;
						address.CountryISO = addr.Address__r.Country_ISO_Code__c;
						address.AddressId		 = addr.Address__r.Id;
						//address.IEId		 = addr.Address__r.IE_ID__c;
						address.LastModifiedDate = DateTime.newInstance(addr.Address__r.LastModifiedDate.dateGmt()
																	   ,addr.Address__r.LastModifiedDate.timeGmt());
						address.PrimaryMailTo	= addr.Primary_Mail_To__c;
						address.MailTo			= addr.Mail_To__c;
						address.Physical		= addr.Physical__c;
						address.BillTo			= addr.Bill_To__c;
						address.PrimaryBillTo	= addr.Primary_Bill_To__c;
						address.ShipTo			= addr.Ship_To__c;
						address.PrimaryShipTo	= addr.Primary_Ship_To__c;
						//address.OtherAddress	= addr.Other_Address__c;
						address.Active			= addr.Active__c;
						sAddr.add(address);
					}
				}
				/*else
				{
						AccountAddress address = new AccountAddress();
						
						
						address.AddressLine1 = a.BillingStreet;
						address.City 		 = a.BillingCity;
						address.Country 	 = a.BillingCountry;  
						address.StateProvince= a.BillingState;
						address.PostalCode 	 = a.BillingPostalCode;
						address.AddressId	   = null;
						//address.IEId		 = null;
						address.LastModifiedDate = DateTime.newInstance(a.LastModifiedDate.dateGmt()
																   	   ,a.LastModifiedDate.timeGmt());
						address.PrimaryMailTo	= false;
						address.MailTo			= false;
						address.Physical		= false;
						address.BillTo			= true;
						address.PrimaryBillTo	= false;
						address.ShipTo			= false;
						address.PrimaryShipTo	= false;
						address.Active			= true;
						sAddr.add(address);
				}*/
				sAcct.Addresses = sAddr;
			}
			result.Account = sAcct;
			list<ContactAddress> sAddr = new list<ContactAddress>();
			if(c.Contact_Addresses__r.size() > 0)
			{
				for(Contact_Address__c addr : c.Contact_Addresses__r)
				{
					ContactAddress address = new ContactAddress();
					address.AddressLine1 = addr.Address__r.Address_Line_1__c;
					address.AddressLine2 = addr.Address__r.Address_Line_2__c;
					address.AddressLine3 = addr.Address__r.Address_Line_3__c;
					address.AddressLine4 = addr.Address__r.Address_Line_4__c;
					address.City 		 = addr.Address__r.City__c;
					address.Country 	 = addr.Address__r.Country__c;  
					address.StateProvince= addr.Address__r.State_Province__c;
					address.PostalCode 	 = addr.Address__r.Postal_Code__c;
					address.StateProvinceISO = addr.Address__r.State_Province_ISO_Code__c;
					address.CountryISO = addr.Address__r.Country_ISO_Code__c;
					address.AddressId		 = addr.Address__r.Id;
					//address.IEId		 = addr.Address__r.IE_ID__c;
					address.LastModifiedDate = DateTime.newInstance(addr.Address__r.LastModifiedDate.dateGmt()
																   ,addr.Address__r.LastModifiedDate.timeGmt());
					address.PrimaryMailTo	= addr.Primary_Mail_To__c;
					address.MailTo			= addr.Mail_To__c;
					address.Physical		= addr.Physical__c;
					address.Active			= addr.Active__c;
					sAddr.add(address);
				}
			}/*
			else
			{
					ContactAddress address = new ContactAddress();
					address.AddressLine1 = c.MailingStreet;
					address.City 		 = c.MailingCity;
					address.Country 	 = c.MailingCountry;  
					address.StateProvince= c.MailingState;
					address.PostalCode 	 = c.MailingPostalCode;
					address.AddressId	 = null;
					address.LastModifiedDate = DateTime.newInstance(c.LastModifiedDate.dateGmt()
																   ,c.LastModifiedDate.timeGmt());
					address.PrimaryMailTo	= false;
					address.MailTo			= true;
					address.Physical		= false;
					address.Active			= true;
					sAddr.add(address);
			}*/
			result.Addresses = sAddr;
		}
        return result;
    }
}