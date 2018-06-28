global class IE_IntegrationObjects {
	public static Integer SUBSCRIPTION_BATCH_SIZE = 10;
	public static Integer INDIVIDUAL_BATCH_SIZE = 10;
	public static Integer UNIT_BATCH_SIZE = 5;
	public static Integer ORGANIZATION_BATCH_SIZE = 10;
	
	global class IE_Error
	{
		webservice string ErrorCode{get;set;}
		webservice string ErrorMessage{get;set;}
		
		global IE_Error(String errCode, String errMsg)
		{
			ErrorCode = errCode;
			ErrorMessage = errMsg;
		}
	}
	
	global class IE_User 
	{
		webservice string FirstName{get;set;}
		webservice string MiddleName{get;set;}
		webservice string LastName{get;set;}
		webservice string Username{get;set;}
		webservice boolean Accessed{get;set;}
		webservice boolean Inactive{get;set;}
		webservice string EmailAddress{get;set;}
		webservice list<IE_Role> Roles{get;set;}
		webservice IE_Address Address{get;set;}
		webservice string CellPhone{get;set;}
		webservice string WorkPhone{get;set;}
		webservice string SFDCId{get;set;}
		webservice DateTime LastModifiedDate{get;set;}
		webservice string IEId{get;set;}
		webservice string OrganizationSFDCId{get;set;}
		webservice string OrganizationIEId{get;set;}
		webservice list<IE_Error> errors{get;set;}
		
	}
	
	global class IE_Address
	{
		webservice string Bulding{get;set;}
		webservice string AddressLine1{get;set;}
		webservice string AddressLine2{get;set;}
		webservice string AddressLine3{get;set;}
		webservice string AddressLine4{get;set;}
		webservice string City{get;set;}
		webservice string Country{get;set;}  
		webservice string StateCode{get;set;}
		webservice string ZipCode{get;set;}
		webservice string IEId{get;set;}
		webservice DateTime LastModifiedDate{get;set;}
		webservice string SFDCId{get;set;}
		webservice list<IE_Error> errors{get;set;}
		
	}
	 
	global class IE_Role
	{
		webservice string Type{get;set;}
		webservice string UnitSFDCId{get;set;}
		webservice string UnitIEId{get;set;}
		webservice string MasterAdmin{get;set;}
		webservice list<IE_Error> errors{get;set;}
	}
	
	global class IE_Unit
	{
		webservice string SerialNumber{get;set;}
		webservice string UnitTag{get;set;}
		webservice string SalesOrderNumber{get;set;}
		webservice string JobName{get;set;}
		webservice string MACAddress{get;set;}
		webservice string SIMCardICCID{get;set;}
		webservice string CodeStringFormat{get;set;}
		webservice list<string> CodeValues{get;set;}
		webservice boolean Commissioned{get;set;}
		webservice IE_Address UnitAddress{get;set;}
		webservice string IEId{get;set;}
		webservice DateTime LastModifiedDate {get;set;}
		webservice string SFDCId{get;set;}
		webservice list<IE_Error> errors{get;set;}
	}
	
	global class IE_Organization
	{
		webservice string OrganizationName{get;set;}
		webservice IE_Address Address{get;set;}
		webservice string PhoneNumber{get;set;}
		webservice string IEId{get;set;}
		webservice string SFDCId{get;set;}
		webservice DateTime LastModifiedDate{get;set;}
		webservice list<IE_Error> errors{get;set;}
	}
	
	
	global class IE_Subscription
	{
		webservice string Type{get;set;}
		webservice DateTime StartDate{get;set;}
		webservice DateTime EndDate{get;set;}
		webservice string BuyerID{get;set;}
		webservice string UnitSFDCId{get;set;}
		webservice string IEId{get;set;}
		webservice string SFDCId{get;set;}
		webservice DateTime LastModifiedDate{get;set;}
		webservice boolean Active{get;set;}
		webservice list<IE_Error> errors{get;set;}
	}
	
	//
	// Response Objects
	//
	global class IE_SubscriptionListResponse
	{
		webservice list<IE_Error> errors{get;set;}
		webservice list<IE_Subscription> Subscriptions{get;set;}
	}
	
	global class IE_UnitListResponse
	{
		webservice list<IE_Error> errors{get;set;}
		webservice list<IE_Unit> Units{get;set;}
	}
	
	global class IE_UserListResponse
	{
		webservice list<IE_Error> errors{get;set;}
		webservice list<IE_User> Individuals{get;set;}
	}
	
	global class IE_OrganizationListResponse
	{
		webservice list<IE_Error> errors{get;set;}
		webservice list<IE_Organization> Organizations{get;set;}
	}
	
	//
	//Request Objects
	//
	global class IE_SubscriptionList
	{
		webservice list<IE_Subscription> Subscriptions{get;set;}
	}
	
	global class IE_UnitList
	{
		webservice list<IE_Unit> Units{get;set;}
	}
	
	global class IE_UserList
	{
		webservice list<IE_User> Individuals{get;set;}
	}
	
	global class IE_OrganizationList
	{
		webservice list<IE_Organization> Organizations{get;set;}
	}
	
	global static HTTPResponse sendIeRequest(string ieService, string method, string jsonBody)
	{
		//pull the credentials from a custom setting 
		IE_Service_Configuration__c serviceConfig = IE_Service_Configuration__c.getInstance();
		
        //create a HTTP request and response
        HTTPRequest r = new HTTPRequest();
        r.setTimeOut(120000) ; // timeout in milliseconds - 2 minutes
        //set the endpoint
        string endpointurl=serviceConfig.endpoint__c+ieService;//'/Individuals';//'http://daikin-iep-test-service.cloudapp.net/UnitService.svc/IndividualsTest';.
        r.setEndpoint(endpointurl);
        
        
        //use basic http authentication
        Blob headerValue = Blob.valueOf(serviceConfig.username__c +':' +serviceConfig.password__c);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        
        //set the auth header 
        r.setHeader('Authorization', authorizationHeader);
        
        //POST is for creating new records
        r.setMethod(method);
        r.setHeader('Content-Type', 'application/json');
        
        
        system.debug('Encoder Value' + EncodingUtil.base64Encode(headerValue));
        
        //add the individuals to the body
        r.setBody(jsonBody);
        
        
        //Attempt to call the service
        HTTP auth = new HTTP();
        HTTPResponse resp = null;
        if(!Test.isRunningTest())
        {
    		resp = auth.send(r);
        }
    	
    	return resp;
        
        
	}
	
	public static Boolean isValidSalesforceId(String s) {
		Id validId;
		try {
			validId = s;
			return true;
		} catch (Exception ex) {
			return false;
		}
	}
}