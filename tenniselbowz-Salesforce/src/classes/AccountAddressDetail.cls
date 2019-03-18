public with sharing class AccountAddressDetail {
	
	public Address__c address{get;set;}
	Address__c originalAaddress;
	public Account_Address__c accountAddress{get;set;}
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
	
	public class AssetAddressWrapper
	{
		public boolean selected{get;set;}
		public Asset assetAddress{get;set;}
		
		public AssetAddressWrapper(boolean sel, Asset aa)
		{
			selected = sel;
			assetAddress = aa;
		}
	}
	
	public list<AssetAddressWrapper> assetAddresses{get;set;}
	
	public AccountAddressDetail(ApexPages.StandardController ctl)
	{
		address = new Address__c();
		originalAaddress = new Address__c();
		accountAddress = new Account_Address__c(Active__c = true);
		returnUrl = ApexPages.currentPage().getParameters().get('retURL');
		//
		//Edit
		//
		if(ctl.getId() !=null)
		{
			addressSelected = false;
			contactAddresses = new list<ContactAddressWrapper>();
			assetAddresses =  new list<AssetAddressWrapper>();
			for(Account_Address__c aa : [Select Id
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
										 from Account_Address__c
										where Id = :ctl.getId()])
			{
				accountAddress = aa;
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
			//Only Contacts that are associated with the Account and Address that’s being edited.
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
											  , LastModifiedBy.Name
											  , LastModifiedDate
										   from Contact_Address__c
										  where Contact__r.AccountId = :accountAddress.Account__c
										    and Address__c = :address.Id])	
		     {
		     	contactAddresses.add(new ContactAddressWrapper(false, ca));
		     }
		     
		     //Asset Addresses
		     //All Assets related to the Address that’s being edited.	
		     for(Asset ca : [Select Id
								  , a.SerialNumber
								  , a.SO_Number__c
								  , a.Product2.ProductCode
								  , a.Product2Id
								  , a.Job_Name__c
								  , Asset_Address__r.Address_Line_1__c 
								  , Asset_Address__r.City__c 
								  , Asset_Address__r.Country__c 
								  , LastModifiedBy.Name
								  , LastModifiedDate
								  , Name
							   from Asset a
							  where Asset_Address__c = :address.Id])	
		     {
		     	assetAddresses.add(new AssetAddressWrapper(false, ca));
		     }		
		}
		else
		{
			//
			//NEW
			//
			addressSelected = false;
			string accountId = ApexPages.currentPage().getParameters().get('CF00NC0000005xBUN_lkid');//use a custom setting - Account Id
			accountAddress = new Account_Address__c(Account__c = accountId, Active__c = true);
			
		}
		
	}
	
	public PageReference selectAddress()
	{
		if(accountAddress.Address__c != null)
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
						    , DCW_ID__c
						    , Warehouse_Id__c
							, IE_ID__c
							, State_Province_ISO_Code__c
							, Country_ISO_Code__c
						    , LastModifiedBy.Name
						    , LastModifiedDate
					    from Address__c
					   where Id = :accountAddress.Address__c];
					   
			addressSelected = true;
			accountAddress.Active__c = true;
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
			
			AddressHelper.saveAccountAddress( contactAddresses
                                     		 , assetAddresses
                                             , originalAaddress
                                             , address
                                             , accountAddress
                                             , addressSelected
                                             );
			String returnUrl = ApexPages.currentPage().getParameters().get('retURL');			
			pg= new PageReference(returnUrl==null ? '/home/home.jsp' : returnUrl);
		}
		catch(Exception e)
		{
			System.Debug('ACCOUNT ADDRESS ERROR::::::::::>'+e);
			ApexPages.addMessages(e);
			Database.rollback(sp);
			pg = null;
		}
		
		return pg;
	}

}