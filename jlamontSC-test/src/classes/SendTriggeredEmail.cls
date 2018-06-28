/*
SendTriggeredEmail

Created by: Tami Lau
Created on: November 2016

Called by SendTeamEmailController, SendListEmailController, and SendEventEmailController, creates TriggeredSendEmail(s) to send an email to selected members of team

AfterInsert trigger on TriggeredSendEmail object will send request 
to Exact Target REST API to actually send email.
*/

public without sharing class SendTriggeredEmail {
    private static final Integer maxMessagesPerSend = 10;
    private static List<TriggeredSendEmail__c> sendList = new List<TriggeredSendEmail__c>();

	public static void sendemail(List<Contact> cts, String subjLine, String image, String text1, String text2, String text3, String close, String closeName, User usr, String source, String sendkey) {
        Integer counter = 0;
        JSONGenerator gen = JSON.createGenerator(false);
        gen.writeStartArray();
        for(Contact ct : cts) {
            counter ++;
            if(counter > maxMessagesPerSend) {
                gen.writeEndArray();
                addMessages(gen.getAsString(), sendkey);
                gen = JSON.createGenerator(false);
                counter = 1;
                gen.writeStartArray();
            }

			gen.writeStartObject();
            gen.writeFieldName('From');
            gen.writeStartObject();
            gen.writeStringField('Address', usr.Email);
			gen.writeStringField('Name', usr.Name);
            gen.writeEndObject();
			gen.writeFieldName('To');
			gen.writeStartObject();
			gen.writeStringField('Address', ct.Email);
            if (ct.Id != null) {
                gen.writeStringField('SubscriberKey', ct.Id);
            }
            else {
                gen.writeStringField('SubscriberKey', ct.Email);
            }			
			gen.writeFieldName('ContactAttributes');
			gen.writeStartObject();
			gen.writeFieldName('SubscriberAttributes');
			gen.writeStartObject();
			gen.writeStringField('SubjectLine', subjLine);
            gen.writeStringField('ImageLink', image);
            if (ct.FirstName != null) {
                gen.writeStringField('FirstName', ct.FirstName);
            }
            else {
                gen.writeStringField('FirstName', 'Supporter');
            }            
			gen.writeStringField('TextBlock1', text1);
			gen.writeStringField('TextBlock2', text2);
			gen.writeStringField('TextBlock3', text3);
			gen.writeStringField('Closing', close);
			gen.writeStringField('ClosingName', closeName);
            gen.writeStringField('Source', source);
			gen.writeEndObject();
			gen.writeEndObject();
			gen.writeEndObject();
			gen.writeEndObject();
        }
        gen.writeEndArray();
        addMessages(gen.getAsString(), sendkey);
        insert sendList;
    }
    private static void addMessages(String msgBody, String sendkey) {
        TriggeredSendEmail__c msg = new TriggeredSendEmail__c (
            RequestBody__c = msgBody,
            SendId__c = sendkey
        );
        sendList.add(msg);
    }
}