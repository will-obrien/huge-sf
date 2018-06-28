/*
ClubEventLeaderEmail

Created by: Mark Maslow
Created on: April, 2016

The send method of this class is called by ClubEventController
when the status of an event is changed, and either an Outings Chair
is to be notified of a Pending Outing, or an Outing Leader is to be
notified that an Outing has been approved or disapproved.

Modification History

12/7/2016 Maslow - if contact record for leader does not have an email,
try using the email on the leader record. If no email there either, 
do not attempt to send a notification.

12/13/2016 Maslow - Only retrieve chairs who are active.

6/2017 Maslow - Add sending of notification of newly active Outing
*/
public without sharing class ClubEventLeaderEmail {
public static Boolean testSend;	

	static {
		Map<String, SiteURL__c> urlMap = SiteURL__c.getAll();
		SiteURL__c siteURL = urlMap.get('EventsURL');
		testSend = siteURL.Testing__c;
	}	
	
	public static void send(Club_Event__c event, Event_Leader__c ldr, String entityName, Boolean isNewlyActive, Boolean notifyLeader) {
		if(event.Status__c == 'Pending Approval') {
			List<Contact> chairList = getOutingsChairs(event.Club_Entity__c);
			if( ! chairList.isEmpty()) {
				leaderToChairs(chairList, event, ldr, entityName);
			}		
		}
		else {
			if(notifyLeader) {
				approverToLeader(event, ldr, entityName);
			}
			if(isNewlyActive) {
				if( event.Event_Category__c == 'Outing' && ( ! String.isEmpty(event.Club_Entity__r.Newly_Activated_Outings_Email__c) )) {
					newlyActivatedOuting(event);
				}
			}
		}
	}
	private static List<Contact> getOutingsChairs(Id entityId) {
		Leader_Position__c pos = [
			select Id from Leader_Position__c where Name = 'Outing Chair'
		];
		List<Leadership__c> ldrList = [
			select Contact__c, Contact__r.Email, Contact__r.FirstName, Contact__r.LastName
			from Leadership__c 
			where Club_Entity__c = :entityId and Leader_Position__c = :pos.Id and Position_Active__c = true
		];
		List<Contact> contactList = new List<Contact>();
		for(Leadership__c ldr : ldrList) {
			Contact ctct = new Contact(
				Id = ldr.Contact__c,
				Email = ldr.Contact__r.Email,
				FirstName = ldr.Contact__r.FirstName,
				LastName = ldr.Contact__r.LastName
			);
			contactList.add(ctct);
		}
		return contactList;
	}
	private static void leaderToChairs(List<Contact> ctctList, Club_Event__c event, Event_Leader__c ldr, String entityName) {
		List<TriggeredSendEmail__c> emailList = new List<TriggeredSendEmail__c>();
		for(Contact ctct : ctctList) {
			TriggeredSendEmail__c msg = new TriggeredSendEmail__c (
				Email__c = ctct.Email,
				SubscriberKey__c = ctct.Id,
				RequestBody__c = createRequestBody(ctct, event, ldr, entityName),
				SendId__c = 'nat-event-pending'
			);
			emailList.add(msg);
		}
		insert emailList;
	}
	private static void approverToLeader(Club_Event__c event, Event_Leader__c ldr, String entityName) {
		Contact ctct;
		if(ldr.Contact__c == null) {
			ctct = new Contact(
				FirstName = '',
				LastName = ldr.Leader_Name__c,
				Email = ldr.Email__c				
			);
		}
		else {
			ctct = [
				select Id, FirstName, LastName, Email
				from Contact
				where Id = :ldr.Contact__c
			];
			if(String.isEmpty(ctct.Email)) {
				ctct.Email = ldr.Email__c;
			}
		}
		if( ! String.isEmpty(ctct.Email)) {
			String sendId;
			if(event.Status__c == 'Changes Required' || event.Status__c == 'Disapproved') {
				sendId = 'nat-event-disapproved';
			}		
			else if(event.Status__c == 'Active') {
				sendId = 'nat-event-approved';
			}
			
			TriggeredSendEmail__c msg = new TriggeredSendEmail__c (
				Email__c = ldr.Email__c,
				SubscriberKey__c = ldr.Contact__c,
				RequestBody__c = createRequestBody(ctct, event, ldr, entityName),
				SendId__c = sendId
			);
			insert msg;
		}
	}
	private static void newlyActivatedOuting(Club_Event__c event) {
		TriggeredSendEmail__c msg = new TriggeredSendEmail__c (
			Email__c = event.Club_Entity__r.Newly_Activated_Outings_Email__c,
			RequestBody__c = newlyActivatedOutingMessage(event),
			Resend__c = true,
			SendId__c = 'nat-event-activated'
		);
		insert msg;
	}
	private static String newlyActivatedOutingMessage(Club_Event__c event) {
		String testMessage;
		JSONGenerator gen = JSON.createGenerator(false);
		gen.writeStartObject();
		gen.writeFieldName('To');
		gen.writeStartObject();
		if(testSend) {
			testMessage = 'This is a test message. In production, this message would be sent to: ' + 
				event.Club_Entity__r.Newly_Activated_Outings_Email__c;
			gen.writeStringField('Address', UserInfo.getUserEmail());
			gen.writeStringField('SubscriberKey', UserInfo.getUserEmail());
		}
		else {
			gen.writeStringField('Address', event.Club_Entity__r.Newly_Activated_Outings_Email__c);
			gen.writeStringField('SubscriberKey', event.Club_Entity__r.Newly_Activated_Outings_Email__c);
		}
		gen.writeFieldName('ContactAttributes');
		gen.writeStartObject();
		gen.writeFieldName('SubscriberAttributes');
		gen.writeStartObject();
		if(testMessage != null) {
			gen.writeStringField('TestMessage', testMessage);
		}
		gen.writeStringField('SponsorDescription', event.Sponsor_Description__c);
		gen.writeStringField('EventTitle', event.Event_Title__c);
		gen.writeStringField('DateBegin', formatDate(event.Date_Begin__c));
		gen.writeStringField('EventURL', event.URL_to_Share__c);
		if( ! String.isEmpty(event.RecurringEvent__c)) {
			gen.writeStringField('Recurs', showOccurrences(event.Recurring_Dates__c));
		}
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeEndObject();
		return gen.getAsString();		
	}
	private static String createRequestBody(Contact ctct, Club_Event__c event, Event_Leader__c ldr, String entityName) {
		String testMessage;
		JSONGenerator gen = JSON.createGenerator(false);
		gen.writeStartObject();
		gen.writeFieldName('To');
		gen.writeStartObject();
		if(testSend) {
			testMessage = 'This is a test message. In production, this message would be sent to: ' + 
				ctct.FirstName + ' ' + ctct.LastName + ' - ' + ctct.Email;
			gen.writeStringField('Address', UserInfo.getUserEmail());
			gen.writeStringField('SubscriberKey', UserInfo.getUserEmail());
		}
		else {
			gen.writeStringField('Address', ctct.Email);
			gen.writeStringField('SubscriberKey', (ctct.Id == null ? ctct.Email : ctct.Id));
		}
		gen.writeFieldName('ContactAttributes');
		gen.writeStartObject();
		gen.writeFieldName('SubscriberAttributes');
		gen.writeStartObject();
		if(testMessage != null) {
			gen.writeStringField('TestMessage', testMessage);
		}
		String chairName;
		if(ctct.FirstName != null && ctct.LastName != null) {
			gen.writeStringField('ChairName', ctct.FirstName + ' ' + ctct.LastName);
		}
		gen.writeStringField('EntityName', entityName);
		gen.writeStringField('LeaderName', ldr.Leader_Name__c);
		gen.writeStringField('EventName', event.Event_Title__c);
		gen.writeStringField('StartDate', formatDate(event.Date_Begin__c));
		writeStringField(gen,'LeaderEmail', ldr.Email__c);
		writeStringField(gen,'LeaderContactInfo', ldr.Phone_or_Other_Contact_Information__c + ' ' + ldr.Email__c);
		gen.writeStringField('ApproverName', UserInfo.getFirstName() + ' ' + UserInfo.getLastName());
		gen.writeStringField('ApproverEmail', UserInfo.getUserEmail());
		gen.writeStringField('DisapproverName', UserInfo.getFirstName() + ' ' + UserInfo.getLastName());
		gen.writeStringField('DisapproverEmail', UserInfo.getUserEmail());
		String disapprovalReason;
		if(event.Status__c == 'Changes Required') {
			disapprovalReason = 'Your proposed activity has not been approved as changes are required';
		}
		else if(event.Status__c == 'Disapproved') {
			disapprovalReason = 'Your proposed activity has been disapproved';
		}
		if(disapprovalReason != null) {
			gen.writeStringField('DisapprovalReason', disapprovalReason);
		}
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeEndObject();
		return gen.getAsString();
	}
	@TestVisible
	private static String formatDate(Date input) {
		if(input == null) {
			return '';
		}
		DateTime dt = DateTime.newInstance(input.year(), input.month(), input.day());
		return dt.format('MMMMM d, yyyy');
	}
	@TestVisible
	private static void writeStringField(JSONGenerator gen, String fieldLabel, String fieldContents) {
		if(String.isEmpty(fieldContents)) {
			return;
		}
		gen.writeStringField(fieldLabel, fieldContents);
	}
	private static String showOccurrences(String occurrences) {
		List<DateTime> dateTimeList = (List<DateTime>)System.Json.deserialize(occurrences, List<DateTime>.class);
		String dtString = '';
		
		for(Integer idx = 0; idx < dateTimeList.size(); idx ++) {
			dtString += dateTimeList.get(idx).format('MMMMM d, yyyy') + '<br/>';
		}
		
		return '<p>This event occurs on the following dates</p> ' + dtString ;		
	}
}