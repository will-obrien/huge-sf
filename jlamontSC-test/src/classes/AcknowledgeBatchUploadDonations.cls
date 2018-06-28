/*
AcknowledgeBatchUploadDonations

Created by: Mark Maslow
Created on: October, 2015

Called by BatchUploadTrigger

If a Batch Upload record is added with Giving Paid = true, 
or Batch Upload record is changed from Giving Paid = false to Giving Paid = true,
create a TriggeredSendEmail to be sent to donor using Exact Target using REST API
*/
public without sharing class AcknowledgeBatchUploadDonations {
	public static final String etMessageDefinitionsSendEndPoint = 'https://www.exacttargetapis.com/messaging/v1/messageDefinitionSends/key:$SendId/send';
	public static final String etAuthEndPoint = 'https://auth.exacttargetapis.com/v1/requestToken';
	public static boolean DonationsAcknowledged = false;

	public void acknowledge(List<rC_Connect__Batch_Upload__c> newList, Map<Id, rC_Connect__Batch_Upload__c> oldMap) {
		List<rC_Connect__Batch_Upload__c> donationsToAcknowledge = new List<rC_Connect__Batch_Upload__c>();
		for(rC_Connect__Batch_Upload__c upload : newList) {
			if(upload.rC_Connect__Giving_Paid__c == true || upload.Send_Autoresponder__c == true) {
				if( ! String.isEmpty(upload.Autoresponder_External_Key__c) ) {
                    if(oldMap == null) {
                        //Insert
                        donationsToAcknowledge.add(upload);
                    }
                    else {
                        //Update
                        rC_Connect__Batch_Upload__c oldValue = oldMap.get(upload.Id);
                        if(oldValue != null) {
                            if(oldValue.rC_Connect__Giving_Paid__c == false) {
                                donationsToAcknowledge.add(upload);
                            }
                        }
                    }
                }
			}
		}
		if(donationsToAcknowledge.size() > 0) {
			List<TriggeredSendEmail__c> emailList = new List<TriggeredSendEmail__c>();
			for(rC_Connect__Batch_Upload__c donation : donationsToAcknowledge) {
				TriggeredSendEmail__c tse = new TriggeredSendEmail__c (
					Email__c = donation.rC_Connect__Contact_1_Email__c,
					SubscriberKey__c = donation.rC_Connect__Batch_Upload_Contact_1_Matched__c,
					RequestBody__c = generateRequestBody(donation),
					SendId__c = donation.Autoresponder_External_Key__c
				);
				emailList.add(tse);
			}
			insert emailList;
			donationsAcknowledged = true;
		}
	}
	private String generateRequestBody(rC_Connect__Batch_Upload__c donation) {
		JSONGenerator gen = JSON.createGenerator(false);
		gen.writeStartObject();
		gen.writeFieldName('To');
		gen.writeStartObject();
		gen.writeStringField('Address', donation.rC_Connect__Contact_1_Email__c);
		gen.writeStringField('SubscriberKey', String.isEmpty(donation.rC_Connect__Batch_Upload_Contact_1_Matched__c) ? donation.rC_Connect__Contact_1_Email__c : donation.rC_Connect__Batch_Upload_Contact_1_Matched__c);
		gen.writeFieldName('ContactAttributes');
		gen.writeStartObject();
		gen.writeFieldName('SubscriberAttributes');
		gen.writeStartObject();
		gen.writeStringField('SubscriberKey', String.isEmpty(donation.rC_Connect__Batch_Upload_Contact_1_Matched__c) ? donation.rC_Connect__Contact_1_Email__c : donation.rC_Connect__Batch_Upload_Contact_1_Matched__c);
		gen.writeStringField('EmailAddress', donation.rC_Connect__Contact_1_Email__c);
		gen.writeStringField('FirstName', donation.rC_Connect__Contact_1_First_Name__c);
		gen.writeStringField('LastName', donation.rC_Connect__Contact_1_Last_Name__c);
		gen.writeNumberField('Amount', donation.rC_Connect__Giving_Giving_Amount__c);
		gen.writeStringField('ConfirmationNumber', String.isEmpty(donation.Confirmation_Number__c) ? '' : donation.Confirmation_Number__c);
		gen.writeDateField('Date', donation.rC_Connect__Giving_Close_Date__c);
		gen.writeStringField('BatchuploadID', donation.Id == null ? '' : donation.Id);
		gen.writeStringField('GeneralAccountingUnit', donation.General_Accounting_Unit__c == null ? '' : donation.General_Accounting_Unit__c);
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeEndObject();
		gen.writeEndObject();
		gen.close();
		return gen.getAsString();
	}
}