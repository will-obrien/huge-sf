@isTest 
private class ContactsOperation_Test {
    static testMethod void testContactsOperation() {
       //User u2 = [SELECT Id FROM User WHERE Alias='vvall'];
       //User u2 = [select id from user where name = 'eCommerce Customer' and isactive=true limit 1];   
       //System.RunAs(u2){        
            Test.startTest();
            Account act = new account(Name = 'Test Acc', Ecommerce_account_number__c = 'Ecomm-0001', Z_Source__c = 'eCommerce');
            insert act;
            System.assert(act.id <> null);
               Contact ct = new Contact();
               ct.FirstName = 'First ct';
               ct.LastName  = 'Last ct';
               ct.Phone     = '2002012011';
               ct.Email     = 'create@premierglobal.com';
               ct.accountId = act.id;
               ct.License_Profile__c = true;
               insert ct;
            
            Contact ct2 = new Contact();
               ct2.FirstName = 'First ct';
               ct2.LastName  = 'Last ct';
               ct2.Phone     = '2002012011';
               ct2.Email     = 'create@premierglobal.com';
               ct2.accountId = act.id;
               ct2.License_Profile__c = true;
               insert ct2;
               
            String JsonMsg = '';
            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();            
            RestContext.request = req;
            RestContext.response= res;
            
            req.requestURI = '/services/apexrest/ContactsOperation/'+act.id;  //Request URL
            req.httpMethod = 'GET';//HTTP Request Type
            req.requestBody = Blob.valueof(JsonMsg);
            
            RestContext.request = req;
            RestContext.response= res;
            try{
                ContactsOperation.retrieveContacts();           
            }
            catch(Exception e){}
            Test.stopTest();
        //}
    }  
}