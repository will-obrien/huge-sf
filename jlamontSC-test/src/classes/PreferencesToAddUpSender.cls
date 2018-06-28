/*************************************************************************
	PreferencesToAddUpSender
	
	Send message to BSD when a Preference that they are interested in changes
	
	Enqueued by class PreferencesToAddUp, which is called by Preference Trigger

	2016/08		Mark Maslow		Original
	2017/03		Mark Maslow		Send error notifications to CastIron Notifications List
*/
public with sharing class PreferencesToAddUpSender implements Queueable, Database.AllowsCallouts {
	private String addUpId;
	private String addUpPreference;
	private Boolean optOut;
	private BSD_Auth_Token__c authToken;
	private Boolean updateAuthToken = false;
	
	public PreferencesToAddUpSender(String addUpId, String addUpPreference, Boolean optOut) {
		this.addUpId = addUpId;
		this.addUpPreference = addUpPreference;
		this.optOut = optOut;
	}
	public void execute(QueueableContext context) {
		Map<String, BSD_Auth_Token__c> tokenMap = BSD_Auth_Token__c.getAll();
		authToken = tokenMap.get('AuthToken');
		if(authToken.Expires__c < System.now().addSeconds(-60)) {
			authToken = getNewToken(authToken);
			if(authToken == null) { 
				return;
			}
		}
		JSONGenerator generator = JSON.createGenerator(false);
		generator.writeStartObject();
		generator.writeNumberField(addUpPreference, optOut ? 1 : 0);
		generator.writeEndObject();
		generator.close();

		HttpResponse res;
		Boolean retry = true;
		Integer numRetries = 0;
		
		while(retry && numRetries <= 1) {
			try {
				res = sendMessage(generator.getAsString());
			}
			catch(Exception e) {
				sendErrorNotification(e.getMessage());
				retry = false;
			}
			if(res != null) {
		 		if(res.getStatus() == 'OK' || res.getStatus() == 'Bad Request') {
		 			retry = false;
					JSONParser parser = JSON.createParser(res.getBody());
					System.debug('Body:' + res.getBody());
					String responseMessage;
			 		while(parser.nextToken() != null) {
						if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status')) {
			 				parser.nextToken();
			 				String responseStatus = parser.getText();
			 				if(responseStatus == 'ok') {
					 			//Good response
			 					break;
			 				}
			 				else {
			 					parser.nextToken();
			 					if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'message') {
			 						parser.nextToken();
			 						responseMessage = parser.getText();
			 						sendErrorNotification('Error setting BSD Email Preference: ' + responseMessage);
			 					}
			 				}
			 			}
			 		}
		 		}
		 		else if(res.getStatus() == 'Unauthorized') {
		 			//Access token may have changed - get a new one and retry
					authToken = getNewToken(authToken);
					if(authToken == null) {
						return;
					}
					numRetries ++;
		 		}
		 		else {
		 			sendErrorNotification('Call returned status code ' + res.getStatusCode() + ' - ' + res.getStatus());
		 			retry = false;
		 		}
			}
		}
		
		if(updateAuthToken) {
			update authToken;
		}
	}
	private HttpResponse sendMessage(String message) {
		System.debug('Starting sendMessage - message:' + message);
		//Create HTTP Request
		HttpRequest req = new HttpRequest();
		HTTPResponse res;
		req.setTimeout(15000);
 		req.setEndpoint(authToken.Endpoint__c + '/api/v1/users/' + addUpId + '/email_prefs?api_token=' + authToken.Token__c);
 		req.setMethod('POST');
 		req.setHeader('content-type', 'application/json');
 		req.setBody(message);

		System.debug('sendMessage req:' + req);
		System.debug('sendMessage body:' + req.getBody());
		//Send request and get back response
		try {
     		res = new Http().send(req);
		}
		catch(Exception e) {
			System.debug('Error sending message:' + e.getMessage());
			throw new CustomException(e.getMessage());
		}
		System.debug('sendMessage res:' + res);
		System.debug('sendMessage res.body:' + res.getBody());
		System.debug('sendMessage message:' + message);
		return res;
	}
	private BSD_Auth_Token__c getNewToken(BSD_Auth_Token__c token) {
		//Get a new access token
		String accessToken;
		DateTime expires;
		String endPoint = token.Endpoint__c;
		
		//Create body of message in JSON format
		JSONGenerator gen = JSON.createGenerator(false);
		gen.writeStartObject();
		gen.writeStringField('email', token.Email__c);
		gen.writeStringField('password', token.Password__c);
		gen.writeEndObject();
		gen.close();
		
		//Create request	
		HttpRequest req = new HttpRequest();
		req.setTimeout(15000);
		req.setEndPoint(token.Endpoint__c + '/api/v1/developers/login');
 		req.setMethod('POST');
 		req.setHeader('content-type', 'application/json');
 		req.setBody(gen.getAsString());
 		System.debug('getNewToken req:' + req);
			
		Http http = new Http();
		HTTPResponse res;
		try {
			//Send request and get back response
	 		res = http.send(req);
		}
		catch(Exception e) {
 			sendErrorNotification('Exception when attempting to get token ' + e.getMessage());
 			return null;
		}

 		System.debug('getNewToken res:' + res);
     		
 		if(res.getStatus() != 'OK') {
 			//If call to get token fails, send email and quit
 			sendErrorNotification('Call to get token returned status code ' + res.getStatusCode());
 			return null;
 		}
 		
 		//Parse response
 		String status;
		JSONParser parser = JSON.createParser(res.getBody());
		System.debug('Body:' + res.getBody());
 		while(parser.nextToken() != null) {
			if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status')) {
 				parser.nextToken();
 				status = parser.getText();
 				if(status != 'OK') {
 					sendErrorNotification('Call to get token returned status: ' + status);
 					return null;
 				}
 			}
			else if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'data')) {
				while(parser.nextToken() != null) {
					if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'api_token')) {
						parser.nextToken();
						accessToken = parser.getText();
					}
				}
				parser.nextToken();
 			} 
 		}
   		token.Token__c = accessToken;
   		token.Expires__c = System.now().addHours(24);
   		updateAuthToken = true;
   		return token;
	}
	private void sendErrorNotification(String message) {
		//updateAuthToken = false;
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {'it-castiron-notifications-list@sierraclub.org'};
		//String[] toAddresses = new String[] {'mark.maslow@sierraclub.org'};
		mail.setToAddresses(toAddresses); 
		mail.setReplyTo('castiron@undefined.com');
		String msg = 'Error sending Preference to BSD\r\n' +
			'AddUpId: ' + addUpId + '\r\n' +
			'Setting preference: ' + addUpPreference + ' to ' + optOut + '\r\n' +
			'Error is: ' + message;
		mail.setPlainTextBody(msg);
		mail.setSubject('BSD Preference Send Error Notification');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
	private class customException extends Exception {}
}