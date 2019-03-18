/* 
 * POST Service Request - Create service requests 
 * GET Service Requests - Query the current status of multiple requests 
 * GET Service Request - Query the current status of an individual request 
 */

@RestResource(urlMapping='/v2/requests/*')
global without sharing class GetServiceRequest {

   // Initialize the list variables - Start 
   global class RestResponseWrapper {                
       public string message;
       public list<Case> sObjects3 = new list<Case>();
    //   public list<Token__c> sObjects4 = new list<Token__c>();
       public list<string> params = new list<string>();       
       public list<Case> sObjects1 = new list<Case>();
       public list<CaseComment> cCom = new list<CaseComment>();
       String requestURI = RestContext.request.requestURI;
       boolean flag1 = false;
       public String callback;
       public string cComBody = '';
   }
   // Initialize the list variables - End
        
   // HTTPGet Method for retrieving data for below APIs - Start
   // - Get Service Request
   // - Get Service Requests
       
   @HttpGet        
   global Static void doGet() { 
           
       RestResponseWrapper thisResponse = new RestResponseWrapper();
       thisResponse = output();
   }      
        
  global Static RestResponseWrapper output(){

       // Intializing required Variables
       RestResponseWrapper thisResponse = new RestResponseWrapper();
       thisResponse.params = getRestParams(thisResponse.requestURI);     
       RestRequest restReq = RestContext.request;
       RestResponse restResp = RestContext.response;     
       thisResponse.callback = RestContext.request.params.get('callback');  
       String caseNo = null;
       String type = null; 
       String code = null;   
       ApplicationException appException = new ApplicationException();

       // Method for parsing input parameters from the input URL - Start 
       list<String> uriKeys = RestContext.request.requestURI.split('/');
       try {                   
           if(uriKeys.size() == 4) {                             
               type = uriKeys[3];    
           } 
           else {  
               type = uriKeys[4]; 
               caseNo = uriKeys[3];
           }       
       } 
       catch (Exception e) {
           System.debug('Error thrown while parsing URL: ' + e.getMessage());       
       }
       // Method for parsing input parameters from the input URL - End
          
       String serviceRequestId = RestContext.request.params.get('service_request_id');
       String serviceCode = RestContext.request.params.get('service_code');
       String startDate = RestContext.request.params.get('start_date');
       String endDate = RestContext.request.params.get('end_date');
       String status = RestContext.request.params.get('status');
       Boolean flag1 = false;
       Boolean flag2 = false;
       String CaseComm; 
       // Paramset stores all paramters name passed in the URL
        Set <String> paramset1 = new Set<String>();
        Set <String> paramset = new Set<String>();
        paramset1 = RestContext.request.params.keySet();
        
        for(string s : paramset1)    {
            if(!s.equalsIgnoreCase('callback'))
                paramset.add(s);
        }
       Boolean flag = paramset.isEmpty();
        
       try {
         
           // GetServiceRequests Service return service list depending on the paramters provided
           if((flag == false) && (caseNo == null || caseNo == '') && (type.equalsIgnoreCase('xml') || type.equalsIgnoreCase('json')) ) {
                System.debug('Status :'+ status);
               if(serviceCode != null && serviceCode != '')                                 
                   thisResponse.sObjects1 = getMembers(restReq);
                         
               else if(serviceRequestId != null && serviceRequestId != '')                                 
                   thisResponse.sObjects1 = getMembers(restReq);
                         
               else if(startDate != null && startDate != '')                                 
                   thisResponse.sObjects1 = getMembers(restReq);                    
                   
               else if(endDate != null && endDate != '')                                  
                   thisResponse.sObjects1 = getMembers(restReq);
                        
               else if(status != null && status != '')                                 
                   thisResponse.sObjects1 = getMembers(restReq);                            
               else                              
                   thisResponse.sObjects1 = [SELECT CaseNumber,Status,Status_Update__c,Case_Record_Type__c, Reason, 
                                              Description,Owner.Name,Department__c,Id,SLA__c,Media_Url__c, SLA_date__c,CreatedDate,LastModifiedDate,
                                              Street__c, ZipCode__c,Location__latitude__s,Location__longitude__s, Resolution__c, 
                                              Service_Code__c FROM Case WHERE Street__c != null and Location__longitude__s != null 
                                              and Location__longitude__s != 0 and CreatedDate = LAST_90_DAYS
                                              ORDER BY CaseNumber LIMIT 1000];  
                
               
               flag1 = true;
               RestContext.response.responseBody = formatResponse(thisResponse,type); 
                 
           }
           
           // GetServiceRequest Service         
           else if((flag == true && flag1 == false) && (caseNo != null && caseNo != '' )) {
               
               thisResponse.sObjects1 = [SELECT CaseNumber,Status,Status_Update__c ,Case_Record_Type__c, Reason, 
                                          Description,CreatedDate,Street__c,SLA__c,LastModifiedDate,SLA_date__c, Resolution__c,  
                                          Media_Url__c, ZipCode__c,Location__latitude__s, Owner.Name,Department__c,Id,Location__longitude__s, 
                                          Service_Code__c FROM Case WHERE (CaseNumber=:caseNo )
                                          AND CreatedDate = LAST_90_DAYS];                                                                                
              
              //Open311 Change Order related to status_notes mapping 16 Feb 2015 (Query for case comment) - Start
               List<Case> Id1 = [SELECT id from Case where CaseNumber=:caseNo];
               if(Id1.size() > 0) {
                   thisResponse.cCom = [Select Id,CommentBody,CreatedDate,IsPublished from CaseComment where parentID =: Id1 AND IsPublished=True order by CreatedDate LIMIT 1];
                   if(thisResponse.cCom.size() > 0)
                       thisResponse.cComBody = thisResponse.cCom[0].CommentBody;
               }    
              // Open311 Change Order related to status_notes mapping 16 Feb 2015 (Query for case comment) - End
               flag2 = true;
               RestContext.response.responseBody = formatResponse(thisResponse,type);     
           }
           
           // GetServiceRequests         
           if(thisResponse.sObjects1.isEmpty() && flag == true) {
                    
               if((uriKeys.size() == 4) && (type == 'xml' || type == 'json')) {
                       
                   thisResponse.sObjects1 = [SELECT CaseNumber,Status,Status_Update__c ,Case_Record_Type__c, Reason,
                                              Description,CreatedDate,Street__c,SLA__c,LastModifiedDate,SLA_date__c, Resolution__c,
                                              ZipCode__c, Media_Url__c, Location__latitude__s, Owner.Name,Department__c,Id,Location__longitude__s, 
                                              Service_Code__c FROM Case WHERE Street__c != null and Location__longitude__s != null 
                                              and Location__longitude__s != 0  and CreatedDate = LAST_90_DAYS ORDER BY caseNumber LIMIT 1000]; 
                                           
                   RestContext.response.responseBody = formatResponse(thisResponse,type);
               } 
           }
                   
           if(thisResponse.sObjects1.isEmpty()) {
                    
               if((flag == false) && (caseNo != null && caseNo != '') && (paramset.contains('service_code') == true || paramset.contains('start_date') == true || 
                    paramset.contains('end_date') == true || paramset.contains('status') == true || (paramset.contains('service_request_id') == true))) {                                
                    
                       throw new ApplicationException();                       
               } 
               else if(flag == false && (caseNo != null) && 
                         (paramset.contains('service_code') == false) && (paramset.contains('start_date') == false) && 
                         (paramset.contains('end_date') == false) && (paramset.contains('status') == false) && 
                         (paramset.contains('service_request_id') == false)) {
                    
                       thisResponse.sObjects1 = [SELECT CaseNumber,Status,Status_Update__c ,Case_Record_Type__c, Reason, 
                                              Description, CreatedDate,Street__c,SLA__c, LastModifiedDate,
                                              SLA_date__c,ZipCode__c,Media_Url__c ,Location__latitude__s, Owner.Name,Id, Department__c,
                                              Location__longitude__s, Service_Code__c, Resolution__c
                                              FROM Case WHERE (CaseNumber=:caseNo)  and CreatedDate = LAST_90_DAYS 
                                              ORDER BY CaseNumber LIMIT 1000];  
                       
                       if(string.valueOf(thisResponse) != null && (type == 'xml' || type == 'json'))    
                           RestContext.response.responseBody = formatResponse(thisResponse,type);        
                      
                       else                    
                           throw new ApplicationException();    
               }
           }
                        
           if(thisResponse.sObjects1.isEmpty()) {
                    
               if(((type != 'xml' && type != 'json') || (type == 'xml'||type == 'json')) && flag == false && 
                    (paramset.contains('jurisdiction_id') == false) && (caseNo != null)&& (paramset.contains('service_code') == false) && 
                    (paramset.contains('start_date') == false) && (paramset.contains('end_date') == false) && 
                    (paramset.contains('status') == false) && (paramset.contains('service_request_id') == false)) 
                         
                         throw new ApplicationException();
                                               
               else if(caseNo !=null && caseNo != '') 
                   throw new ApplicationException();
                        
               else if(caseNo.contains('') && (flag == true)) 
                   throw new ApplicationException();
                  
           }
           
           if(thisResponse.sObjects1.size() != 0) {
                  
               if((type != 'xml' && type != 'json'))
                   throw new ApplicationException();
                            
               else if(type == null)
                   throw new ApplicationException();
                    
           }
                         
           if(string.valueOf(thisResponse) != null && (type == 'xml' || type == 'json'))    
               RestContext.response.responseBody = formatResponse(thisResponse,type);        
                   
           else 
               throw new ApplicationException();  
       
           return (thisResponse);                
       } 
       catch(exception e) {   // catch Exception if required parameters are 'Not Provided' or 'Not Found' 
           
           String message1 = 'Missing or Invalid service_request_id';
           String message2 = 'Missing or Invalid content_type';            
           String message3 = 'Invalid service_request_id';
           String message4 = 'The URL request is invalid or open311 service is not running or reachable';
           String message5 = 'Missing or Invalid jurisdiction_id';
           String message6 = 'Missing or Invalid jurisdiction_id or content type';
           String message7 = 'Missing or Invalid service_request_id or content type';
           String message8 = 'Invalid Paramters provided';
          
           if(type == null || (!type.equalsIgnoreCase('xml') && !type.equalsIgnoreCase('json')) )    {
           
               code = '400';
               thisResponse.message = message2+code;
               RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
               RestContext.response.responseBody = appException.vxmlException(message2,code,'xml',thisResponse.callback);                
           }
           else    {
           
               // GetServiceRequests
               if(caseNo == null)    {
                   if(thisResponse.sObjects1.isEmpty())    {
                       code = '404';
                       thisResponse.message = message8+code;
                       if(type.equalsIgnoreCase('json'))    {
                           if(thisResponse.callback == null)                                          
                               RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                           else
                               RestContext.response.addHeader('Content-Type','application/javascript'); 
                           RestContext.response.responseBody = appException.vxmlException(message8,code,type,thisResponse.callback);
                       }
                       else    {
                           RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
                           RestContext.response.responseBody = appException.vxmlException(message8,code,'xml',thisResponse.callback);
                       }
                   }
                   else    {
                       code = '404';
                       thisResponse.message = message4+code;
                       if(type.equalsIgnoreCase('json'))    {
                           if(thisResponse.callback == null)                                          
                               RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                           else
                               RestContext.response.addHeader('Content-Type','application/javascript'); 
                           RestContext.response.responseBody = appException.vxmlException(message4,code,type,thisResponse.callback);
                       }
                       else    {
                           RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
                           RestContext.response.responseBody = appException.vxmlException(message4,code,'xml',thisResponse.callback);
                       }  
                   }    
               }
               // GetServiceRequest Service
               else {
                   if(caseNo.trim() == '')    {
                   
                       code = '404';
                       thisResponse.message = message1+code;
                       if(type.equalsIgnoreCase('json'))    {
                           if(thisResponse.callback == null)                                          
                               RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                           else
                               RestContext.response.addHeader('Content-Type','application/javascript'); 
                           RestContext.response.responseBody = appException.vxmlException(message1,code,type,thisResponse.callback);
                       }
                       else    {
                           RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
                           RestContext.response.responseBody = appException.vxmlException(message1,code,'xml',thisResponse.callback);
                       }    
                   }
                   else    {
                       if(thisResponse.sobjects1.isEmpty())    {
                           code = '404';
                           thisResponse.message = message3+code;
                           if(type.equalsIgnoreCase('json'))    {
                               if(thisResponse.callback == null)                                          
                                   RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                               else
                                   RestContext.response.addHeader('Content-Type','application/javascript'); 
                               RestContext.response.responseBody = appException.vxmlException(message3,code,type,thisResponse.callback);
                           }
                           else    {
                               RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
                               RestContext.response.responseBody = appException.vxmlException(message3,code,'xml',thisResponse.callback);
                           }                           
                       }
                   }
               }           
           }       
       }        // catch Exception - Ends                  
       return (thisResponse);             
   }
   // HTTPGet Method for retrieving data - End

   // Method for parsing input parameters from the input URL - Start              
   public static List<Case> getMembers(RestRequest req) { 
    
       RestResponseWrapper thisResponse = new RestResponseWrapper();
       list<String> serviceRequestId1 = new list<string>();
       string serviceRequestId = RestContext.request.params.get('service_request_id');

       if(null == serviceRequestId || ''.equals(serviceRequestId)){
        
       }
       else {        
           serviceRequestId1=serviceRequestId.split(',');
       }
        
       String qryFields = 'CaseNumber, Resolution__c , Status,Status_Update__c, Reason, Case_Record_Type__c,Service_Code__c,Description,Owner.Name,Department__c,SLA__c,SLA_date__c,CreatedDate,LastModifiedDate,Street__c,ZipCode__c,Location__latitude__s,Media_Url__c,Location__longitude__s';    
        
       String qryWhere =  '';
       string jurisdictionId = RestContext.request.params.get('jurisdiction_id');
       string serviceCode = RestContext.request.params.get('service_code');
       string startDate = RestContext.request.params.get('start_date');
       string endDate = RestContext.request.params.get('end_date');
       string status = RestContext.request.params.get('status');
       integer counter = 0 ;
       Date lastDate = null;
       String datePart = null, timePart = null;
       
       System.debug('Start Date :'+ startDate);
       System.debug('End Date :'+ endDate);
       
       
       if(serviceCode != NULL && serviceCode != '') {
        
           if(counter==0) {
            
               qryWhere = 'Service_Code__c =\''+serviceCode+'\'';
               counter += 1;
           } 
           else {
        
               String s1 = ' and Service_Code__c =\''+serviceCode+'\'';
               qryWhere = qryWhere + s1 ;
               counter += 1;
           }
       }
    
       if(startDate != NULL && startDate != '') {
           datePart = startDate.subString(0,10);
           timePart = startDate.subString(10,startDate.length());
           Date d = Date.parse((datePart.subString(5,datePart.length())+'/'+datePart.subString(0,4)).replaceAll('-','/')).addDays(90);
           
           if(counter == 0) {
                if(endDate != NULL && endDate != '')
                    qryWhere = 'CreatedDate >=' +startDate;
                else    
                    qryWhere = 'CreatedDate >=' +startDate + ' and CreatedDate<=' + String.valueOf(d)+ timePart;
               counter += 1;
           } 
           else {   
  
                if(endDate != NULL && endDate != '')
                    qryWhere += ' AND CreatedDate >=' +startDate;
                else    
                    qryWhere += ' AND CreatedDate >=' +startDate + ' and CreatedDate<=' + String.valueOf(d)+ timePart;
                counter += 1;         
           }
       }
        
       if(endDate != NULL && endDate != '') {
           datePart = endDate.subString(0,10);
           timePart = endDate.subString(10,endDate.length());
           Date d = Date.parse((datePart.subString(5,datePart.length())+'/'+datePart.subString(0,4)).replaceAll('-','/')).addDays(-90);
            
           if(counter == 0) {
                if(startDate != NULL && startDate != '')
                    qryWhere = 'CreatedDate <= '+endDate;
                else
                    qryWhere = 'CreatedDate <= '+endDate + ' and CreatedDate >=' + String.valueOf(d)+ timePart; 
               counter += 1;
           } 
           else {
            
               if(startDate != NULL && startDate != '')
                    qryWhere += ' AND CreatedDate <= '+endDate;
               else
                    qryWhere += ' AND CreatedDate <= '+endDate + ' and CreatedDate >=' + String.valueOf(d)+ timePart;   
               counter += 1;
           }
       }
   
       if(status != NULL && status != '') {
           if(counter == 0) {
              if(status.equalsIgnoreCase('Open')) 
                 qryWhere = 'isClosed = false';
              else if(status.equalsIgnoreCase('Closed'))
                 qryWhere = 'isClosed = true';
              counter += 1;
           } 
           else {
   
               if(status.equalsIgnoreCase('Open')) 
                 qryWhere += ' and isClosed = false';
               else if(status.equalsIgnoreCase('Closed'))
                 qryWhere += ' and isClosed = true';
               counter += 1;
           }
       }
    
       if(serviceRequestId1.size() >= 1) {

           String newSetStr = '';
           for(String str : serviceRequestId1)
               newSetStr += '\'' + str + '\',';
           
           newSetStr = newSetStr.lastIndexOf(',') > 0 ? '(' + newSetStr.substring(0,newSetStr.lastIndexOf(',')) + ')' : newSetStr;
 
           if(counter == 0) 
               qryWhere='CaseNumber in'+newSetStr;                           
           else                        
               qryWhere=qryWhere+' and CaseNumber in'+newSetStr;
                
           counter += 1;
                
           if(thisResponse.sObjects1.isEmpty() == true && null != serviceRequestId)                          
               qryWhere='CaseNumber in'+newSetStr;
                   
       }
       if((startDate == null || startDate == '') && (endDate == null || endDate == ''))
          qryWhere += ' AND CreatedDate = LAST_90_DAYS ';
       System.debug('SELECT ' + qryFields + ' FROM Case WHERE ' + qryWhere + ' ORDER BY CaseNumber LIMIT 1000');      
       return Database.query('SELECT ' + qryFields + ' FROM Case WHERE ' + qryWhere + ' ORDER BY CaseNumber LIMIT 1000');
   }       
   // Method for parsing input parameters from the input URL - End  
          
   // Post method
   @HttpPost
   global static void doPost() {    
        
                 
       // Intializing the reqd variables
       RestResponseWrapper thisResponse1 = new RestResponseWrapper();   
       RestRequest restReq = RestContext.request;
       RestResponse restResp = RestContext.response;
       RestRequest req = RestContext.request;
       Boolean flag = false;
       Boolean flag1 = false;
       Boolean conFlag = false;
       Decimal address_id; 
       Decimal lat;
       Decimal long1 ;
       String a1 = 'loop';
       Set <String> colorSet = new Set<String>();
       
       Set <String> paramset1 = new Set<String>();
       paramset1 = RestContext.request.params.keySet();
        
        for(string s : paramset1)    {
            if(!s.equalsIgnoreCase('callback'))
                colorSet.add(s);
        }
       
       String li = String.valueOf(colorSet);               
       List<String> li1 = new List<String>();
       List<String> val = new List<String>();            
       String encryptedCode = '';   
       GetServiceDefinitionDetails det = new GetServiceDefinitionDetails();
       Schema.DescribeSObjectResult r = Case.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();
       List<Contact> con = new List<Contact>();
       List<X311RequestType__c> serv = new List<X311RequestType__c>();
       
       // Get all the parameters value
       String temp = req.params.get('temp');
       String type = restReq.requestURI.substring(restReq.requestURI.lastIndexOf('/')+1); 
       String apiKey = RestContext.request.params.get('api_key');
       String service_code = req.params.get('service_code');
       String jurisdiction_id = req.params.get('jurisdiction_id');
       String lat1 = req.params.get('lat');
       String long2 = req.params.get('long');
       String address_id1 = req.params.get('address_id');
       String address_string1 = req.params.get('address_string');    
       String first_name = req.params.get('first_name');
       String last_name = req.params.get('last_name');
       String phone = req.params.get('phone'); 
       String email = req.params.get('email'); 
       thisResponse1.callback = RestContext.request.params.get('callback');  
       List<APIkey_Register__c> postObject = [SELECT key_Open311__c from APIkey_Register__c where key_Open311__c=: apiKey];
       Integer i;
       
       if(apiKey == null)    {
           ApplicationException a = new ApplicationException(); 
           String msg = 'API Key were not provided';
           RestContext.response.addHeader('Content-Type', 'text/xml; charset=utf-8');
           RestContext.response.responseBody = a.vxmlException(msg,'404',type,thisResponse1.callback);   
       }
       else  {
           if(postObject.size()==1) { 
                                  
               if((!req.params.containsKey('address_id')) || (string.valueOf(req.params.get('address_id'))== null ||string.valueOf( req.params.get('address_id'))== '')) {
                   address_id = 0.0000; 
               } 
               else {                
                   address_id  = Decimal.ValueOf((req.params.get('address_id')));
               }    
                    
               if((!req.params.containsKey('lat'))|| ((req.params.containsKey('lat'))&& ((string.valueOf(req.params.get('lat'))== null ||string.valueOf( req.params.get('lat'))== '')))) {
                   lat = 0.0000;                              
               } 
               else  {
                   lat = Decimal.ValueOf((req.params.get('lat')));
               }
                     
               if((!req.params.containsKey('long'))|| (string.valueOf(req.params.get('long'))== null ||string.valueOf( req.params.get('long'))== '')) {
                   long1 = 0.0000;  
               }
               else  {
                   long1  = Decimal.ValueOf((req.params.get('long')));
               } 
                    
               Set <String> colorSet1 = new Set<String>();
               colorSet1 = req.params.keySet();
               Set<String> myString = new Set<String>();
               Set<String> myString1 = new Set<String>();  
                    
               if(service_code != null)    {
                   serv = [Select Name, Service_Code__c, Department__c, Case_RecordTypeId__c, Case_RecordType_Name__c from  X311RequestType__c WHERE Service_Code__c =: service_code LIMIT 1];     
               }   
                   
               for(X311RequestType__c g: [Select service_code__c from X311RequestType__c]) {                
                   myString.add(g.service_code__c);                  
               } 
                    
               try {
                        
                   if((req.params.containsKey('service_code') )){
                       if((req.params.containsKey('address_string') ) || ((req.params.containsKey('lat')) && (req.params.containsKey('long')))) {
                           if(((lat1 != null && lat1 != '') && (long2 != null && long2 != '')) || (address_string1 != null && address_string1 != '')) {
                     
                               if(myString.Contains(service_code)) 
                                   flag1 = true;                                    
                           }
                       } 
                   }
                        
                   // Querying for the Contact if Contact info is provided
                   if(last_name != null )    {            
                       if(first_name != null)    
                           con = [Select id, Name, Phone, MobilePhone from Contact where LastName =: last_name and FirstName =: first_name];                    
                       else
                           con = [Select id, Name, Phone, MobilePhone from Contact where LastName =: last_name ];
                       if(con == null || con.size() == 0)    {
                           Contact newCon = new Contact();
                           newCon.LastName = last_name;
                           newCon.FirstName = first_name;
                           newCon.Email = email;
                           newCon.Phone = phone;
                           conFlag = TRUE;
                           INSERT newCon;
                           con.add(newCon);
                       }
                   }  
                   
                   if(flag1 == true) {
                     /*  if(temp == 'true') {
                                
                           Token__c t  = new Token__c(
                                    Servicecode_Open311__c = req.params.get('service_code'), 
                                    Jurisdiction_id_Open311__c = req.params.get('jurisdiction_id'),
                                    First_name_Open311__c = req.params.get('first_name'),
                                    Location_Open311__latitude__s = lat,
                                    Location_Open311__longitude__s = long1,
                                    Street__c = req.params.get('address_string'),
                                    Address_id_Open311__c = address_id,
                                    Email_Open311__c = req.params.get('email'),
                                    Media_url_Open311__c = req.params.get('media_url'),
                                    Name_Open311__c = req.params.get('last_name'),
                                    Phone_Open311__c = req.params.get('phone'),
                                    Description_Open311__c = req.params.get('description')
                           );
                           
                           INSERT t;
                           thisResponse1.sObjects4 = [SELECT Name FROM Token__c WHERE Id =: t.Id  ];
                           RestContext.response.responseBody = formatResponse1(thisResponse1,type);
                           flag = false;  
                       }
                       else {*/
                       
                           String dept = null, cRecType = null, sReqType = null, cRecId = null, conId; 
                           
                           if(serv != null && serv.size()>0)    {
                               
                               cRecId = serv[0].Case_RecordTypeId__c;
                               dept = serv[0].Department__c;
                               cRecType = serv[0].Name;
                           }
                           
                           if(con != null && con.size() > 0)
                               conId= con[0].Id;
                               
                           System.debug('Intialising Cases Field');    
                           Case u = new Case(
                                       RecordTypeId = cRecId ,
                                       Department__c = dept,
                                       Case_Record_Type__c = cRecType,
                                       Location__latitude__s = lat,
                                       Location__longitude__s= long1,
                                       Street__c = req.params.get('address_string'),
                                       ContactId = conId,
                                       Description = req.params.get('description'),   
                                       ByPass_VR_WF__c = TRUE,
                                       Service_Request_Type__c = cRecType,
                                       Type = 'Service Request Type',
                                       Subject = cRecType,
                                       Origin = 'Open311'
                           );             
                                 
                           for(String s : colorSet)   {
                               if(s.contains('attribute'))  {                                                                           
                                   
                                   encryptedCode = s.substring(s.indexOf('attribute')+10,s.indexOf(']'));
                                   String fieldValue = req.params.get('attribute['+encryptedCode+']');
                                   String fieldName = det.decryptFieldListCode(service_code, encryptedCode);
                                   System.debug('Encrypted Code: ' + encryptedCode);
                                   if(!fieldName.equals('invalid')){
                                       
                                       Schema.SObjectField field = M.get(fieldName);
                                       Schema.DescribeFieldResult F = field.getDescribe();
                                       Schema.DisplayType dType = F.getType();
                                       System.debug('Field Name: ' + fieldName);
                                       System.debug('Field Value: ' + fieldValue);
                                       
                                       if(String.valueOf(dType)=='PICKLIST'){
                                           List<String> values = new list<String>();
                                           List<Schema.PicklistEntry> pickList = F.getPicklistValues();
                                           String value,label;
                                           
                                           for(integer l=0 ;l< pickList.size() ;l++){
                                               
                                               value = string.ValueOf(pickList.get(l)); 
                                               label = value.subString(value.indexOf('getLabel')+9,value.indexOf(';getValue'));
                                               values.add(label);
                                               System.debug('Picklist Value for ' + fieldName + ': Adding' + label);
                                               if(label.trim().equalsIgnoreCase(fieldValue.trim()))
                                                   u.put(fieldName,fieldValue);
                                           }
                                       }
                                       else if(String.valueOf(dType)=='BOOLEAN'){
                                           
                                           if(fieldValue.equalsIgnoreCase('true'))
                                               u.put(fieldName,true);
                                           else
                                               u.put(fieldName,false);                                              
                                       }
                                       else
                                           u.put(fieldName,fieldValue);                                     
                                   }                                              
                               }                        
                           }      
                               
                           INSERT u; 
                           List<Group> gr = [Select id, Name, DeveloperName from Group WHERE DeveloperName = 'Open311_Group']; 
                           Boolean shared = CaseSharing.manualShareRead(u.Id,gr[0].Id);
                           System.debug('Shared: ' + shared);
                           thisResponse1.sObjects3 = [SELECT CaseNumber, Id, SLA__c FROM Case WHERE Id =: u.Id];
                           flag = true;
                           System.debug('thisResponse1.sObjects3 : ' + thisResponse1.sObjects3);
                           
                     //  }  End of temp loop
            
                            
                       if(flag == true){
                       
                           a1 = 'loop1';                            
                           RestContext.response.responseBody = formatResponse3(thisResponse1,type);
                           System.debug('Case Object ' + thisResponse1 + type);
                       } 
                     /*  else if(flag == false) {                                    
                       
                           a1 = 'loop2';
                           RestContext.response.responseBody = formatResponse1(thisResponse1,type);              
                           System.debug('Token Object ' + thisResponse1 + type);
                       }*/
                   }
                   else 
                       throw new ApplicationException();
               } 
               catch(exception e){   // Catch Block
                     
                   String message1 = 'service_code not provided';                       
                   String message2 = 'service_code provided was not found';
                   String message3 = 'please provide any one of the location parameter';  
                   String message4 = 'Missing or Invalid content-type';  
                   String message5 = 'please provide valid location parameter';
                   String message6 = 'jurisdiction_id provided were not found';   
                   String message7 = 'Missing or Invalid field/code for Service Request Creation';  
                   String message8 = 'Unable to create contact';
                   String code;            
                   ApplicationException a = new ApplicationException();                                            
                     
                   if(thisResponse1.sObjects3.IsEmpty()) {
                              
                       if((!req.params.containsKey('address_string') ) && ((!req.params.containsKey('lat')) && (!req.params.containsKey('long'))) && (!req.params.containsKey('address_id'))){
                                
                           if(type == 'xml'){
                                 
                               code = '400';
                               RestContext.response.addHeader('Content-Type', 'text/xml; charset=utf-8');
                               RestContext.response.responseBody = a.vxmlException(message3,code,type,thisResponse1.callback);                               
                           } 
                           else if(type == 'json'){
                                        
                               code = '400';
                               if(thisResponse1.callback == null)                                          
                                   RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                               else
                                   RestContext.response.addHeader('Content-Type','application/javascript'); 
                               RestContext.response.responseBody = a.vxmlException(message3,code,type,thisResponse1.callback);                               
                           }                                
                       } 
                      /* else if((req.params.containsKey('address_string')) || ((req.params.containsKey('lat')) && (req.params.containsKey('long'))) && (req.params.containsKey('address_id'))){
                                
                           if(((lat1 == null ||lat1 == '')|| (long2 == null || long2 == '')) && (address_id1 == null || address_id1 == '') && (address_String1 == null || address_String1 == '')) {
                                    
                               if(type == 'xml'){
                                     
                                   code = '400';
                                   RestContext.response.addHeader('Content-Type', 'text/xml; charset=utf-8');
                                   RestContext.response.responseBody = a.vxmlException(message5,code,type,thisResponse1.callback);                               
                               } 
                               else if(type == 'json'){
                                                
                                   code = '400';
                                   if(thisResponse1.callback == null)                                          
                                       RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                                   else
                                       RestContext.response.addHeader('Content-Type','application/javascript'); 
                                   RestContext.response.responseBody = a.vxmlException(message5,code,type,thisResponse1.callback);                               
                               }                                
                           }
                       }     */
                       
                       if((!req.params.containsKey('service_code')) ) {
                                
                           if(type == 'xml'){
                                                
                               code = '400';
                               RestContext.response.addHeader('Content-Type', 'text/xml; charset=utf-8');
                               RestContext.response.responseBody = a.vxmlException(message1,code,type,thisResponse1.callback);                               
                           } 
                           else if(type == 'json'){
                                                
                               code = '400';
                               if(thisResponse1.callback == null)                                          
                                   RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                               else
                                   RestContext.response.addHeader('Content-Type','application/javascript'); 
                               RestContext.response.responseBody = a.vxmlException(message1,code,type,thisResponse1.callback);                               
                           }                                
                       } 
                       else if((req.params.containsKey('service_code'))&& (!myString.Contains(service_code))){
                                
                           if(type == 'xml'){
                                    
                               code = '404';
                               RestContext.response.addHeader('Content-Type', 'text/xml; charset=utf-8');
                               RestContext.response.responseBody = a.vxmlException(message2,code,type,thisResponse1.callback);                               
                           }
                           else if(type == 'json'){
                                            
                               code = '404';
                               if(thisResponse1.callback == null)                                          
                                   RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                               else
                                   RestContext.response.addHeader('Content-Type','application/javascript'); 
                               RestContext.response.responseBody = a.vxmlException(message2,code,type,thisResponse1.callback);                               
                           }   
                       }
                       else if((!req.params.containsKey('address_string'))&&(!req.params.containsKey('address_id'))&&(!req.params.containsKey('lat')||!req.params.containsKey('long'))){
                                
                           if(type == 'xml'){
                                         
                               code = '400';
                               RestContext.response.addHeader('Content-Type', 'text/xml; charset=utf-8');
                               RestContext.response.responseBody = a.vxmlException(message5,code,type,thisResponse1.callback);                               
                           } 
                           else if(type == 'json'){
                                                
                               code = '400';
                               if(thisResponse1.callback == null)                                          
                                   RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                               else
                                   RestContext.response.addHeader('Content-Type','application/javascript'); 
                               RestContext.response.responseBody = a.vxmlException(message5,code,type,thisResponse1.callback);                               
                           }   
                       }
                       else {
                           if(type == 'xml'){
                                    
                               code = '404';
                               RestContext.response.addHeader('Content-Type', 'text/xml; charset=utf-8');
                               RestContext.response.responseBody = a.vxmlException(message7,code,type,thisResponse1.callback);                               
                           }
                           else if(type == 'json'){
                                            
                               code = '404';
                               if(thisResponse1.callback == null)                                          
                                   RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                               else
                                   RestContext.response.addHeader('Content-Type','application/javascript'); 
                               RestContext.response.responseBody = a.vxmlException(message7,code,type,thisResponse1.callback);                               
                           }
                       }
                       if(conFlag && (con == null || con.size() != 1))    {
                           if(type == 'xml'){
                                    
                               code = '404';
                               RestContext.response.addHeader('Content-Type', 'text/xml; charset=utf-8');
                               RestContext.response.responseBody = a.vxmlException(message8,code,type,thisResponse1.callback);                               
                           }
                           else if(type == 'json'){
                                            
                               code = '404';
                               if(thisResponse1.callback == null)                                          
                                   RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                               else
                                   RestContext.response.addHeader('Content-Type','application/javascript'); 
                               RestContext.response.responseBody = a.vxmlException(message8,code,type,thisResponse1.callback);                               
                           }
                       }
                   }  
                   
               }// end of catch block
           }
           else  {
               ApplicationException a = new ApplicationException(); 
               RestContext.response.addHeader('Content-Type', 'text/xml; charset=utf-8');
               RestContext.response.responseBody = a.vxmlException('Missing or Invalid API Key','404',type,thisResponse1.callback);   
           }
       }
   }  
   // end of Post method 
       
   // Method for Response formatting for Post Service Request - Start        
   public static blob formatResponse3(RestResponseWrapper thisResponse, String type) { 
            
       String response;  
       System.debug('formatResponse3 Method');
       System.debug('Type: ' + type);
       System.debug('thisResponse: ' + String.valueOf(thisResponse));
       // Printing xml output
       if(type == 'xml') {
            
           RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
           XmlStreamWriter writer = new XmlStreamWriter();
           writer.writeStartDocument('UTF-8','1.0');
           writer.writeStartElement(null,'service_requests',null);
           String sla1;
           for(Case a : thisResponse.sObjects3){

               writer.writeStartElement(null, 'request', null);                          
               writer.writeStartElement(null, 'service_request_id', null);
               writer.writeCharacters(String.valueOf(a.CaseNumber));
               writer.writeEndElement();
               writer.writeStartElement(null, 'service_notice', null);
                    
               if(a.SLA__c == null || a.SLA__c == '') {                                
                   sla1 = ' ';
               }
               else 
                   sla1 = a.SLA__c;
               
               writer.writeCharacters(sla1);                        
               writer.writeEndElement();
               writer.writeStartElement(null, 'account_id', null);                      
               writer.writeEndElement();
               writer.writeEndElement();
           }        
           writer.writeEndDocument();                         
           response = writer.getXmlString();
           writer.close();
       } 
                   
       // Printing JSON Output
       else if(type == 'json') {
            
           if(thisResponse.callback == null)                                          
               RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
           else
               RestContext.response.addHeader('Content-Type','application/javascript'); 
           JSONGenerator gen = JSON.createGenerator(true);
           gen.writeStartArray();
            
           for(Case a1 : thisResponse.sObjects3){  
                
               gen.writeStartObject(); 
              gen.writeObjectField('service_request_id',a1.CaseNumber);
               gen.writeObjectField('service_notice', a1.SLA__c);
               gen.writeObjectField('account_id', 'null');
               gen.writeEndObject();
           }
           gen.writeEndArray();
            
           response = gen.getAsString();
           if(thisResponse.callback != null)    {
               response = thisResponse.callback + '(' + response + ' );';
           } 
           response = response.replace('{','\n{');
           response = response.replace('" : "','":"');
           response = response.replace('" : ','":');
           response = response.replace(']','\n]'); 
           response = response.replace('"null"','null'); 
       }
       return blob.ValueOf(response);
   }
   // Method for Response formatting for Post Service Request - End
   /*     
   // Method for Response formatting for Post Service Request when stored in Temp Object - Start        
   public static blob formatResponse1(RestResponseWrapper thisResponse, String type) { 
        
       String response;      
       if(type == 'xml') {
            
           RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
           XmlStreamWriter writer = new XmlStreamWriter();
           writer.writeStartDocument('UTF-8','1.0');
           writer.writeStartElement(null,'service_requests',null);
            
           for(Token__c a1 : thisResponse.sObjects4){
               writer.writeStartElement(null, 'request', null);                          
               writer.writeStartElement(null, 'token', null);
               writer.writeCharacters(String.valueOf(a1.Name));
               writer.writeEndElement();
               writer.writeEndElement();
           }        
           writer.writeEndDocument();                         
           response = writer.getXmlString();
           writer.close();
       } 
       else if(type == 'json') {
            
           RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
           JSONGenerator gen = JSON.createGenerator(true);
           gen.writeStartArray();
           
           for(Token__c a2 : thisResponse.sObjects4){
                
               gen.writeStartObject(); 
               gen.writeObjectField('token',a2.Name);                        
               gen.writeEndObject();
           }
           gen.writeEndArray();
           response =  gen.getAsString();
           response = gen.getAsString();
           response = response.replace('{','\n{');
           response = response.replace('" : "','":"');
           response = response.replace('" : ','":');
           response = response.replace(']','\n]'); 
           response = response.replace('"null"','null'); 
       }
       return blob.ValueOf(response);
   } 
   // Method for Response formatting for Post Service Request when stored in Temp Object - End
   */
    
   // Method for parsing input parameters from the input URL - Start         
   global static list<string> getRestParams(String url) {

       list<string> returnParams = new list<string>();
       integer endOfUrl = url.indexOf('?');
       
       if(endOfUrl == -1) {
           endOfUrl = url.length();
       }          
       
       if(url.indexOf('/apexrest/') > 0) {
           url = url.substring(url.indexOf('/apexrest/')+10,endOfUrl);
       } 
       else { 
           url = url.substring(1,endOfUrl);
       }
       
       url = url.replace('.','/');          
       list<String> URLParams = url.split('/'); 
       for(integer i =0; i < 4; i++) {
           if(i<urlParams.size()) {
               returnParams.add(EncodingUtil.urlDecode(urlParams[i],'UTF-8'));
           }    
           else {
               returnParams.add(' ');
           }
       }           
       return returnParams;           
   }
   // Method for parsing input parameters from the input URL - End          
        
   // Typecasting Datetime to String representation
   public static String ToString(Datetime Value,String format) {
            
       return Value.format(format);
   }        
        
   // Method for Response formatting for Get Service Request - Start
   public static blob formatResponse(RestResponseWrapper thisResponse, String type) {

       string expectedDateString;
       string createdDateString;
       string closedDateString;
       String response;
       String requested_datetime;
       String updated_datetime;
       String expected_datetime;
               
       if(type == 'xml') {   // Printing for XML type 
        
           RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
           XmlStreamWriter writer = new XmlStreamWriter();
           writer.writeStartDocument('UTF-8','1.0');
           writer.writeStartElement(null,'service_requests',null);

           for(Case eachAccount:thisResponse.sObjects1) {
               
               writer.writeStartElement(null,'request',null);
               
               writer.writeStartElement(null,'service_request_id',null);                 
               writer.writeCharacters(String.Valueof(eachAccount.CaseNumber));                       
               writer.writeEndElement();
               
               writer.writeStartElement(null,'status',null);
               if(eachAccount.Status == null || eachAccount.Status == '')                 
                   writer.writeCharacters('  ');                                                            
               else                                 
                   writer.writeCharacters(eachAccount.Status != 'Closed' ? 'open' : 'closed'); 
               writer.writeEndElement();
               
             /* Open311 Change Order related to agency_responsible mapping 16 Feb 2015 - Start
                if(eachAccount.Status != null && eachAccount.Resolution__c != null && eachAccount.Resolution__c != '')  {
                   writer.writeStartElement(null,'status_notes',null); 
                   writer.writeCharacters(eachAccount.Resolution__c);
                   writer.writeEndElement();                 
               }
               
               else if(eachAccount.Status != null && eachAccount.Status != 'Closed' && eachAccount.Status_Update__c != null && eachAccount.Status_Update__c != '')  {
                   writer.writeStartElement(null,'status_notes',null); 
                   writer.writeCharacters(eachAccount.Status_Update__c);
                   writer.writeEndElement();                        
               }
               
               else if(eachAccount.Status != null && eachAccount.Status == 'Closed' && eachAccount.Reason != null && eachAccount.Reason != '')  {
                   writer.writeStartElement(null,'status_notes',null); 
                   writer.writeCharacters(eachAccount.Reason);
                   writer.writeEndElement();                        
               }
               
               else {
                   writer.writeStartElement(null,'status_notes',null); 
                   writer.writeCharacters('');
                   writer.writeEndElement();                        
               } */
              
                if(eachAccount.Department__c == null || eachAccount.Department__c == '') {
                   writer.writeStartElement(null,'status_notes',null); 
                   writer.writeCharacters('');
                   writer.writeEndElement();                
                }
                else if (eachAccount.Department__c == 'Streets Department' || eachAccount.Department__c == 'Water Department (PWD)' || eachAccount.Department__c == 'License & Inspections')  {   
                
                   /* Open311 Change Order related to new requirement on status_notes mapping 14th march - start
                    if(eachAccount.Status == 'Closed')  {
                        if(eachAccount.Resolution__c != null && eachAccount.Resolution__c != '') {
                            writer.writeStartElement(null,'status_notes',null); 
                            writer.writeCharacters(eachAccount.Resolution__c);
                            writer.writeEndElement(); 
                        }
                        else {
                              writer.writeStartElement(null,'status_notes',null); 
                              writer.writeCharacters('');
                              writer.writeEndElement(); 
                        } 
                            
                    }
                    else {                     
                    Open311 Change Order related to new requirement on status_notes mapping 14th march - end
                    
                    */
                        writer.writeStartElement(null,'status_notes',null); 
                        writer.writeCharacters(thisResponse.cComBody);
                        writer.writeEndElement();
                    //}                       
                }
                else {
                
                    if(eachAccount.Status == 'Closed')  {
                      if(eachAccount.Reason != null && eachAccount.Reason != '') {
                        writer.writeStartElement(null,'status_notes',null); 
                        writer.writeCharacters(eachAccount.Reason);
                        writer.writeEndElement();  
                      }
                      else {
                       writer.writeStartElement(null,'status_notes',null); 
                       writer.writeCharacters('');
                       writer.writeEndElement();                       
                      }  
                    }
                   /* Change mapping to status_update 
                    else {
                        if(eachAccount.Description != null && eachAccount.Description != '') {
                            writer.writeStartElement(null,'status_notes',null); 
                            writer.writeCharacters(eachAccount.Description);
                            writer.writeEndElement();
                        }
                        else
                        {
                            writer.writeStartElement(null,'status_notes',null); 
                           writer.writeCharacters('');
                           writer.writeEndElement(); 
                        }      
                    }  */ 
                     else {
                        if(eachAccount.Status_Update__c != null && eachAccount.Status_Update__c != '') {
                            writer.writeStartElement(null,'status_notes',null); 
                            writer.writeCharacters(eachAccount.Status_Update__c );
                            writer.writeEndElement();
                        }
                        else
                        {
                            writer.writeStartElement(null,'status_notes',null); 
                           writer.writeCharacters('');
                           writer.writeEndElement(); 
                        }      
                    }        
                
                }
                //Open311 Change Order related to agency_responsible mapping 16 Feb 2015 - End
                
               writer.writeStartElement(null,'service_name',null);   
               if(eachAccount.Case_Record_Type__c == null || eachAccount.Case_Record_Type__c == '')                              
                   writer.writeCharacters('  ');                                     
               else                               
                   writer.writeCharacters(String.Valueof(eachAccount.Case_Record_Type__c));
               writer.writeEndElement();
         
               writer.writeStartElement(null,'service_code',null);  
               if(eachAccount.Service_Code__c == null || eachAccount.Service_Code__c == '')                              
                   writer.writeCharacters('  ');                                     
               else                                     
                   writer.writeCharacters(String.Valueof(eachAccount.Service_Code__c));
               writer.writeEndElement();
                          
               writer.writeStartElement(null,'description',null);   
               if(eachAccount.Description == null || eachAccount.Description == '')                              
                   writer.writeCharacters('  ');                             
               else                                     
                   writer.writeCharacters(eachAccount.Description);
               writer.writeEndElement();
               
              /* Open311 Change Order related to agency_responsible mapping 16 Feb 2015 - Start
                writer.writeStartElement(null,'agency_responsible',null);   
               if(eachAccount.Owner.Name == null || eachAccount.Owner.Name == '')                              
                   writer.writeCharacters('  ');                             
               else                             
                   writer.writeCharacters(eachAccount.Owner.Name);
               writer.writeEndElement();  */                                     
               
               writer.writeStartElement(null,'agency_responsible',null);   
               if(eachAccount.Department__c == null || eachAccount.Department__c == '')                              
                   writer.writeCharacters('  ');                             
               else                             
                   writer.writeCharacters(eachAccount.Department__c);
               writer.writeEndElement(); 
               //Open311 Change Order related to agency_responsible mapping 16 Feb 2015 - End
               
               if(eachAccount.SLA__c != null && eachAccount.SLA__c != '' && eachAccount.SLA__c != 'None')    { 
               
                   writer.writeStartElement(null,'service_notice',null);                                            
                   writer.writeCharacters(eachAccount.SLA__c);
                   writer.writeEndElement();
               }
               
               writer.writeStartElement(null,'requested_datetime',null);                 
               Datetime dt = eachAccount.CreatedDate;
               if(eachAccount.CreatedDate != null )                                         
                   createdDateString = ToString(dt,'yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');                               
               else
                   createdDateString = ' ';
               writer.writeCharacters(createdDateString);                       
               writer.writeEndElement();                                  
                 
               writer.writeStartElement(null,'updated_datetime',null);                                     
               Datetime dt1 = eachAccount.LastModifiedDate;
               if(eachAccount.LastModifiedDate != null)                                      
                   closedDateString = ToString(dt1,'yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
               else                                       
                   closedDateString = '';
               writer.writeCharacters(closedDateString);     
               writer.writeEndElement();                    
              
               if(eachAccount.SLA_date__c != null)  {  
                   
                   writer.writeStartElement(null,'expected_datetime',null);                                     
                   dateTime dt2 = eachAccount.SLA_date__c;                                 
                   expectedDateString = ToString(dt2,'yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                   writer.writeCharacters(expectedDateString);
                   writer.writeEndElement();
               }    
            
               writer.writeStartElement(null,'address',null);   
               if(eachAccount.Street__c == null || eachAccount.Street__c == '')                              
                   writer.writeCharacters('  '); 
               else   
                   writer.writeCharacters(eachAccount.Street__c);
               writer.writeEndElement();
        
               writer.writeStartElement(null,'zipcode',null); 
               if(String.Valueof(eachAccount.ZipCode__c) == null || String.Valueof(eachAccount.ZipCode__c) == '')                                    
                   writer.writeCharacters('  '); 
               else 
                   writer.writeCharacters(String.Valueof(eachAccount.ZipCode__c));
               writer.writeEndElement();
        
               writer.writeStartElement(null,'lat',null); 
               if(string.valueOf(eachAccount.Location__latitude__s) == '' || string.valueOf(eachAccount.Location__latitude__s) == null)
                   writer.writeCharacters('  '); 
               else  
                   writer.writeCharacters(string.valueOf(eachAccount.Location__latitude__s));
               writer.writeEndElement();
               
               writer.writeStartElement(null,'long',null); 
               if(string.valueOf(eachAccount.Location__longitude__s) == null || string.valueOf(eachAccount.Location__longitude__s) == '')                             
                   writer.writeCharacters('  '); 
               else 
                   writer.writeCharacters(string.valueOf(eachAccount.Location__longitude__s));
               writer.writeEndElement();               
              
               if(eachAccount.Media_Url__c != null && eachAccount.Media_Url__c !='')  {
                   writer.writeStartElement(null,'media_url',null);    
                   writer.writeCharacters(eachAccount.Media_Url__c);
                   writer.writeEndElement();
               }
                 
               writer.writeEndElement();                         
           }
                                         
           writer.writeEndElement();
           writer.writeEndDocument();
           response = writer.getXmlString();
           writer.close();     
                
       } 
       else if(type == 'json') {   // Printing for JSON type                        
                
            if(thisResponse.callback == null)                                          
               RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
           else
               RestContext.response.addHeader('Content-Type','application/javascript');       
            JSONGenerator writer = JSON.createGenerator(true); 
            writer.writeStartArray();     
            
            for(Case eachAccount1:thisResponse.sObjects1) {
                
                Datetime dt = eachAccount1.CreatedDate;
                Datetime dt1 = eachAccount1.LastModifiedDate;
                Datetime dt2 = eachAccount1.SLA_date__c;
                
                if(eachAccount1.CreatedDate != null )                                  
                    requested_datetime = ToString(dt,'yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                else                                
                    requested_datetime = '';
                
                if(eachAccount1.LastModifiedDate != null)                                  
                    updated_datetime = ToString(dt1,'yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                else                                
                    updated_datetime = '';
                 
                if(eachAccount1.SLA_date__c != null)                                 
                    expected_datetime = ToString(dt2,'yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
                else                                 
                    expected_datetime = 'null';
                 
                writer.writeStartObject(); 
                writer.writeObjectField('service_request_id',eachAccount1.CaseNumber);

                if(eachAccount1.Status == null || eachAccount1.Status == '')
                    writer.writeObjectField('status','');                            
                else 
                    writer.writeObjectField('status',eachAccount1.Status != 'Closed' ? 'open' : 'closed');    
                                
               /* Open311 Change Order related to status_notes mapping 16 Feb 2015 - Start
                 if(eachAccount1.Status != null  && eachAccount1.Resolution__c != null && eachAccount1.Resolution__c != '')  
                    writer.writeObjectField('status_notes',eachAccount1.Resolution__c );
                
                else if(eachAccount1.Status != null && eachAccount1.Status != 'Closed' && eachAccount1.Status_Update__c != null && eachAccount1.Status_Update__c != '')  
                    writer.writeObjectField('status_notes',eachAccount1.Status_Update__c );
                    
                else if(eachAccount1.Status != null && eachAccount1.Status == 'Closed' && eachAccount1.Reason != null && eachAccount1.Reason != '') 
                     writer.writeObjectField('status_notes',eachAccount1.Reason );     
                
                else
                    writer.writeObjectField('status_notes','');   */  
                      
                if(eachAccount1.Department__c == null || eachAccount1.Department__c == '')  
                    writer.writeObjectField('status_notes','');
                else if (eachAccount1.Department__c == 'Streets Department' || eachAccount1.Department__c == 'Water Department (PWD)' || eachAccount1.Department__c == 'License & Inspections')   {                   
                   /* Open311 Change Order related to new requirement on status_notes mapping 14th march - start
                    if(eachAccount1.Status == 'Closed') {
                        if(eachAccount1.Resolution__c != null && eachAccount1.Resolution__c != '')
                            writer.writeObjectField('status_notes',eachAccount1.Resolution__c );
                        else
                            writer.writeObjectField('status_notes','');  
                     }          
                    else 
                    Open311 Change Order related to new requirement on status_notes mapping 14th march - end
                    */
                        writer.writeObjectField('status_notes',thisResponse.cComBody);
                }
                else {
                    if(eachAccount1.Status == 'Closed') {
                         if(eachAccount1.Reason != null && eachAccount1.Reason != '')
                           writer.writeObjectField('status_notes',eachAccount1.Reason );
                        else
                            writer.writeObjectField('status_notes','');  
                    }                             
                   /* Change the mapping to Status_Update again
                     else {
                        if(eachAccount1.Description  != null && eachAccount1.Description  != '')
                            writer.writeObjectField('status_notes',eachAccount1.Description );
                        else    
                            writer.writeObjectField('status_notes','');
                    }*/
                    else {
                        if(eachAccount1.Status_Update__c != null && eachAccount1.Status_Update__c != '')
                            writer.writeObjectField('status_notes',eachAccount1.Status_Update__c);
                        else    
                            writer.writeObjectField('status_notes','');
                    }    
                }               
                //Open311 Change Order related to agency_responsible mapping 16 Feb 2015 - End
                    
                if(eachAccount1.Case_Record_Type__c == null || eachAccount1.Case_Record_Type__c == '')
                    writer.writeObjectField('service_name','null');                           
                else  
                    writer.writeObjectField('service_name',eachAccount1.Case_Record_Type__c);

                if(string.valueOf(eachAccount1.Service_Code__c) == null || string.valueOf(eachAccount1.Service_Code__c) == '')
                    writer.writeObjectField('service_code','null');
                else 
                    writer.writeObjectField('service_code',eachAccount1.Service_Code__c);

                if(eachAccount1.Description == null || eachAccount1.Description == '')
                    writer.writeObjectField('description','null');
                
                else writer.writeObjectField('description',eachAccount1.Description);
                
             /* Open311 Change Order related to agency_responsible mapping 16 Feb 2015 - Start
                if(eachAccount1.Owner.Name == null || eachAccount1.Owner.Name == '')
                    writer.writeObjectField('agency_responsible','null');                            
                else 
                    writer.writeObjectField('agency_responsible',eachAccount1.Owner.Name); */
                
            
                if(eachAccount1.Department__c == null || eachAccount1.Department__c == '')
                    writer.writeObjectField('agency_responsible','null');                            
                else 
                    writer.writeObjectField('agency_responsible',eachAccount1.Department__c);
               // Open311 Change Order related to agency_responsible mapping 16 Feb 2015 - Start
                
                if(eachAccount1.SLA__c != null && eachAccount1.SLA__c != '' && eachAccount1.SLA__c != 'None') 
                    writer.writeObjectField('service_notice',eachAccount1.SLA__c);
                
                writer.writeObjectField('requested_datetime',requested_datetime);
    
                writer.writeObjectField('updated_datetime',updated_datetime);
                
                if(eachAccount1.SLA__c != null && eachAccount1.SLA__c != '' && eachAccount1.SLA__c != 'None') 
                    writer.writeObjectField('expected_datetime',expected_datetime);                   

                if(eachAccount1.Street__c == null || eachAccount1.Street__c == '') 
                    eachAccount1.Street__c = 'null' ;
                
                writer.writeObjectField('address',eachAccount1.Street__c);
           
                if(eachAccount1.ZipCode__c == null) 
                    writer.writeObjectField('zipcode','null');                            
                else 
                    writer.writeObjectField('zipcode',eachAccount1.ZipCode__c);
                     
                if(eachAccount1.Location__latitude__s == null) 
                    writer.writeObjectField('lat','null');                             
                else  
                    writer.writeObjectField('lat',eachAccount1.Location__latitude__s); 

                if(eachAccount1.Location__longitude__s == null) 
                    writer.writeObjectField('long','null');                             
                else 
                    writer.writeObjectField('long',eachAccount1.Location__longitude__s ); 

                if(eachAccount1.Media_Url__c != null && eachAccount1.Media_Url__c != '') 
                     writer.writeObjectField('media_url',eachAccount1.Media_Url__c);
              
                writer.writeEndObject(); 
           }
           writer.writeEndArray();
           response = writer.getAsString();  
           if(thisResponse.callback != null)    {
               response = thisResponse.callback + '(' + response + ' );';
           }                                         
           response = response.replace('{','\n {');
           response = response.replace('}',' }');
           response = response.replace('" : "','":"');
           response = response.replace('" : ','":');
           response = response.replace(']','\n]');  
           response = response.replace('"null"','null');
       }
       system.debug('response is ' + response);
       return blob.valueOf(response);   
   }           
// Response formatting for Get Request List - End     
 }