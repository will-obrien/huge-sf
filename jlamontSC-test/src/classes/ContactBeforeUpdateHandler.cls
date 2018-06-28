/*********************************************************************************************************
Name			: ContactBeforeUpdateTriggerHandler
Created By		: Vernon Baas
Created Date	: April 6, 2016
Description		: Before Update trigger handler class for Contact. Called by CIContactChanges Trigger
Updated			: 2014/04/04 VB:  Created

	7/2017 Maslow - Add call to MoveZDMFromAccountsToContacts.moveInfo
***********************************************************************************************************/
public with sharing class ContactBeforeUpdateHandler {

    // This method will be fired before Contacts get updated.
    public void OnBeforeUpdate(List<Contact> newList, Map<Id,Contact> newMap, Map<Id,Contact> oldMap) {

		// If the Contact has switched Accounts,
		//		update the Contact's address fields to its parent account's values
		InitializeMovedContactAddress(newList, newMap, oldMap);
    }

	// 
	// When a new Contact is added, this method looks up its parent Account, retrieves it's address information
	//		and loads that into the Contact's standard Salesforce address fields (Mailing/Other)
	//
	public void InitializeMovedContactAddress(List<Contact> newList, Map<Id,Contact> newMap, Map<Id,Contact> oldMap)	{

		// We only want to move the address information for Contact's that have switched Accounts.
		Map<Id,Contact> contactsMoved = new Map<Id,Contact>();

        //
        // Find any Contact's that are going to be moved to a new Account
        //
        // Step through the new Contacts
        for(Contact newC : newlist) {
        	
        	// Grab the previous values of this contact
            Contact oldC = oldMap.get(newC.Id);
            if(oldC != null) {
            	
		    	// Did the Contact's Account value change?
                if(oldC.AccountId != newC.AccountId) {
                	
                	// Save the Contact
            		contactsMoved.put(newC.Id,newC);
		            System.debug('Contact Moved :' + newC.Id + ':  New Name:' + newC.LastName + ':');
                }
            }
        }
        
		// Build the set of AccountIds from the Moved Contacts
		Set<Id> accountIds = new Set<Id>();
		for (Contact theContact: contactsMoved.values()) {
			accountIds.add(theContact.AccountId);
		}
		
		// Lookup the Account Address information
		Map<Id,Account> accountMap = new Map<Id,Account>(
			[SELECT Id,
					Name, 
					BillingStreet,
					BillingCity,
					BillingState,
					BillingPostalCode,
					BillingCountry,
					ShippingStreet,
					ShippingCity,
					ShippingState,
					ShippingPostalCode,
					ShippingCountry
				FROM Account
				WHERE Id IN :accountIds]);

		List<Contact> contactsMovedList = new List<Contact>();
		// Step through each Contact
		// 	INFO: I'm stepping through newList b/c that's the object I need to update.
		for (Contact c: newList) {
			
			// Only process the Contacts who's Account has been changed.
			//		i.e. Don't update the address fields for all Contacts in the account 
    		if (contactsMoved.containskey(c.Id) ) {
    			
    			contactsMovedList.add(c);
			
				// We should have the Account's Address information 
	    		if (accountMap.containskey(c.AccountId) ) {
	    			
			        Account a = AccountMap.get(c.AccountId);
			        
			        // Load the Account Address info into the Contact
			        //	- overwriting any values there
			        //	- writes Billing -> Mailing and Shipping -> Other
			        c.MailingStreet 	= a.BillingStreet;
			        c.MailingCity 		= a.BillingCity;
			        c.MailingState 		= a.BillingState;
			        c.MailingPostalCode = a.BillingPostalCode;
			        c.MailingCountry 	= a.BillingCountry;
			        
			        c.OtherStreet 		= a.ShippingStreet;
			        c.OtherCity 		= a.ShippingCity;
			        c.OtherState 		= a.ShippingState;
			        c.OtherPostalCode	= a.ShippingPostalCode;
			        c.OtherCountry 		= a.ShippingCountry;
	    		}
    		}    
		}
		
		if( ! contactsMovedList.isEmpty() ) {
			MoveZDMFromAccountsToContacts.moveInfo(contactsMovedList);
		}
	}
}