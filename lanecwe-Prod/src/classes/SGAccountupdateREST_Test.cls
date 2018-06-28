@isTest (SeeAllData = true)
private class SGAccountupdateREST_Test {
    static testMethod void SGAccountupdateREST_Test() {

        SGAccountUpdateRequest ldReqData 			 		= new SGAccountUpdateRequest();
        list<SGAccountUpdateRequest.Products> Products2 	= new list<SGAccountUpdateRequest.Products>();
        SGAccountUpdateRequest.Products Products1 	 		= new SGAccountUpdateRequest.Products();
        Products1.EnterpriseName             	            = 'SMB_PayAsYouGo';
        Products1.Quantity                   	            = 0;
        Products1.Contractterm               	            = 1;
        Products1.StartDate                  	            = '2014-11-11';
        Products1.EndDate                    	            = '2014-11-11';
        Products1.ProductName                	            = 'Automated Conferencing';
        Products1.UnitPrice                  	            =  00.10;       
        Products1.BillingFrequency           	            = 'Monthly';
        Products1.Mincommitment              	            = 'true';
        Products1.UnitType                   	            = 'minutes';
        Products1.mincmmtamount              	            = 20.833333333333;       
        Products2.add(Products1);

        SGAccountUpdateRequest.Products Products3 	 		= new SGAccountUpdateRequest.Products();
        Products3.EnterpriseName             	            = 'SMB_PayAsYouGo';
        Products3.Quantity                   	            = 0;
        Products3.Contractterm               	            = 1;
        Products3.StartDate                  	            = '2014-11-11';
        Products3.EndDate                    	            = '2014-11-11';
        Products3.ProductName                	            = 'Automated Conferencing';
        Products3.UnitPrice                  	            =  00.10;       
        Products3.BillingFrequency           	            = 'Monthly';
        Products3.Mincommitment              	            = 'true';
        Products3.UnitType                   	            = 'licenses';
        Products3.mincmmtamount              	            = 20.833333333333;       
        Products2.add(Products3);

        
        Account accttest = PGITestUtilities.getAccountDetails();
		//accttest.z_source__c	= 'Salesgateway';
        insert accttest;
        
        Opportunity opptytest = PGITestUtilities.getOpportunityDetails();
        insert opptytest;
        
        Contact cntcttest = PGITestUtilities.getContactDetails(accttest.id);
		//cntcttest.z_source__c	= 'Salesgateway';
        insert cntcttest;

        conman_contract__c cntrcttest = new conman_contract__c(Account_Name__c		=	accttest.id
                                                              ,Opportunity__c 		= 	opptytest.id
                                                              ,Contract_Status__c	=	'Sent To Customer');
        insert cntrcttest;

        ldReqData.SFDCAccountID    				            = '1234';
        ldReqData.opportunityId    				            = opptytest.id; 
        ldReqData.contractId    				            = null;
        //ldReqData.contractId    				            = cntrcttest.id;
        ldReqData.accountId    					            = accttest.id;
        ldReqData.contactId    					            = cntcttest.id;
        ldReqData.SlesgatewayID                             = '2512';
        ldReqData.Company                                   = 'Test Venkat';
        ldReqData.Source                                    = 'Salesgateway';
        ldReqData.CustomerFirstName                         = 'Venkat';
        ldReqData.CustomerLastName                          = 'Valluru';
        ldReqData.RepFirstName                              = 'Venkata';
        ldReqData.RepLastName                               = 'Valluru';
        ldReqData.Phone                                     = '7176861470';   
        ldReqData.Email                                     = 'venkata.valluru@pgi.com';
        ldReqData.Street                                    = '6640 akers mill rd';
        ldReqData.City                                      = 'Atlanta';
        ldReqData.State                                     = 'GA';
        ldReqData.PostalCode                                = '30339';
        ldReqData.Country                                   = 'USA';
        ldReqData.ContractURL                               = 'https://test.com';
        ldReqData.BusinessType                              = 2;
        ldReqData.ProductsOfInterest 			            =Products2;
        
        String JsonMsg = JSON.serialize(ldReqData);
        
        Test.startTest();
        RestRequest req 	= new RestRequest();
        RestResponse res 	= new RestResponse();
        req.requestURI 		= '/services/apexrest/SGAccountUpdate';
        req.httpMethod 		= 'POST';
        req.requestBody 	= Blob.valueof(JsonMsg);
        
        RestContext.request = req;
        RestContext.response= res;
        
        SGAccountupdateREST.SGAccountupdate();
        
        Test.stopTest();
    }

}