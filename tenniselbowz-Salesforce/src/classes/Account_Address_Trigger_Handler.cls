public without sharing class Account_Address_Trigger_Handler {
	
	public static void onBeforeUpdate(map<Id, Account_Address__c> newMap, map<Id, Account_Address__c> oldMap)
	{
		setAccountAddressUniqueId(newMap.values());
		validateAccountAddress(newMap.values(), oldMap);
	}
	
	public static void onAfterUpdate(map<Id, Account_Address__c> newMap, map<Id, Account_Address__c> oldMap)
	{
		
		uncheckDuplicateFlags(newMap.values());
		setAccountAddresses(newMap.values());
	}
	
	public static void onBeforeInsert(list<Account_Address__c> newList)
	{
		setAccountAddressUniqueId(newList);
		validateAccountAddress(newList, null);
	}
	
	public static void onAfterInsert(map<Id, Account_Address__c> newMap)
	{
		uncheckDuplicateFlags(newMap.values());
		setAccountAddresses(newMap.values());
	}

	public static void uncheckDuplicateFlags(List<Account_Address__c> newList){
		Set<Id> accountIds = new Set<Id>();
		Map<Id, Id> accountToMailAccountAddressMap = new Map<Id, Id>();
		Map<Id, Id> accountToShipAccountAddressMap = new Map<Id, Id>();
		Map<Id, Id> accountToBillAccountAddressMap = new Map<Id, Id>();
		Map<Id, Id> accountToPhysicalAccountAddressMap = new Map<Id, Id>();

		List<Account_Address__c> accountAddressToUpdate = new List<Account_Address__c>();
		
		for(Account_Address__c ca : newList)
		{
			accountIds.add(ca.Account__c);

			if(ca.Active__c){
				if(ca.Primary_Ship_To__c){
					accountToShipAccountAddressMap.put(ca.Account__c, ca.Id);
				}
				if(ca.Primary_Bill_To__c){
					accountToBillAccountAddressMap.put(ca.Account__c, ca.Id);
				}
				if(ca.Primary_Mail_To__c){
					accountToMailAccountAddressMap.put(ca.Account__c, ca.Id);
				}
				if(ca.Physical__c){
					accountToPhysicalAccountAddressMap.put(ca.Account__c, ca.Id);
				}
			} 
		}
		
		//find all the other Account address records and add them to a map
		for(Account_Address__c ca : [Select Id
		                                  , Account__c
		                                  , Primary_Ship_To__c
		                                  , Primary_Bill_To__c
		                                  , Physical__c
		                                  , Primary_Mail_To__c
		                               from Account_Address__c
		                              where account__c in :accountIds
		                                and Active__c = true])
		{
			Boolean updateJuntion = false;

			if(accountToMailAccountAddressMap.containsKey(ca.Account__c) && ca.Primary_Mail_To__c
					&& accountToMailAccountAddressMap.get(ca.account__c)!=ca.Id){
				ca.Primary_Mail_To__c = false;
				updateJuntion = true;
			}
			if(accountToShipAccountAddressMap.containsKey(ca.Account__c) && ca.Primary_Ship_To__c
					&& accountToShipAccountAddressMap.get(ca.account__c)!=ca.Id){
				ca.Primary_Ship_To__c = false;
				updateJuntion = true;
			}
			if(accountToBillAccountAddressMap.containsKey(ca.Account__c) && ca.Primary_Bill_To__c
					&& accountToBillAccountAddressMap.get(ca.account__c)!=ca.Id){
				ca.Primary_Bill_To__c = false;
				updateJuntion = true;
			}
			if(accountToPhysicalAccountAddressMap.containsKey(ca.Account__c) && ca.Physical__c
					&& accountToPhysicalAccountAddressMap.get(ca.account__c)!=ca.Id){
				ca.Physical__c = false;
				updateJuntion = true;
			}

			if(updateJuntion){
				accountAddressToUpdate.add(ca);
			}
		}

		if(!accountAddressToUpdate.isEmpty()){
			update accountAddressToUpdate;
		}
	}

	public static void setAccountAddresses(List<Account_Address__c> newList){
		List<Account> accountsToUpdate = new List<Account>();

		Set<Id> accountIds = new Set<Id>();
		for(Account_Address__c ca : newList){
		 	accountIds.add(ca.Account__c);
		}
		 
		for(Account act : [Select Id, Primary_Billing_Address__c, Primary_Mailing_Address__c, Primary_Shipping_Address__c,Physical_Address__c, IE_Account__c, IE_Sync_Status__c, 
 									(select Address__c, Primary_Mail_To__c , Primary_Ship_To__c, Primary_Bill_To__c, Physical__c 
 									,Address__r.Address_Line_1__c
 									,Address__r.Address_Line_2__c
 									,Address__r.Address_Line_3__c
 									,Address__r.Address_Line_4__c
									,Address__r.City__c
									,Address__r.Country__c
									,Address__r.Country_ISO_Code__c
									,Address__r.State_Province__c
									,Address__r.State_Province_ISO_Code__c
									,Address__r.Postal_Code__c
									from Account_Addresses__r
									where Active__c=true
									and (Primary_Mail_To__c=true or Primary_Ship_To__c=true or Primary_Bill_To__c=true or Physical__c=true))
						from Account where Id in :accountIds ])
		{
			Boolean updatedAccount = setAccountPhysicalAddress(act);
			updatedAccount |= setAccountShippingAddress(act);
			updatedAccount |= setAccountMailingAddress(act);
			updatedAccount |= setAccountBillingAddress(act);
			updatedAccount |= setIeSyncStatus(act);

			if(updatedAccount){
				accountsToUpdate.add(act);
			}
		}

		if(TriggerUtility.limitAccountExecution == false && accountsToUpdate.size() > 0 )
		 {
		 	TriggerUtility.limitAccountExecution = true;
		 	TriggerUtility.syncedAddresses = true;
			
			 	update accountsToUpdate;
			
			TriggerUtility.syncedAddresses = false;
			TriggerUtility.limitAccountExecution = false;
		 }
	}

	private static Boolean setAccountPhysicalAddress(Account act)
	{
		
		Account_Address__c physicalCA;
		for(Account_Address__c ca : act.Account_Addresses__r){
			if(ca.Physical__c){
				physicalCA=ca;
				break;
			}
		}

		if(act.Physical_Address__c!=null && physicalCA==null)
	 	{
		 	  act.Physical_Address__c 		= null;
		 	  act.BillingStreet				= null;
		 	  act.BillingCity				= null;
		 	  act.BillingCountry			= null;
		 	  act.BillingState				= null;
		 	  act.BillingPostalCode			= null;
				
		 	  return true;
	 	}
	 	else if(physicalCA!=null && act.Physical_Address__c != physicalCA.Address__c)
	 	{
		 	  act.Physical_Address__c 		= physicalCA.Address__c;
		 	  act.BillingStreet				= physicalCA.Address__r.Address_Line_1__c
			 								+(physicalCA.Address__r.Address_Line_2__c==null?'':'\n'+ physicalCA.Address__r.Address_Line_2__c)
			 								+(physicalCA.Address__r.Address_Line_3__c==null?'':'\n'+ physicalCA.Address__r.Address_Line_3__c)
			 								+(physicalCA.Address__r.Address_Line_4__c==null?'':'\n'+ physicalCA.Address__r.Address_Line_4__c);
		 	  act.BillingCity				= physicalCA.Address__r.City__c;
		 	  act.BillingCountry			= physicalCA.Address__r.Country__c;
		 	  act.BillingState				= physicalCA.Address__r.State_Province__c;
		 	  act.BillingPostalCode			= physicalCA.Address__r.Postal_Code__c;
			
		 	  return true;
	 	}
		 
		 return false;	
	}

	private static Boolean setAccountShippingAddress(Account act)
	{
		
		Account_Address__c shipCA;
		for(Account_Address__c ca : act.Account_Addresses__r){
			if(ca.Primary_Ship_To__c){
				shipCA=ca;
				break;
			}
		}

		if(act.Primary_Shipping_Address__c!=null && shipCA==null)
	 	{
		 	  act.Primary_Shipping_Address__c = null;
		 	  act.ShippingStreet			= null;
		 	  act.ShippingCity				= null;
		 	  act.ShippingCountry			= null;
		 	  act.ShippingState				= null;
		 	  act.ShippingPostalCode		= null;
				
		 	  return true;
	 	}
	 	else if(shipCA!=null && act.Primary_Shipping_Address__c != shipCA.Address__c)
	 	{
		 	  act.Primary_Shipping_Address__c = shipCA.Address__c;
		 	  act.ShippingStreet			= shipCA.Address__r.Address_Line_1__c
			 								+(shipCA.Address__r.Address_Line_2__c==null?'':'\n'+ shipCA.Address__r.Address_Line_2__c)
			 								+(shipCA.Address__r.Address_Line_3__c==null?'':'\n'+ shipCA.Address__r.Address_Line_3__c)
			 								+(shipCA.Address__r.Address_Line_4__c==null?'':'\n'+ shipCA.Address__r.Address_Line_4__c);
		 	  act.ShippingCity				= shipCA.Address__r.City__c;
		 	  act.ShippingCountry			= shipCA.Address__r.Country__c;
		 	  act.ShippingState				= shipCA.Address__r.State_Province__c;
		 	  act.ShippingPostalCode		= shipCA.Address__r.Postal_Code__c;
			
		 	  return true;
	 	}
		 
		 return false;	
	}

	private static Boolean setAccountMailingAddress(Account act)
	{
		
		Account_Address__c mailCA;
		for(Account_Address__c ca : act.Account_Addresses__r){
			if(ca.Primary_Mail_To__c){
				mailCA=ca;
				break;
			}
		}

		if(act.Primary_Mailing_Address__c!=null && mailCA==null)
	 	{
		 	  act.Primary_Mailing_Address__c = null;
		 	  return true;
	 	}
	 	else if(mailCA!=null && act.Primary_Mailing_Address__c != mailCA.Address__c)
	 	{
		 	  act.Primary_Mailing_Address__c = mailCA.Address__c;
		 	  return true;
	 	}
		 
		 return false;	
	}

	private static Boolean setAccountBillingAddress(Account act)
	{
		
		Account_Address__c billingCA;
		for(Account_Address__c ca : act.Account_Addresses__r){
			if(ca.Primary_Bill_To__c){
				billingCA=ca;
				break;
			}
		}

		if(act.Primary_Billing_Address__c!=null && billingCA==null)
	 	{
		 	  act.Primary_Billing_Address__c = null;
		 	  return true;
	 	}
	 	else if(billingCA!=null && act.Primary_Billing_Address__c != billingCA.Address__c)
	 	{
		 	  act.Primary_Billing_Address__c = billingCA.Address__c;
		 	  return true;
	 	}
		 
		 return false;	
	}
	
	static Boolean setIeSyncStatus(Account act)
	{
		if(!TriggerUtility.limitIeServiceIntegration 
				&& !TriggerUtility.limitIntegrationBatch
				&& act.Ie_Account__c
				&& act.IE_Sync_Status__c != 'Pending'){
			act.IE_Sync_Status__c = 'Pending';
			return true;	
		}	
		return false;
	}
	
	
	public static void validateAccountAddress(list<Account_Address__c> newList, map<Id, Account_Address__c> oldMap)
	{	
		Set<Id> accountIds = new Set<Id>();
		Set<Id> accountIdsWithExistingAddresses = new Set<Id>();
		Map<Id, Id> accountToMailAccountAddressMap = new Map<Id, Id>();
		Map<Id, Id> accountToShipAccountAddressMap = new Map<Id, Id>();
		Map<Id, Id> accountToBillAccountAddressMap = new Map<Id, Id>();
		Map<Id, Id> accountToPhysicalAccountAddressMap = new Map<Id, Id>();
		
		for(Account_Address__c ca : newList)
		{
			accountIds.add(ca.Account__c);

			if(ca.Active__c){
				if(oldMap == null && ca.Primary_Ship_To__c != true && ca.Physical__c != true && ca.Bill_To__c != true 
			   		&& ca.Primary_Bill_To__c != true && ca.Ship_To__c != true && ca.Mail_To__c != true && ca.Primary_Mail_To__c != true)
				{
					ca.addError('Please check the type of account address when checking Active.');
				}

				if(ca.Primary_Ship_To__c){
					ca.Ship_To__c = true;
					accountToShipAccountAddressMap.put(ca.Account__c, ca.Id);
				}
				if(ca.Primary_Bill_To__c){
					ca.Bill_To__c = true;
					accountToBillAccountAddressMap.put(ca.Account__c, ca.Id);
				}
				if(ca.Primary_Mail_To__c){
					ca.Mail_To__c = true;
					accountToMailAccountAddressMap.put(ca.Account__c, ca.Id);
				}
				if(ca.Physical__c){
					accountToPhysicalAccountAddressMap.put(ca.Account__c, ca.Id);
				}
			} 
		}
		
		//find all the other Account address records and add them to a map
		for(Account_Address__c ca : [Select Id
		                                  , Account__c
		                                  , Primary_Ship_To__c
		                                  , Primary_Bill_To__c
		                                  , Physical__c
		                                  , Primary_Mail_To__c
		                               from Account_Address__c
		                              where account__c in :accountIds
		                                and Active__c = true
		                                and (not Id in :newList) ])
		{
			accountIdsWithExistingAddresses.add(ca.Account__c);

			if(!accountToMailAccountAddressMap.containsKey(ca.Account__c) && ca.Primary_Mail_To__c)
				accountToMailAccountAddressMap.put(ca.account__c, ca.Id);
			
			if(!accountToShipAccountAddressMap.containsKey(ca.Account__c) && ca.Primary_Ship_To__c)
				accountToShipAccountAddressMap.put(ca.account__c, ca.Id);
			
			if(!accountToBillAccountAddressMap.containsKey(ca.Account__c) && ca.Primary_Bill_To__c)
				accountToBillAccountAddressMap.put(ca.account__c, ca.Id);
			
			if(!accountToPhysicalAccountAddressMap.containsKey(ca.Account__c) && ca.Physical__c)
				accountToPhysicalAccountAddressMap.put(ca.account__c, ca.Id);
			
		}
		
		
		for(Account_Address__c ca : newList)
		{
			if(ca.Active__c){
				//set the current record to the primary mail-to and physical address on insert if no other account addresses exist
				if(oldMap == null && !accountIdsWithExistingAddresses.contains(ca.Account__c))
				{
					ca.Physical__c = true;
					ca.Primary_Mail_To__c = true;
					ca.Mail_To__c = true;
				}

				if(ca.Mail_To__c && !accountToMailAccountAddressMap.containsKey(ca.Account__c)){
					ca.Primary_Mail_To__c = true;
					accountToMailAccountAddressMap.put(ca.Account__c, ca.Id);
				}

				if(ca.Ship_To__c && !accountToShipAccountAddressMap.containsKey(ca.Account__c)){
					ca.Primary_Ship_To__c = true;
					accountToShipAccountAddressMap.put(ca.Account__c, ca.Id);
				}

				if(ca.Bill_To__c && !accountToBillAccountAddressMap.containsKey(ca.Account__c)){
					ca.Primary_Bill_To__c = true;
					accountToBillAccountAddressMap.put(ca.Account__c, ca.Id);
				}
			}
		}
	}
	
	public static void setAccountAddressUniqueId(list<Account_Address__c> newList)
	{
		for(Account_Address__c a : newList)
		{
			a.Account_Address_ID__c = a.Account__c + '-'+a.Address__c;
		}
	}
	

}