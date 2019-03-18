@isTest (SeeAllData = true)
private class SGLeadOpptyGetREST_Test {
    static testMethod void SGLeadOpptyGetRESTLead_Test() {
        Test.startTest();
		

        Lead leadtest = PGITestUtilities.getLeadDetails();
		insert leadtest;
        
        Account accttest = PGITestUtilities.getAccountDetails();
		insert accttest;
        
        Opportunity opptytest = PGITestUtilities.getOpportunityDetails();
        opptytest.AccountId =accttest.id; 
        insert opptytest;
        
        Contact cntcttest = PGITestUtilities.getContactDetails(accttest.id);
        insert cntcttest;
            
        RestRequest req 	= new RestRequest();
        RestResponse res 	= new RestResponse();
        req.httpMethod 		= 'POST';
        For(integer i =0;i<6;i++){
        If(I==1){
           req.requestURI 	= '/services/apexrest/SGLeadOpptyGetREST/'+leadtest.id;
           RestContext.request = req;
           RestContext.response= res;
           SGLeadOpptyGetREST.SGLeadOpptyGet();
        }else If(I==2){
           req.requestURI 	= '/services/apexrest/SGLeadOpptyGetREST/'+opptytest.id;
           RestContext.request = req;
           RestContext.response= res;
           SGLeadOpptyGetREST.SGLeadOpptyGet();
        }else  If(I==3){
           req.requestURI 	= '/services/apexrest/SGLeadOpptyGetREST/00q19120002Sec7';
           RestContext.request = req;
           RestContext.response= res;
           SGLeadOpptyGetREST.SGLeadOpptyGet();
        }else  If(I==4){
           //try{
           req.requestURI 	= '/services/apexrest/SGLeadOpptyGetREST/0061ss0sub2Sec7';
           RestContext.request = req;
           RestContext.response= res;
           SGLeadOpptyGetREST.SGLeadOpptyGet();
           //} catch(exception e){}    
        }else  If(I==5){
           req.requestURI 	= '/services/apexrest/SGLeadOpptyGetREST/00813400002Sec7';
           RestContext.request = req;
           RestContext.response= res;
           SGLeadOpptyGetREST.SGLeadOpptyGet();
    	}
    }
        Test.stopTest();
    }
}