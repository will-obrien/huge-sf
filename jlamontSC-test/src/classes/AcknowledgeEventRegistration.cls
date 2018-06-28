/*
AcknowledgeEventRegistration

Created by: Mark Maslow
Created on: October, 2015

Called by EventRegistrationController

Creates a TriggeredSendEmail to acknowledge a new Event Registration

AfterInsert trigger on TriggeredSendEmail object will send request 
to Exact Target REST API to actually send email.

June 2016 Maslow - Only put values in label fields if marked to be displayed
*/

public without sharing class AcknowledgeEventRegistration {
	public static void acknowledge(Campaign eventCampaign, Event_Registration__c eventRegistration, Event_Leader__c eventLeader) {
		List<TriggeredSendEmail__c> emailList = new List<TriggeredSendEmail__c>();
		
		if( ! String.isEmpty(eventCampaign.Autoresponder_Type__c) ) {
			JSONGenerator gen = JSON.createGenerator(false);
			gen.writeStartObject();
			gen.writeFieldName('To');
			gen.writeStartObject();
			gen.writeStringField('Address', eventRegistration.Email__c);
			gen.writeStringField('SubscriberKey', String.isEmpty(eventRegistration.Contact__c) ? eventRegistration.Email__c : eventRegistration.Contact__c);
			gen.writeFieldName('ContactAttributes');
			gen.writeStartObject();
			gen.writeFieldName('SubscriberAttributes');
			gen.writeStartObject();
			writeStringField(gen, 'EventName', eventCampaign.Event_Name__c);
			writeStringField(gen,'LocationDescription', eventCampaign.Location_Description__c);
			writeStringField(gen,'Sponsor', eventCampaign.Sponsor_Description__c);
			writeStringField(gen,'StartDate', formatDate(eventCampaign.Start_Date__c));
			writeStringField(gen,'StartTime', eventCampaign.Start_Time__c);
			writeStringField(gen,'EndDate', formatDate(eventCampaign.End_Date__c));
			writeStringField(gen,'EndTime', eventCampaign.End_Time__c);
			writeStringField(gen,'Timezone', eventCampaign.Time_Zone__c);
			writeStringField(gen,'LeaderName', eventLeader.Leader_Name__c);
			writeStringField(gen,'ContactInfo', eventLeader.Phone_or_Other_Contact_Information__c);
			writeStringField(gen,'FirstName', eventRegistration.First_Name__c);
			writeStringField(gen,'LastName', eventRegistration.Last_Name__c);
			writeStringField(gen,'Phone', eventRegistration.Phone__c);
			writeStringField(gen,'MobilePhone', eventRegistration.Mobile_Phone__c);
			writeStringField(gen,'Street', eventRegistration.Street__c);
			writeStringField(gen,'City', eventRegistration.City__c);
			writeStringField(gen,'State', eventRegistration.State__c);
			writeStringField(gen,'PostalCode', eventRegistration.PostalCode__c);
			writeStringField(gen,'SubjectLine', eventCampaign.Autoresponder_Subject_Line__c);
			writeStringField(gen,'CustomField1Label', eventCampaign.Display_Field_1__c ? eventCampaign.Custom_Field_1_Label__c : '');
			writeStringField(gen,'CustomField1Response', eventRegistration.Custom_Field_1_Response__c);
			writeStringField(gen,'CustomField2Label', eventCampaign.Display_Field_2__c ? eventCampaign.Custom_Field_2_Label__c : '');
			writeStringField(gen,'CustomField2Response', eventRegistration.Custom_Field_2_Response__c);
			writeStringField(gen,'CustomField3Label', eventCampaign.Display_Field_3__c ? eventCampaign.Custom_Field_3_Label__c : '');
			writeStringField(gen,'CustomField3Response', eventRegistration.Custom_Field_3_Response__c);
			writeStringField(gen,'CustomField4Label', eventCampaign.Display_Field_4__c ? eventCampaign.Custom_Field_4_Label__c : '');
			writeStringField(gen,'CustomField4Response', eventRegistration.Custom_Field_4_Response__c);
			writeStringField(gen,'CustomField5Label', eventCampaign.Display_Field_5__c ? eventCampaign.Custom_Field_5_Label__c : '');
			writeStringField(gen,'CustomField5Response', eventRegistration.Custom_Field_5_Response__c);
			writeStringField(gen,'AutoresponderText', eventCampaign.Autoresponder_Text__c);
            writeStringField(gen,'LocalAddressStreet', eventCampaign.Club_Entity__r.Address_Street__c != null ? eventCampaign.Club_Entity__r.Address_Street__c : '');
            writeStringField(gen,'LocalAddressCity', eventCampaign.Club_Entity__r.Address_City__c != null ? eventCampaign.Club_Entity__r.Address_City__c : '');
            writeStringField(gen,'LocalAddressState', eventCampaign.Club_Entity__r.Address_State__c != null ? eventCampaign.Club_Entity__r.Address_State__c : '');
            writeStringField(gen,'LocalAddressPostalCode', eventCampaign.Club_Entity__r.Address_Postal_Code__c != null ? eventCampaign.Club_Entity__r.Address_Postal_Code__c : '');
			gen.writeEndObject();
			gen.writeEndObject();
			gen.writeEndObject();
			gen.writeEndObject();
			gen.close();
	
			TriggeredSendEmail__c ack = new TriggeredSendEmail__c (
				Email__c = eventRegistration.Email__c,
				SubscriberKey__c = eventRegistration.Contact__c,
				RequestBody__c = gen.getAsString(),
				SendId__c = 'event-autoresponder'
			);
			emailList.add(ack);
		}
		
		if(eventCampaign.Send_RSVP_to_Leader__c) {
			JSONGenerator gen = JSON.createGenerator(false);
			gen.writeStartObject();
			gen.writeFieldName('To');
			gen.writeStartObject();
			gen.writeStringField('Address', eventLeader.Email__c);
			gen.writeStringField('SubscriberKey', String.isEmpty(eventLeader.Contact__c) ? eventLeader.Email__c : eventLeader.Contact__c);
			gen.writeFieldName('ContactAttributes');
			gen.writeStartObject();
			gen.writeFieldName('SubscriberAttributes');
			gen.writeStartObject();
			writeStringField(gen, 'EventName', eventCampaign.Event_Name__c);
			writeStringField(gen, 'RegistrantEmail', eventRegistration.Email__c);
			writeStringField(gen, 'EventURL', eventCampaign.URL_to_Share__c);
			writeStringField(gen,'FirstName', eventRegistration.First_Name__c);
			writeStringField(gen,'LastName', eventRegistration.Last_Name__c);
			writeStringField(gen,'Phone', eventRegistration.Phone__c);
			writeStringField(gen,'MobilePhone', eventRegistration.Mobile_Phone__c);
			writeStringField(gen,'Street', eventRegistration.Street__c);
			writeStringField(gen,'City', eventRegistration.City__c);
			writeStringField(gen,'State', eventRegistration.State__c);
			writeStringField(gen,'PostalCode', eventRegistration.PostalCode__c);
			writeStringField(gen,'CustomField1Label', eventCampaign.Custom_Field_1_Label__c);
			writeStringField(gen,'CustomField1Response', eventRegistration.Custom_Field_1_Response__c);
			writeStringField(gen,'CustomField2Label', eventCampaign.Custom_Field_2_Label__c);
			writeStringField(gen,'CustomField2Response', eventRegistration.Custom_Field_2_Response__c);
			writeStringField(gen,'CustomField3Label', eventCampaign.Custom_Field_3_Label__c);
			writeStringField(gen,'CustomField3Response', eventRegistration.Custom_Field_3_Response__c);
			writeStringField(gen,'CustomField4Label', eventCampaign.Custom_Field_4_Label__c);
			writeStringField(gen,'CustomField4Response', eventRegistration.Custom_Field_4_Response__c);
			writeStringField(gen,'CustomField5Label', eventCampaign.Custom_Field_5_Label__c);
			writeStringField(gen,'CustomField5Response', eventRegistration.Custom_Field_5_Response__c);
			gen.writeEndObject();
			gen.writeEndObject();
			gen.writeEndObject();
			gen.writeEndObject();
			gen.close();
			
			TriggeredSendEmail__c rsvp = new TriggeredSendEmail__c (
				Email__c = eventLeader.Email__c,
				SubscriberKey__c = eventLeader.Contact__c,
				RequestBody__c = gen.getAsString(),
				SendId__c = 'event-leader-notification'
			);
			emailList.add(rsvp);
		}
		if( ! emailList.isEmpty()) {
			insert emailList;
		}
	}
	private static void writeStringField(JSONGenerator gen, String fieldLabel, String fieldContents) {
		if(String.isEmpty(fieldContents)) {
			return;
		}
		gen.writeStringField(fieldLabel, fieldContents);
	}
	private static String formatDate(Date input) {
		if(input == null) {
			return '';
		}
		DateTime dt = DateTime.newInstance(input.year(), input.month(), input.day());
		return dt.format('EEEEE MMMMM d, yyyy');
	}
}