/**** This class is REST API used by sales gateway to update contract reject status in SFDC.
Salesgateway scenario: This API gets executed when cutomer rejects the contract
****/
@RestResource(urlMapping='/SGContractReject/*')
global with sharing class SGContractRejectREST {
    @HttpPost
    global static String SGContractReject(){
        Logs__c logerror 				= new Logs__c();
        string Response;
        try {
        /*** START recieving data from salesgateway and deserializing into local data class(SGRejectRequest) format. ***/
        SGRejectRequest SGReqdata =  (SGRejectRequest)JSON.deserialize(
                        RestContext.request.requestbody.tostring(),SGRejectRequest.class);

        logerror.Class_Name__c 			= 'SGContractRejectREST';    
	    logerror.Method_Name__c 		= 'SGContractReject';
        logerror.Object_Name__c 		= 'Opportunity';
        logerror.Record_ID__c			= SGReqData.opportunityId;
		logerror.Request__c				= string.valueOf(SGReqData);
        logerror.Z_Source__c			= 'Salesgateway';    
        logerror.Status__c				= 'Success';    
        logerror.Error_Message__c		= 'NA';
        logerror.Exception_Cause__c		= 'NA';
        logerror.Exception_Message__c	= 'NA';
        logerror.EndPoint_Url__c		= 'NA';
        logerror.Exception_Type__c		= 'NA';
        
        /*** Update Opportunity ***/ 
        Opportunity UpdateOppty 			= [select Opp_Stage__c,Prob_Input__c from Opportunity 
                                           		where Id = :SGReqdata.opportunityId];
        UpdateOppty.Prob_Input__c			= System.Label.Prob10;
        update UpdateOppty;
            
        /*** Update Contract ***/ 
        logerror.Object_Name__c 			= 'CONMAN_Contract__c';
        logerror.Record_ID__c				= SGReqData.contractId;
        CONMAN_Contract__c UpdateContrct 	= [select Contract_Status__c,Contract_URL__c from CONMAN_Contract__c
                                           		where Id = :SGReqdata.contractId];
		UpdateContrct.Contract_Status__c	= System.Label.Customer_Rejected;
        UpdateContrct.Contract_URL__c		= null;

        SGLeadCreateREST.sendemail = true;
        Update UpdateContrct;
        SGLeadCreateREST.sendemail = false;
 
        /*** Setting success response back to SG ***/ 
        Response 						= 'Status updated successfully';      
        logerror.Response__c			= response;
        Insert logerror;
        return Response;        
        }
        catch(Exception e){ 
        /*** Setting system error message back to SG ***/ 
            Response = e.getMessage();      
		    
            logerror.Status__c				= 'Failure';    
            logerror.Error_Message__c		= e.getMessage();
            logerror.Exception_Cause__c		= string.valueof(e.getcause());
            logerror.Exception_Message__c	= e.getStackTraceString();
            logerror.Response__c			= response;
	        logerror.Exception_Type__c		= e.getTypeName();
	        Insert logerror;
            
            return Response;        
        }
	}
}