/*********************************************************************************************************
Name			: ContactIconsExtension
Created by		: Mark Maslow
Created Date	: July 6,2016 4:11 PM
Description		: Extension that defines when Icons should appear
Updated			: 2017/03/07 VB: Adding this header and support for Contact Grasstop 
***********************************************************************************************************/
public without sharing class ContactIconsExtension {
	private final Contact theContact;
	private Account theAccount;
    private static Id offlineActionTypeId = Schema.SObjectType.kweos__EOCS_Data__c.getRecordTypeInfosByName().get('Offline').getRecordTypeId();
    private static Id onlineActionTypeId = Schema.SObjectType.kweos__EOCS_Data__c.getRecordTypeInfosByName().get('Online').getRecordTypeId();
	public ContactIconsExtension(ApexPages.StandardController stdController) {
		Contact ctct = (Contact)stdController.getRecord();
        theContact = [select Id, AccountId, rC_Bios__Deceased__c, Grasstop__c from Contact where Id=:ctct.Id];
	}
	private Account getAccount() {
		if(theAccount == null) {
			theAccount = [
				select Id, Membership_Active__c, Total_Giving__c, Estate__c,
					Summit_Circle_Member__c, John_Muir_Society__c, Planned_Giving_Prospect__c, 
					Major_Donor__c
				from Account
				where Id = :theContact.AccountId 
			];
		}
		return theAccount;
	}
	public Boolean getHasCases() {
		List<Contact> contactList = [
			select Id from Contact where AccountId = :theContact.AccountId
		];
		Set<Id> contactIds = (new Map<Id,Contact>(contactList)).keySet();
		List<Case> caseList = [
			select Id from Case where ContactId in :contactIds and isClosed = false
			limit 1
		];
		if(caseList.isEmpty()) {
			caseList = [
				select Id from Case where AccountId = :theContact.AccountId and isClosed = false
				limit 1
			];
		}
		return ! caseList.isEmpty();
	}
	public Boolean getHasActiveMembership() {
		return getAccount().Membership_Active__c; 
	}
	public Boolean getIsLeader() {
		List<Leadership__c> ldrList = [
			select Id from Leadership__c 
			where 
				Position_Status__c = 'Active'
				and Contact__c = :theContact.Id
				and 
				(
					(Club_Entity__r.Entity_Category__c = 'Organizing' and Leader_Position__r.Name = 'Team Leader')
					or 
					(Club_Entity__r.Entity_Category__c != 'Organizing')
				)  
			limit 1 
		];
		return ! ldrList.isEmpty();
	}
	public Boolean getIsDonor() {
		Account acct = getAccount();
		Double totalDonationAmount = acct.Total_Giving__c;
		if(totalDonationAmount == null) {
			totalDonationAmount = 0;
		}
		if(totalDonationAmount > 0) {
			return true;
		}
		if(acct.Summit_Circle_Member__c == true ||
			acct.John_Muir_Society__c == true ||
			acct.Planned_Giving_Prospect__c
		) {
			return true;
		}
		return false;
	}
	public Boolean getIsOutingsParticipant() {
		Date threeYearsAgo = Date.today().addYears(-3);
		List<Event_Registration__c> evList = [
			select Id from Event_Registration__c
			where Contact__c = :theContact.Id
			and Status__c != 'Cancelled'
			and Status__c != 'No Show'
			and Campaign__r.Events_Category__c = 'Outing'
			and Campaign__r.Status__c != 'Cancelled'
			and CreatedDate >= :threeYearsAgo 
		];
		if(evList.size() > 0) {
			return true;
		}
		List<Reservation__c> resvList = [
			select Id from Reservation__c
			where Contact__c = :theContact.Id
			and Reservation_Status__c = 'Signed Up'
		];
		return ! resvList.isEmpty();
	}
	public Boolean getIsDeceased() {
		return theContact.rC_Bios__Deceased__c == true;
	}
	public Boolean getIsOnlineActivist() {
		Date sixMonthsAgo = Date.today().addMonths(-6);
		List<kweos__EOCS_Data__c> onlineActList = [
			select Id from kweos__EOCS_Data__c 
			where kwac__Contact__c = :theContact.Id
			and RecordTypeId = :onlineActionTypeId
			and CreatedDate >= :sixMonthsAgo
			LIMIT 1 
		];
		return ! onLineActList.isEmpty();
	}
	public Boolean getIsOfflineActivist() {
		Date oneYearAgo = Date.today().addYears(-1);
		List<kweos__EOCS_Data__c> offlineActList = [
			select Id from kweos__EOCS_Data__c 
			where kwac__Contact__c = :theContact.Id
			and RecordTypeId = :offlineActionTypeId
			and CreatedDate >= :oneYearAgo
			LIMIT 1 
		];
		return ! offLineActList.isEmpty();
	}
	public Boolean getIsMobileSubscriber() {
		List<Contact> subscriberList = [
			select Id from Contact
			where Id = :theContact.Id 
			and Mobile_Subscriber__c = true
			LIMIT 1
		];
		return ! subscriberList.isEmpty();
	}
	public Boolean getIsMajorDonor() {
		Account acct = getAccount();
		return getAccount().Major_Donor__c == true;
	}
	public Boolean getIsGrasstop() {
		return theContact.Grasstop__c == true;
	}
}