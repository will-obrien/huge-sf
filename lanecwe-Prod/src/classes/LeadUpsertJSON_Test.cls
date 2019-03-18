@isTest
private class LeadUpsertJSON_Test {
    static testMethod void testLeadUpsertJSON() {
        //User u2 = [SELECT Id FROM User WHERE Alias='vvall'];
        //User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];   
        //System.RunAs(u2){  
            LeadUpsertJSON.LeadRequest ldUpsertReq = new LeadUpsertJSON.LeadRequest();
            ldUpsertReq.leadId = null;
            ldUpsertReq.FirstName = 'New Test Lead';
            ldUpsertReq.LastName = ' JSON Test';
            ldUpsertReq.Phone = '2002012001';
            ldUpsertReq.Email = 'newTestLead@pgi.com';
            ldUpsertReq.ECommerceAccountNumber = 'Ecom-00001';
            ldUpsertReq.ECommerceConvert = false;
            ldUpsertReq.LeadSource = 'ECommerce Customer';
            ldUpsertReq.Company = 'IPG Corp';
            ldUpsertReq.ChannelType = 'Direct';
            ldUpsertReq.Status = 'Qualifying';
            ldUpsertReq.Street = '1500 Main Street';
            ldUpsertReq.City = 'San Jose';
            ldUpsertReq.State = 'CA';
            ldUpsertReq.PostalCode = '95802';
            ldUpsertReq.Country = 'USA';
            ldUpsertReq.BusinessType = 1;
            ldUpsertReq.DoNotSolicit = true;
            ldUpsertReq.CompanyID = null;
                
            //String JsonMsg = '{"Street":"1500 Main Street","Status":"Qualifying","State":"CA","PostalCode":"95802","Phone":"2002012001","LeadSource":"ECommerce Customer","leadId":null,"LastName":" JSON Test","FirstName":"New Test Lead","Email":"newTestLead@pgi.com","ECommerceConvert":false,"ECommerceAccountNumber":"Ecom-00001","DoNotSolicit":true,"Country":"USA","CompanyID":null,"Company":"IPG Corp","City":"San Jose","ChannelType":"Direct","BusinessType":1}';
            String JsonMsg = JSON.serialize(ldUpsertReq);
            Test.startTest();
            
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/LeadUpsertJSON';  //Request URL
            req.httpMethod = 'POST';//HTTP Request Type
            req.requestBody = Blob.valueof(JsonMsg);
            
            RestContext.request = req;
            RestContext.response= res;
            
            LeadUpsertJSON.upsertLeadJSON();
            Test.stopTest();
        //}
    }    
}