/*
SendTriggeredSendEmails

Created by: Mark Maslow
Created on: October, 2015

Attempt to send emails using Exact Target API

First attempt is enqueued by trigger TriggeredSendEmailTrigger afterUpdate

If call fails because Exact Target is unavailable, Resend will be set to true.

Class ResendTriggeredSendEmails is scheduled to run every hour. It enqueues this class if it finds
any emails that need to be resent.

Testing will be covered by AcknowledgeBatchUploadDonationsTest and AcknowledgeEventRegistrationTest
*/
public without sharing class SendTriggeredSendEmails implements Queueable, Database.AllowsCallouts {
	private static final Integer maxRetries = 1;
	private static final String etMessageDefinitionsSendEndPoint = 'https://www.exacttargetapis.com/messaging/v1/messageDefinitionSends/key:$SendId/send';
	//private static final String etDataEventsAsyncEndPoint = 'https://www.exacttargetapis.com/hub/v1/dataeventsasync/key:$SendId/rowset';
	private static final String etAuthEndPoint = 'https://auth.exacttargetapis.com/v1/requestToken';

	private ExactTarget_Auth_Token__c authToken;
	private boolean accessTokenIsNew = false;
	private List<TriggeredSendEmail__c> emailsToUpdate = new List<TriggeredSendEmail__c>();	

	private List<TriggeredSendEmail__c> emailsToSend;
	
	public SendTriggeredSendEmails(List<TriggeredSendEmail__c> emailsToSend) {
		this.emailsToSend = emailsToSend;
	}
	
	public void execute(QueueableContext context) {
		String accessToken;
		DateTime expires;

		//Retrieve previously used Auth Token from Custom Setting
		Map<String, ExactTarget_Auth_Token__c> tokenMap = ExactTarget_Auth_Token__c.getAll();
		authToken = tokenMap.get('AuthToken');
		
		if(Test.isRunningTest()) {
			authToken = new ExactTarget_Auth_Token__c();
			authToken.ClientId__c = 'xxxx';
			authToken.ClientSecret__c = 'yyyy';
			authToken.Expires__c = System.now().addSeconds(-120);
		}
		if(authToken.Expires__c < System.now().addSeconds(-60)) {
			//Token will expire in less than 1 minute - get new token
			accessTokenIsNew = true;
			authToken = getNewToken(authToken);
		}
		for(TriggeredSendEmail__c email : emailsToSend) {
			sendOneEmail(email);
		}
		if( ! emailsToUpdate.isEmpty()) {
			update emailsToUpdate;
		}
		if(accessTokenIsNew && authToken != null) {
			//Save new Access Token and expire date/time for future use
			//Callouts cannot occur when an uncommitted change has been made,
			//so update occurs after calls are completed
			if(! Test.isRunningTest()) {
				update authToken;
			}
		}
	}
	private void sendOneEmail(TriggeredSendEmail__c email) {
		boolean retry = true;
		Integer numberRetries = 0;
		HTTPResponse res;
		Http http = new Http();
		
		while(retry && authToken != null && numberRetries <= maxRetries) {
			String accessToken = authToken.Token__c;
				
			//Create HTTP Request
			HttpRequest req = new HttpRequest();
			req.setTimeout(15000);
			String endPoint;
			endPoint = etMessageDefinitionsSendEndPoint;
			if(email.RequestBody__c.startsWith('[')) {
				endPoint = endPoint + 'Batch';
			}
			
     		req.setEndpoint(endPoint.Replace('$SendId', email.SendId__c));
     		req.setMethod('POST');
     		req.setHeader('Authorization', 'Bearer ' + accessToken);
	 		req.setHeader('content-type', 'application/json');
     		req.setBody(email.RequestBody__c);
			
			//Send request and get back response
			if(Test.isRunningTest()) {
				res = new HTTPResponse();
				res.setStatus('Accepted');
			}
			else {
				try {
		     		res = http.send(req);
				}
				catch(Exception e) {
					TriggeredSendEmail__c updt = new TriggeredSendEmail__c(
						Id = email.Id,
						Message__c = e.getMessage(),
						TimeSent__c = DateTime.now()
					);
					if(e.getMessage() == 'Read timed out' || e.getMessage() == 'Connection reset') {
						updt.Resend__c = true;
					}
					else if(e.getMessage().contains('500 Internal Server Error') ||
							e.getMessage().contains('503 Service Unavailable')    ) {
								updt.Resend__c = true;
					}
					else {
						updt.Resend__c = false;
		     			sendErrorNotification('Unable to send TriggeredSendEmail. Id: ' + email.Id + ' Message: ' + e.getMessage());
					}
					updt.LastErrorTime__c = System.now();
					updt.LastErrorMessage__c = e.getMessage();
					emailsToUpdate.add(updt);
		 			retry = false;
		 			res = null;
				}
			}
			if(res != null) {
	     		if(res.getStatus() == 'Accepted') {
	     			//Good response
					TriggeredSendEmail__c updt = new TriggeredSendEmail__c(
						Id = email.Id,
						StatusCode__c = res.getStatusCode(),
						TimeSent__c = DateTime.now(),
						Message__c = null,
						Resend__c = false
					);
					emailsToUpdate.add(updt);
	     			retry = false;
	     		}
	     		else if(res.getStatus() == 'Unauthorized') {
	     			//Access token may have changed - get a new one and retry
					accessTokenIsNew = true;
					authToken = getNewToken(authToken);
					numberRetries ++;
	     		}
	     		else {
	     			//Send failed. If status 503 (Server Unavailable) set to Resend to true
	     			//Otherwise, send error notification via email.
					TriggeredSendEmail__c updt = new TriggeredSendEmail__c(
						Id = email.Id,
						StatusCode__c = res.getStatusCode(),
						TimeSent__c = DateTime.now(),
						Message__c = null
					);
					if(res.getStatusCode() == 503 || res.getStatusCode() == 500) {
						updt.Resend__c = true;
					}
					else {
		     			sendErrorNotification('Unable to send TriggeredSendEmail. Id: ' + email.Id + ' Status Code: ' + res.getStatusCode());
					}
					updt.LastErrorTime__c = System.now();
					updt.LastErrorStatus__c = res.getStatusCode();
					emailsToUpdate.add(updt);
	     			retry = false;
	     		}
			}
		}
		if( authToken == null || (numberRetries > maxRetries) ) {
			TriggeredSendEmail__c updt = new TriggeredSendEmail__c(
				Id = email.Id,
				TimeSent__c = DateTime.now(),
				Message__c = 'Authorization Failed', 
				Resend__c = true
			);
			if(res != null) {
				updt.StatusCode__c = res.getStatusCode();
			}
			updt.LastErrorTime__c = System.now();
			updt.LastErrorMessage__c = 'Authorization Failed';
			if(res != null) {
				updt.LastErrorStatus__c = res.getStatusCode();
			}
			emailsToUpdate.add(updt);
   			//sendErrorNotification('Authorization problem sending TriggeredSendEmail. Id: ' + email.Id + ' Status Code: ' + res.getStatusCode());
		}
	}
	private ExactTarget_Auth_Token__c getNewToken(ExactTarget_Auth_Token__c token) {
		//Get a new access token
		String accessToken;
		DateTime expires;
		
		//Create body of message in JSON format
		JSONGenerator gen = JSON.createGenerator(false);
		gen.writeStartObject();
		gen.writeStringField('clientId', token.ClientId__c);
		gen.writeStringField('clientSecret', token.ClientSecret__c);
		gen.writeEndObject();
		gen.close();
		
		//Create request	
		HttpRequest req = new HttpRequest();
		req.setTimeout(15000);
		req.setEndPoint(etAuthEndpoint);
 		req.setMethod('POST');
 		req.setHeader('content-type', 'application/json');
 		req.setBody(gen.getAsString());
			
		Http http = new Http();
		HTTPResponse res;
		if(Test.isRunningTest()) {
			res = new HTTPResponse();
			res.setStatus('OK');
			res.setBody('{\"accessToken\": \"hvjhpn82zy2hms68gdrda87x\",\"expiresIn\": 3600}');
		}
		else {
			try {
				//Send request and get back response
		 		res = http.send(req);
			}
			catch(Exception e) {
	 			sendErrorNotification('Exception when attempting to get token ' + e.getMessage());
	 			return null;
			}
		}
     		
 		if(res.getStatus() != 'OK') {
 			//If call to get token fails, send email and quit
 			System.debug('*** Bad Return Status:' + res.getStatusCode());
 			sendErrorNotification('Call to get token returned status code ' + res.getStatusCode());
 			return null;
 		}
 		
 		//Parse response and populate custom object with values
		JSONParser parser = JSON.createParser(res.getBody());
 		while(parser.nextToken() != null) {
			if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'accessToken')) {
 				parser.nextToken();
 				accessToken = parser.getText();
 			}
			else if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'expiresIn')) {
				parser.nextToken();
				expires = System.now().addSeconds(parser.getIntegerValue());
 			} 
 		}
   		token.Token__c = accessToken;
   		token.Expires__c = expires;
   		return token;
	}
	private static void sendErrorNotification(String message) {
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {'it-castiron-notifications-list@sierraclub.org'};
		mail.setToAddresses(toAddresses); 
		mail.setReplyTo('castiron@undefined.com');
		String ids = '';
		message = message + '\r\n' + 'Error Sending Triggered Send Email \r\n'; 
		mail.setPlainTextBody(message);
		mail.setSubject('Triggered Send Error Notification');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
}