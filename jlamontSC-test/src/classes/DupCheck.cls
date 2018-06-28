public with sharing class DupCheck {
	Set<Id> possibleDupIds = new Set<Id>();
	List<Contact> possibleDups = new List<Contact>();

	public List<Contact> checkContacts(DupCheckContact contactsToCheck) {
		Set<String> firstInitials = new Set<String>();
		Set<String> lastNames = new Set<String>();
		Set<String> emails = new Set<String>();
		
		List<Contact> contactList = contactsToCheck.contactList;
		for(Contact ctct : contactList) {
			firstInitials.add(ctct.FirstName.substring(0,1));
			lastNames.add(ctct.LastName);
			emails.add(ctct.Email);
		}
		List<Contact> retrievedContacts = [
			SELECT
				Id,
				AccountId,
				Account.Name,
				FirstName,
				LastName,
				First_Initial__c,
				MailingStreet,
				MailingCity,
				MailingState,
				MailingPostalCode,
				Phone,
				Email,
				Zip_5__c,
				External_Id__c
			FROM Contact
			WHERE 
				LastName in :lastNames
				AND First_Initial__c in :firstInitials
			LIMIT 100
		];
		
		for(Contact toCheck : contactList) {
			for(Contact retrieved : retrievedContacts) {
				if(
					toCheck.FirstName.substring(0,1) == retrieved.First_Initial__c &&
					toCheck.LastName == retrieved.LastName 
				) {
					if(
						toCheck.MailingStreet == contactsToCheck.street &&
						toCheck.MailingCity == contactsToCheck.city &&
						toCheck.MailingState == contactsToCheck.state &&
						toCheck.MailingPostalCode == contactsToCheck.postalCode
					) {
						addPossibleDup(retrieved);
					} else if(toCheck.Phone == retrieved.Phone) {
						addPossibleDup(retrieved);
					} 
				}
			}
		}
		
		retrievedContacts = [
			SELECT
				Id,
				AccountId,
				Account.Name,
				FirstName,
				LastName,
				MailingStreet,
				MailingCity,
				MailingState,
				MailingPostalCode,
				Phone,
				Email,
				Zip_5__c,
				External_Id__c
			FROM Contact
			WHERE Email in :emails
			LIMIT 100
		];
		for(Contact toCheck : contactList) {
			for(Contact retrieved : retrievedContacts) {
				String zip5 = 'xxxxx';
				if(! String.isEmpty(toCheck.MailingPostalCode)) {
					if(toCheck.MailingPostalCode.length() > 5) {
						zip5 = toCheck.MailingPostalCode.substring(0,5);
					}
					else {
						zip5 = toCheck.MailingPostalCode;
					}
				}
				if(
					toCheck.FirstName == retrieved.FirstName ||
					toCheck.LastName == retrieved.LastName ||
					retrieved.LastName == 'Unknown' ||
					retrieved.Zip_5__c == zip5
				) {
					addPossibleDup(retrieved);
				}						
			}
		}
		
		return possibleDups;
	}
	public static List<Account> dupCheckAccount(Account acctToCheck) {
		List<Account> possibleDupAccounts = [
			SELECT
				Id,
				Name,
				BillingStreet,
				BillingCity,
				BillingState,
				BillingPostalCode,
				Phone,
				External_Id__c
			FROM Account
			WHERE
				RecordTypeId = :acctToCheck.RecordTypeId 
				AND Name = :acctToCheck.Name
			LIMIT 500				
		];
		return possibleDupAccounts;
	}
	private void addPossibleDup(Contact ctct) {
		if( ! possibleDupIds.contains(ctct.Id) ) {
			possibleDupIds.add(ctct.Id);
			possibleDups.add(ctct);
		}
	}
	public Class DupCheckContact {
		public String street {get; set;}
		public String city {get; set;}
		public String state {get; set;}
		public String postalCode {get; set;}
		public List<Contact> contactList {get; set;}
	}
}