global class BarChartManager implements Database.Batchable<sObject>, Database.AllowsCallouts{

	global final String Query;
	global final set<Id> AccountIds;
	global final String action;

    global BarChartManager(set<Id> accountIds,String action){
    	this.AccountIds = accountIds;
    	this.action = action;
    	this.Query = 'SELECT id,FirstName,LastName,PersonEmail,Phone,BillingStreet,BillingCity,BillingPostalCode,BillingCountry,Charting_BARCHARTS_Password__pc,Charting_BARCHARTS_Username__pc,Barchart_Location__c,PB_Client_UCS_Options__c FROM Account WHERE Id IN :accountIds';
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
    	return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC,List<Account> accounts){
    	try{
	    	for(Account account : accounts){
				if(this.action == 'Subscribe'){
	      			
	      			integer counter = 0;
	      			String username = BarChartManager.generateUsername();
	      			while(!BarChartManager.checkUserName(username) && counter < 8){
	      				counter++;
	      				username = BarChartManager.generateUsername();
	      			}
	      			
	      			//String password = BarChartManager.generatePassword();
	      			String password = 'mt1_bar3';
	      			
	      			String result = BarChartManager.subscribe(account, username, password);
	      			
	      			JSONParser parser = JSON.createParser(result);
			        String statusCode;
			        while (parser.nextToken() != null) {
			            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status_code')) {
			                parser.nextToken();
			                statusCode = parser.getText();
			            }
			        }

			        if(statusCode == '200'){
			        	account.Charting_BARCHARTS_Username__pc = username;
			        	account.Charting_BARCHARTS_Password__pc = password;
			        }
	
	      		}else if(this.action == 'Cancel'){
	      			
	      			String result = BarChartManager.cancel(account);
	      			
	      			JSONParser parser = JSON.createParser(result);
			        String statusCode;
			        while (parser.nextToken() != null) {
			            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'status_code')) {
			                parser.nextToken();
			                statusCode = parser.getText();
			            }
			        }

			        if(statusCode == '200'){
			        	account.Charting_BARCHARTS_Username__pc = null;
			        	account.Charting_BARCHARTS_Password__pc = null;
			        }

	      		}
	      	}  
	      	    
      		Database.update(accounts);
      		
    	}catch(Exception ex){
    		Logger logger = new Logger();
    		logger.log(ex.getMessage());
    		logger.log(ex.getStackTraceString());
    		logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});
    	}
    }

   global void finish(Database.BatchableContext BC){

   }
   
   @TestVisible private static String generatePassword(){
   		Integer len = 8;
	    String password;
	    while(password == null || password.isNumeric()){
	      Blob blobKey = crypto.generateAesKey(128);
	      String key = EncodingUtil.convertToHex(blobKey);
	      password = key.substring(0,len);
	    }
	    System.debug('************ '+password);
	    return password;
   	}
   	
   	@TestVisible private static String generateUsername(){
   		list<String> availableCharacters = new list<String>{'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','1','2','3','4','5','6','7','8','9','0'};
   		
   		String username = '';
   		while(username.length() < 4){
   			Integer rand = Math.round(Math.random()*35);
   			String character = availableCharacters[rand];
   			username += character;
   		}
   		return 'test' + username;
   	}
   	
   	@TestVisible private static boolean checkUserName(String username) {
   		String url = 'https://www.barchart.com/register/realtime/api/1.1/?ID=MTI&master_password=0735c85f&action=checkavailability&username=' + username;
   		Http h = new Http();
	
	    HttpRequest req = new HttpRequest();
	    req.setEndpoint(url);
	    req.setMethod('GET');
	    
	    HttpResponse res = h.send(req);
	    JSONParser parser = JSON.createParser(res.getBody());
        boolean userNameAvailable = false; 
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'available')) {
                parser.nextToken();
                userNameAvailable = parser.getBooleanValue();
            }
        }
	    return userNameAvailable;
   	}
   	
   	@TestVisible private static String subscribe(Account account,String username,String password){

   		String url = 'https://www.barchart.com/register/realtime/api/1.1/?ID=MTI&master_password=0735c85f&action=subscribe';
   		url += '&username=' + EncodingUtil.urlEncode(username,'UTF-8');
   		url += '&password=' + EncodingUtil.urlEncode(password,'UTF-8');
   		url += '&email=' + EncodingUtil.urlEncode(account.PersonEmail,'UTF-8');
   		url += '&fname=' + EncodingUtil.urlEncode(account.FirstName,'UTF-8');
   		url += '&lname=' + EncodingUtil.urlEncode(account.LastName,'UTF-8');
   		url += '&phone=' + EncodingUtil.urlEncode(account.Phone,'UTF-8');
   		
   		url += '&address1=' + EncodingUtil.urlEncode(account.BillingStreet,'UTF-8');
   		url += '&city=' + EncodingUtil.urlEncode(account.BillingCity,'UTF-8');
   		url += '&state=' + EncodingUtil.urlEncode(account.Barchart_Location__c,'UTF-8');
   		url += '&zip=' + EncodingUtil.urlEncode(account.BillingPostalCode,'UTF-8');
   		
   		url += '&service=LEVEL_DATA_100';
   		url += '&billing=immediate';

	    Http h = new Http();
	
	    HttpRequest req = new HttpRequest();
	    req.setEndpoint(url);
	    req.setMethod('GET');
	
	    HttpResponse res = h.send(req);
	
        return res.getBody();

   	}
   	
   	@TestVisible private static String cancel(Account account){
   	
   		String url = 'https://www.barchart.com/register/realtime/api/1.1/?ID=MTI&master_password=0735c85f&action=cancel';
   		url += '&username=' + EncodingUtil.urlEncode(account.Charting_BARCHARTS_Username__pc,'UTF-8');
   		
   		Http h = new Http();
	
	    HttpRequest req = new HttpRequest();
	    req.setEndpoint(url);
	    req.setMethod('GET');
	
	    HttpResponse res = h.send(req);
	
        return res.getBody();

   	}
   	
   	public static boolean validateSubscriptionRequest(Account account){
   		boolean valid = true;
   		String error = '';
   		if(account.PersonEmail == null){
   			error += 'Account must have an Email in order to subscripe to Ultimate Charting Software.';
   			valid = false;
   		}
   		
   		if(account.FirstName == null){
   			error += '<br/>';
   			error += 'Account must have a First Name in order to subscripe to Ultimate Charting Software.';
   			valid = false;
   		}
   		
   		if(account.Phone == null){
   			error += '<br/>';
   			error += 'Account must have a Phone in order to subscripe to Ultimate Charting Software.';
   			valid = false;
   		}
   		
   		if(account.BillingStreet == null){
   			error += '<br/>';
   			error += 'Account must have a Billing Address in order to subscripe to Ultimate Charting Software.';
   			valid = false;
   		}
   		
   		if(account.BillingCity == null){
   			error += '<br/>';
   			error += 'Account must have a Billing City in order to subscripe to Ultimate Charting Software.';
   			valid = false;
   		}
   		
   		if(account.Barchart_Location__c == null){
   			error += '<br/>';
   			error += 'Account must have a Barchart Location in order to subscripe to Ultimate Charting Software.';
   			valid = false;
   		}
   		
   		if(account.BillingPostalCode == null){
   			error += '<br/>';
   			error += 'Account must have a Billing Zip in order to subscripe to Ultimate Charting Software.';
   			valid = false;
   		}
   		
   		if(valid == false){
   			account.addError(error,false);
   		}
   		
   		return valid;
   	}


}