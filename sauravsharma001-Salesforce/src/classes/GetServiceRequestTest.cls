/*
 *  GetServiceRequest Test (GetServiceRequestTest) is a test class that tests GetServiceRequest as per open 311 online. 
 *  The GetServiceRequest class consists of 15 methods. 
 *  1. “getserviceRequest_SampleData” - Tests with the sample data provided.
 *  2. “getServiceRequestTest_RealtimeData” - Retrieves the information from the database and tests with the response output.
 *  3. “getServiceRequestTest_NegativeData”- Given the negative input,tests for the response error message.
 *  4. “getServiceRequestTest_OtherCodeCoverage(1 to 8 )”- Checks if all parts of the code are covered.
 */


@isTest
public class GetServiceRequestTest{
    
   public static String baseUrl = 'apexrest/v2/requests/'; 
   
   static RestRequest getDetails(){
       
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       RestContext.request = req;
       RestContext.response = res;
       return req;
   }
   
    public static String insertAPI()    {
        APIkey_Register__c apiKey = new APIkey_Register__c() ;
        apiKey.Name = 'Test';
        apiKey.Email_Open311__c = 'asdas@as.as';
        apiKey.First_Name_Open311__c = 'Test';
        apiKey.Last_Name_Open311__c = 'Test';
        apiKey.Organization_Open311__c = 'Test';
       // apiKey.Phone_Open311__c = 12313413;
        //apiKey.URL_Open311__c = 'https://www.google.com';
        Insert(apiKey);
        APIkey_Register__c api1 = [Select Key_Open311__c from APIkey_Register__c WHERE id =:apiKey.id];
        
        X311RequestType__c x = new X311RequestType__c();
        x.Name= 'Street Defect';
        x.Case_RecordTypeId__c = '012G00000014GtUIAU';
        x.Case_RecordType_Name__c = 'Street_Defect';
        x.Department__c ='Streets Department';
        x.Description__c = 'Make a request to have a pothole, ditch, or cave-in repaired';
        x.Keywords__c = 'Street,Defect,Street,Defect';
        x.Request_Category__c ='Service Request Type';
        Database.insert(x);
        
        X311RequestType__c x1 = new X311RequestType__c();
        x1.Case_RecordTypeId__c = '012G00000014BWl';
        x1.Name = 'Abandoned Vehicle';
        x1.Case_RecordType_Name__c = 'Abandoned_Vehicle';
        x1.Department__c ='Police Department';
        x1.Description__c = 'Make a request to have an abandoned vehicle and/or car removed';
        x1.Keywords__c = 'Abandoned Vehicle, Vehicle, Abandoned';
        x1.Request_Category__c ='Service Request Type';
        Database.insert(x1);
        
        Open311Field__c op = new Open311Field__c();
        op.Name = 'SR-ST01';
        op.Case_Record_Type__c = 'Street Defect';
        op.Custom_Fields_1__c = 'Crack_in_Street_Depression_or_a_Hole_i__c;Utility_Company__c;Gas_Escaping_from_the_Hole__c;Parking_or_Driving_Lane__c;Running_Water__c;Shape__c;On_State_Highway__c;Pothole__c;Has_a_Utility_Company_Worked_at_Location__c;';
        op.Encrypted_Code_Name_1__c ='SR-ST01-F01;SR-ST01-F02;SR-ST01-F03;SR-ST01-F04;SR-ST01-F05;SR-ST01-F06;SR-ST01-F07;SR-ST01-F08;SR-ST01-F09;';
        op.Not_Required_Fields__c = 'SR-ST01-F08;';
        Database.insert(op);
        return(api1.Key_Open311__c);
    }
       
    public static void sampleCases()    {
                    
            RecordType rec = [Select id from RecordType WHERE Name = 'Miscellaneous' LIMIT 1];
            Contact con = new Contact();
            con.FirstName = 'Saurav';
            con.LastName = 'Sharma';
            insert(con);
            integer i = null;
            List<Case> cList = new List<Case>();
            for(i = 0; i <2 ; i++)    {                
                Case c = new Case();
                c.Subject = 'Subject ' + i;
                c.Description = 'Description ' + i;
                c.RecordTypeId = rec.Id; 
                c.Type = 'Service Request Type';
                c.Department__c = 'Philly311 Contact Center';
                c.Case_Record_Type__c = 'Miscellaneous';
                c.Service_Request_Type__c = 'Miscellaneous';
                c.contactId = con.ID;
                c.ByPass_VR_WF__c = true;
                c.Street__c = '1234 Market St';
                c.Location__latitude__s = 2131.453;
                c.Location__longitude__s = 132412.1341;
                c.Origin = 'Phone';
                c.Status_Update__c = 'qqwdas';
                c.ZipCode__c = 12314;
                c.Media_Url__c = 'asdwdqw';
                cList.add(c);
            }
            rec = [Select id from RecordType WHERE Name = 'Salting' LIMIT 1];
            for(i = 0; i <2 ; i++)    {
                Case c = new Case();
                c.Status_Update__c = 'qqwdas';
                c.Subject = 'Subject ' + i;
                c.Description = 'Description ' + i;
                c.RecordTypeId = rec.Id; 
                c.Type = 'Service Request Type';
                c.Department__c = 'Streets Department';
                c.Case_Record_Type__c = 'Salting';
                c.Service_Request_Type__c = 'Snow Removal';
                c.ByPass_VR_WF__c = true;
                c.Street__c = '1234 Market St';
                c.Location__latitude__s = 23131.453;
                c.Location__longitude__s = 112412.1341;
                c.Origin = 'Email';
                c.Status_Update__c = 'asdasf';
                c.Media_Url__c = 'asdwdqw';
                c.ZipCode__c = 12314;
                C.SLA__c  = '2 Business Hours';
                cList.add(c);
            }
            rec = [Select id from RecordType WHERE Name = 'Other Dangerous' LIMIT 1];
            for(i = 0; i <2 ; i++)    {
                Case c = new Case();
                c.Status_Update__c = 'qqwdas';
                c.Subject = 'Subject ' + i;
                c.Description = 'Description ' + i;
                c.RecordTypeId = rec.Id; 
                c.Type = 'Service Request Type';
                c.Department__c = 'License & Inspections';
                c.Case_Record_Type__c = 'Other Dangerous';
                c.Service_Request_Type__c = 'Other Dangerous';
                c.Problem_Type__c = 'Snow Removal';
                c.ByPass_VR_WF__c = true;
                c.contactId = con.ID;
                c.Street__c = '1234 Market St';
                c.Location__latitude__s = 23131.453;
                c.Location__longitude__s = 112412.1341;
                c.Origin = 'Email';
                c.Status_Update__c = 'asdasf';
                c.ZipCode__c = 12314;
                C.SLA__c  = '2 Business Hours';
                c.Media_Url__c = 'asdwdqw';
                cList.add(c);
            }
            if(!cList.isEmpty())
                Database.Insert(cList);
            
            Case c1 = [Select id, Status,Reason, Resolution__c from Case WHERE Department__c = 'Streets Department' LIMIT 1];
            c1.Status = 'Closed';
            c1.Reason = 'sad';
            c1.Resolution__c = 'afsasf';  
            Database.update(c1);
        
            Case c2 = [Select id, Status,Reason, Resolution__c from Case WHERE Department__c = 'License & Inspections' LIMIT 1];
            c2.Status = 'Closed';
            c2.Reason = 'sad';
            c2.Resolution__c = 'afsasf';  
            Database.update(c2);    
        
            Case c3 = [Select id, Status,Reason, Resolution__c from Case WHERE Department__c = 'Philly311 Contact Center' LIMIT 1];
            c3.Status = 'Closed';
            c3.Reason = 'sad';
            c3.Resolution__c = 'afsasf';  
            Database.update(c3);
        
            List<Group> gr = [Select id, Name, DeveloperName from Group WHERE DeveloperName = 'Open311_Group']; 
            for(Case u: cList)
                Boolean shared = CaseSharing.manualShareRead(u.Id,gr[0].Id);
        }
        
        public static String sampleCaseswithCN(String recType)    {
            RecordType rec = [Select id from RecordType WHERE Name =: recType LIMIT 1];
            Contact con = new Contact();
            con.FirstName = 'Saurav';
            con.LastName = 'Sharma';
            insert(con);
            integer i = null;
            Case c = new Case();
            c.Subject = 'Subject ' + i;
            c.Description = 'Description ' + i;
            c.RecordTypeId = rec.Id; 
            c.Type = 'Service Request Type';
            c.Department__c = 'Streets Department';
            c.Case_Record_Type__c = 'Salting';
            c.Service_Request_Type__c = 'Snow Removal';
            c.Problem_Type__c = 'Snow Removal';
            c.ByPass_VR_WF__c = true;
            c.Street__c = '1234 Market St';
            c.Location__latitude__s = 23131.453;
            c.Location__longitude__s = 112412.1341;
            c.Origin = 'Email';
            Database.Insert(c);
            List<Group> gr = [Select id, Name, DeveloperName from Group WHERE DeveloperName = 'Open311_Group']; 
            Boolean shared = CaseSharing.manualShareRead(c.Id,gr[0].Id);
            Case c1 = [Select id, CaseNumber from Case WHERE id =:c.Id];
            return (c1.CaseNumber);
        } 
         
        static  testmethod void getServiceRequestTest_SampleData(){
                 
                Case servicerequest = new Case();
                RecordType rec = [Select id, Name from RecordType WHERE Name='Miscellaneous' LIMIT 1];
                servicerequest.Type = 'Service Request Type';
                servicerequest.Department__c = 'Philly311 Contact Type';
                servicerequest.Case_Record_Type__c = 'Miscellaneous';
                servicerequest.Service_Request_Type__c = 'Miscellaneous';
                servicerequest.ZipCode__c = 54321;
                servicerequest.Description = 'Sample description';
                servicerequest.location__latitude__s = 39.9345950582677;
                servicerequest.location__longitude__s = -75.1675514745034;
                servicerequest.Street__c = 'Sample address';
                servicerequest.ByPass_VR_WF__c = TRUE;
                servicerequest.Subject = 'Sample Subject';
                servicerequest.Location__latitude__s = 2312.124;
                servicerequest.Location__longitude__s = 23413.134;
            
                insert servicerequest;
            
                Case ser = [select Id,CaseNumber from Case WHERE Id = :servicerequest.Id];
                string fValue = ser.CaseNumber;
                RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();
                RestContext.request = req;
                RestContext.response = res;
                req.requestURI = baseUrl + fvalue + '/xml';
                req.httpMethod = 'GET';
                GetServiceRequest.RestResponseWrapper a=new GetServiceRequest.RestResponseWrapper(); 
                
                a.params=GetServiceRequest.getRestParams (baseUrl +fvalue+'/xml');   
                                            
                a.sObjects1 = [SELECT id, CaseNumber,Status,Status_Update__c ,Department__c,Case_Record_Type__c, Reason,Service_Request_Type__c,
                                              Description,CreatedDate,Street__c,SLA__c,LastModifiedDate,SLA_date__c, Resolution__c,
                                              ZipCode__c, Media_Url__c, location__latitude__s, Owner.Name,location__longitude__s, 
                                              Service_Code__c FROM Case WHERE CaseNumber=:fValue];                              
                GetServiceRequest.doGet();
                
                GetServiceRequest.formatResponse(a, 'xml');
                for(Case serFor : a.sObjects1){
                    
                        System.assertEquals(serFor.CaseNumber, fvalue);
                        System.assertEquals(serFor.status, 'New'); 
                        System.assertEquals(serFor.service_code__c, 'SR-MI01');
                        System.assertEquals(serFor.Description, 'Sample description');
                        System.assertEquals(serFor.service_request_type__c, 'Miscellaneous');
                        System.assertEquals(serFor.Street__c, 'Sample address');
                        System.assertEquals(serFor.Zipcode__c , 54321);
                }      
            
                req.requestURI = baseUrl + fvalue + '/json';
                req.httpMethod = 'GET';
                GetServiceRequest.doGet();
        }
    
        static  testmethod void getServiceRequestTest_RealtimeData(){
            
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'xml';  
                req.httpMethod = 'GET';
                GetServiceRequest.doGet();  
                system.debug(req.requestURI);    
              
                GetServiceRequest.RestResponseWrapper b = new GetServiceRequest.RestResponseWrapper();
                b=GetServiceRequest.output();
                
                GetServiceRequest.RestResponseWrapper a = new GetServiceRequest.RestResponseWrapper(); 
                
                a.params=GetServiceRequest.getRestParams (baseUrl + '/xml');
            
                a.sObjects1 = [SELECT CaseNumber,Status,Status_Update__c,Department__c,Case_Record_Type__c, Reason,
                                       Description,Owner.Name,SLA__c,Media_Url__c, SLA_date__c,CreatedDate,LastModifiedDate,
                                       Street__c, ZipCode__c,location__latitude__s,location__longitude__s, Resolution__c,
                                       Service_Code__c FROM Case WHERE Street__c != null and location__longitude__s != null 
                                       and location__longitude__s != 0 ORDER BY CaseNumber desc LIMIT 100];
                GetServiceRequest.formatResponse(a, 'xml');
                GetServiceRequest.formatResponse(a, 'json'); 
                
                integer temp=0;
                if(a.sObjects1.size() == b.sObjects1.size()){
                    
                    for(Case modelListdata : a.sObjects1){
                        
                            for(Case prevListdata : b.sObjects1){
                                
                                    if(modelListdata.Service_code__c == prevListdata.Service_code__c)
                                        temp++;
                            }
                    }          
                }
                    
                if(a.sObjects1.size() == b.sObjects1.size())
                    System.assertEquals(b.sObjects1.Size(),temp);    
                else
                    System.assertEquals(temp,b.sObjects1.Size());      
        }
         
        static  testmethod void getServiceRequestTest_NegativeData(){ 
        
                String caseNumber = sampleCaseswithCN('Salting');
                RestRequest req = getDetails();
                req.requestURI = baseUrl + caseNumber + '/xml?service_code=';
                req.httpMethod = 'GET';
                GetServiceRequest.doGet();
                
                GetServiceRequest.RestResponseWrapper a=new GetServiceRequest.RestResponseWrapper(); 
                GetServiceRequest.RestResponseWrapper b=new GetServiceRequest.RestResponseWrapper();
                system.debug(req.requestURI);   
                b=GetServiceRequest.output(); 
                a.params=GetServiceRequest.getRestParams (baseUrl + '05047128/xml');
                RestContext.request.params.put('service_code','');
                string jurisdictionID = a.params[1];
                string type =a.params[2];
                System.assertEquals(b.message,'Missing or Invalid content_type400');
        }
    
    static  testmethod void getServiceRequestsTest_NegativeData(){
        
                
                RestRequest req = getDetails();
                req.requestURI = baseUrl + '/xml';
                req.httpMethod = 'GET';
                GetServiceRequest.doGet();
                
                GetServiceRequest.RestResponseWrapper a=new GetServiceRequest.RestResponseWrapper(); 
                GetServiceRequest.RestResponseWrapper b=new GetServiceRequest.RestResponseWrapper();
                system.debug(req.requestURI);   
                b=GetServiceRequest.output(); 
                a.params=GetServiceRequest.getRestParams (baseUrl + '/jso');
                RestContext.request.params.put('service_code','');
                //string jurisdictionID = a.params[1];
                //string type =a.params[2];
                System.assertEquals(b.message,'Missing or Invalid service_request_id404');
        
                GetServiceRequest.RestResponseWrapper c=new GetServiceRequest.RestResponseWrapper(); 
                GetServiceRequest.RestResponseWrapper d=new GetServiceRequest.RestResponseWrapper();
                system.debug(req.requestURI);   
                d=GetServiceRequest.output(); 
                c.params=GetServiceRequest.getRestParams (baseUrl);
                System.assertEquals(d.message,'Missing or Invalid service_request_id404');
        }
        
    static  testmethod void getGet1(){ 
        
        String caseNumber = sampleCaseswithCN('Salting');
        RestRequest req = getDetails();
        req.requestURI = baseUrl + caseNumber + '/json'; 
        req.httpMethod = 'GET';
        GetServiceRequest.doGet();
    } 
    
    static  testmethod void getGet1_1(){ 
        
        String caseNumber = sampleCaseswithCN('Salting');
        RestRequest req = getDetails();
        req.requestURI = baseUrl + caseNumber + '/json'; 
        RestContext.request.params.put('callback','Key');
        req.httpMethod = 'GET';
        GetServiceRequest.doGet();
    }
    
    static  testmethod void getGet2(){ 
        
        sampleCases();
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'json';  
        req.httpMethod = 'GET';
        GetServiceRequest.doGet();
    }
    
    static  testmethod void getGet2_1(){ 
        
        sampleCases();
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'json';  
        RestContext.request.params.put('callback','Key');
        req.httpMethod = 'GET';
        GetServiceRequest.doGet();
    }
    
    static  testmethod void getGet3(){ 
        
        sampleCases();
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'json';  
        RestContext.request.params.put('callback','Key');
        RestContext.request.params.put('start_date','2013-01-01T03:57:00Z');
        RestContext.request.params.put('end_date','2013-12-12T03:57:00Z');
        RestContext.request.params.put('status','New');
        RestContext.request.params.put('service_code','SR-ST18');
        req.httpMethod = 'GET';
        GetServiceRequest.doGet();
        RestContext.request.params.put('service_request_id','SR,ST18');
        RestContext.request.params.put('jurisdiction_id','sfgov.org');
        GetServiceRequest.getMembers(req);
    }
    
    static  testmethod void getGet3_3(){ 
            
        sampleCases();    
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'json';  
        RestContext.request.params.put('callback','Key');
        RestContext.request.params.put('service_code','SR-ST18');
        RestContext.request.params.put('start_date','2013-01-01T03:57:00Z');
        req.httpMethod = 'GET';
        GetServiceRequest.doGet();
        GetServiceRequest.getMembers(req);
    }
    
    static  testmethod void getGet3_4(){ 
            
        sampleCases();    
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'json';  
        RestContext.request.params.put('callback','Key');
        RestContext.request.params.put('service_request_id','12489,123414');
        RestContext.request.params.put('start_date','2013-01-01T03:57:00Z');
        req.httpMethod = 'GET';
        GetServiceRequest.doGet();
        GetServiceRequest.getMembers(req);  
    }
    
    static  testmethod void getGet3_5(){ 
        
        sampleCases();    
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'json';  
        RestContext.request.params.put('start_date','2013-01-01T03:57:00Z');
        RestContext.request.params.put('service_code','SR-ST18');
        req.httpMethod = 'GET';
        GetServiceRequest.doGet();
        GetServiceRequest.getMembers(req);  
    }
    
    static  testmethod void getGet3_6(){ 
        
        sampleCases();    
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'json';  
        RestContext.request.params.put('service_request_id','12489,123414');
        req.httpMethod = 'GET';
        GetServiceRequest.doGet();
        GetServiceRequest.getMembers(req);  
    }
    
    static  testmethod void getGet3_7(){ 
        
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'json';  
        RestContext.request.params.put('status','New');
        req.httpMethod = 'GET';
      //  GetServiceRequest.getMembers(req);  
        GetServiceRequest.ToString(System.now(), 'dd-m-yyyy');
    }
    
    static  testmethod void getGet3_8(){ 
        
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'json';  
        RestContext.request.params.put('end_date','2013-12-12T03:57:00Z');
        req.httpMethod = 'GET';
        GetServiceRequest.getMembers(req);  
    }
    
    static testmethod void testGetServiceRequests1()    {
        
         sampleCases();   
         RestRequest req = getDetails();
         req.requestURI = baseUrl + 'json';
         RestContext.request.params.put('status','New');
         RestContext.request.params.put('service_code','SR-MI01');
         GetServiceRequest.doGet();
    }
        
     static testmethod void testPost(){
            
                RestRequest req = getDetails();
                String key = insertAPI();
                req.requestURI = baseUrl + 'json';
                GetServiceRequest.doPost();
                req.requestURI = baseUrl + 'xml';
                GetServiceRequest.doPost();
            
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-ST01');
                GetServiceRequest.doPost();
            
                req.requestURI = baseUrl + 'xml';
                RestContext.request.params.put('service_code','SR-ST01');
                GetServiceRequest.doPost();
            
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-005');
                RestContext.request.params.put('api_key','111');
                GetServiceRequest.doPost();
                GetServiceRequest.getMembers(req);
            
                req.requestURI = baseUrl + 'xml';
                RestContext.request.params.put('service_code','SR-005');
                RestContext.request.params.put('api_key','111');
                GetServiceRequest.doPost();
            
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('lat','37.76524078');
                RestContext.request.params.put('long','-122.4212043');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
            
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
            
                req.requestURI = baseUrl + 'xml';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('lat','37.76524078');
                RestContext.request.params.put('long','');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
            
                req.requestURI = baseUrl + 'xml';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('lat','37.76524078');
                RestContext.request.params.put('long','-122.4212043');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharmaqw');
                RestContext.request.params.put('first_name','Sauravqw');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
            
                req.requestURI = baseUrl + 'xml';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('lat','37.76524078');
                RestContext.request.params.put('long','-122.4212043');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
            
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('lat','');
                RestContext.request.params.put('long','-122.4212043');
                GetServiceRequest.doPost();
            
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-ST31');
                RestContext.request.params.put('lat','');
                RestContext.request.params.put('long','-122.4212043');
                GetServiceRequest.doPost();
            
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('address_key','21 N Juniper St');
                GetServiceRequest.doPost();
            
        }
        
        static testmethod void testPost1(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-00');
                RestContext.request.params.put('address_id','1234');
                GetServiceRequest.doPost();
            
                req.requestURI = baseUrl +'xmlas';
                RestContext.request.params.put('service_code','SR-ST01');
                GetServiceRequest.doPost();
            
                req.requestURI = baseUrl + 'xml';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('lat','37.76524078');
                RestContext.request.params.put('long','-122.4212043');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('address_string','12345');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
            
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('lat','37.76524078');
                RestContext.request.params.put('long','-122.4212043');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('address_string','12345');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                RestContext.request.params.put('callback','as');
                GetServiceRequest.doPost();
        }
    
        static testmethod void testPost2(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'xml';
                RestContext.request.params.put('service_code','SR-SN01');
                RestContext.request.params.put('lat','37.76524078');
                RestContext.request.params.put('long','-122.4212043');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('first_name','Saurav');
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('email','sauravsharma001@gmail.com');
                RestContext.request.params.put('address_string','12345');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
            
                req.requestURI = baseUrl + 'xml';
                RestContext.request.params.put('service_code','SR-SN01');
                RestContext.request.params.put('lat','37.76524078');
                RestContext.request.params.put('long','-122.4212043');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('first_name','Saurav');
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('email','sauravsharma001@gmail.com');
                RestContext.request.params.put('address_string','12345');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }    
    
        static testmethod void testPost3(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-SN01');
                RestContext.request.params.put('lat','37.76524078');
                RestContext.request.params.put('long','-122.4212043');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('address_string','12345');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }    
    
        static testmethod void testPost3_1(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-SN01');
                RestContext.request.params.put('callback','hello');
                RestContext.request.params.put('lat','37.76524078');
                RestContext.request.params.put('long','-122.4212043');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('address_string','12345');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }    
    
        static testmethod void testPost4(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'xml';
                RestContext.request.params.put('lat','37.76524078');
                RestContext.request.params.put('long','-122.4212043');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('address_string','12345');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }    
    
        static testmethod void testPost5(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('lat','37.76524078');
                RestContext.request.params.put('long','-122.4212043');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('address_string','12345');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }    
    
        static testmethod void testPost5_1(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('callback','hello');
                RestContext.request.params.put('lat','37.76524078');
                RestContext.request.params.put('long','-122.4212043');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('address_string','12345');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }    
    
        static testmethod void testPost6(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }
    
        static testmethod void testPost6_1(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'xml';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }
        
        static testmethod void testPost6_2(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'xml';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('callback','Sharma');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }
    
        static testmethod void testPost7(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('address_string','');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }
    
        static testmethod void testPost7_2(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('callback','Sharma');
                RestContext.request.params.put('address_string','');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }
    
        static testmethod void testPost7_1(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'xml';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('address_string','');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }
    
        static testmethod void testPost8(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('first_name','Sharma');
                RestContext.request.params.put('email','saurav.sharma@in.unisys.com');
                RestContext.request.params.put('address_string','12');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }
    
        static testmethod void testPost8_1(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('first_name','Sharma');
                RestContext.request.params.put('callback','Sharma');
                RestContext.request.params.put('email','saurav.sharma@in.unisys.com');
                RestContext.request.params.put('address_string','12');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }
    
        static testmethod void testPost8_2(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'xml';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('first_name','Sharma');
                RestContext.request.params.put('email','saurav.sharma@in.unisys.com');
                RestContext.request.params.put('address_string','12');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }
    
        static testmethod void testPost9(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('callback','Key');
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('first_name','Sharma');
                RestContext.request.params.put('email','saurav.sharma@in.unisys.com');
                RestContext.request.params.put('address_string','12');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }
    
        static testmethod void testPost9_1(){
            
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'json';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('api_key','Key00001');
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('first_name','Sharma');
                RestContext.request.params.put('email','saurav.sharma@in.unisys.com');
                RestContext.request.params.put('address_string','12');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }
    
        static testmethod void testPost9_2(){
            
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'xml';
                RestContext.request.params.put('service_code','SR-ST01');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('callback','Key');
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('first_name','Sharma');
                RestContext.request.params.put('email','saurav.sharma@in.unisys.com');
                RestContext.request.params.put('address_string','12');
                RestContext.request.params.put('attribute[SR-ST01-F01]','Crack');
                GetServiceRequest.doPost();
        }
    
        static testmethod void testPost10(){
                
                Test.startTest();
                String key = insertAPI();
                RestRequest req = getDetails();
                req.requestURI = baseUrl + 'xml';
                RestContext.request.params.put('service_code','SR-PD01');
                RestContext.request.params.put('api_key',key);
                RestContext.request.params.put('callback','Key');
                RestContext.request.params.put('last_name','Sharma');
                RestContext.request.params.put('address_string','12');
                RestContext.request.params.put('attribute[SR-PD01-F04]','true');
                GetServiceRequest.doPost();
                Test.stopTest();
       }
}