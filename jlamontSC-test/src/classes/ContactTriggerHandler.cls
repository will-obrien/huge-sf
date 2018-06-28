/*********************************************************************************************************
Name			: ContactTriggerHandler
Created By		: Kapil Choudhary(Appirio JDC)
Created Date	: March 18, 2014
Description		: Trigger handler class for all triggers of Contact.
Updated			: 2014/04/04 VB:  Formatted and comments
				: 2015/08/05 VB:  Added InitializeContactAddress() method to move Account address
				: 					information down to a newly inserted Contact.
                : 2017/01/17 MM: Don't overwrite orginal campaign if there already is one.
				: 2017/03/23 TL; Modified OriginalCampaignName to use hierarchical custom setting 
***********************************************************************************************************/
public with sharing class ContactTriggerHandler {

	// WARNING: VB - This seems to be the outdated way of doing this.  Not touching this existing code.    
	static Id castIronUserId;
	static Id bsdProfile;
	static {
		for(User usr : [Select Id From User Where Name = 'Cast Iron' Limit 1]) {
			castIronUserId = usr.Id;
		}
		for(Profile prof : [Select Id From Profile Where Name = 'BSD User' Limit 1]) {
			bsdProfile = prof.Id;
		}
	}
    
    // This method will be fired before Contacts get inserted.
    public void OnBeforeInsert(List<Contact> newList) {

		// Update the Contact's address fields to its parent Account's values
		InitializeContactAddress(newList);

		// Give the new Contact the default Original Campaign value
        OriginalCampaignName(newList);
    }

	// 
	// When a new Contact is added, this method looks up its parent Account, retrieves it's address information
	//		and loads that into the Contact's standard Salesforce address fields (Mailing/Other)
	//
	public void InitializeContactAddress(List<Contact> newList)	{

		// Build the set of AccountIds from out Contacts
		Set<Id> accountIds = new Set<Id>();
		for (Contact theContact: newList) {
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

		// Step through each Contact		
		for (Contact c: newList) {
			
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
    
    // Set default campaign in the field Original_Campaign__c
    private void OriginalCampaignName(List<Contact> newList){
        
        Id profileId = userinfo.getProfileId();
        Original_Campaign__c oc = Original_Campaign__c.getinstance(profileId);
        String cmpName = oc.Campaign_Name__c;
     
            list<Campaign> campaignList = [select id from Campaign where name=:cmpName];
            if(!campaignList.isEmpty()){ 
                for(Contact c: newList){
                    system.debug(UserInfo.getUserId() + ' ::: ' + castIronUserId);
                    if(String.isEmpty(c.Original_Campaign__c)) {
	                    if(UserInfo.getUserId() != castIronUserId) {
	                      if(UserInfo.getProfileId() != bsdProfile) {
	                        c.Original_Campaign__c = campaignList.get(0).id;
	                      }
	                    }
                    }
                }
            }
        }
}