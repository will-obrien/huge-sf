@isTest 
private class LeadLineItemsOperation_Test {
    static testMethod void testLineItemLeadUpsertJSON() {
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
    
            Lead ld = [select id from lead where ECommerce_Account_Number__c = 'Ecom-00001' limit 1];
            system.debug('Lead ld: '+ld);        
            List<sObject> ls = Test.loadData(Offerings__c.sObjectType, 'TestDataOfferings');
            // Verify that all 3 test accounts were created
            System.assert(ls.size() > 1);
    
            // Get first test Offerings
            Offerings__c ofrngs1 = (Offerings__c)ls[0]; 
            Offerings__c ofrngs2 = (Offerings__c)ls[1]; 
            
            list<LeadLineItemsOperation.LeadLineItemRequest> ldLineItemReqLst = new list<LeadLineItemsOperation.LeadLineItemRequest>();
                
            LeadLineItemsOperation.LeadLineItemRequest ldLineItemReq1 = new LeadLineItemsOperation.LeadLineItemRequest();
            ldLineItemReq1.Order_Number = 1;
            ldLineItemReq1.Line_Number = 1;
            ldLineItemReq1.SKU = 'SKU-00001';
            ldLineItemReq1.Description = 'Lead Line Item - 1';
            ldLineItemReq1.Price = 12.01;
            ldLineItemReq1.LeadId = ld.id;
            ldLineItemReq1.lineItemId = null;
            ldLineItemReq1.Name= 'Prod 1';
            ldLineItemReq1.Enterprise_Name = ofrngs1.name;
            ldLineItemReq1.Number_of_Licensed_Named_Users = 1;
            ldLineItemReq1.Subscription_License_Term_Months = 1;
            ldLineItemReq1.Start_Date = system.today();  
            ldLineItemReq1.End_Date = system.today().adddays(100);
            ldLineItemReq1.isDeleteOperation = false;
            
            LeadLineItemsOperation.LeadLineItemRequest ldLineItemReq2 = new LeadLineItemsOperation.LeadLineItemRequest();
            ldLineItemReq2.Order_Number = 1;
            ldLineItemReq2.Line_Number = 1;
            ldLineItemReq2.SKU = 'SKU-00002';
            ldLineItemReq2.Description = 'Lead Line Item - 1';
            ldLineItemReq2.Price = 12.01;
            ldLineItemReq2.LeadId = ld.id;
            ldLineItemReq2.lineItemId = null;
            ldLineItemReq2.Name= 'Prod 1';
            ldLineItemReq2.Enterprise_Name = ofrngs2.name;
            ldLineItemReq2.Number_of_Licensed_Named_Users = 1;
            ldLineItemReq2.Subscription_License_Term_Months = 1;
            ldLineItemReq2.Start_Date = system.today();  
            ldLineItemReq2.End_Date = system.today().adddays(100);
            ldLineItemReq2.isDeleteOperation = false;
            
            ldLineItemReqLst.add(ldLineItemReq1);
            ldLineItemReqLst.add(ldLineItemReq2);
            
            String lineItemjsonMsg = JSON.serialize(ldLineItemReqLst);
            
            req = new RestRequest();
            res = new RestResponse();
            req.requestURI = '/services/apexrest/LeadLineItemsUpsert';  //Request URL
            req.httpMethod = 'POST';//HTTP Request Type
            req.requestBody = Blob.valueof(lineItemjsonMsg);
            
            RestContext.request = req;
            RestContext.response= res;
                
            LeadLineItemsOperation.upsertLeadLineItem();
            
            Licenseset__c licset = [select id from licenseset__c limit 1];
            LeadLineItemsOperation.LeadLineItemRequest ldLineItemReq3 = new LeadLineItemsOperation.LeadLineItemRequest();
            ldLineItemReq3.Order_Number = 1;
            ldLineItemReq3.Line_Number = 1;
            ldLineItemReq3.SKU = 'SKU-00002';
            ldLineItemReq3.Description = 'Lead Line Item - 1';
            ldLineItemReq3.Price = 12.01;
            ldLineItemReq3.LeadId = ld.id;
            ldLineItemReq3.lineItemId = licset.id;
            ldLineItemReq3.Name= 'Prod 1';
            ldLineItemReq3.Enterprise_Name = ofrngs2.name;
            ldLineItemReq3.Number_of_Licensed_Named_Users = 1;
            ldLineItemReq3.Subscription_License_Term_Months = 1;
            ldLineItemReq3.Start_Date = system.today();  
            ldLineItemReq3.End_Date = system.today().adddays(100);
            ldLineItemReq3.isDeleteOperation = true;
            ldLineItemReqLst.clear();
            ldLineItemReqLst.add(ldLineItemReq3);        
            
            lineItemjsonMsg = JSON.serialize(ldLineItemReqLst);
            
            req = new RestRequest();
            res = new RestResponse();
            req.requestURI = '/services/apexrest/LeadLineItemsUpsert';  //Request URL
            req.httpMethod = 'POST';//HTTP Request Type
            req.requestBody = Blob.valueof(lineItemjsonMsg);
            
            RestContext.request = req;
            RestContext.response= res;
                
            LeadLineItemsOperation.upsertLeadLineItem();        
            Test.stopTest();        
        //}
    }
}