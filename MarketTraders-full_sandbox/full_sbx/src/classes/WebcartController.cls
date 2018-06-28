//This is the controller that interacts with the Webcart page for the OAuth
public with sharing class WebcartController {
	public string valueToShow{get;set;}
	public string apiCallResults{get;set;}

	public WebcartController() {
		valueToShow = '';
		apiCallResults = '';
	}
 
	public PageReference doAPICall(){	
		apiCallResults = '';
		return apiTestCall();
		/*
		<?xml version="1.0" encoding="UTF-8"?>
		  <methodResponse>
		   <fault><value><struct>
		    <member><name>faultCode</name><value><i4>3</i4></value></member>
		    <member><name>faultString</name><value>[Unexpected]Unable to get saved search results</value></member>
		   </struct></value></fault>
		  </methodResponse>
		*/
	}

	//https://developer.infusionsoft.com/docs/read/Getting_Started_With_OAuth2
	public PageReference oAuthGo(){	
		PageReference pr = new PageReference('https://signin.infusionsoft.com/app/oauth/authorize' +
			'?client_id=' + WebcartHelper.getWebCartClientID(webcartHelper.INFUSIONSOFT) + 
			'&redirect_uri=' + WebcartHelper.getWebCartRedirectURI(webcartHelper.INFUSIONSOFT) +
			'&scope=full' +
			'&response_type=code');
		return pr;
	}

	public PageReference apiTestCall(){
		/*
		WebcartHelper.accessTokenItems ati = WebcartHelper.retrieveWebcartAccessToken(
          webcartHelper.getWebCartAuthorizationCode(webcartHelper.INFUSIONSOFT), webcartHelper.INFUSIONSOFT);
		if(ati.isError){
			valueToShow = ati.valueToShow;
			return null;
		}
		*/
      
   	   //The wbList will be the object that is iterated over in the batch job
   	   //string xmlBodyResponse = WebcartHelper.callWebCart(webcartHelper.INFUSIONSOFT, ati.accessToken, webcartHelper.TBL_PAYMENT);
   	   //ati.accessToken, 

   	   //These two lines will call the API to get the actual columns that can be retreived for a report
   	   //string xmlBodyResponse = WebcartHelper.callWebCart(webcartHelper.INFUSIONSOFT, webcartHelper.TBL_REPORT_COLUMNS, true);
   	   //apiCallResults = xmlBodyResponse;

   	   ///string xmlBodyResponse = WebcartHelper.callWebCart(webcartHelper.INFUSIONSOFT, webcartHelper.TBL_SAVED_PAYMENTS, true);
   	   string xmlBodyResponse = WebcartHelper.callWebCart(webcartHelper.INFUSIONSOFT, webcartHelper.TBL_SAVED_DECLINES, true, 0);
   	   
   	   //apiCallResults = showPaymentItemsFromMaps(xmlBodyResponse);
   	   WebcartHelper.checkforRefreshTokenSaveNeeded(webcartHelper.INFUSIONSOFT);
   	   apiCallResults = xmlBodyResponse;

   	   return null; //Action Result:<h1>Developer Inactive</h1> 'TODO: WHY DID I GET THIS?  I regenerated the Authorizaiton Code and then it worked'
	}

	@TestVisible
	private string showPaymentItemsFromMaps(string xmlBodyResponse){
		   list<WebcartHelper.webCartItemAction> piList = WebcartHelper.parseWebCartToList(xmlBodyResponse);
	   	   string tempStr = '';
	   	   integer i = 0;
	   	   for(WebcartHelper.webCartItemAction wbiPay : piList){
	   	   	 i += 1;
	   	   	 if(i <> 1){
	   	   	 	tempStr += '; ';
	   	   	 }
	   	   	 tempStr += 'Payment Number ' + i + ': ' + wbiPay.actionMap.keySet() + '; ' + wbiPay.actionMap.Values();
	   	   }
	   	   tempStr += '; Total Retrieved: ' + i;
	   	   return tempStr;
	}

	public PageReference startAction(){
		string authorizationCode = System.currentPageReference().getParameters().get('code'); //The Authorization Code is in the 'code' query string param
		if(authorizationCode == null || authorizationCode == ''){
			string errorDescription = System.currentPageReference().getParameters().get('error_description');
			if(string.isBlank(errorDescription) == false){
				valueToShow = 'Error Description: ' + errorDescription;
			}else{
				valueToShow = '<Press "Get Webcart Authorization Code" button - No Authorization Code Yet>';
			}
			
		}else{
			//We have the Authorization Code.  Try to get the Access Token
			
			if (Webcart__c.getInstance(webcartHelper.INFUSIONSOFT) != null) {	
				valueToShow = 'Authorization Code has been saved! It is: ' + authorizationCode;
			}else{
				valueToShow = 'Authorization Code could not be saved.  Please create a Webcart Custom Setting row with a name of: ' + webcartHelper.INFUSIONSOFT;
				return null;
			}
			//This line will get the Access token.   This must be called before the batch job call
			WebcartHelper.accessTokenItems ati = WebcartHelper.retrieveWebcartAccessToken(authorizationCode, webcartHelper.INFUSIONSOFT);

			valueToShow += '.  The new Access Token was also retrieved: ' + ati.accessToken;

			if (Webcart__c.getInstance(webcartHelper.INFUSIONSOFT) != null) {	
				Webcart__c wbItem = Webcart__c.getInstance(webcartHelper.INFUSIONSOFT);
				wbItem.Authorization_Code__c = authorizationCode;
				wbItem.Access_Token__c = ati.accessToken;
				wbItem.Refresh_Token__c = ati.refreshToken;
				wbItem.Expires_In__c = ati.expiresIn;
				update wbItem;
			}
			
			//string accessToken = retrieveWebcartAccessToken(authorizationCode, webcartHelper.INFUSIONSOFT);
			//if(string.isBlank(ati.accessToken) == false){ //Batch job Started! 
				//valueToShow = 'Authorization Code: ' + authorizationCode + '; Access Token: ' + ati.accessToken;
				//string xmlBodyResponse = WebcartHelper.callWebCart(webcartHelper.INFUSIONSOFT, accessToken, webcartHelper.TBL_PAYMENT);
				//valueToShow += '; Response Body: ' + xmlBodyResponse;

				//Now kick off batch job:
				//WebcartBatch b = new WebcartBatch(accessToken); 
				//database.executebatch(b, WebcartHelper.getWebCartBatchSize(WebcartHelper.INFUSIONSOFT));
			//}
		}
		return null;
	}

	
}