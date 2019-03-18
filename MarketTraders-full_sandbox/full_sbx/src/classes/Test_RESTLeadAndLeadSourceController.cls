/***************************
* Test_RESTLeadAndLeadSourceController
* @description:test lead source handler class
* 
*   Author:             Asha Calderon
*   Date Created:       1/10/2015
*   Last Modified:      1/10/2015
*   Last Modified By:   Asha Calderon
*
**********************************/
@isTest
private class Test_RESTLeadAndLeadSourceController{

    static testMethod void testPOST() {
        //do request
        RestResponse res = new RestResponse();
        RestRequest req = new RestRequest();        
        /*
        ResponseHandler respnd = RESTLeadAndLeadSourceController.createLeadAndLeadSource(String FirstName, String LastName, String email,
        String lead_source, String url , String lead_source_detail, String lead_source_content,String product,String clickid,
        String subid, String ip_address, String offertype, String offer, String createdbyapi, String recordtype, String phone, 
        String cityaddress, String countryaddress); 
        */         

        req.requestURI = '/services/apexrest/CreateLeadAndLeadSourceRecords';       
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        ResponseHandler respnd = RESTLeadAndLeadSourceController.createLeadAndLeadSource('Han','Solo', 'han.solo@swars.com',
        'Newspaper', 'http://www.markettraders.com' , 'n/a','n/a','USOP','none',
        'none', '1.192.0.1.2','discount', '20%','UME', 'Ultimate Stock and Options', '555-555-5555', 
        'Lake Mary', 'United States of America');
        System.debug('@asha:@debug:TestRESTLeadAndLeadSourceController: Successful response:'+respnd);
        System.assertequals('Success',respnd.Status); 
        List<lead> returnedleads = [Select id from lead];
        List<lead_sources__c> returnedleadsources = [Select id from lead_sources__c];        
        System.assertequals(1,returnedleads.size());
        System.assertequals(1,returnedleadsources.size());
        
    }
    
     static testMethod void testPOSTError() {
        //do request
        RestResponse res = new RestResponse();
        RestRequest req = new RestRequest();        
        /*
        ResponseHandler respnd = RESTLeadAndLeadSourceController.createLeadAndLeadSource(String FirstName, String LastName, String email,
        String lead_source, String url , String lead_source_detail, String lead_source_content,String product,String clickid,
        String subid, String ip_address, String offertype, String offer, String createdbyapi, String recordtype, String phone, 
        String cityaddress, String countryaddress); 
        */         

        req.requestURI = '/services/apexrest/CreateLeadAndLeadSourceRecords';       
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        ResponseHandler respnd = RESTLeadAndLeadSourceController.createLeadAndLeadSource('Han',null, 'han.solo@swars.com',
        'Newspaper', 'http://www.markettraders.com' , 'n/a','n/a','USOP','none',
        'none', '1.192.0.1.2','discount', '20%','UME', 'Ultimate Stock and Options', '555-555-5555', 
        'Lake Mary', 'United States of America');
               System.debug('@asha:@debug:TestRESTLeadAndLeadSourceController: Error response:'+respnd);
        System.assertequals('ERROR DATA - Required Fields Missing',respnd.Status);     
    }   
    
     static testMethod void testPOSTError2() {
        //do request
        RestResponse res = new RestResponse();
        RestRequest req = new RestRequest();        
        /*
        ResponseHandler respnd = RESTLeadAndLeadSourceController.createLeadAndLeadSource(String FirstName, String LastName, String email,
        String lead_source, String url , String lead_source_detail, String lead_source_content,String product,String clickid,
        String subid, String ip_address, String offertype, String offer, String createdbyapi, String recordtype, String phone, 
        String cityaddress, String countryaddress); 
        */         

        req.requestURI = '/services/apexrest/CreateLeadAndLeadSourceRecords';       
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        ResponseHandler respnd = RESTLeadAndLeadSourceController.createLeadAndLeadSource('Han','Solo', 'han.solo@swars.com',
        null, 'http://www.markettraders.com' , 'n/a','n/a','USOP','none',
        'none', '1.192.0.1.2','discount', '20%','UME', 'Ultimate Stock and Options', '555-555-5555', 
        'Lake Mary', 'United States of America');
               System.debug('@asha:@debug:TestRESTLeadAndLeadSourceController: Error response:'+respnd);
        System.assertequals('ERROR ON INSERT - Lead Success: Lead Source Failed',respnd.Status);     
    }   
        
     static testMethod void testPOSTError3() {
        //do request
        RestResponse res = new RestResponse();
        RestRequest req = new RestRequest();        
        /*
        ResponseHandler respnd = RESTLeadAndLeadSourceController.createLeadAndLeadSource(String FirstName, String LastName, String email,
        String lead_source, String url , String lead_source_detail, String lead_source_content,String product,String clickid,
        String subid, String ip_address, String offertype, String offer, String createdbyapi, String recordtype, String phone, 
        String cityaddress, String countryaddress); 
        */         

        req.requestURI = '/services/apexrest/CreateLeadAndLeadSourceRecords';       
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        ResponseHandler respnd = RESTLeadAndLeadSourceController.createLeadAndLeadSource('Han','Solo', 'han.solo@swars.com',
        null, 'http://www.markettraders.com' , 'n/a','n/a','USOP','none',
        'none', '1.192.0.1.2','discount', '20%','UME', 'Ultimate Stock and Options', '555-555-5555', 
        'Lake Mary', 'United States of America');
       System.debug('@asha:@debug:TestRESTLeadAndLeadSourceController: Error response:'+respnd);
         
        String errorreturned = 'ERROR ON INSERT - Lead Success: Lead Source Failed';
        System.assertequals(errorreturned,respnd.Status);  
        /*List<Database.Error> dtbaseerrorlist = new List<Database.Error>();
        Database.Error newerr = new Database.Error();
        dtbaseerrorlist.add(newerr);
        */
        Lead lead = new Lead();
        lead.FirstName = 'Han';
        lead.LastName = null;
        lead.Email = 'Han.Solo@swars.com';
        Database.SaveResult savedldResult = Database.insert(lead, false);
        //newerr.Message = 'Test Error Message';
        //newerr.statuscode =    
        ResponseHandler res2 = new ResponseHandler();     
        ResponseHandler result = RESTLeadAndLeadSourceController.createErrorResponse(res2, savedldResult.getErrors(), respnd.Data, true,false );
         
         
    }   
    
        static testMethod void testGET() {
         //insert lead and lead source
        Lead lead = new Lead();
        lead.FirstName = 'Han';
        lead.LastName = 'Solo';
        lead.Email = 'Han.Solo@swars.com';
        Database.insert(lead);
        
                
        Lead_Sources__c leadsrc = new Lead_Sources__c();
        leadsrc.Lead__c = lead.id;
        leadsrc.Lead_Source__c = 'Newspaper';
        leadsrc.Email_at_last_edit__c = 'Han.Solo@swars.com';
        leadsrc.Lead_Source_Detail__c = 'test lead source detail';
        leadsrc.Lead_Source_Date__c = Date.today();
        leadsrc.Override_Lead_Source_Rules__c = true;
        Database.insert(leadsrc);
            
            
        //do request
        RestResponse res = new RestResponse();
        RestRequest req = new RestRequest();    
        req.requestURI = '/services/apexrest/CreateLeadAndLeadSourceRecords';   
        req.addParameter('ldid', lead.id);
            
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        ResponseHandler respnd = RESTLeadAndLeadSourceController.getLeadSourcesByLead();
        System.assertequals('Success', respnd.Status); 
        System.assertnotequals(null, respnd.Data);     

        }
    
}