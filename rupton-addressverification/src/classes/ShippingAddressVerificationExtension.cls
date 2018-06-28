public with sharing class ShippingAddressVerificationExtension {
 private Account account;
    private VerifiedAddressDto verifiedAddressValues {get; set;}
    private VerifiedAddressDto.SesameVerificationResults vresults{get; set;}
    public String verificationStatus{get; set;}
    public Integer verificationScore{get; set;}
    public Integer verificationPostProc{get; set;}
    public String shippingStreet{get; set;}
    public String shippingCity{get; set;}
    public String shippingState{get; set;}
    public String postalCode{get; set;}
    public String shippingCountry{get; set;}
    private SesameQuery sesameQuery{get; set;}
    
    public ShippingAddressVerificationExtension(ApexPages.StandardController controller){
        account = (Account)controller.getRecord();
        getVerifiedAddress();
    }
    
    private void getVerifiedAddress(){
    	if( account.shippingCountry == null){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You must provide a valid country'));
    	}
    	try{
    		String queryString = account.shippingStreet + ' ' + account.shippingCity + ' ' + account.shippingState + ' ' + account.shippingPostalCode +
    			' ' + account.shippingCountry;
    		sesameQuery = new SesameQuery();
    		System.debug('***** Outgoing query: ' + queryString );
    		verifiedAddressValues = sesameQuery.query(queryString);
    		vresults = verifiedAddressValues.results[0];
   			String[] matches = sesameQuery.matchResults();
   			verificationStatus = matches[0].substring(0,1);
   			verificationPostProc = Integer.valueOf(matches[0].substring(1,2));
			verificationScore = Integer.valueOf(matches[3]);
   			//set verification message for page
   			if(verificationStatus.equalsIgnoreCase('v')){
   				if(verificationScore < 100){
   					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Address was fully matched but might have incorrect values. Check fields highlighted in red '));
   				}else{
   				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Address was fully verified and was ' + verificationScore +'% matched'));
   				}
   			}else if(verificationStatus.equalsIgnoreCase('u')){
   				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Address could not be found. Check fields highlighted in red'));
   			}else{
   				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Address was not fully verified. Check fields highlighted in red'));
   			}

   			//assign cleansed form values
   			shippingStreet = vresults.deliveryAddress;
   			shippingCity = vresults.locality;
   			shippingState = vresults.administrativeArea;
   			shippingCountry = vresults.iso3166_2;
   			postalCode = vresults.postalCode;
   			shippingCountry = vresults.countryName;
    	}catch(SesameQuery.QueryException e){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The following exception occured' + e.getMessage()));
    	}
    }
    
    public PageReference cleanse(){
    	createRecoveryData();
    	account.shippingCity = shippingCity;
    	account.shippingStreet = shippingStreet;
    	account.shippingState = shippingState;
    	account.shippingPostalCode = postalCode;
    	account.shippingCountry = shippingCountry;
    	account.shipping_Address_Cleansed_Date__c = Date.today();
    	account.shipping_Address_Cleansing_Score__c = String.valueOf(verificationScore);
    	try{
    		update account;
    	}catch(Exception e){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The following exception occured' + e.getMessage()));
    	}
    	//return to account detail view
    	return new ApexPages.StandardController(account).view();
    }
    
    private void createRecoveryData(){
    	RJAccountVerificationHistory__c recover = new RJAccountVerificationHistory__c();
    	recover.Account__c = account.Id;
    	recover.shippingCity__c = account.shippingCity;
    	recover.shippingCountry__c = account.shippingCountry;
    	recover.shippingPostalCode__c = account.shippingPostalCode;
    	recover.shippingState__c = account.shippingState;
    	recover.shippingStreet__c = account.shippingStreet;
    	
    	upsert recover;
    }
}