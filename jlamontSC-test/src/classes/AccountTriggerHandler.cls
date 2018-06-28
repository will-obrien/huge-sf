//*********************************************************************************************************
//
//Name              : AccountTriggerHandler
//Created By        : Kapil Choudhary(Appirio JDC)
//Created Date      : March 18, 2014
//Description       : Trigger handler class for all triggers of account.
//Last Updated      : March 6, 2017; modified OriginalCampaignName to use hierarchical custom setting 
//					: 2017/05/24 VB: Adding cascading update for No Phone/No Mail value to Contacts
//					: 2017/06/12 VB: Adding cascading update for No Local Phone/No Local Mail to Contacts
//
public with sharing class AccountTriggerHandler {
    
    static Id castIronUserId,bsdProfile;
    
    static {
        for(User usr : [Select Id From User Where Name = 'Cast Iron' Limit 1]) {
            castIronUserId = usr.Id;
        }
        for(Profile prof : [Select Id From Profile Where Name = 'BSD User' Limit 1]) {
            bsdProfile = prof.Id;
        }
    }
    
    //This method will be fired before accounts get inserted.
    public void OnBeforeInsert(List<Account> newList) {
        OriginalCampaignName(newList);
    }
    //This method will be fired before accounts get updated.
    public void OnBeforeUpdate(List<Account> oldList, List<Account> newList, Map<Id,Account> oldMap, Map<Id,Account> newMap) {

    	// When an Accounts No Phone value is changed, 
    	//		the new value must be propagated to all the Contacts 
    	UpdateContactsNoPref(oldList,newList,oldMap,newMap);
    }

    //Set default campaign in the field Original_Campaign__c
    private void UpdateContactsNoPref(List<Account> oldList, List<Account> newList, Map<Id,Account> oldMap, Map<Id,Account> newMap) {
        
	    // Our (unique) Set of Account Ids who's No Phone or No Mail values have changed and who's Contacts need to be updated.
	    Set<Id> accountsUpdated = new Set<Id>();

	    // First determine which Account's have had their No Phone value changed
		for(Account newAccount :newList) {
				
			// If the No Phone or No Mail values has been changed 
			if( newAccount.No_Phone__c 		 != oldMap.get(newAccount.Id).No_Phone__c || 
				newAccount.No_Mail__c 		 != oldMap.get(newAccount.Id).No_Mail__c  || 
				newAccount.No_Local_Phone__c != oldMap.get(newAccount.Id).No_Local_Phone__c  || 
				newAccount.No_Local_Mail__c  != oldMap.get(newAccount.Id).No_Local_Mail__c  ) {
					
				//system.debug('ATH : Found Phone Id:' + newAccount.Id + ':');
				
				// Add the Account to the list of Accounts who's contacts need to be updated.
				accountsUpdated.add(newAccount.Id);
			}
		}

		// Does at least one Account need to have it's Contacts updated?
		if(!accountsUpdated.isEmpty()) {

	    	// Our new list of Contact's to update.
	    	List<Contact> contactsToUpdate = new List<Contact>();
	    	
	    	// Pull the list of all Contacts for these updated Accounts.
	    	for (Contact theContact :[SELECT Id, AccountId, No_Phone__c, No_Mail__c, No_Local_Phone__c, No_Local_Mail__c 
	    									FROM Contact 
	    									WHERE AccountId IN :accountsUpdated]) {

				// If for some reason the value on the Contact is already correct, no need to update it
				// 		NOTE: I'm assuming it's not intergral to simply touch all the Contacts 
				//			so this code might not cause an update to the lastmodifield values.  
				if(theContact.No_Phone__c 		 != newMap.get(theContact.AccountId).No_Phone__c ||
					theContact.No_Mail__c 		 != newMap.get(theContact.AccountId).No_Mail__c ||
					theContact.No_Local_Phone__c != newMap.get(theContact.AccountId).No_Local_Phone__c ||
					theContact.No_Local_Mail__c  != newMap.get(theContact.AccountId).No_Local_Mail__c) {

					// A simple new Contact to update    	
	    			Contact newContact = new Contact();
	    			newContact.Id = theContact.Id;
	    		
		    		// Set it's No Phone & No Mail values to the value of it's Account
	    			newContact.No_Phone__c 		 = newMap.get(theContact.AccountId).No_Phone__c;
	    			newContact.No_Mail__c  		 = newMap.get(theContact.AccountId).No_Mail__c;
	    			newContact.No_Local_Phone__c = newMap.get(theContact.AccountId).No_Local_Phone__c;
	    			newContact.No_Local_Mail__c	 = newMap.get(theContact.AccountId).No_Local_Mail__c;
	    		
			    	// Add it to the list of Contact's to be updated
		    		contactsToUpdate.add(newContact);
				}
	    	}
	    	
	    	// Update the Contacts to be updated, if there are any...
			if (!contactsToUpdate.isEmpty()) {
				update contactsToUpdate;
			}
	    }
    }
    
    
    //Set default campaign in the field Original_Campaign__c
    private void OriginalCampaignName(List<Account> newList){
        
        Id profileId = userinfo.getProfileId();
        Original_Campaign__c oc = Original_Campaign__c.getinstance(profileId);
        String cmpName = oc.Campaign_Name__c;
     
            list<Campaign> campaignList = [select id from Campaign where name=:cmpName];
            if(!campaignList.isEmpty()){ 
                for(Account acc: newList){
                    system.debug(UserInfo.getUserId() + ' ::: ' + castIronUserId);
                    if(String.isEmpty(acc.Original_Campaign__c)) {
	                    if(UserInfo.getUserId() != castIronUserId) {
	                      if(UserInfo.getProfileId() != bsdProfile) {
	                        acc.Original_Campaign__c = campaignList.get(0).id;
	                      }
	                    }
                    }
                }
            }
        }
        
}