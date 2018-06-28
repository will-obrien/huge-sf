/*********************************************************************************************************
Name			: ContactIconsExtension
Created by		: Mark Maslow
Created Date	: July 7,2016 3:13 PM
Description		: Extension that defines when Icons should appear on Accounts
Updated			: 2017/03/07 VB: Adding this header and support for Account Grasstop 
				  2017/03/15 JL: Added logic to Deceased check to account for Accounts with no Contacts
***********************************************************************************************************/
public without sharing class AccountIconsExtension {
	private final Account theAccount;
	private Set<Id> contactIdSet;
	private Account accountData;
	
	public AccountIconsExtension(ApexPages.StandardController stdController) {
		theAccount = (Account)stdController.getRecord();
	}
    private static Id offlineActionTypeId = Schema.SObjectType.kweos__EOCS_Data__c.getRecordTypeInfosByName().get('Offline').getRecordTypeId();
    private static Id onlineActionTypeId = Schema.SObjectType.kweos__EOCS_Data__c.getRecordTypeInfosByName().get('Online').getRecordTypeId();
	
	private Account getAccount() {
		if(accountData == null) {
			accountData = [
				select Id, Membership_Active__c, Total_Giving__c, Estate__c,
					Summit_Circle_Member__c, John_Muir_Society__c, Planned_Giving_Prospect__c, 
					Major_Donor__c
				from Account
				where Id = :theAccount.Id 
			];
		}
		return accountData;
	}
	private Set<Id> getContactIds() {
		if(contactIdSet == null) {
			List<Contact> contactList = [
				select Id from Contact where AccountId = :theAccount.Id
			];
			contactIdSet = (new Map<Id,Contact>(contactList)).keySet();
		}
		return contactIdSet;
	}
	public Boolean getHasCases() {
		Set<Id> contactIds = getContactIds();
		List<Case> caseList = [
			select Id from Case where ContactId in :contactIds and isClosed = false
			limit 1
		];
		if(caseList.isEmpty()) {
			caseList = [
				select Id from Case where AccountId = :theAccount.Id and isClosed = false
				limit 1
			];
		}
		return ! caseList.isEmpty();
	}
	public Boolean getHasActiveMembership() {
		Account acct = getAccount();
		return acct.Membership_Active__c;
	}
	public Boolean getIsLeader() {
		Set<Id> contactIds = getContactIds();
		List<Leadership__c> ldrList = [
			select Id from Leadership__c 
			where 
				Position_Status__c = 'Active'
				and Contact__c in :contactIds
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
		Set<Id> contactIds = getContactIds();
		Date threeYearsAgo = Date.today().addYears(-3);
		List<Event_Registration__c> evList = [
			select Id from Event_Registration__c
			where Contact__c in :contactIds
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
			where Contact__c in :contactIds
			and Reservation_Status__c = 'Signed Up'
		];
		return ! resvList.isEmpty();
	}
	public Boolean getIsDeceased() {
		Account acct = getAccount();
		if(acct.Estate__c == true) {
			return true;
		}
		Set<Id> contactIds = getContactIds();
		List<Contact> contactList = [
			select Id from Contact where Id in :contactIds 
			and rC_Bios__Deceased__c = true
		];
		return (contactList.size() == contactIds.size()) && contactList.size() > 0; //2017MAR15 - JL - Updated to account for accounts with no contacts
	}
	public Boolean getIsOnlineActivist() {
		Set<Id> contactIds = getContactIds();
		Date sixMonthsAgo = Date.today().addMonths(-6);
		List<kweos__EOCS_Data__c> onlineActList = [
			select Id from kweos__EOCS_Data__c 
			where kwac__Contact__c in :contactIds
			and RecordTypeId = :onlineActionTypeId
			and CreatedDate >= :sixMonthsAgo
			LIMIT 1 
		];
		return ! onLineActList.isEmpty();
	}
	public Boolean getIsOfflineActivist() {
		Set<Id> contactIds = getContactIds();
		Date oneYearAgo = Date.today().addYears(-1);
		List<kweos__EOCS_Data__c> offlineActList = [
			select Id from kweos__EOCS_Data__c 
			where kwac__Contact__c in :contactIds
			and RecordTypeId = :offlineActionTypeId
			and CreatedDate >= :oneYearAgo
			LIMIT 1 
		];
		return ! offLineActList.isEmpty();
	}
	public Boolean getIsMobileSubscriber() {
		Set<Id> contactIds = getContactIds();
		List<Contact> subscriberList = [
			select Id from Contact
			where Id in :contactIds 
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
		Set<Id> contactIds = getContactIds();
		List<Contact> subscriberList = [
			select Id from Contact
			where Id in :contactIds 
			and Grasstop__c = true
			LIMIT 1
		];
		return ! subscriberList.isEmpty();
	}
}