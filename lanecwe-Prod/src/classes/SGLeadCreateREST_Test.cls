@isTest (SeeAllData = true)
private class SGLeadCreateREST_Test {
    static testMethod void SGLeadCreateREST_Test() {

        SGLeadRequest ldReqData 			 = new SGLeadRequest();
        list<SGLeadRequest.Products> Products2 	 = new list<SGLeadRequest.Products>();
		for (Integer i = 0; i < 4; i++) {
            SGLeadRequest.Products Products1 	 = new SGLeadRequest.Products();
            Products1.EnterpriseName             = 'SMB_PayAsYouGo';
            Products1.Quantity                   = 0;
            Products1.Contractterm               = 1;
            Products1.StartDate                  = '2014-11-11';
            Products1.EndDate                    = '2014-11-11';
            Products1.ProductName                = 'Automated Conferencing';
            Products1.UnitPrice                  =  00.10;       
            Products1.BillingFrequency           = 'Monthly';
            Products1.Mincommitment              = 'true';
            if( I == 1)
               Products1.UnitType                   = 'Licenses';
            else if(I==2){ 
               Products1.UnitType                   = 'Minutes';
               Products1.mincmmtamount              = 20.833333333333;       
            }
            else if(I==3){ 
               Products1.UnitType                   = 'Minutes';
               Products1.Mincommitment              = 'false';
            }
            else if(I==4){ 
               Products1.UnitType                   = 'Event';
            }
            
            Products2.add(Products1);
        }    
        ldReqData.LeadID                        = null;
        ldReqData.SlesgatewayID                 = '2512';
        ldReqData.Company                       = 'Test Venkat';
        ldReqData.Source                        = 'Salesgateway';
        ldReqData.CustomerFirstName             = 'Venkat';
        ldReqData.CustomerLastName              = 'Valluru';
        ldReqData.RepFirstName                  = 'Venkata';
        ldReqData.RepLastName                   = 'Valluru';
        ldReqData.Phone                         = '7176861470';   
        ldReqData.Email                         = 'venkata.valluru@pgi.com';
        ldReqData.Street                        = '6640 akers mill rd';
        ldReqData.City                          = 'Atlanta';
        ldReqData.State                         = 'GA';
        ldReqData.PostalCode                    = '30339';
        ldReqData.Country                       = 'USA';
        ldReqData.ContractURL                   = 'https://test.com';
        ldReqData.BusinessType                  = 2;
        ldReqData.ProductsOfInterest 			=Products2;
        
        
        String JsonMsg = JSON.serialize(ldReqData);
        
        Test.startTest();
        RestRequest req 	= new RestRequest();
        RestResponse res 	= new RestResponse();
        req.requestURI 		= '/services/apexrest/SGLeadCreate';
        req.httpMethod 		= 'POST';
        req.requestBody 	= Blob.valueof(JsonMsg);
        
        RestContext.request = req;
        RestContext.response= res;
        
        SGLeadCreateREST.SGLeadCreate();
        Test.stopTest();
    }
}