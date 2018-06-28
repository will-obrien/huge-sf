/*
AddUpContact

Created by: Mark Maslow

This class is meant to be called by AddUp as a REST call.

AddUp passes an email and an AddUp Id
This class finds all Contacts with passed email.
It assigns the passed AddUp Id to all Contact records with matching email.
It passes back Contact Id and Account Id for all matched Contacts.

Matched Contacts are returned in descending order of number of Advocacy Actions 
taken by the Contact.

March 2017 Maslow - Only return Contacts with Household or Organizational record types
                    Ignore inputs with no email
*/
@RestResource(urlMapping='/AddUpContact/*')
global without sharing class AddUpContact {
	static Id contactHouseholdTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
	static Id contactOrganizationTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Organizational').getRecordTypeId();
	@HttpPost
	global static List<AddUpLookup> getEmail(AddUpLookup[] input) {
		Map<String, String> emailMap = new Map<String, String>();
		for(AddUpLookup aul: input) {
            if( ! String.isEmpty(aul.email)) {
				emailMap.put(aul.email, aul.AddUpId);
            }
		}
		
		List<AddUpLookup> returnList = new List<AddUpLookup>();
		List<Contact> contactList = new List<Contact>([
			select Id, AccountId, Email, Website_System_Id__c from Contact 
            where Email in :emailMap.KeySet()
            and RecordTypeId in (:contactHouseholdTypeId, :contactOrganizationTypeId)
		]);
		
		Set<Id> contactIdSet = new Set<Id>();
		for(Contact ct : contactList) {
			contactIdSet.add(ct.Id);
		}
		
		List<AggregateResult> lst = [
			select kwac__Contact__c, count(Id) 
			from kweos__EOCS_Data__c 
			where kwac__Contact__c in :contactIdSet
			group by kwac__Contact__c
		];
		
		Map<Id, Integer> countMap = new Map<Id, Integer>();
		for(AggregateResult rslt : lst) {
			countMap.put((Id)rslt.get('kwac__Contact__c'), (Integer)rslt.get('expr0'));
		}
		
		for(Contact ctct : contactList) {
			AddUpLookup au = new AddUpLookup();
			au.email = ctct.email;
			au.ContactId = ctct.Id;
			au.accountId = ctct.AccountId;
			au.addUpId = emailMap.get(ctct.email);
			au.numActions = countMap.get(ctct.Id);
			if(au.numActions == null) {
				au.numActions = 0;
			}
			returnList.add(au);
			ctct.Website_System_Id__c = au.addUpId;
		}
		update contactList;

		returnList.sort();
		return returnList;	
	}
	
	global class AddUpLookup implements Comparable {
		public String email {get; set;}
		public String contactId {get; set;}
		public String accountId {get; set;}
		public String addUpId {get; set;}
		public Integer numActions {get; set;}
		
		public Integer compareTo(Object compareTo) {
			AddUpLookup lu = (AddUpLookup) compareTo;
			if(email == lu.email) {
				if(numActions == lu.numActions) return 0;
				if(numActions > lu.numActions) return -1;
				return 1;
			}
			else if(email > lu.email) return 1;
			return -1;
		}
	}
}