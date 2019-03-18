public without sharing class AccountTriggerHandler {
	
	public static void onBeforeDelete(map<Id, Account> oldMap)
	{
		for(Account a : oldMap.values())
		{
			if(a.Record_Usage__c != null )
				a.addError('This record cannot be deleted because it is integrated with other systems or tied to other critical information within Salesforce.');
		}
	} 
	
	public static void onBeforeUpdate(map<Id, Account> newMap, map<Id, Account> oldMap)
	{
		allOrNoneAccountAddresses(newMap.values());
		setIeValues(newMap.values(), oldMap);
		updateAccountAddress(newMap, oldMap);
	}
	
	public static void onBeforeInsert(list<Account> newList)
	{
		allOrNoneAccountAddresses(newList);
		setIeValues(newList, null);
	}
	
	public static void onAfterInsert(map<Id, Account> newMap)
	{
		createAccountAddress(newMap);
	}
	
	public static void setIeValues(list<Account> newList, map<Id, Account> oldMap)
	{
		
		if(TriggerUtility.limitIntegrationBatch){
				
				return;
		} 
		
		for(Account a : newList)
		{
			if(oldMap == null)
				continue;
				
			if(oldMap.get(a.Id).IE_Updated_Date__c != a.IE_Updated_Date__c
			   && a.IE_Updated_Date__c != null
			   && a.IE_Updated_Date__c < oldMap.get(a.Id).LastModifiedDate)
			{
				a.AddError('Salesforce Last Modified Date is more Recent then IE Updates');
			}
		}
		
		for(Account a : newList)
		{
			if(oldMap != null && oldMap.get(a.Id).Name != a.Name && UserInfo.getProfileId().substring(0,15) == '00eC0000001GSlm' )
				a.Name = oldMap.get(a.Id).Name;
			
			if(a.IE_Account__c && a.IE_Sync_Status__c != 'Pending' 
			   && (oldMap == null || oldMap.get(A.Id).IE_Sync_Status__c != 'Pending')
			   && TriggerUtility.limitIeServiceIntegration == false)
			{
				a.IE_Sync_Status__c = 'Pending';
			}
			if(a.IE_Account__c && (oldMap==null || oldMap.get(a.Id).IE_Account__c != true))
			{
				if(a.Record_Usage__c != null && !a.Record_Usage__c.contains('IE'))
					a.Record_Usage__c +=  ';IE';
				else if(a.Record_Usage__c == null)
					a.Record_Usage__c =  'IE';
			}
			
		}
		
	}
	
	public static void createAccountAddress(map<Id, Account> newMap)
	{
		map<Id, Address__c> billingAddressMap = new map<Id, Address__c>();
		System.Debug(':::::createAccountAddress :::::::');
		//iterate through newMap ti find completed addresses
		for(Account a : newMap.values())
		{
			//map the address records to the account
			if(a.BillingStreet != null && a.BillingCity != null && a.BillingCountry != null)
			{
				list<String> billAddressLines = a.BillingStreet.split('\n');
				billingAddressMap.put(a.Id, new Address__c( Address_Line_1__c 	= billAddressLines.size() > 0 ? billAddressLines[0] : null
														  , Address_Line_2__c 	= billAddressLines.size() > 1 ? billAddressLines[1] : null
														  , Address_Line_3__c	= billAddressLines.size() > 2 ? billAddressLines[2] : null
														  , Address_Line_4__c	= billAddressLines.size() > 3 ? billAddressLines[3] : null
														  , City__c 			= a.BillingCity
														  , Country__c 			= a.BillingCountry
														  , State_Province__c 	= a.BillingState
														  , Postal_Code__c 		= a.BillingPostalCode
														  , RecordTypeId 		= '012C0000000HrB3'));
			}
		}
		
		//insert the addresses
		if(billingAddressMap.size() > 0)
		{
			insert billingAddressMap.values();
		}
		
		System.Debug(':::::billingAddressMap :::::::'+billingAddressMap);
		
		
		//iterate throug the account address map and create the account address junctions
		list<Account_Address__c> accountAddresses = new list<Account_Address__c>();
		for(Account a : newMap.values())
		{
			if(billingAddressMap.containsKey(a.Id))
			{
				accountAddresses.add(new Account_Address__c(Account__c 			= a.Id
														   ,Address__c 			= billingAddressMap.get(a.Id).Id
														   ,Active__c 			= true
														   ,Physical__c 		= true
														   ,Primary_Bill_To__c 	= true
													       ,Bill_To__c 			= true) );
			}
			
		}
		
		//insert the account address junctions
		if(accountAddresses.size() > 0)
			insert accountAddresses;
		
		System.Debug(':::::accountAddresses :::::::'+accountAddresses);
		
	}
	
	public static void updateAccountAddress(map<Id, Account> newMap, map<Id,Account> oldMap)
	{
		if(TriggerUtility.limitAccountExecution == true || TriggerUtility.syncedAddresses){
				
				return;
		} 
		
		list<Address__c> addresses= new list<Address__c>();
		map<Id, Address__c> oldAddressMap = new map<Id, Address__c>();
		map<Id, Address__c> newAddrMap = new map<Id, Address__c>();
		map<Id, Address__c> newAddrMap2 = new map<Id, Address__c>();
		map<Id, Address__c> oldAddrMap = new map<Id, Address__c>();
		map<Id, Address__c> mapOfAccountToAddress = new map<Id, Address__c>();
		
		map<Id,Id> oldAddressAccountMap = new map<Id,Id>();
		
		//Iterate through the account records looking for changes in the billing address
		//001M000000ZWR4T
		//003M000000TXn6x
		for(Account a : newMap.values())
		{
			if(!AddressHelper.equalStandardAddress(a, oldMap.get(a.Id), 'Billing')
			  && a.BillingStreet != null && a.BillingCity != null && a.BillingCountryCode != null)
			 {
			 	string[] billAddressLines = a.BillingStreet.split('\n');
			 	//a.addError('::::'+billAddressLines);
			 	CountryCodes__c countryCode = CountryCodes__c.getValues(a.BillingCountryCode);
			 	StateCodes__c stateCode =  a.BillingStateCode != null ? StateCodes__c.getValues(a.BillingCountryCode + '-' + a.BillingStateCode) : null;

			 	Address__c addr = new Address__c(Address_Line_1__c 	= billAddressLines.size() > 0 ? billAddressLines[0] : null
											   , Address_Line_2__c 	= billAddressLines.size() > 1 ? billAddressLines[1] : null
											   , Address_Line_3__c	= billAddressLines.size() > 2 ? billAddressLines[2] : null
											   , Address_Line_4__c	= billAddressLines.size() > 3 ? billAddressLines[3] : null
											   , City__c 			= a.BillingCity
											   , Country__c 		= countryCode != null ? countryCode.Country__c : null
											   , State_Province__c 	= stateCode != null ? stateCode.State__c : null
											   , Postal_Code__c 	= a.BillingPostalCode
											   , Id 				= a.Physical_Address__c);
			 	
			 	if(a.Physical_Address__c != null)
			 	{
			 		oldAddressMap.put(a.Physical_Address__c, addr );
			 		oldAddressAccountMap.put(a.Physical_Address__c, a.Id);
			 	}
			 	else
			 	{
			 		newAddrMap.put(a.Id, addr);
			 	}
			 }
		}
		map<Id, Address__c> originalAddresses = new map<Id, Address__c>();
		
		for(Address__c a : [Select Address_Line_1__c 
								, Address_Line_2__c
								, Address_Line_3__c	
								, Address_Line_4__c
								, City__c 
								, Country__c 
								, State_Province__c
								, Postal_Code__c
								, Id 
								, DCW_ID__c
								, Warehouse_Id__c
							 from Address__c
							where Id in :oldAddressMap.keySet()])
		{
			originalAddresses.put(a.Id, a);
		}
		
		
		
		
		map<Id, Account_Address__c> existingAccountAddressMap = new map<Id, Account_Address__c>();
		for(Account_Address__c aa : [Select Id, Address__c from Account_Address__c where Account__c = :newMap.KeySet()])
		{
			existingAccountAddressMap.put(aa.Address__c, aa);
		}
		
		
		//attempt to update the billing addresss
		list<Address__c> addressesToUpdate = new list<Address__c>();
		list<Address__c> addressesToInsert = new list<Address__c>();
		if(newAddrMap.size() > 0 || oldAddressMap.size() > 0)
		{
			map<Id, String> addressActions = AddressTriggerHandler.validateAddressCanUpdate(originalAddresses, oldAddressMap, null);
			/*System.Debug('::AddressTriggerHandler.validateAddressCanUpdate::'+addressActions);
			System.Debug('::originalAddresses::'+originalAddresses);
			System.Debug('::oldAddressMap::'+oldAddressMap);*/
			for(Id i : addressActions.keySet())
			{
				if(addressActions.get(i) == AddressTriggerHandler.PROCEED_WITH_UPDATE)
					addressesToUpdate.add(oldAddressMap.get(i));
				else
				{
					Address__c nAddr = oldAddressMap.get(i).clone();
					//addressesToInsert.add(nAddr);
					
			 		mapOfAccountToAddress.put(oldAddressAccountMap.get(i), nAddr);
				}
			}
			TriggerUtility.syncedAddresses = true;
			if(addressesToUpdate.size() > 0)
				update addressesToUpdate;
				
			if(mapOfAccountToAddress.size() > 0)
			{
				insert mapOfAccountToAddress.values();
				
			}
				
			//create neww addresses in place of addresses that cannot be updated due to relationships to other objects
			if(newAddrMap.size() > 0)
				insert newAddrMap.values();
			TriggerUtility.syncedAddresses = false;

			//iterate over the account records either updating the address Ids with newly created address Ids or adding an associated error
			list<Account_Address__c> accountAddresses = new list<Account_Address__c>();
			for(Account a :  newMap.values())
			{
				if(newAddrMap.containsKey(a.Id))
				{
					accountAddresses.add(new Account_Address__c(Account__c 			= a.Id
														   	   ,Address__c 			= newAddrMap.get(a.Id).Id
															   ,Active__c 			= true
															   ,Physical__c 		= true) );
					a.Physical_Address__c = newAddrMap.get(a.Id).Id;
					a.Primary_Mailing_Address__c = newAddrMap.get(a.Id).Id;
					
				}
				else
				{
					
				
					if(addressActions.get(a.Physical_Address__c) != AddressTriggerHandler.PROCEED_WITH_UPDATE)
					{
						if(mapOfAccountToAddress.containsKey(a.Id))
						{
							a.Physical_Address__c = mapOfAccountToAddress.get(a.Id).Id;
							accountAddresses.add(new Account_Address__c(Account__c 			= a.Id
																   	   ,Address__c 			= a.Physical_Address__c
																	   ,Active__c 			= true
																	   ,Physical__c 		= true) );
						}
					}
				}
				
				if(a.Physical_Address__c == a.Primary_Shipping_Address__c)
				{
					a.ShippingCity 		= a.BillingCity;
					a.ShippingCountryCode	= a.BillingCountryCode;
					a.ShippingStateCode 	= a.BillingStateCode;
					a.ShippingPostalCode= a.BillingPostalCode;
					a.ShippingStreet 	= a.BillingStreet;
					
				}
					
			}
			TriggerUtility.limitAccountExecution = true;
			if(accountAddresses.size() > 0)
				insert accountAddresses;
		}
		
	}

	private static void allOrNoneAccountAddresses(List<Account> accounts){
      for(Account act : accounts){
        AddressHelper.allOrNoneStandardAddress(act, 'Billing','Physical_Address__c', true);
        AddressHelper.allOrNoneStandardAddress(act, 'Shipping', 'Primary_Shipping_Address__c', true);
      }
    }

}