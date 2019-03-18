public class JSONParserUtil {
    @future(callout=true)
    public static void parseJSONResponse(String endpoint) {        
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        // Set the HTTP verb to GET.
        request.setMethod('GET');
        
        // Get Gapi key base on environment
        String gapiKey = '';
        if(Gutils.isSandbox())
			gapiKey = [select Test_Key__c from Gapi_Key__c limit 1].Test_Key__c;
		else
			gapiKey = [select Live_Key__c from Gapi_Key__c limit 1].Live_Key__c;
        
        // Set the request header to authenticate        
        request.setHeader('X-Application-Key', gapiKey);
        
        // Set the endpoint URL.
        request.setEndPoint(endpoint);
        // Send the HTTP request and get the response.
        // The response is in JSON format.
        HttpResponse response = httpProtocol.send(request);
                        
		String jsonBody = response.getBody();
		System.debug('Body: ' + jsonBody);
		
		JSONParser parser = JSON.createParser(jsonBody);
		
		//create a task instance to store info
		Task tempTask = new Task(Subject='temp');
		tempTask.Type = 'Email';				
		
		while (parser.nextToken() != null){   
			//system.debug('outter value: ' + parser.getText());
			//parse email subject and descriptoin
			if (parser.getText() == 'content'){
				//Start at the array of content
				if (parser.nextToken() != null){
					if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
						//system.debug('current value: ' + parser.getText()); 
						
						while (parser.nextToken() != null){
		
								system.debug('inner current value: ' + parser.getText());
								if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
									Content con = (Content)parser.readValueAs(Content.class);
									if(con.type == 'TITLE')
										tempTask.Subject = con.value;
									if(con.type == 'HTML')
										tempTask.Description = con.value;
								}else{
									//finish parsing contents and jump out to parent token 
									break;
								}
		
						}
						
						
					} 
				}
			}
			
			//parse WhoId: customer_id
			if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'customer_id')){
				parser.nextToken();
				String accountId = 'C'+parser.getText();
				
				//system.debug('AccountId (who): ' + accountId);
				accountId = 'C136975';//remove before push to production (for sandbox testing)
				
				//get contact id associate with the person account
				String contactSfId = [select personContactId from Account where Compass_ID_2__c =: accountId].personContactId; //Compass_ID_2__c is unique external key				
				system.debug('contactSfId: ' + contactSfId);
				tempTask.whoid = contactSfId;
						
			}
			
			//parse whatId : booking Id
			if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'booking')){
				system.debug('here1: ' + parser.getText());
				//travers thru booking Object
				while(parser.nextToken() != null){
					
					system.debug('here2: ' + parser.getText());
					if(parser.getText() == 'agent'){
						parser.nextToken();
						system.debug('here3(1): ' + parser.getText());
							if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
								system.debug('here3(2): ' + parser.getText());
								parser.skipChildren();
							}						
					}else if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && parser.getText() == 'id'){
						//parse booking id value
						parser.nextToken();
												
						String bookingId = parser.getText();
						system.debug('booking id:' + bookingId);
						bookingId = '564927';//remove before push to production (for sandbox testing)
						String bookingSfId = [select Id from Booking__c where Name =: bookingId limit 1].Id;
						tempTask.WhatId = bookingSfId;
						break;
					}
					system.debug('here4: ' + parser.getText());
				}
			}
			
			//parse email template: code
			if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'template')){
				while(parser.nextToken() != null){
					if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'code')){
						parser.nextToken();
						tempTask.Template_Code__c = parser.getText();
						break;
					}						
				}
			}
		}
		insert tempTask;
		system.debug('Task Id: ' + tempTask.Id);
    }
    
    public class Content {
    	public String state;
    	public String type;
    	public String value;	
    }
}