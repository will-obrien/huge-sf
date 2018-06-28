public with sharing class ContactAddressDetail {
	
	public Address__c address{get;set;}
	Address__c originalAaddress;
	public Contact_Address__c contactAddress{get;set;}
	public string returnUrl{get;set;}
	public boolean addressSelected{get;set;}
	public class ContactAddressWrapper
	{
		public boolean selected{get;set;}
		public Contact_Address__c contactAddress{get;set;}
		
		public ContactAddressWrapper(boolean sel, Contact_Address__c ca)
		{
			selected = sel;
			contactAddress = ca;
		}
	}
	
	public list<ContactAddressWrapper> contactAddresses{get;set;}
	
	public class AccountAddressWrapper
	{
		public boolean selected{get;set;}
		public Account_Address__c AccountAddress{get;set;}
		
		public AccountAddressWrapper(boolean sel, Account_Address__c aa)
		{
			selected = sel;
			AccountAddress = aa;
		}
	}
	
	public list<AccountAddressWrapper> AccountAddresses{get;set;}
	
	public ContactAddressDetail(ApexPages.StandardController ctl)
	{
		address = new Address__c();
		originalAaddress = new Address__c();
		contactAddress = new Contact_Address__c(Active__c = true);
		returnUrl = ApexPages.currentPage().getParameters().get('retURL');
		//
		//Edit
		//
		if(ctl.getId() !=null)
		{
			addressSelected = false;
			contactAddresses = new list<ContactAddressWrapper>();
			AccountAddresses =  new list<AccountAddressWrapper>();
			for(Contact_Address__c aa : [Select Id
											  , Name
											  , Contact__c
											  , Address__c
											  , Active__c
											  , Mail_To__c
											  , Physical__c
											  , Contact__r.AccountId
											  , Primary_Mail_To__c
											  , Address__r.Address_Line_1__c
											  , Address__r.Address_Line_2__c
											  , Address__r.Address_Line_3__c
											  , Address__r.Address_Line_4__c
											  , Address__r.City__c
											  , Address__r.Country__c
											  , Address__r.State_Province__c
											  , Address__r.Postal_Code__c
											  , Address__r.Name
											  , Address__r.OwnerId
											  , Address__r.Address_Name__c
											  , Address__r.Id
											  , Address__r.DCW_ID__c
											  , Address__r.Warehouse_Id__c
											  , Address__r.IE_ID__c
											  , Address__r.State_Province_ISO_Code__c
											  , Address__r.Country_ISO_Code__c
											  , Address__r.LastModifiedBy.Name
											  , Address__r.LastModifiedDate
											  , LastModifiedBy.Name
											  , LastModifiedDate
										 from Contact_Address__c
										where Id = :ctl.getId()])
			{
				contactAddress = aa;
				address = aa.Address__r;
				originalAaddress = new Address__c(  Address_Line_1__c = aa.Address__r.Address_Line_1__c
												  , Address_Line_2__c = aa.Address__r.Address_Line_2__c
												  , Address_Line_3__c = aa.Address__r.Address_Line_3__c
												  , Address_Line_4__c = aa.Address__r.Address_Line_4__c
												  , City__c = aa.Address__r.City__c
												  , Country__c =  aa.Address__r.Country__c
												  , State_Province__c = aa.Address__r.State_Province__c
												  , Postal_Code__c = aa.Address__r.Postal_Code__c
												  , Address_Name__c = aa.Address__r.Address_Name__c
											  	  , IE_ID__c = aa.Address__r.IE_ID__c
											  	  , DCW_ID__c = aa.Address__r.DCW_ID__c
											  	  , Warehouse_Id__c = aa.Address__r.Warehouse_Id__c
												  , State_Province_ISO_Code__c = aa.Address__r.State_Province_ISO_Code__c
												  , Country_ISO_Code__c = aa.Address__r.Country_ISO_Code__c
												  , Id = aa.Address__r.Id);
			}
			
			//Contact Addresses	
			//Only Contacts that are associated with the Contact and Address that’s being edited.
			for(Contact_Address__c ca : [Select Id
											  , Contact__r.Name
											  , Contact__r.Account.Name
											  , Contact__r.Title
											  , Contact__r.Email
											  , Active__c
											  , Physical__c
											  , Mail_To__c
											  , Primary_Mail_To__c
											  , Contact__r.OwnerId
											  , Address__r.Address_Name__c
						    				  , Address__r.LastModifiedBy.Name
						    				  , Address__r.LastModifiedDate
											  , LastModifiedBy.Name
											  , LastModifiedDate
										   from Contact_Address__c
										  where Contact__r.AccountId = :contactAddress.Contact__r.AccountId
										    and Address__c = :address.Id
										    and Id != :contactAddress.Id])	
		     {
		     	contactAddresses.add(new ContactAddressWrapper(false, ca));
		     }
		     
		     //Account Addresses
		     //All Accounts related to the Address that’s being edited.	
		     for(Account_Address__c ca : [Select Id
											  , Account__r.Name
											  , Address__r.Address_Name__c
						    				  , Address__r.LastModifiedBy.Name
						    				  , Address__r.LastModifiedDate
											  , Name
											  , Account__c
											  , Address__c
											  , Active__c
											  , Bill_To__c
											  , Mail_To__c
											  , Physical__c
											  , Ship_To__c
											  , Primary_Bill_To__c
											  , Primary_Mail_To__c
											  , Primary_Ship_To__c
											  , LastModifiedBy.Name
											  , LastModifiedDate
										   from Account_Address__c
										  where Address__c = :address.Id
										   and Account__c = :contactAddress.Contact__r.AccountId])	
		     {
		     	AccountAddresses.add(new AccountAddressWrapper(false, ca));
		     }	
		     
		}
		else
		{
			//
			//NEW
			//
			addressSelected = false;
			string contactId = ApexPages.currentPage().getParameters().get('CF00NC0000005xBUP_lkid');//use a custom setting - Contact Id
			contactAddress = new Contact_Address__c(Contact__c = contactId, Active__c = true);
			
		}
		
	}
	
	public PageReference selectAddress()
	{
		if(contactAddress.Address__c != null)
		{
			address = [select Address_Line_1__c
						    , Address_Line_2__c
						    , Address_Line_3__c
						    , Address_Line_4__c
						    , City__c
						    , Country__c
						    , State_Province__c
						    , Postal_Code__c
						    , Name
						    , OwnerId 
						    , Address_Name__c
						    , DCW_Id__c
						    , Warehouse_Id__c
							, IE_ID__c
							, State_Province_ISO_Code__c
							, Country_ISO_Code__c
						    , LastModifiedBy.Name
						    , LastModifiedDate
					    from Address__c
					   where Id = :contactAddress.Address__c];
					   
			addressSelected = true;
			contactAddress.Active__c = true;
		}
		else
		{
			addressSelected = false;
			address = new Address__c();
		}
		
		return null;
	}
	
	public PageReference save()
	{
		PageReference pg;
		Savepoint sp = Database.setSavepoint();
		try{ 
			AddressHelper.saveContactAddress(  contactAddresses
	                                           , AccountAddresses
	                                           , originalAaddress
	                                           , address
	                                           , contactAddress
	                                          , addressSelected);
			
			String returnUrl = ApexPages.currentPage().getParameters().get('retURL');			
			pg= new PageReference(returnUrl==null ? '/home/home.jsp' : returnUrl);
		}
		catch(Exception e)
		{
			System.Debug('CONTACT ADDRESS ERROR::::::::::>'+e);
			ApexPages.addMessages(e);
			Database.rollback(sp);
			pg = null;
		}
		
		return pg;
	}

}