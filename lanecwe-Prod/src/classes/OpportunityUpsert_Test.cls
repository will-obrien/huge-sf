@isTest 
private class OpportunityUpsert_Test {
    static testMethod void testOpportunityUpsert() {
        //User u2 = [SELECT Id FROM User WHERE Alias='vvall'];
        //User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];   
        //System.RunAs(u2){  
            Test.startTest();
            try{
                Account act = new account(Name = 'Test Acc', Ecommerce_account_number__c = 'Ecomm-0001', Z_Source__c = 'eCommerce');
                insert act;
                System.assert(act.id <> null);
                
                OpportunityUpsert.OpportunityRequest opporUpsertReq = new OpportunityUpsert.OpportunityRequest();
                opporUpsertReq.opportunityStage = 'Open';
                opporUpsertReq.opportunityName = 'Test Acc';
                opporUpsertReq.accountId = act.id;
                opporUpsertReq.type = 'SBS';
                opporUpsertReq.closeDate = system.today().adddays(30);
                opporUpsertReq.stageName = 'Open';
                opporUpsertReq.opportunityId = null;
                opporUpsertReq.probInput = null;
                opporUpsertReq.eCommerceConvert =  false;
                opporUpsertReq.eCommerceAccountNumber = 'Ecomm-0001';
                
                    
                String JsonMsg = JSON.serialize(opporUpsertReq);
                
                
                RestRequest req = new RestRequest();
                RestResponse res = new RestResponse();
                req.requestURI = '/services/apexrest/OpportunityUpsert';  //Request URL
                req.httpMethod = 'POST';//HTTP Request Type
                req.requestBody = Blob.valueof(JsonMsg);
                
                RestContext.request = req;
                RestContext.response= res;
                    OpportunityUpsert.upsertOpportunityJSON();
            }
            catch(Exception e){}
            Test.stopTest();
        //}
    }
}