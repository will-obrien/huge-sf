/*
ClubEventCancellationEmail

Created by: Mark Maslow
Created on: April, 2016

The send method of this class is called by ClubEventController
when the status of an event is changed from Active or At Capacity to Cancelled
*/
public without sharing class ClubEventCancellationEmail {
    private static final Integer maxMessagesPerSend = 50;
    private static String timeZone = System.UserInfo.getTimeZone().getID();
    private static Time zTime = Time.newInstance(0,0,0,0);

	public static void send(Club_Event__c event, List<Event_Registration__c> regList) {
		List<TriggeredSendEmail__c> sendList = new List<TriggeredSendEmail__c>();
		Integer counter = 0;
		JSONGenerator gen = JSON.createGenerator(false);
		gen.writeStartArray();
		for(Event_Registration__c reg : regList) {
			counter ++;
			if(counter > maxMessagesPerSend) {
				gen.writeEndArray();
				addMessages(gen.getAsString(), sendList);
				gen = JSON.createGenerator(false);
				counter = 1;
				gen.writeStartArray();
			}
			gen.writeStartObject();
			gen.writeFieldName('To');
			gen.writeStartObject();
			gen.writeStringField('Address', reg.Email__c);
			gen.writeStringField('SubscriberKey', (reg.Contact__c == null ? reg.Email__c : reg.Contact__c));
			gen.writeFieldName('ContactAttributes');
			gen.writeStartObject();
			gen.writeFieldName('SubscriberAttributes');
			gen.writeStartObject();
			gen.writeStringField('Email', reg.Email__c);
			gen.writeStringField('FirstName', reg.First_Name__c);
			gen.writeStringField('LastName', reg.Last_Name__c);
			gen.writeStringField('EventName', event.Event_Title__c);
			gen.writeStringField('EventDate', formatDate(event.Date_Begin__c) + ' ' + event.Time_Begin__c);
			gen.writeStringField('CancelReason', event.Cancel_Reason__c);
			gen.writeEndObject();
			gen.writeEndObject();
			gen.writeEndObject();
			gen.writeEndObject();
		}
		gen.writeEndArray();
		addMessages(gen.getAsString(), sendList);
		insert sendList;
	}
	private static void addMessages(String msgBody, List<TriggeredSendEmail__c> sendList) {
		TriggeredSendEmail__c msg = new TriggeredSendEmail__c (
			RequestBody__c = msgBody,
			SendId__c = 'nat-event-cancelled',
			Resend__c = true
		);
		sendList.add(msg);
	}
	private static String formatDate(Date dt) {
       	return DateTime.newInstance(dt, zTime).format('EEEE, MMMM d, yyyy', timeZone);
	}
}