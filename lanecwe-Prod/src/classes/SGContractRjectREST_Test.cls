@isTest (SeeAllData = true)
private class SGContractRjectREST_Test {
    static testMethod void SGContractRjectREST_Test() {

        SGRejectRequest 		ldReqData 			 		= new SGRejectRequest();
        
        Account accttest = PGITestUtilities.getAccountDetails();
		insert accttest;
        
        Opportunity opptytest = PGITestUtilities.getOpportunityDetails();
        opptytest.AccountId = accttest.id;
        insert opptytest;
        
        Contact cntcttest = PGITestUtilities.getContactDetails(accttest.id);
        insert cntcttest;

        conman_contract__c cntrcttest = new conman_contract__c(Account_Name__c		=	accttest.id
                                                              ,Opportunity__c 		= 	opptytest.id);
        insert cntrcttest; 

        ldReqData.opportunityId    				            = opptytest.id; 
        ldReqData.contractId    				            = cntrcttest.id;
        ldReqData.accountId    					            = accttest.id;
        ldReqData.SlesgatewayID                             = '2512';
        ldReqData.SFDCAccountID    				            = '1234';
        ldReqData.ContractStatus							= 'Customer Rejected';
        
        String JsonMsg = JSON.serialize(ldReqData);
        
        Test.startTest();
        RestRequest req 	= new RestRequest();
        RestResponse res 	= new RestResponse();
        req.requestURI 		= '/services/apexrest/SGContractReject';
        req.httpMethod 		= 'POST';
    	//positive testing
        req.requestBody 	= Blob.valueof(JsonMsg);
        
        RestContext.request = req;
        RestContext.response= res;
        
        SGContractRejectREST.SGContractReject();

        //negative testing
        ldReqData.contractId = null;
        String JsonMsg1 = JSON.serialize(ldReqData);

        req.requestBody 	= Blob.valueof(JsonMsg1);
        
        RestContext.request = req;
        RestContext.response= res;
        
        SGContractRejectREST.SGContractReject();

        Test.stopTest();
    }
}