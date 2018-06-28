/**** This class is REST API used by sales gateway to retrieve data for existing lead and opportunity .
Salesgateway scenario: This API gets executed when rep enters lead or oppportunity id.
****/
@RestResource(urlMapping='/SGLeadOpptyGet/*')
Global class SGLeadOpptyGetREST {
    @HttpGet
    global static String SGLeadOpptyGet(){
        Logs__c LogAudit 						= new Logs__c();
        SGLedOpptyGetResponse successresponse 	= new SGLedOpptyGetResponse();
        string ErrorResponse;
        try {
        /*** Retrieving lead or opportunity Id from URI ***/
        RestRequest req 						= RestContext.request;
        String leadopptyId 						= req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        /*** setting default values to logs object ***/
        LogAudit.Class_Name__c 					= 'SGLeadOpptyGetREST';    
        LogAudit.Method_Name__c 				= 'SGLeadOpptyGet';
		LogAudit.Request__c						= string.valueOf(req);
        LogAudit.Z_Source__c					= 'Salesgateway';    
        LogAudit.Status__c						= 'Success';    
        LogAudit.Record_ID__c					= leadopptyId;
	    LogAudit.Object_Name__c 				= 'NA';
        LogAudit.Error_Message__c				= 'NA';
        LogAudit.Exception_Cause__c				= 'NA';
        LogAudit.Exception_Message__c			= 'NA';
        LogAudit.EndPoint_Url__c				= 'NA';
        LogAudit.Exception_Type__c				= 'NA';
        /*** checking Id from SG is LeadId or opportunityId ***/ 
        If(leadopptyId.substring(0,3) == '00Q'){
           LogAudit.Object_Name__c 				= 'Lead';
	       ErrorResponse						= 'No Matches found for the LeadId';
		   Lead leaddata 						= [Select firstname,lastname,company,phone,email,street,city,state,postalcode,country,ownerId
                                  	   				from Lead where Id =: leadopptyId];
           LogAudit.Object_Name__c 				= 'User';
	       ErrorResponse						= 'Rep is not present in salesforce';
           User userdata       					= [select firstname,lastname from user where Id =:leaddata.ownerId];
           successresponse.LeadID 				= leadopptyId;
           successresponse.CustomerFirstName 	= leaddata.firstname;
           successresponse.CustomerLastName 	= leaddata.lastname;
           successresponse.Company 				= leaddata.Company;
           successresponse.Phone 				= leaddata.Phone;
           successresponse.Email 				= leaddata.Email;
           successresponse.Street 				= leaddata.Street;
           successresponse.City 				= leaddata.City;
           successresponse.State 				= leaddata.State;
           successresponse.PostalCode 			= leaddata.PostalCode;
           successresponse.Country 				= leaddata.Country;
           successresponse.RepFirstName 		= userdata.firstname;
           successresponse.RepLastName 			= userdata.lastname;
	       LogAudit.Response__c					= json.serialize(successresponse);
           
           LogAudit.Object_Name__c 				= 'Logs__c';
	       ErrorResponse						= 'Insert failed for Logs__c';
           Insert LogAudit;
           return json.serialize(successresponse);
        }else If(leadopptyId.substring(0,3) == '006'){
	       LogAudit.Object_Name__c 				= 'Opportunity';
	       ErrorResponse						= 'No Matches found for the OpportunityId';
           Opportunity Opptydata 				= [Select AccountId,ownerId,Account.name,Account.SFDC_Account_ID__c 
                                                   from Opportunity where Id =: leadopptyId];
           try{
           	CONMAN_Contract__c contractdata		= [select id from CONMAN_Contract__c where Opportunity__c = :leadopptyId ];
            successresponse.contractId 			= contractdata.Id;
           }catch(queryexception e){
           /*** no action required aswe don't pass contract id back ***/    
           }

           LogAudit.Object_Name__c 				= 'Contact';
	       ErrorResponse						= 'No contacts found for this opportunity';
           Contact customertdata				= [Select Id,firstname,lastname,phone,email,mailingstreet,mailingcity,mailingstate,
                                                   mailingpostalcode,mailingcountry from Contact where AccountId = :Opptydata.AccountId];
           LogAudit.Object_Name__c 				= 'User';
	       ErrorResponse						= 'Rep is not present in salesforce';
           User userdata       					= [select firstname,lastname from user where Id =:Opptydata.ownerId];
           successresponse.opportunityId 		= leadopptyId;
           successresponse.accountId 			= Opptydata.AccountId;
           successresponse.contactId 			= customertdata.Id;
           successresponse.SFDCAccountID 		= Opptydata.Account.SFDC_Account_ID__c;
           successresponse.CustomerFirstName 	= customertdata.firstname;
           successresponse.CustomerLastName 	= customertdata.lastname;
           successresponse.Phone 				= customertdata.Phone;
           successresponse.Email 				= customertdata.Email;
           successresponse.Street 				= customertdata.mailingStreet;
           successresponse.City 				= customertdata.mailingCity;
           successresponse.State 				= customertdata.mailingState;
           successresponse.PostalCode 			= customertdata.mailingPostalCode;
           successresponse.Country 				= customertdata.mailingCountry;
           successresponse.Company 				= Opptydata.Account.name;
           successresponse.RepFirstName 		= userdata.firstname;
           successresponse.RepLastName 			= userdata.lastname;
	       LogAudit.Response__c					= json.serialize(successresponse);
           LogAudit.Object_Name__c 				= 'Logs__c';
	       ErrorResponse						= 'Insert failed for Logs__c';
	       Insert LogAudit;
           return json.serialize(successresponse);
        }else{
          ErrorResponse 						= 'Invalid ID is passed from SG';
          LogAudit.Status__c					= 'Failure';    
	      LogAudit.Response__c					= ErrorResponse;
	      Insert LogAudit;
          return ErrorResponse;        
        }   
        }
        catch(QueryException e){ 
        /*** Setting query error message back to SG ***/ 
            LogAudit.Status__c					= 'Failure';    
            LogAudit.Error_Message__c			= e.getMessage();
            LogAudit.Exception_Cause__c			= string.valueof(e.getcause());
            LogAudit.Exception_Message__c		= e.getStackTraceString();
            LogAudit.Response__c				= ErrorResponse;
	        LogAudit.Exception_Type__c			= e.getTypeName();
	        Insert LogAudit;
            return ErrorResponse;        
        }
        catch(Exception e){ 
        /*** Setting system error message back to SG ***/ 
            ErrorResponse = e.getMessage();      
            LogAudit.Status__c					= 'Failure';    
            LogAudit.Error_Message__c			= e.getMessage();
            LogAudit.Exception_Cause__c			= string.valueof(e.getcause());
            LogAudit.Exception_Message__c		= e.getStackTraceString();
            LogAudit.Response__c				= ErrorResponse;
	        LogAudit.Exception_Type__c			= e.getTypeName();
	        Insert LogAudit;
            return ErrorResponse;        
        }
	}
}