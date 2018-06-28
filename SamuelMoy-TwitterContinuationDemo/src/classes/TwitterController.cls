/**
*	@class TwitterController
*	@author Samuel Moyson
*	@date   13/06/2016
**/

public with sharing class TwitterController {	

	// Ouath Parameters
	private String CONSUMER_KEY = 'insert here you twitter consumer key';
	private String CONSUMER_SECRET = 'insert here your twitter consumer secret';

    // Unique label corresponding to the continuation
    public String requestLabel;
    // Result of callout
    public String result {get;set;}
    // Search string
    public String search {get; set;}
    // Statuses
    public List <String> statuses {get; set;}   
   
    // Action method
    public Object startRequest() {
      // Create continuation with a timeout
      Continuation con = new Continuation(40);
      // Set callback method
      con.continuationMethod='processResponse';
      
      HttpRequest req = new HttpRequest(); 
      String endpoint = 'https://api.twitter.com/1.1/search/tweets.json?q=' + EncodingUtil.urlEncode(search, 'UTF8');           
      req.setEndpoint(endpoint);
      req.setMethod('GET');

      // oauth
      String authorizationHeader = 'Bearer ' + getToken();
      req.setHeader('Authorization', authorizationHeader);
      
      // Add callout request to continuation
      this.requestLabel = con.addHttpRequest(req);
      
      // Return the continuation
      return con;  
    }
    
    // Callback method 
    public Object processResponse() {   
      // Get the response by using the unique label
      HttpResponse response = Continuation.getResponse(this.requestLabel);
      // Set the result variable that is displayed on the Visualforce page
      this.result = response.getBody();	    

	  this.statuses = new List <String> (); 

	  //Use Json parser to parse result	  
	  TwitterJsonToApex parsed = TwitterJsonToApex.parse(this.result);	
	  
	  for(TwitterJsonToApex.cls_statuses status : parsed.statuses ) {	  	
	      this.statuses.add(status.text);
	  }
      
      // Return null to re-render the original Visualforce page
      return null;
    }	

	private String getToken() {
		//Encode them
		String keyencoded = EncodingUtil.urlEncode(CONSUMER_KEY, 'UTF-8');
		String secretkeyencoded = EncodingUtil.urlEncode(CONSUMER_SECRET, 'UTF-8');

		//Create Final Key String
		String sFinal = keyencoded + ':' + secretkeyencoded;
		//Convert to Blob
		Blob headerValue = Blob.valueOf(sFinal);

		//Build Request
		HttpRequest req = new HttpRequest();
		req.setEndpoint('https://api.twitter.com/oauth2/token');
		req.setMethod('POST');

		//Add Auth Header
		String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
		req.setHeader('Authorization', authorizationHeader);

		//You need to add this to the request - proved easy to miss in instructions...
		req.setBody('grant_type=client_credentials');

		//Make request
		Http http = new Http();
		HTTPResponse res = http.send(req);
		String stoken;
		//Parse JSON for Bearer Token
		JSONParser parser = JSON.createParser(res.getBody());
		while (parser.nextToken() != null) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'access_token'){
				parser.nextToken();
				stoken = parser.getText();
			}
		}
		//Return Token so it can be used in next call
		System.debug(stoken);
		return stoken;
	}


}