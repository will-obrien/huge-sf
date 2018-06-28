/* 
 * Get Service List provides a list of acceptable 311 service request types and 
 * their associated service codes. These request types can be unique to the 
 * city/jurisdiction. 
 * Get Service Definition defines attributes associated with a service code. 
 * These attributes can be unique to the city/jurisdiction. 
 */

@RestResource(urlMapping='/v2/services/*')
global with sharing class GetServiceList{
   
   global static Map<String, String> dataTypeMapping = new Map<String, String>{
       'string' => 'string', 
       'id' => 'string', 
       'integer' => 'number',
       'double' => 'number', 
       'datetime' => 'datetime', 
       'textarea' => 'text',       
       'picklist' => 'singlevaluelist', 
       'multipicklist' => 'multivaluelist',
       'boolean' => 'boolean'
   };
   
   // Initialize the list variables - Start
   global class RestResponseWrapper{
    
       public string message;
       public list<string> params = new list<string>();       
       public list<X311RequestType__c> sObjects = new list<X311RequestType__c>();
       public String requestURI = RestContext.request.requestURI;
       public Blob out;
       public boolean flag;
       public String callback;
   }
   // Initialize the list variables - End
        
   // HTTPGet Method for retrieving data for Get Service List - Start      
   @HttpGet
   global static void doGet(){  
        
        System.debug(RestContext.request);        
        RestResponseWrapper thisResponse = new RestResponseWrapper();
        thisResponse = output();
        System.debug(RestContext.response);
   }             
                
   global static RestResponseWrapper output(){    
    
       RestResponseWrapper thisResponse = new RestResponseWrapper();
       String jurisdictionID = RestContext.request.params.get('jurisdiction_id');
       thisResponse.callback = RestContext.request.params.get('callback');
       /*
       Are we doing anything with jurisdictions?  If not, wouldn't it
       be better to ignore the parameter?  Then maintenance programmers
       wouldn't have to wonder why it's used later-on in the code.
       
       Also, accessing parameters should be more consistent.  Should they be fetched from the RestRequest 
       or fetched from the RestResponseWrapper?
       
       A better pattern would be to create a RestResponseWrapper constructor that takes
       a RestRequest as a parameter, or maybe both the RestRequest and the RestResponse
       */
       
       list<string> uriParts = RestContext.request.requestUri.split('/');
       system.debug('uriParts');
       system.debug(uriParts);
       
       system.assert(uriParts.size() > 1, 'Too few URI parts in ' + uriParts);
       string jsonOrXml = uriParts[uriParts.size() - 1].tolowercase();
       
       /*
       Actually, there should be /at least/ three uri parts, v2, services, and json|xml.
       
       Guard clauses should be placed at the top of this method throwing exceptions when
       o uriparts.size < 3 (anything less is an err)
       o uriparts[uriparts.size() - 1] is not 'json' or 'xml' (it can only be one of the two)
       
       With the guard clause in-place, we needn't worry about whether the values exist
       or not later-on in the code.
       */
       
        Set <String> paramset1 = new Set<String>();
        Set <String> paramset = new Set<String>();
        paramset1 = RestContext.request.params.keySet();
        
        for(string s : paramset1)    {
            if(!s.equalsIgnoreCase('callback'))
                paramset.add(s);
        }
        
        RestResponseWrapper newthisResponse = new RestResponseWrapper();
        newthisResponse.params = getRestParams(thisResponse.requestURI);
           
        /*
        I'm confused why there's both a thisResponse and a newthisResponse.  Having
        both, so indistinguishbly named, makes the code confusing to read.  In the
        end, thisResponse is what's returned, so I wonder what newthisResponse is used 
        for.
        */  
   
        
        
        Set<String> notExposedServiceCode = new Set<String>(); 
        Set<String> serviceCode = new Set<String>(); 
        Set<String> jId= new Set<String>();
        Boolean metadataFlag = FALSE;
         
        for (X311RequestType__c each : [Select Service_Code__c from X311RequestType__c])                 
           serviceCode.add(each.Service_Code__c);
       
        for (X311RequestType__c each : [Select Service_Code__c from X311RequestType__c where Metadata__c = FALSE])                 
           notExposedServiceCode.add(each.Service_Code__c);

        String category = null;
        thisResponse.flag = false;
        
        /*
        What is category?  Could a better name be used?
        What is "flag" used for?  I can't tell anything from the name.
        */

        if (newthisResponse.params.size() == 2 && newthisResponse.params[1] == jsonOrXml){
            category = newthisResponse.params[0];
            thisResponse.flag=true;
        }
      
        integer temp=0;
        
        try{  
            
        /*
        if we already complained (thew an exception) about jsonOrXml not being either
        'json' or 'xml' we wouldn't have to test its value below.
        */                 
           if (paramset.isEmpty()){ 
               if (serviceCode.contains(category)){
                   if (!notExposedServiceCode.contains(category)) {   
                       if (jsonOrXml == 'xml' || jsonOrXml == 'json') {
                           temp=1;
                           thisResponse.out = getQuery(category, jsonOrXml, thisResponse.callback);
                       }
                       else if (jsonOrXml != 'xml' && jsonOrXml != 'json') {
                       
                           throw new ApplicationException();
                       }
                   }
                   else {
                       metadataFlag = TRUE;
                       throw new ApplicationException();                           
                   }    
               }
               else if(thisResponse.flag==true){    
                   
                   throw new ApplicationException();   
               }
               else {                       
                    temp=0;
                    
                    /*
                    So we're selecting fro X311RequestType__c again, getting the same fields
                    as the SELECT above.  Under what conditions would the field list
                    or discrimination be different between the two?  If never, then they 
                    probably shouldn't be separate statements.
                    */
                    
                    thisResponse.sObjects = [
                        SELECT  Service_Code__c,Case_RecordTypeId__c, Name, Description__c, 
                                metadata__c, Request_Category__c,
                                Keywords__c,Department__c  
                          FROM  X311RequestType__c  
                         ORDER  BY Service_Code__c
                    ];
               }
           }
                
           // Calling the formatResponse method for printing output
           if(temp==0)
               RestContext.response.responseBody = formatResponse(thisResponse,jsonOrXml);
           else
               RestContext.response.responseBody = thisResponse.out;
              
           if (thisResponse.sObjects.isEmpty() == false){
                
               if(paramset.isEmpty() == false)                                   
                   throw new ApplicationException();                                
           }    
                
           if((thisResponse.sObjects.isEmpty())&&(thisResponse.out==null))
               throw new ApplicationException();                                                
                
           return (thisResponse);       
       }
       catch(exception e){   // catch Exception if required parameters are 'Not Provided' or 'Not Found' 
         
           String code;
           String message1 = 'Missing/Invalid jurisdictionID and content-type';
           String message2 = 'Missing or Invalid content_type';            
           String message3 = 'Jurisdiction_id provided was not found';
           String message4 = 'Jurisdiction id was not provided';
           String message5 = 'Missing or Invalid Service_code';
           String message6 = 'Missing/Invalid Service_code and content-type';
           String message7 = 'Metadata not exposed for the service code provided';
           ApplicationException a = new ApplicationException();
           
           /*
           When jsonOrXml is json, isn't the reply always supposed to be application/json?
           And when it's 'xml' won't the response always be xml?  Why not set Content-type
           once (at the top) then NOT set it inside every conditional statement
           below?
           */
           
           if (metadataFlag)    {  
           
               code = '404';
               thisResponse.message = message7+code;
               
               if (jsonOrXml == 'json'){                
                   if(thisResponse.callback == null)                                          
                       RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                   else
                       RestContext.response.addHeader('Content-Type','application/javascript'); 
                   RestContext.response.responseBody = a.vxmlException(message7,code,jsonOrXml,thisResponse.callback);                           
               }
               else {
                   RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
                   RestContext.response.responseBody = a.vxmlException(message7,code,jsonOrXml,thisResponse.callback);
               }
           }

           else if(thisResponse.flag == true && thisResponse.out == null){  
                                                                               
               if(jsonOrXml == 'xml'){
                                        
                   code = '404';
                   thisResponse.message = message5+code;
                   RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
                   RestContext.response.responseBody = a.vxmlException(message5,code,jsonOrXml,thisResponse.callback);
               }
               else if(jsonOrXml == 'json'){ 
                                                         
                   code = '404';
                   thisResponse.message = message5+code;
                   if(thisResponse.callback == null)                                          
                       RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                   else
                       RestContext.response.addHeader('Content-Type','application/javascript'); 
                   RestContext.response.responseBody = a.vxmlException(message5,code,jsonOrXml,thisResponse.callback);                           
               }
               else if(jsonOrXml != 'json' && jsonOrXml != 'xml'){   
                       
                   code = '400';
                   thisResponse.message = message2+code;
                   RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
                   XmlStreamWriter writer = new XmlStreamWriter();
                   RestContext.response.responseBody = a.vxmlException(message2,code,jsonOrXml,thisResponse.callback);
               }  
           }
           else if(thisResponse.sObjects.size() != 0){  
                                      
               if(jsonOrXml != 'json' && jsonOrXml != 'xml'){
                           
                   code = '400';
                   thisResponse.message = message2+code;
                   RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
                   XmlStreamWriter writer = new XmlStreamWriter();
                   RestContext.response.responseBody = a.vxmlException(message2,code,jsonOrXml,thisResponse.callback);
               }           
           }
           else if(thisResponse.sObjects.isEmpty() && thisResponse.out== null){  
                
               if(serviceCode.contains(category) && category != null){
                   
                   if(jsonOrXml == 'xml'){
                                        
                       code = '404';
                       thisResponse.message = message5+code;
                       RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
                       RestContext.response.responseBody = a.vxmlException(message5,code,jsonOrXml,thisResponse.callback);
                                
                   }
                   else if(jsonOrXml == 'json'){
                                        
                       code = '404';
                       thisResponse.message = message5+code;
                       if(thisResponse.callback == null)                                          
                           RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                       else
                           RestContext.response.addHeader('Content-Type','application/javascript'); 
                       RestContext.response.responseBody = a.vxmlException(message5,code,jsonOrXml,thisResponse.callback);                           
                                    
                   }
                   else if(jsonOrXml != 'json' && jsonOrXml != 'xml'){    
                                                                                    
                       code = '400';
                       thisResponse.message = message2+code;
                       RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
                       XmlStreamWriter writer = new XmlStreamWriter();
                       RestContext.response.responseBody = a.vxmlException(message2,code,jsonOrXml,thisResponse.callback);
                   }
               }
                           
           }
           else if((thisResponse.sObjects.isEmpty()) && ((jurisdictionID != null) || (jurisdictionID != ' '))){ 
                                              
               if(jsonOrXml == 'xml'){
                                
                   code = '404';
                   thisResponse.message = message3+code;
                   RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
                   RestContext.response.responseBody = a.vxmlException(message3,code,jsonOrXml,thisResponse.callback);
               }
               else if(jsonOrXml == 'json'){
                                
                   code = '404';
                   thisResponse.message = message3+code;
                   if(thisResponse.callback == null)                                          
                       RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                   else
                       RestContext.response.addHeader('Content-Type','application/javascript'); 
                   RestContext.response.responseBody = a.vxmlException(message3,code,jsonOrXml,thisResponse.callback);                           
               }
               else{   
                    
                   code = '400';
                   thisResponse.message = message1+code;
                   RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
                   RestContext.response.responseBody = a.vxmlException(message1,code,jsonOrXml,thisResponse.callback);
               }
           }
           else if(thisResponse.sObjects.isEmpty() && (paramset.isEmpty() == false)){                                             
                    
               if(paramset.contains('jurisdiction_id') == false){
                         
                   if(jsonOrXml == 'xml'){
                                
                       code = '404';
                       thisResponse.message = message3+code;
                       RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
                       RestContext.response.responseBody = a.vxmlException(message3,code,jsonOrXml,thisResponse.callback);
                   }
                   else if(jsonOrXml == 'json'){
                               
                       code = '404';
                       thisResponse.message = message3+code;
                       if(thisResponse.callback == null)                                          
                           RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
                       else
                           RestContext.response.addHeader('Content-Type','application/javascript'); 
                       RestContext.response.responseBody = a.vxmlException(message3,code,jsonOrXml,thisResponse.callback);  
                   }                                
               } 
           }
           else if(thisResponse.out != null){
                                                            
               code = '404';
               thisResponse.message = message3+code;
               if(thisResponse.callback == null)                                          
                   RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
               else
                   RestContext.response.addHeader('Content-Type','application/javascript'); 
               RestContext.response.responseBody = a.vxmlException(message3,code,jsonOrXml,thisResponse.callback);
           }
           else if(jsonOrXml!='xml'&&jsonOrXml!='json'){
               code = '400';
               thisResponse.message = message2+code;
               RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
               XmlStreamWriter writer = new XmlStreamWriter();
               RestContext.response.responseBody = a.vxmlException(message2,code,jsonOrXml,thisResponse.callback);                
           }    
           /*  
           else if(RestContext.request.requestURI.contains('.xml') || RestContext.request.requestURI.contains('.json')){     
               
               e.getMessage();
               RestContext.response.responseBody = a.vxmlException(e.getMessage(),code,jsonOrXml);
           } 
           */                            
           //      End Of catch block   
       }  
               
       return (thisResponse);                             
   } 
   
   // HTTPGet call for retrieving data for Get Service List - Start         
   global static list<string> getRestParams(string url){
            
       list<string> returnParams = new list<string>();
       integer endOfUrl = url.indexOf('?');
           
       if(endOfUrl == -1){                
        
           endOfUrl = url.length();
       }
       
       if(url.indexOf('/services/') > 0){                
        
           url = url.substring(url.indexOf('/services/')+10,endOfUrl);
       }
       else{
                
           url = url.substring(1,endOfUrl);
       }            
       list<String> URLParams = url.split('/'); 
             
       for(integer i = 0; i < 2; i++){
                
           if(i<urlParams.size()){
               
               returnParams.add(EncodingUtil.urlDecode(urlParams[i], 'UTF-8'));
           }
           else{
               
               returnParams.add(' ');
           }
       }   
       return returnParams;           
   }        
   // HTTPGet call for retrieving data for Get Service List - End
     
   // Method for Response formatting for Get Service List - Start   
   public static blob formatResponse(restResponseWrapper thisResponse, string jsonOrXml) {
        system.debug(thisResponse);
        system.debug('jsonOrXml = ' + jsonOrXml);

        String response;
   
        if (jsonOrXml == 'xml'){   // Printing for XML type
            
           RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
           XmlStreamWriter writer = new XmlStreamWriter();
           writer.writeStartDocument('UTF-8','1.0');
           writer.writeStartElement(null,'services',null);
           
           for(X311RequestType__c eachAccount: thisResponse.sObjects){
    
               writer.writeStartElement(null,'service',null);  
               writer.writeStartElement(null,'service_code',null);
               writer.writeCharacters(String.valueOf(eachAccount.Service_Code__c));
               writer.writeEndElement();
               
               writer.writeStartElement(null,'service_name',null);                 
               if(eachAccount.Name == null || eachAccount.Name == '')                             
                   writer.writeCharacters(' ');                                 
               else                               
                   writer.writeCharacters(String.Valueof(eachAccount.Name));    
               writer.writeEndElement();
               
               writer.writeStartElement(null,'description',null);
               if(eachAccount.Description__c == null || eachAccount.Description__c == '')                            
                   writer.writeCharacters(' ');                            
               else                                   
                   writer.writeCharacters(String.Valueof(eachAccount.Description__c));                                   
               writer.writeEndElement();

               writer.writeStartElement(null,'metadata',null);
               writer.writeCharacters(String.ValueOf(eachAccount.metadata__c)); 
               writer.writeEndElement();

               writer.writeStartElement(null,'type',null);
               writer.writeCharacters('realtime');
               /*if(eachAccount.Request_Category__c == null || eachAccount.Request_Category__c == '')                              
                   writer.writeCharacters(' ');                                 
               else                                  
                   writer.writeCharacters(String.Valueof(eachAccount.Request_Category__c));*/   
               writer.writeEndElement();
                 
               writer.writeStartElement(null,'keywords',null);
               if(eachAccount.Keywords__c == null || eachAccount.Keywords__c == '')                                
                   writer.writeCharacters(' ');                                 
               else                                         
                   writer.writeCharacters(String.Valueof(eachAccount.Keywords__c)); 
               writer.writeEndElement();

               writer.writeStartElement(null,'group',null);
               if(eachAccount.Department__c == null || eachAccount.Department__c == '')                                    
                    writer.writeCharacters(' ');                                  
               else                                    
                    writer.writeCharacters(String.Valueof(eachAccount.Department__c));      
               writer.writeEndElement();
               
               writer.writeEndElement();
           }
            
           writer.writeEndElement();
           writer.writeEndDocument();
           response = writer.getXmlString();
           writer.close();
        
       }
       else if(jsonOrXml == 'json'){    // Printing for JSON type 
             
           if(thisResponse.callback == null)                                          
               RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
           else
               RestContext.response.addHeader('Content-Type','application/javascript');   
               
           JSONGenerator gen = JSON.createGenerator(true); 
           gen.writeStartArray();
               
           for(X311RequestType__c a : thisResponse.sObjects){

               gen.writeStartObject(); 
               gen.writeObjectField('service_code',a.Service_Code__c);
               
               if(a.Name == null || a.Name == '')
                   a.Name = 'null';                
               gen.writeObjectField('service_name',a.Name);
               
               if(a.Description__c == null || a.Description__c == '')
                   a.Description__c = 'null';                
               gen.writeObjectField('description',a.Description__c);
               
               gen.writeBooleanField('metadata',a.metadata__c);
               
               if(a.Request_Category__c == null || a.Request_Category__c == '')
                   a.Request_Category__c = 'null';                
             //  gen.writeObjectField('type',a.Request_Category__c);
               gen.writeObjectField('type','realtime');
               
               if(a.Keywords__c == null || a.Keywords__c == '')
                   a.Keywords__c = 'null';
               gen.writeObjectField('keywords',a.Keywords__c);

               if(a.Department__c == null || a.Department__c == '')
                   a.Department__c = 'null';
               gen.writeObjectField('group',a.Department__c);          
               
               gen.writeEndObject();
           }
           gen.writeEndArray();
           response = gen.getAsString();
           if(thisResponse.callback != null)    {
               response = thisResponse.callback + '(' + response + ');';
           }  
           response = response.replace('{','\n {');
           response = response.replace('" : "','":"');
           response = response.replace('" : ','":');
           response = response.replace('}',' }');
           response = response.replace(']','\n]');  
           response = response.replace('"null"','null');                                              
       }   
       return blob.valueOf(response);
   }
        
   global static Blob getQuery(String category,String jsonOrXml, String callback){            
            
       String response;
       integer order=0;
       GetServiceDefinitionDetails details= new GetServiceDefinitionDetails();
       Schema.DescribeSObjectResult r = Case.sObjectType.getDescribe();
       Map<String,Schema.SObjectField> M = r.fields.getMap();
       list<String> fieldList = new list<String>();
       Map<String,String> fieldCode = new Map<String,String>(); 
             
       if(jsonOrXml=='xml'){
        
           RestContext.response.addHeader('Content-Type','text/xml; charset=utf-8');
           XmlStreamWriter writer = new XmlStreamWriter();
           writer.writeStartDocument('UTF-8','1.0');
           writer.writeStartElement(null,'service_definition',null);
           writer.writeStartElement(null,'service_code',null);
           writer.writeCharacters(category);
           writer.writeEndElement();
           writer.writeStartElement(null,'attributes',null);
                     
           for(String fieldName : M.keySet()){
     
               Schema.SObjectField field = M.get(fieldName);
               Schema.DescribeFieldResult F = field.getDescribe();
               Schema.DisplayType dType = F.getType();
               String description = F.getLabel();
               fieldList = details.fieldList(category);  
               fieldCode = details.fieldListCode(category);       
               String name = F.getName();             
               String isFieldreq  = '';
               
               for(String temp: fieldList ){
        
                   if(fieldName==temp){
                       isFieldreq = details.fieldListNotReqd(category, fieldCode.get(temp));
                       order++;  
                       writer.writeStartElement(null,'attribute',null);
                       writer.writeStartElement(null,'variable',null);    
                       
                       if(fieldName=='Case Id')                                              
                            writer.writeCharacters('false');
                       else
                           writer.writeCharacters('true');
                           
                       writer.writeEndElement();
                       writer.writeStartElement(null,'code',null);                                                  
                       writer.writeCharacters(fieldCode.get(temp));
                       writer.writeEndElement();
                       writer.writeStartElement(null,'datatype',null);
                       writer.writeCharacters(String.valueOf(dType).toLowerCase());                       
                       writer.writeEndElement();
                       writer.writeStartElement(null,'required',null);                                                  
                       writer.writeCharacters(String.valueOf(isFieldreq)); 
                       writer.writeEndElement();
                       writer.writeStartElement(null,'datatype_description',null);                                                  
                       writer.writeCharacters(details.getDatatypeDescription(String.valueOf(dType))); 
                       writer.writeEndElement();
                       writer.writeStartElement(null,'order',null);                                                  
                       writer.writeCharacters(String.valueOf(order)); 
                       writer.writeEndElement();
                       writer.writeStartElement(null,'description',null);                                                  
                       writer.writeCharacters(description); 
                       writer.writeEndElement();
                
                       if(String.valueOf(dType)=='PICKLIST' || String.valueOf(dType)=='MULTIPICKLIST'){
                           System.debug('Name of field ' + F.Name);
                           writer.writeStartElement(null,'values',null);
                          /* if(name.equalsIgnoreCase('Problem_Type__c')) {
                                List<ProblemType__c> ListOfFields = ProblemType__c.getall().values();
                                list<String> fields = new list<String>();
                                System.debug('LIST OF FIELDS ' + ListOfFields );
                                String allCustField = '';
                                if(ListOfFields != null && ListOfFields.size() > 0)    {
                                    for(ProblemType__c pt : ListOfFields)    {
                                        if(pt.Name.equalsIgnoreCase(category))    {
                                            allCustField = pt.PT_Values__c;            
                                            fields = allCustField.split(';');
                                            system.debug('VALUES ' + fields);
                                            }
                                        }
                                 }
                                 for(integer i=0;i< fields.size(); i++) {                                     
                                       writer.writeStartElement(null,'value',null);
                                       writer.writeStartElement(null,'key',null);
                                       writer.writeCharacters(fields[i]);
                                       writer.writeEndElement();
                                       writer.writeStartElement(null,'name',null);
                                       writer.writeCharacters(fields[i]);
                                       writer.writeEndElement();
                                       writer.writeEndElement();                                 
                                 }
                                 
                                                   
                           }
                           if(name.equals('Property_Type__c')) {
                                List<PropertyType__c> ListOfFields1 = PropertyType__c.getall().values();
                                list<String> fields1 = new list<String>();
                                String allCustField1 = '';
                                if(ListOfFields1 != null && ListOfFields1.size() > 0)    {
                                    for(PropertyType__c prop : ListOfFields1)    {
                                        if(prop.Name.equalsIgnoreCase(category))    {
                                            allCustField1 = prop.Prop_Values__c;            
                                            fields1 = allCustField1.split(';');
                                            system.debug('VALUES ' + fields1);
                                            }
                                        }
                                 }
                                 for(integer i=0;i< fields1.size(); i++) {                                     
                                       writer.writeStartElement(null,'value',null);
                                       writer.writeStartElement(null,'key',null);
                                       writer.writeCharacters(fields1[i]);
                                       writer.writeEndElement();
                                       writer.writeStartElement(null,'name',null);
                                       writer.writeCharacters(fields1[i]);
                                       writer.writeEndElement();
                                       writer.writeEndElement();                                 
                                 }
                                 
                                                   
                           }
                           if(name.equals('Violation_Type__c')) {
                                List<ViolationType__c> ListOfFields2 = ViolationType__c.getall().values();
                                list<String> fields2 = new list<String>();
                                String allCustField2 = '';
                                if(ListOfFields2 != null && ListOfFields2.size() > 0)    {
                                    for(ViolationType__c vt : ListOfFields2)    {
                                        if(vt.Name.equalsIgnoreCase(category))    {
                                            allCustField2 = vt.VT_Values__c;            
                                            fields2 = allCustField2.split(';');
                                            system.debug('VALUES ' + fields2);
                                            }
                                        }
                                 }
                                 for(integer i=0;i< fields2.size(); i++) {                                     
                                       writer.writeStartElement(null,'value',null);
                                       writer.writeStartElement(null,'key',null);
                                       writer.writeCharacters(fields2[i]);
                                       writer.writeEndElement();
                                       writer.writeStartElement(null,'name',null);
                                       writer.writeCharacters(fields2[i]);
                                       writer.writeEndElement();
                                       writer.writeEndElement();                                 
                                 }
                                 
                                                   
                           }*/
                           if((name != 'Violation_Type__c') && (name!= 'Property_Type__c') && (name!='Problem_Type__c')) {
                           List<Schema.PicklistEntry> pickList = F.getPicklistValues();
                           String value,label,isActive;
                           for(integer i=0 ;i< pickList.size() ;i++){
                      
                               value = string.ValueOf(pickList.get(i));
                               label = value.subString(value.indexOf('getLabel')+9,value.indexOf(';getValue'));
                               value = value.subString(value.indexOf('getValue')+9,value.indexOf(';isActive'));
                               writer.writeStartElement(null,'value',null);
                               writer.writeStartElement(null,'key',null);
                               writer.writeCharacters(value);
                               writer.writeEndElement();
                               writer.writeStartElement(null,'name',null);
                               writer.writeCharacters(value);
                               writer.writeEndElement();
                               writer.writeEndElement();
                           }
                          } 
                           writer.writeEndElement();
                       }
                       writer.writeEndElement();   
                   }
               }
           }
           writer.writeEndElement();
           writer.writeEndElement();
           writer.writeEndDocument();
           response= writer.getXmlString();
           writer.close();
       }
       else if(jsonOrXml=='json'){
                        
           if(callback == null)                                          
               RestContext.response.addHeader('Content-Type','application/json; charset=utf-8');
           else
               RestContext.response.addHeader('Content-Type','application/javascript'); 
           JSONGenerator writer = JSON.createGenerator(true); 
           writer.writeStartObject();
           writer.writeObjectField('service_code',category);
           writer.writeFieldName('attributes');
           writer.writeStartArray();
             
           for(String fieldName : M.keySet()){
                  
               Schema.SObjectField field = M.get(fieldName);
               Schema.DescribeFieldResult F = field.getDescribe();
               String isFieldreq = '';  
               Schema.DisplayType dType = F.getType();
               String dTypemap = dataTypeMapping.get(String.valueOf(dType).toLowerCase());
               if(dTypemap == null)
                   dTypemap = String.valueOf(dType).toLowerCase();
               String description = F.getLabel();
               fieldList = details.fieldList(category);
               fieldCode = details.fieldListCode(category); 
               String name = F.getName();
               for(String temp: fieldList ){
             
                   if(fieldName == temp){
                         
                       isFieldreq = details.fieldListNotReqd(category, fieldCode.get(temp));
                       order++; 
                       writer.writeStartObject();
                       
                       if(fieldName=='Case Id')            
                           writer.writeObjectField('variable', Boolean.valueOf('false'));
                       else
                           writer.writeObjectField('variable', Boolean.valueOf('true'));
                       
                       writer.writeObjectField('code',fieldCode.get(temp));                   
                       writer.writeObjectField('datatype', dTypemap );
                       writer.writeObjectField('required', Boolean.valueOf(isFieldreq));
                       writer.writeObjectField('datatype_description', details.getDatatypeDescription(String.valueOf(dType)));
                       writer.writeNumberField('order', Integer.valueOf(order));
                       writer.writeObjectField('description', description); 
                     
                       if(String.valueOf(dType)=='PICKLIST' || String.valueOf(dType)=='MULTIPICKLIST'){
                     
                           writer.writeFieldName('values');
                           writer.writeStartArray();
                           /* if(name.equals('Problem_Type__c')) {
                                List<ProblemType__c> ListOfFields = ProblemType__c.getall().values();
                                list<String> fields = new list<String>();
                                String allCustField = '';
                                if(ListOfFields != null && ListOfFields.size() > 0)    {
                                    for(ProblemType__c pt : ListOfFields)    {
                                        if(pt.Name.equalsIgnoreCase(category))    {
                                            allCustField = pt.PT_Values__c;            
                                            fields = allCustField.split(';');
                                            system.debug('VALUES ' + fields);
                                            }
                                        }
                                 }
                                 for(integer i=0;i< fields.size(); i++) {   
                                       writer.writeStartObject();
                                       writer.writeObjectField('key', fields[i]);
                                       writer.writeObjectField('name', fields[i]);
                                       writer.writeEndObject();
                                 }
                              } 
                              if(name.equals('Property_Type__c')) {
                                List<PropertyType__c> ListOfFields1 = PropertyType__c.getall().values();
                                list<String> fields1 = new list<String>();
                                String allCustField1 = '';
                                if(ListOfFields1 != null && ListOfFields1.size() > 0)    {
                                    for(PropertyType__c prop : ListOfFields1)    {
                                        if(prop.Name.equalsIgnoreCase(category))    {
                                            allCustField1 = prop.Prop_Values__c;            
                                            fields1 = allCustField1.split(';');
                                            system.debug('VALUES ' + fields1);
                                            }
                                        }
                                 }
                                 for(integer i=0;i< fields1.size(); i++) {
                                       writer.writeStartObject();
                                       writer.writeObjectField('key', fields1[i]);
                                       writer.writeObjectField('name', fields1[i]);
                                       writer.writeEndObject();
                                 }
                                } 
                           if(name.equals('Violation_Type__c')) {
                                List<ViolationType__c> ListOfFields2 = ViolationType__c.getall().values();
                                list<String> fields2 = new list<String>();
                                String allCustField2 = '';
                                if(ListOfFields2 != null && ListOfFields2.size() > 0)    {
                                    for(ViolationType__c vt : ListOfFields2)    {
                                        if(vt.Name.equalsIgnoreCase(category))    {
                                            allCustField2 = vt.VT_Values__c;            
                                            fields2 = allCustField2.split(';');
                                            system.debug('VALUES ' + fields2);
                                            }
                                        }
                                 }
                                 for(integer i=0;i< fields2.size(); i++) {                                     
                                       writer.writeStartObject();
                                       writer.writeObjectField('key', fields2[i]);
                                       writer.writeObjectField('name', fields2[i]);
                                       writer.writeEndObject();      
                                }  
                             }     */
                           if((name != 'Violation_Type__c') && (name!= 'Property_Type__c') && (name!='Problem_Type__c')) {                                                 
                           List<Schema.PicklistEntry> pickList = F.getPicklistValues();
                           String value,label;
                           
                           for(integer i=0 ;i< pickList.size() ;i++){
                               
                               value = string.ValueOf(pickList.get(i));
                               label = value.subString(value.indexOf('getLabel')+9,value.indexOf(';getValue'));
                               value = value.subString(value.indexOf('getValue')+9,value.indexOf(';isActive'));                                                    
                               writer.writeStartObject();
                               writer.writeObjectField('key', value);
                               writer.writeObjectField('name', value);
                               writer.writeEndObject();               
                           }
                          } 
                           writer.writeEndArray();           
                       }                       
                       writer.writeEndObject();     
                   }
               }       
           }
           writer.writeEndArray();
           String jsonOutput = writer.getAsString();
           jsonOutput = writer.getAsString(); 
           jsonOutput = jsonOutput.replace('[','[\n');
           jsonOutput = jsonOutput.replace('" : "','":"');
           jsonOutput = jsonOutput.replace('" : ','":');
           jsonOutput = jsonOutput.replace(']','\n  ]');  
           jsonOutput = jsonOutput.replace('}, {','},\n{');  
           jsonOutput = jsonOutput.replace('{','  {');
           jsonOutput = jsonOutput.replace('}',' }');                                        
           response = jsonOutput;
           if(callback != null)    {
               response = callback + '(' + response + ' );';
           }
       }
       else
           throw new ApplicationException();
       return blob.valueOf(response);    
   }     
   // Response formatting for Get Service List - End
   
}