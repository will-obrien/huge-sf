/*
 *  GetServiceList Test (GetServiceListTest) is a test class that tests GetServiceList as per open 311 online. 
 *  The GetServiceList class consists of 4 methods. 
 *  1. “serviceList_SampleData” - Tests with the sample data provided.
 *  2. “serviceListTest_RealtimeData” - Retrieves the information from the database and tests with the response output.
 *  3. “getServiceListTest_NegativeData”- Given the negative input,tests for the response error message.
 *  4. “getServiceListTest_OtherCodeCoverage”- Checks if all parts of the code are covered.
 */

@isTest(SeeAllData=true)
public class GetServiceListTest{
   
   public static String baseUrl = '/v2/services/'; 
   
   static RestRequest getDetails(){
            
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       RestContext.request = req;
       RestContext.response = res;
       return req;
   }
    
   // Testing with Samples
   static  testmethod void getServicesListTest_SampleData(){
            
       RestRequest req = new RestRequest(); 
       RestResponse res = new RestResponse();
       RestContext.request = req;
       RestContext.response = res;
       req.requestURI = baseUrl + 'xml';  
       req.httpMethod = 'GET';
       GetServiceList.RestResponseWrapper a=new GetServiceList.RestResponseWrapper(); 
       a.params=GetServiceList.getRestParams (baseUrl + 'xml');   
        
       GetServiceList.doGet();

       a.sObjects = [SELECT Service_Code__c,Case_RecordTypeId__c,Name,Description__c,metadata__c,Request_Category__c,
                                Keywords__c,Department__c  FROM X311RequestType__c ORDER BY Service_Code__c];      
        
   }
    
   // Testing with RealTime Data    
   static  testmethod void getServicesListTest_RealtimeData(){
            
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'xml';  
        req.httpMethod = 'GET';
        system.debug(req.requestURI);    
      
        GetServiceList.RestResponseWrapper b = new GetServiceList.RestResponseWrapper();
        b=GetServiceList.output();
        GetServiceList.RestResponseWrapper a=new GetServiceList.RestResponseWrapper(); 
        a.params=GetServiceList.getRestParams (baseUrl + 'xml');
      
       
            
        a.sObjects = [SELECT  Service_Code__c, Case_RecordTypeId__c, Name, Description__c, metadata__c,Request_Category__c,
                                Keywords__c,Department__c  FROM  X311RequestType__c ORDER  BY Service_Code__c];
     
    
        integer temp=0;
        if(a.sObjects.size() == b.sObjects.size()){
            for(X311RequestType__c modelListdata : a.sObjects){ 
                for(X311RequestType__c prevListdata : b.sObjects){ 
                    if(modelListdata.Service_Code__c == prevListdata.Service_Code__c)
                        temp++;
                    }
                }       
        }
        
       /* if(a.sObjects.size() == b.sObjects.size())
            System.assertEquals(b.sObjects.Size(),temp);    
        else {
            
            System.assertEquals(temp,1);
        }*/
       RestContext.response.responseBody =GetServiceList.formatResponse(b,'xml');
      
   }
    
    //Testing with negative data    
    static  testmethod void getServicesListTest_NegativeData(){ 
        
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'xm';  
        req.httpMethod = 'GET';
        
        GetServiceList.doGet();
        
        GetServiceList.RestResponseWrapper a=new GetServiceList.RestResponseWrapper(); 
        GetServiceList.RestResponseWrapper b=new GetServiceList.RestResponseWrapper();
        system.debug(req.requestURI);   
        b=GetServiceList.output(); 
        
        a.params=GetServiceList.getRestParams (baseUrl + 'xm');
        System.assertEquals(b.message,'Missing or Invalid content_type400');
    }
    /*
    // Testing with other Scenarios for checking the code coverage  
    static  testmethod void getServiceListsTest_1(){ 
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'json';                  
        req.httpMethod = 'GET';
        GetServiceList.doGet();
    }   
    
    static  testmethod void getServiceListsTest_2(){ 
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'json';   
        RestContext.request.params.put('callback','test');
        req.httpMethod = 'GET';
        GetServiceList.doGet();
    }   
    
    static  testmethod void getServicesListTest_3(){     
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'ml';  
        req.httpMethod = 'GET';
        GetServiceList.doGet();
    }
    
    static  testmethod void getServicesListTest_4(){     
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'xml';  
        req.httpMethod = 'GET';
        GetServiceList.doGet();
    }
    */
    static  testmethod void getServiceTest_1(){
        RestRequest req = getDetails();            
        req.requestURI = '/v2/services/SR-MI01/json';  
        req.httpMethod = 'GET';
        GetServiceList.doGet();
    }    
        
    static  testmethod void getServiceTest_2(){     
        RestRequest req = getDetails();   
        req.requestURI = '/v2/services/SR-ST32/xml';  
        req.httpMethod = 'GET';
        GetServiceList.doGet();
    }
   
    static  testmethod void getServiceTest_3(){    
        RestRequest req = getDetails();
        req.requestURI = '/v2/services/SR-ST18/json';  
        RestContext.request.params.put('callback','test');
        req.httpMethod = 'GET';
        GetServiceList.doGet();
    }
    
    static  testmethod void getServiceTest_4(){    
        RestRequest req = getDetails();
        req.requestURI = '/v2/services/SR-ST18/xml';  
        req.httpMethod = 'GET';
        GetServiceList.doGet();
    }
    
    static  testmethod void getServiceTest_5(){    
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'SR-CL01/json';  
        req.httpMethod = 'GET';
        GetServiceList.doGet();
    } 
    
    static  testmethod void getServiceTest_6(){    
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'SR-CL01/xml';  
        req.httpMethod = 'GET';
        GetServiceList.doGet();
    } 
     
    static  testmethod void getServiceTest_7(){    
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'SR-ST19/json';  
        req.httpMethod = 'GET';
        GetServiceList.doGet();
    }
    
    static  testmethod void getServiceTest_8(){    
        RestRequest req = getDetails();
        req.requestURI = baseUrl + 'SR-ST19/xml';  
        req.httpMethod = 'GET';
        GetServiceList.doGet();
    }
    
}