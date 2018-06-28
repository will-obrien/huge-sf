public class AddressVerificationExtension{
    
    private Account account;
    private VerifiedAddressDto verifiedAddressValues {get; set;}
    private VerifiedAddressDto.SesameVerificationResults vresults{get; set;}
    public String verificationStatus{get; set;}
    public Integer verificationScore{get; set;}
<<<<<<< HEAD
    public Integer verificationPostProc{get; set;}
=======
>>>>>>> d3b4d709658d165871e7e61cdc644bc790d7c96f
    public String billingStreet{get; set;}
    public String billingCity{get; set;}
    public String billingState{get; set;}
    public String postalCode{get; set;}
    public String billingCountry{get; set;}
    private SesameQuery sesameQuery{get; set;}
<<<<<<< HEAD
    
=======
>>>>>>> d3b4d709658d165871e7e61cdc644bc790d7c96f
    public AddressVerificationExtension(ApexPages.StandardController controller){
        account = (Account)controller.getRecord();
        getVerifiedAddress();
    }
    
    private void getVerifiedAddress(){
    	if( account.BillingCountry == null){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You must provide a valid country'));
    	}
    	try{
    		String queryString = account.BillingStreet + ' ' + account.BillingCity + ' ' + account.BillingState + ' ' + account.BillingPostalCode +
    			' ' + account.BillingCountry;
    		sesameQuery = new SesameQuery();
<<<<<<< HEAD
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
   			billingStreet = vresults.deliveryAddress;
=======
    		verifiedAddressValues = sesameQuery.query(queryString);
    		System.debug('***** Outgoing query: ' + queryString );
   			vresults = verifiedAddressValues.results[0];
   			String[] matches = sesameQuery.matchResults();
   			verificationStatus = matches[0].substring(0,1);
			verificationScore = Integer.valueOf(matches[3]);
   			//set verification message for page
   			if(verificationStatus.equalsIgnoreCase('v')){
   				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Address was fully verified and was ' + verificationScore +'% matched'));
   			}else if(verificationStatus.equalsIgnoreCase('u')){
   				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Address could not be found'));
   			}else{
   				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Address was not fully verified and was ' + verificationScore +'% matched'));
   			}

   			//assign cleansed form values
   			billingStreet = vresults.address1;
>>>>>>> d3b4d709658d165871e7e61cdc644bc790d7c96f
   			billingCity = vresults.locality;
   			billingState = vresults.administrativeArea;
   			billingCountry = vresults.iso3166_2;
   			postalCode = vresults.postalCode;
   			billingCountry = vresults.countryName;
<<<<<<< HEAD
=======
   			System.debug('***** verificationStatus ' + verificationStatus);
>>>>>>> d3b4d709658d165871e7e61cdc644bc790d7c96f
    	}catch(SesameQuery.QueryException e){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The following exception occured' + e.getMessage()));
    	}
    }
    
    public PageReference cleanse(){
    	createRecoveryData();
    	account.BillingCity = billingCity;
    	account.BillingStreet = billingStreet;
    	account.BillingState = billingState;
    	account.BillingPostalCode = postalCode;
    	account.BillingCountry = billingCountry;
    	account.Billing_Address_Cleansed_Date__c = Date.today();
    	account.Billing_Address_Cleansing_Score__c = String.valueOf(verificationScore);
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
    	recover.BillingCity__c = account.BillingCity;
    	recover.BillingCountry__c = account.BillingCountry;
    	recover.BillingPostalCode__c = account.BillingPostalCode;
    	recover.BillingState__c = account.BillingState;
    	recover.BillingStreet__c = account.BillingStreet;
    	
    	upsert recover;
    }
}