/*
//*************************************************************************************************
//
// Name              : CIContactChanges
// By                : Mark Maslow
// Description       : 
//
// ChangeLog        : VB: 11/19/2014 - Removed check on Anonymous__c field, which has been removed.
//                    MM: 4/9/2015 - Get CastIron UserId from Custom Setting, to reduce SOQL queries
//                    MM: 7/9/2015 - Handle removal of email addresses by CastIron
//                    MM: 7/22/2015 -Handle situation where an Account has more than one Preferred Contact
//					  MM: 8/2015 - Do not check for fields that are not used in integration
//                                 Check integration status and workflow status to set flags correctly or bypass processing
//					  VB: 4/13/2016 - Added ContactBeforeUpdateHander call to ensure a change to 
//									a Contact's Account (moved from one account per a merge) will 
//									correctly populate the Contact's address fields.
// 			          VB: 5/6/2016 - Removed references to CI tables (CI_Contact_Change__c)
//*************************************************************************************************
*/
trigger CIContactChanges on Contact (before update) {
	
    // Call the new Trigger handler 
    ContactBeforeUpdateHandler conTrHandle = new ContactBeforeUpdateHandler();
    conTrHandle.OnBeforeUpdate(trigger.new, trigger.newMap, trigger.oldMap);

    //
    // VB: Not bothering to clean up the below code. 
	//
	
    for (Contact newContact : Trigger.new) {
		if(newContact.CastIron_Integration_Status__c == 'Sent') {
			OutboundMessageHelper.contactInWorkflow = true;
			newContact.CastIron_Integration_Status__c = 'Success';
		}    	
    }
    if(OutboundMessageHelper.contactInWorkflow) {
    	OutboundMessageHelper.contactInWorkflow = true;
    	return;
    }
        
    // Look up the Contact Record Types    
    static Id householdRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    static Id organizationRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Organizational').getRecordTypeId();

    // Grab Cast Iron's Id
    private static final Id castironUserId = UserLookup.getId('ciron');

	// WARNING: VB Not in use?
    Map<Id, Contact> contactMap = new Map<Id, Contact>();

    //MM Begin
    Set<Id> accountIds = new Set<Id>();

    // Step through each of the Acccounts that's been modified
    for (Contact newContact : Trigger.new) {
        
        // Grab the corresponding Contact from the old Values map
        Contact oldContact = Trigger.oldMap.get(newContact.Id);

        // When Cast Iron modifies the Club email field
        //      we want to correctly update the appropriate email field
        //          rC_Bios__Work_Email__C
        //          rC_Bios__Other_Email__C
        //          rC_Bios__Home_Email__c
        //      If the Contact didn't previously have an email address
        //          we set the incoming email to 'Home'
        //
        // If the Contact WAS modified by Cast Iron
        //      AND it's a HouseHold Contact
        
        if (System.UserInfo.getUserId() == castironUserId && newContact.RecordTypeId == householdRTId) {
            if(newContact.Club_Email__c == 'remove@email.com') {
                newContact.Club_Email__c = '';
            }

            // If the Club Email field has changed
            if( newContact.Club_Email__c != null && ((newContact.Club_Email__c != oldContact.Club_Email__c) || (newContact.Club_Email__c == '')) ) {
                
                // Grab the new Club email
                String newEmail = newContact.Club_Email__c;
                newContact.Email = newEmail;
                
                // If the preferred email is Work
                if(newContact.rC_Bios__Preferred_Email__c == 'Work') {
                    
                    // Set the work email to the new value
                    newContact.rC_Bios__Work_Email__c = newEmail;
                    
                // If the preferred email is Other
                } else if(newContact.rC_Bios__Preferred_Email__c == 'Other') {
                    
                    // Set the other email to the new value
                    newContact.rC_Bios__Other_Email__c = newEmail;
                    
                } else { // All other instances?  How/when?
                    // What about Assistant???
                    
                    // Set the Home email to the new value
                    newContact.rC_Bios__Home_Email__c = newEmail;
                    
                    // If the preferred email was previously blank and the incoming email is NOT blank
                    if(String.isEmpty(newContact.rC_Bios__Preferred_Email__c) && newEmail != '') {
                        
                        // Set the preferred email to 'home'
                        newContact.rC_Bios__Preferred_Email__c = 'Home';
                    }    
                }
                
                // If the new incoming email is blank, wipe out the preferred email picklist.
                if(String.isBlank(newEmail)) {
                    newContact.rC_Bios__Preferred_Email__c = '';
                }
                if(newContact.rC_Bios__Preferred_Contact__c) {
                    accountIds.add(newContact.AccountId);
                }
            }
        }
 
        // If the Contact was NOT modified by Cast Iron ( aka a user )
        //      AND the Contact is a household
        if (System.UserInfo.getUserId() != castironUserId && newContact.RecordTypeId == householdRTId) {
   
            // If the Name, Club Salutation, Email or Warning Comment has changed.
            if (newContact.CastIron_Resubmit__c ||  // Has the Contact been marked for resubmission?
                oldContact.Original_Campaign__c != newContact.Original_Campaign__c ||
                oldContact.Salutation != newContact.Salutation ||
                oldContact.FirstName != newContact.FirstName ||
                oldContact.LastName != newContact.LastName ||
                oldContact.rC_Bios__Middle_Name__c != newContact.rC_Bios__Middle_Name__c ||
                oldContact.rC_Bios__Suffix__c != newContact.rC_Bios__Suffix__c ||
                oldContact.rC_Bios__Gender__c != newContact.rC_Bios__Gender__c ||
                oldContact.Club_FullName__c != newContact.Club_FullName__c ||
                oldContact.HomePhone != newContact.HomePhone ||
                oldContact.rC_Bios__Work_Phone__c != newContact.rC_Bios__Work_Phone__c ||
                oldContact.OtherPhone != newContact.OtherPhone ||
                oldContact.rC_Bios__Preferred_Email__c != newContact.rC_Bios__Preferred_Email__c ||
                oldContact.rC_Bios__Home_Email__c != newContact.rC_Bios__Home_Email__c ||
                oldContact.rC_Bios__Work_Email__c != newContact.rC_Bios__Work_Email__c ||
                oldContact.rC_Bios__Other_Email__c != newContact.rC_Bios__Other_Email__c ||
                oldContact.Account != newContact.Account ||
                oldContact.rC_Bios__Preferred_Phone__c != newContact.rC_Bios__Preferred_Phone__c ||
                oldContact.MobilePhone != newContact.MobilePhone ||
                oldContact.rC_Bios__Birth_Year__c != newContact.rC_Bios__Birth_Year__c ||
                oldContact.rC_Bios__Birth_Month__c != newContact.rC_Bios__Birth_Month__c ||
                oldContact.rC_Bios__Birth_Day__c != newContact.rC_Bios__Birth_Day__c 
                ) 
            {

                // Set some values to support the Cast Iron integration
                //      The integration status 'in transit' drives the 
                //      start of the CI orchestration
                newContact.CastIron_Integration_Status__c = 'In Transit';
                newContact.Transmit_Date__c               = datetime.now();
                newContact.CastIron_Resubmit__c           = FALSE;
        
            }

            //
            //VB: Should this be moved outside the If statement?
            //
            // If the Contact is a Preferred Contact
            //      if(newContact.RecordTypeId == householdRTId && newContact.rC_Bios__Preferred_Contact__c) {
            if(newContact.rC_Bios__Preferred_Contact__c) {

                //MM Begin
                // Save the Contact's Account
                accountIds.add(newContact.AccountId);
            }
        }        
    }    

    // Grab the Email__C from the Account
    List<Account> accountsToUpdate = new List<Account>();
    Map<Id, Account> accountsMap = new Map<Id, Account>(
        [SELECT Id, Email__c, CastIron_Integration_Status__c, Transmit_Date__c, CastIron_Resubmit__c FROM Account WHERE Id in :accountIds]
    );
    if(accountsMap.size() > 0) {

        //MM Begin
        Set<Id> accountIdsToUpdate = new Set<Id>();
        for (Contact newContact : Trigger.new) {
          Contact oldContact = Trigger.oldMap.get(newContact.Id);
          
            // If the Contact is the Preferred Contact of a Household Account
            if(newContact.RecordTypeId == householdRTId && newContact.rC_Bios__Preferred_Contact__c) {
                //Accounts should not have more than one Preferred Contact, but there are some that do.
                //We'll just use the first one we get, and ignore any others
                if( ! accountIdsToUpdate.contains(newContact.AccountId)) {
                    accountIdsToUpdate.add(newContact.AccountId);
                    String accountEmail = '';
                    String newEmail;
        
                    // Grab the parent' Account's Email__C            
                    Account account = accountsMap.get(newContact.AccountId);
                    if(account != null) {
                        // VB: Putting in a quick-fix null check.            
                        if (account.Email__c != null) {
                            accountEmail = account.Email__c;
                        }
                        
                        // Determine the new Contact's Preferred email
                        if(newContact.rC_Bios__Preferred_Email__c == 'Work') {
                            newEmail = newContact.rC_Bios__Work_Email__c;
                        }
                        else if(newContact.rC_Bios__Preferred_Email__c == 'Other') {
                            newEmail = newContact.rC_Bios__Other_Email__c;
                        }
                        else {
                            newEmail = newContact.rC_Bios__Home_Email__c;
                        }
                        if(accountEmail == null)
                            accountEmail = '';
                        if(newEmail == null)
                            newEmail = '';
                        // If the Contact's email has changed/or is different from the Contact's 
                        if(accountEmail != newEmail) {
                            
                            // Change the Accounts email to the new email and save it for updating.
                            account.Email__c = newEmail;
                            accountsToUpdate.add(account);
                        }
                        else if(oldContact.Salutation != newContact.Salutation ||
                                oldContact.FirstName != newContact.FirstName ||
                                oldContact.LastName != newContact.LastName ||
                                oldContact.rC_Bios__Suffix__c != newContact.rC_Bios__Suffix__c
                                )
                        {
                            account.Transmit_Date__c               = datetime.now();
                            account.CastIron_Resubmit__c           = FALSE;
                            account.CastIron_Integration_Status__c = 'In Transit';
                            accountsToUpdate.add(account);
                        }
                    }
                }
            }
        }
    }
    
    // Update the Accounts with the new email addresses
    if(accountsToUpdate.size() > 0) {
        update accountsToUpdate;
    }
}