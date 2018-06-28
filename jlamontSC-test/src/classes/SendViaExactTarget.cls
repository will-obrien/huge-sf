public with sharing class SendViaExactTarget {
	public static final Integer maxRetries = 1;
	public static final String etMessageDefinitionsSendEndPoint = 'https://www.exacttargetapis.com/messaging/v1/messageDefinitionSends/key:$SendId/send';
	public static final String etAuthEndPoint = 'https://auth.exacttargetapis.com/v1/requestToken';
	@future(callout='true')
	public static void send(String sendId, String requestBody, String objectToUpdate, String serializedObject) {
		String accessToken;
		DateTime expires;
		boolean accessTokenIsNew = false;
		sObject sObjectToUpdate;
		Event_Registration__c eventReg;
		if(objectToUpdate == 'Event_Registration__c') {
			eventReg = (Event_Registration__c) JSON.deserialize(serializedObject, Event_Registration__c.class);
			sObjectToUpdate = eventReg;
		}
		
		
		//Retrieve previously used Auth Token from Custom Setting
		Map<String, ExactTarget_Auth_Token__c> tokenMap = ExactTarget_Auth_Token__c.getAll();
		ExactTarget_Auth_Token__c authToken = tokenMap.get('AuthToken');
		
		if(Test.isRunningTest()) {
			authToken = new ExactTarget_Auth_Token__c();
			authToken.ClientId__c = 'xxxx';
			authToken.ClientSecret__c = 'yyyy';
			authToken.Expires__c = System.now().addSeconds(-120);
		}
		if(authToken.Expires__c < System.now().addSeconds(-60)) {
			//Token will expire in less than 1 minute - get new token
			accessTokenIsNew = true;
			authToken = getNewToken(authToken, objectToUpdate, sObjectToUpdate);
			if(authToken == null) {
				return;
			}
		}

		boolean retry = true;
		Integer numberRetries = 0;
		while(retry && authToken != null && numberRetries <= maxRetries) {
			accessToken = authToken.Token__c;
				
			//Create HTTP Request
			HttpRequest req = new HttpRequest();
     		req.setEndpoint(etMessageDefinitionsSendEndPoint.Replace('$SendId', sendId));
     		req.setMethod('POST');
     		req.setHeader('Authorization', 'Bearer ' + accessToken);
	 		req.setHeader('content-type', 'application/json');
     		req.setBody(requestBody);
			
			Http http = new Http();
			
			//Send request and get back response
			HTTPResponse res;
			if(Test.isRunningTest()) {
				res = new HTTPResponse();
				res.setStatus('Accepted');
			}
			else {
				try {
		     		res = http.send(req);
				}
				catch(Exception e) {
		 			sendErrorNotification(objectToUpdate, sObjectToUpdate, 'Exception when attempting to send messages ' + e.getMessage());
		 			retry = false;
		 			return;
				}
			}
			
			if(objectToUpdate == 'Event_Registration__c') {
				eventReg = (Event_Registration__c) sObjectToUpdate;
				eventReg.Acknowledement_Response__c = res.getBody();
				eventReg.Time_Acknowledgement_Sent__c = System.now();
				eventReg.Acknowledgement_Status__c = res.getStatusCode() + ' ' + res.getStatus();
			}
     		
     		if(res.getStatus() == 'Accepted') {
     			//Good response - done
     			retry = false;
				if(objectToUpdate == 'Event_Registration__c') {
    	 			eventReg.Acknowledgement_Successfully_Sent__c = true;
				}
     		}
     		else if(res.getStatus() == 'Unauthorized') {
     			//Access token may have changed - get a new one and retry
				accessTokenIsNew = true;
				authToken = getNewToken(authToken, objectToUpdate, sObjectToUpdate);
				numberRetries ++;
     		}
     		else {
     			//Fatal error - send email and quit
     			retry = false;
     			sendErrorNotification(objectToUpdate, sObjectToUpdate, 'Call to send messages returned status code ' + res.getStatusCode());
     		}
		}
		if(numberRetries > maxRetries) {
			sendErrorNotification(objectToUpdate, sObjectToUpdate, 'Unable to obtain authorization token');
		}
		if(accessTokenIsNew && authToken != null) {
			//Save new Access Token and expire date/time for future use
			//Callouts cannot occur when an uncommitted change has been made,
			//so update occurs after calls are completed
			if(! Test.isRunningTest()) {
				update authToken;
			}
		}
		
		update sObjectToUpdate;
		if(Test.isRunningTest()) {
			sendErrorNotification(objectToUpdate, sObjectToUpdate, 'Test message - no actual error occurred');
		}
	}
	private static ExactTarget_Auth_Token__c getNewToken(ExactTarget_Auth_Token__c token, String objectToUpdate, sObject sObjectToUpdate) {
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
	 			sendErrorNotification(objectToUpdate, sObjectToUpdate,'Exception when attempting to get token ' + e.getMessage());
			}
		}
     		
 		if(res.getStatus() != 'OK') {
 			//If call to get token fails, send email and quit
 			System.debug('*** Bad Return Status:' + res.getStatusCode());
 			sendErrorNotification(objectToUpdate, sObjectToUpdate,'Call to get token returned status code ' + res.getStatusCode());
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
	private static void sendErrorNotification(String objectToUpdate, sObject sObjectToUpdate, String message) {
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {'it-castiron-notifications-list@sierraclub.org'};
		mail.setToAddresses(toAddresses); 
		mail.setReplyTo('castiron@undefined.com');
		String ids = '';
		message = message + '\r\n' + 'Unable to acknowledge the following ' + objectToUpdate + ' Id:\r\n' + sObjectToUpdate.Id; 
		mail.setPlainTextBody(message);
		mail.setSubject('Batch Upload Acknowledgement Error Notification');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
}