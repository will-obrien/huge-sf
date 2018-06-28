/*
ContactAfterUpdateHandler

Created by: Mark Maslow
Created on: May, 2015

This class is called by trigger ContactAfterUpdate.

It looks for change to the Email field on a Contact record. 
If it finds a change to the Email field, it looks for a User record attached to the Contact.

If it finds a User record, class UpdateUserEmail is queued up to change the Email and UserName fields.

Since a change to Contact will trigger a change to Account, and SFDC will not allow a change to 
Account and User in the same transaction, the update to User is done via a Queueable job.

8/27/2015 Maslow - Ensure that job to update User emails is only enqueued once in a transaction.

2/17/2016 Maslow - Do not update user email if email on Contact is being removed
*/
public with sharing class ContactAfterUpdateHandler {
	private static Boolean userEmailsUpdated = false;
    public static void afterUpdateHandler(List<Contact> newContacts, Map<Id,Contact> newMap, Map<Id,Contact> oldMap) {
    	
        List<Id> contactIdList = new List<Id>();
        
        // SierraRiseExclusive Contacts to deactivate.
        List<Id> SierraRiseExclusiveContactToDeactivateIdList = new List<Id>();
        
        // Step through the contacts
        for(Contact ctct : newContacts) {
        	
        	// Grab the previous values of this contact
            Contact oldContact = oldMap.get(ctct.Id);

            if(oldContact != null) {
            	
		    	// Did the Contact's email change?
                if(oldContact.Email != ctct.Email) {
            		contactIdList.add(ctct.Id);
                }
                
                // If the Contact is currently SierraRise Exclusive
                //	AND ( the Contact's membership become inactive
                //		OR did the user make a Non-SierraRise Donation )
                //	Then deactive this Contact's SerraRise Exclusive Status
                if(	ctct.SierraRise_Exclusive__c &&
                	(oldContact.Account_Membership_Active__c && !ctct.Account_Membership_Active__c ) ||
                	(!oldContact.Account_Non_SierraRise_Donor__c && ctct.Account_Non_SierraRise_Donor__c)) {
                	
                	// Save the Contact's ID to deactivate their potential SierraRise preference
                	SierraRiseExclusiveContactToDeactivateIdList.add(ctct.Id);
                }
            }
        }
        
        if( ! userEmailsUpdated) {
            // Build the list of Users that need to be updated
            List<User> usersToUpdate = new List<User>();
            if(contactIdList.size() > 0) {
                List<User> userList = new List<User>([
                    select Id, ContactId, Email from User where ContactId in :contactIdList
                ]);
                for(User usr : userList) {
                    Contact oldContact = oldMap.get(usr.ContactId);
                    Contact newContact = newMap.get(usr.ContactId);
                    if(oldContact != null && newContact != null) {
                        if(oldContact.Email != newContact.Email) {
                            // 2/17/2016 Change (Add if)
                            if( ! String.isEmpty(newContact.Email)) {
                            	usr.Email = newContact.Email;
                            	usr.UserName = newContact.Email;
                            	usersToUpdate.add(usr);
                            }
                        }
                    }
                }
            }
            // Update the user's affected by the changed email?
            if(usersToUpdate.size() > 0) {
                UpdateUserEmail updt = new UpdateUserEmail(usersToUpdate);
                System.enqueueJob(updt);
                userEmailsUpdated = true;
            }
        }
		// If there are Contacts who's SierraRise Exclusive status needs to be deactivated
		if(SierraRiseExclusiveContactToDeactivateIdList.size() > 0) {
			
			// Grab the Advocacy Action handler, which can manage these preferences.
			//
			// TODO: Probably break this code into a specific separate class.
			//			This handler is also referenced in OpportunityTriggerHandler
			//
			AdvocacyActionTriggerHandler aaTriggerHandler = new AdvocacyActionTriggerHandler();
			aaTriggerHandler.processDeleteSierraRiseExclusiveContacts(SierraRiseExclusiveContactToDeactivateIdList);
		}
                	
		
    }
}