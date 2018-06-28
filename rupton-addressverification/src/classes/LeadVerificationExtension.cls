public class LeadVerificationExtension{
    
    private Lead lead;
    private VerifiedAddressDto verifiedAddressValues {get; set;}
    private VerifiedAddressDto.SesameVerificationResults vresults{get; set;}
    public String verificationStatus{get; set;}
    public Integer verificationScore{get; set;}
    public Integer verificationPostProc{get; set;}
    public String street{get; set;}
    public String city{get; set;}
    public String state{get; set;}
    public String postalCode{get; set;}
    public String country{get; set;}
    private SesameQuery sesameQuery{get; set;}
    
    public LeadVerificationExtension(ApexPages.StandardController controller){
        lead = (Lead)controller.getRecord();
        getVerifiedAddress();
    }
    
    private void getVerifiedAddress(){
    	if( lead.Country == null){ 
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You must provide a valid country'));
    	}
    	try{
    		String queryString = lead.Street + ' ' + lead.City + ' ' + lead.State + ' ' + lead.PostalCode +
    			' ' + lead.Country;
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
   			street = vresults.deliveryAddress;
   			city = vresults.locality;
   			state = vresults.administrativeArea;
   			postalCode = vresults.postalCode;
   			country = vresults.countryName;
    	}catch(SesameQuery.QueryException e){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The following exception occured' + e.getMessage()));
    	}
    }
    
    public PageReference cleanse(){
    	//createRecoveryData();
    	lead.City = city;
    	lead.Street = street;
    	lead.State = state;
    	lead.PostalCode = postalCode;
    	lead.Country = country;
    	//lead.Address_Cleansed_Date__c = Date.today();
    	//lead.Address_Cleansing_Score__c = String.valueOf(verificationScore);
    	try{
    		update lead;
    	}catch(Exception e){
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The following exception occured' + e.getMessage()));
    	}
    	//return to account detail view
    	return new ApexPages.StandardController(lead).view();
    }
    
    /*private void createRecoveryData(){
    	RJAccountVerificationHistory__c recover = new RJAccountVerificationHistory__c();
    	recover.Account__c = account.Id;
    	recover.BillingCity__c = account.BillingCity;
    	recover.BillingCountry__c = account.BillingCountry;
    	recover.BillingPostalCode__c = account.BillingPostalCode;
    	recover.BillingState__c = account.BillingState;
    	recover.BillingStreet__c = account.BillingStreet;
    	
    	upsert recover;
    }*/
}