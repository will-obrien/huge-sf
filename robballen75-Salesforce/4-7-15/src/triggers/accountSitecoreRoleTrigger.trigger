/** 
 * This trigger will get a list of all Contacts belonging to the updated or inserted Account 
 * and loop through each Contact.
 * If the SitecoreRole checkbox is checked, then the trigger  will give each Contact a Sitecore Username from their Contact Name and a 
 * Sitecore password of Passw0rd.
 * Once each Contact is saved, the contactSitecorePasswordTrigger will encrypt that Contacts password.
 * If the SitecoreRole checkbox is unchecked, then the Sitecore Username and password is removed from each Contact.
 * The Salesforce System Admin can create or modify the Username and password of each Contact individually  
 */
trigger accountSitecoreRoleTrigger on Account (after insert, after update) {

	// Custom Setting can be used to define which Salesforce Contact field is used to auto populate the Sitecore Username
	String defaultSitecoreUsernameField = null;
	if(S4SSettings__c.getInstance('DefaultSitecoreUsernameField') != null)
	{
		defaultSitecoreUsernameField = S4SSettings__c.getInstance('DefaultSitecoreUsernameField').TextValue__c;
	}
	if(defaultSitecoreUsernameField == null || 
	   defaultSitecoreUsernameField.trim().length() == 0 || 
	   defaultSitecoreUsernameField == 'Name') {
		defaultSitecoreUsernameField = null;
	}

	Set<Id> accountsToCheckContacts = new Set<Id>();
	Set<Id> accountsToUncheckContacts = new Set<Id>();
	
	for(Account a : Trigger.new) {
		if(trigger.isUpdate) {
			Account old = trigger.oldMap.get(a.Id);
			// Was checked and now it isn't, so deactivate the Contacts under the Account
			if (old.SitecoreRole__c && !a.SitecoreRole__c) {
				accountsToUncheckContacts.add(a.Id);
			}
			
			// Was unchecked and is not checked, so activate the Contacts under the Account
			if (!old.SitecoreRole__c && a.SitecoreRole__c) {
				accountsToCheckContacts.add(a.Id);
			}
		}
		else {
			//New insert, check if checkbox ticked.
			if(a.SitecoreRole__c) { 
				accountsToCheckContacts.add(a.Id);
			}
		}	
	}
	
	System.debug('checkContacts size=' + accountsToCheckContacts.size());
	System.debug('unCheckContacts size=' + accountsToUncheckContacts.size());
	
	//Check all Contacts for marked accounts
	List<Contact> contactsToUpdate = new List<Contact>();
	Set<String> usedSitecoreUsernames = new Set<String>();
	if(accountsToCheckContacts.size() > 0) {
		System.debug('checkContacts');
		List<Contact> contacts = null;
		if(defaultSitecoreUsernameField == null) {
			contacts = [Select Id, Name, SitecoreUsername__c, SitecorePassword__c
								  from Contact c 
								  where c.AccountId in :accountsToCheckContacts and c.IsDeleted = false];	
		} else {
			System.debug('using dynamic SOQL for ' + defaultSitecoreUsernameField);
			contacts = Database.query('Select Id, Name, SitecoreUsername__c, SitecorePassword__c, ' + String.escapeSingleQuotes(defaultSitecoreUsernameField) +
								  ' from Contact c' + 
								  ' where c.AccountId in :accountsToCheckContacts and c.IsDeleted = false');
		}						  
		
		System.debug('contacts Count =' + contacts.size());
		
		String name = '';
		String password = '';
	
		// Loop through the list and update the Name field
		for(Contact c : contacts) {
			
			// Check for existing values before resetting them. I.e. The username shoud be set only if they don't already have one?
			
			name = c.SitecoreUsername__c; 
			if(name == null) {
				if(defaultSitecoreUsernameField == null) {
					//System.debug('Contact Name = ' + c.Name);
					name = c.Name.replaceAll('\\W', ''); //Remove white space etc.
					//System.debug('Contact Name now = ' + name);
				} else {
					object newNameValue = c.get(defaultSitecoreUsernameField); 
					name = (newNameValue == null)? c.Name : (String)newNameValue;
					System.debug('Contact Name now = ' + name);
				}	
				
			}
			
			// The name must be unique
			if(usedSitecoreUsernames.contains(name)) {
				string baseName = name;
				integer increment = 1;
				while(usedSitecoreUsernames.contains(name)) {
					name = baseName + increment;
					increment++;
				}	
			}		
			usedSitecoreUsernames.add(name);
			
			password = c.SitecorePassword__c;
			if(password == null || password == '') {
				password = 'Passw0rd'; // Default password
			}
									
			Contact updatedContact = new Contact(
				Id = c.Id,
				SitecoreUsername__c = name,
				SitecorePassword__c = password, 
				SitecorePasswordEncrypted__c = (password != c.SitecorePassword__c));
			
			//System.debug('Enabling Contact Id:' + updatedContact.Id + ' Name = ' + updatedContact.SitecoreUsername__c );
			 
			contactsToUpdate.add(updatedContact);
		}
		
	}
	
	//Uncheck Contacts for marked accounts
	if(accountsToUncheckContacts.size() > 0) {
		System.debug('unCheckContacts');
		List<Contact> contacts = [Select c.Id, c.Name, c.SitecorePassword__c, c.SitecorePasswordEncrypted__c, c.SitecoreUsername__c from Contact c where c.AccountId in :accountsToUncheckContacts and c.IsDeleted = false];
		System.debug('contacts Count =' + contacts.size());

		// Loop through the list and update the Name field
		for(Contact c : contacts) {
							
				//System.debug('Disabling Contact Id:' + c.Id );
							
				Contact updatedContact = new Contact(
					Id = c.Id,
					SitecoreUsername__c = null,
					SitecorePassword__c = null,
					SitecorePasswordEncrypted__c = false);
		 
				contactsToUpdate.add(updatedContact);
		}

	}
	
	//update contacts;
	//try {
	
		//Do update out of loop due to 200 SQL limit
		List<Database.SaveResult> SRs = database.update(contactsToUpdate);
		
		for(Database.SaveResult sr : SRs) {
			if(!sr.isSuccess()) {
				System.debug('Database.SaveResult Error = ' + sr.getErrors());
			}
		}
		
	//} catch(Exception e) {
	//	System.debug('Error accountSitecoreRoleTrigger =' + e);
	//}
	
}