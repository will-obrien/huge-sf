public without sharing class Contact_Address_Trigger_Handler {
	
	public static void onBeforeUpdate(map<Id, Contact_Address__c> newMap, map<Id, Contact_Address__c> oldMap)
	{
		setContactAddressUniqueId(newMap.values());
		validateContactAddress(newMap.values(), oldMap);
	}
	
	public static void onAfterUpdate(map<Id, Contact_Address__c> newMap, map<Id, Contact_Address__c> oldMap)
	{
		uncheckDuplicateFlags(newMap.values(), oldMap);
		setContactAddresses(newMap.values());
	}
	
	public static void onBeforeInsert(list<Contact_Address__c> newList)
	{
		setContactAddressUniqueId(newList);
		validateContactAddress(newList, null);
	}
	
	public static void onAfterInsert(map<Id, Contact_Address__c> newMap)
	{
		uncheckDuplicateFlags(newMap.values(), null);
		setContactAddresses(newMap.values());
	}
	
	public static void uncheckDuplicateFlags(list<Contact_Address__c> newList, map<Id, Contact_Address__c> oldMap)
	{
		Map<Id, Id> contactToPrimaryIds = new Map<Id, Id>();
		Map<Id, Id> contactToPhysicalIds = new Map<Id, Id>();
		Map<Id, Contact_Address__c> addressesToUncheckMap = new Map<Id,Contact_Address__c>();

		for(Contact_Address__c ca : newList){
			if(ca.Active__c&& ca.Primary_Mail_To__c){
				contactToPrimaryIds.put(ca.Contact__c, ca.Id);
			}
			if(ca.Active__c&& ca.Physical__c){
				contactToPhysicalIds.put(ca.Contact__c, ca.Id);
			}
		}

		//Primary
		if(!contactToPrimaryIds.isEmpty()){
			for(Contact_Address__c ca : [Select Id, Primary_Mail_To__c, Physical__c 
			                            from Contact_Address__c
			                            where Active__c = true 
			                            and Primary_Mail_To__c = true
	                                	and Contact__c IN :contactToPrimaryIds.keyset()
	                                	and ID NOT IN :contactToPrimaryIds.values()]){
				ca.Primary_Mail_To__c = false;
				addressesToUncheckMap.put(ca.Id, ca);
			}
		}

		//Physical
		if(!contactToPhysicalIds.isEmpty()){
			for(Contact_Address__c ca : [Select Id, Primary_Mail_To__c, Physical__c 
			                            from Contact_Address__c
			                            where Active__c = true 
										and Physical__c = true
		                        		and Contact__c IN :contactToPhysicalIds.keyset()
		                        		and ID NOT IN :contactToPhysicalIds.values()]){
				Contact_Address__c caToUpdate = addressesToUncheckMap.containskey(ca.Id)? addressesToUncheckMap.get(ca.Id) : ca;
				caToUpdate.Physical__c = false;
				addressesToUncheckMap.put(ca.Id, caToUpdate);
			}
		}

				
		
		if(!addressesToUncheckMap.isEmpty())
		{
			update addressesToUncheckMap.values();
		}
	}
	
	public static void setContactAddresses(List<Contact_Address__c> newList){
		List<Contact> contactsToUpdate = new List<Contact>();

		Set<Id> contactIds = new Set<Id>();
		for(Contact_Address__c ca : newList){
		 	contactIds.add(ca.Contact__c);
		}
		 
		for(Contact c : [Select Id, Primary_Mailing_Address__c,Physical_Address__c, IE_Contact__c, IE_Sync_Status__c, 
 									(select Address__c, Primary_Mail_To__c , Physical__c
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
									from Contact_Addresses__r
									where Active__c=true
									and ((Primary_Mail_To__c=true and Mail_To__c = true) or Physical__c=true))
						from Contact where Id in :contactIds ])
		{
			Boolean updatedContact = setContactPrimaryAddress(c);
			updatedContact |= setContactPhysicalAddress(c);
			updatedContact |= setIeSyncStatus(c);

			if(updatedContact){
				contactsToUpdate.add(c);
			}
		}

		if(TriggerUtility.limitContactExecution == false && contactsToUpdate.size() > 0 )
		 {
		 	TriggerUtility.limitContactExecution = true;
		 	TriggerUtility.syncedAddresses = true;
			
			 	update contactsToUpdate;
			
			TriggerUtility.syncedAddresses = false;
			TriggerUtility.limitContactExecution = false;
		 }
	}
	
	
	private static Boolean setContactPrimaryAddress(Contact c)
	{
		Contact_Address__c primaryCa;
		for(Contact_Address__c ca : c.Contact_Addresses__r){
			if(ca.Primary_Mail_To__c){
				primaryCa=ca;
				break;
			}
		}

		 	
	 	if(c.Primary_Mailing_Address__c!=null && primaryCa==null)
	 	{
		 	  c.Primary_Mailing_Address__c 	= null;
		 	  c.MailingStreet				= null;
		 	  c.MailingCity					= null;
		 	  c.MailingCountry				= null;
		 	  c.MailingState				= null;
		 	  c.MailingPostalCode			= null;
				
		 	  return true;
	 	}
	 	else if(primaryCa!=null && c.Primary_Mailing_Address__c != primaryCa.Address__c)
	 	{
		 	  c.Primary_Mailing_Address__c = primaryCa.Address__c;
		 	  c.MailingStreet				= primaryCa.Address__r.Address_Line_1__c
			 								+(primaryCa.Address__r.Address_Line_2__c==null?'':'\n'+ primaryCa.Address__r.Address_Line_2__c)
			 								+(primaryCa.Address__r.Address_Line_3__c==null?'':'\n'+ primaryCa.Address__r.Address_Line_3__c)
			 								+(primaryCa.Address__r.Address_Line_4__c==null?'':'\n'+ primaryCa.Address__r.Address_Line_4__c);
		 	  c.MailingCity					= primaryCa.Address__r.City__c;
		 	  c.MailingCountry				= primaryCa.Address__r.Country__c;
		 	  c.MailingState				= primaryCa.Address__r.State_Province__c;
		 	  c.MailingPostalCode			= primaryCa.Address__r.Postal_Code__c;
				
		 	  return true;
	 	}
		 
		 return false;	
	}
	
	
	private static Boolean setContactPhysicalAddress(Contact c)
	{
		
		Contact_Address__c physicalCA;
		for(Contact_Address__c ca : c.Contact_Addresses__r){
			if(ca.Physical__c){
				physicalCA=ca;
				break;
			}
		}

		if(c.Physical_Address__c!=null && physicalCA==null)
	 	{
		 	  c.Physical_Address__c 		= null;
		 	  c.OtherStreet					= null;
		 	  c.OtherCity					= null;
		 	  c.OtherCountry				= null;
		 	  c.OtherState					= null;
		 	  c.OtherPostalCode				= null;
				
		 	  return true;
	 	}
	 	else if(physicalCA!=null && c.Physical_Address__c != physicalCA.Address__c)
	 	{
		 	  c.Physical_Address__c 		= physicalCA.Address__c;
		 	  c.OtherStreet					= physicalCA.Address__r.Address_Line_1__c
			 								+(physicalCA.Address__r.Address_Line_2__c==null?'':'\n'+ physicalCA.Address__r.Address_Line_2__c)
			 								+(physicalCA.Address__r.Address_Line_3__c==null?'':'\n'+ physicalCA.Address__r.Address_Line_3__c)
			 								+(physicalCA.Address__r.Address_Line_4__c==null?'':'\n'+ physicalCA.Address__r.Address_Line_4__c);
		 	  c.OtherCity					= physicalCA.Address__r.City__c;
		 	  c.OtherCountry				= physicalCA.Address__r.Country__c;
		 	  c.OtherState					= physicalCA.Address__r.State_Province__c;
		 	  c.OtherPostalCode				= physicalCA.Address__r.Postal_Code__c;
				
		 	  return true;
	 	}
		 
		 return false;	
	}
	
	
	
	static Boolean setIeSyncStatus(Contact c)
	{
		if(!TriggerUtility.limitIeServiceIntegration 
				&& !TriggerUtility.limitIntegrationBatch
				&& c.IE_Contact__c
				&& c.IE_Sync_Status__c != 'Pending'){
			c.IE_Sync_Status__c = 'Pending';
			return true;	
		}
			
		return false;
	}
	
	static void validateContactAddress(list<Contact_Address__c> newList, map<Id, Contact_Address__c> oldMap)
	{
		set<Id> contactsToCheck = new set<Id>();
		map<String, Id> primaryAddressMap = new map<String, Id>();
				
		for(Contact_Address__c a : newList)
		{
			if(oldMap == null && a.Active__c == true  && a.Physical__c != true && a.Mail_To__c != true && a.Primary_Mail_To__c != true)
			{
				a.addError('Please check the type of Contact address when checking Active.');
			}

			if(a.Active__c && a.Primary_Mail_To__c)
			{
				a.Mail_To__c = true;
				primaryAddressMap.put(a.Contact__c, a.Id);
				contactsToCheck.remove(a.Contact__c);
			}
			else{
				contactsToCheck.add(a.Contact__c);
			}
		}
		
		for(Contact_Address__c ca : [Select Contact__c, Primary_Mail_To__c, Physical__c, Active__c
									   from Contact_Address__c
									  where (NOT Id in :newList)
									   and Contact__c in :contactsToCheck
									   and Primary_Mail_To__c = true
									   and Active__c = true
									   ])
		{
				primaryAddressMap.put(ca.Contact__c, ca.Id);
		}
		
		for(Contact_Address__c ca : newList)
		{
			if(ca.Active__c && !primaryAddressMap.containsKey(ca.Contact__c) && ca.mail_To__c == true)
			{
				ca.Primary_Mail_To__c = true;
				primaryAddressMap.put(ca.Contact__c, ca.Id);
			}
		}
	}
	
	public static void setContactAddressUniqueId(list<Contact_Address__c> newList)
	{
		for(Contact_Address__c a : newList)
		{
			a.Contact_Address_ID__c = a.Contact__c + '-'+a.Address__c;
		}
	}

}