global without sharing class TrendingSnapshotsController {
    
    public static final String API_VERSION = 'v36.0';
    public static final String DATE_FORMAT = 'yyyy/MM/dd';    
    
    global String orgURL{get; set;}
     
    global TrendingSnapshotsController() {
        String forwardedHeader = ApexPages.currentPage().getHeaders().get('X-Salesforce-Forwarded-To');
        orgURL = 'https://' + ((forwardedHeader == null) ? ApexPages.currentPage().getHeaders().get('host') : forwardedHeader);            
    }       
    
    @RemoteAction
    global static List<Object> getDataExtract(String extractType, String orgURL){
            
        String query;
        //create query for getting data extract for Existing Dataset drop down
        if(extractType == 'All') {
            query = 'SELECT Id, Dataset_Name__c, Timestamp__c, Timestamp_String__c FROM Data_Extract__c';
        } else {//create query for getting data extracts for tabs in left panel
            query = 'SELECT Id, Dataset_Name__c, Timestamp__c, Timestamp_String__c FROM Data_Extract__c WHERE Type__c = \'' + extractType + '\'';
        }
        
        //Call rest api to get result of the SOQL query
        HttpRequest req = new HttpRequest();
        req.setEndpoint(orgURL + '/services/data/' + TrendingSnapshotsController.API_VERSION + '/query/?q=' + EncodingUtil.urlEncode(query, 'UTF-8'));
        req.setMethod('GET');
        string autho = 'Bearer '+ userInfo.getsessionId();
        req.setHeader('Authorization', autho);
        Http http = new Http();
        
        if(!Test.isRunningTest()) {
            HTTPResponse res = http.send(req);
            String response = res.getBody();
            
            Map<String, Object> objectDetails = (Map<String, Object>)JSON.deserializeUntyped(response);
            return (List<Object>)objectDetails.get('records');
        } else {   
            return new List<Object>();
        }
    }
    
    @RemoteAction
    global static List<DataExtractWrapper> getSobjectList(){
        
        List<DataExtractWrapper> sObjectList = new List<DataExtractWrapper>();
        List<Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe().Values();   
          
        for(Schema.SObjectType sObjectType : globalDescribe){
           sObjectList.add(new DataExtractWrapper(sObjectType.getDescribe().getName(), sObjectType.getDescribe().getLabel()));
        }
        return sObjectList;
    }
        
    @RemoteAction
    global static List<DataExtractWrapper> getSobjectDetail(String sObjectName) {
        
        List<DataExtractWrapper> sObjectFieldList = new List<DataExtractWrapper>();
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(sObjectName);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        for (String fieldName: fieldMap.keySet()) {  
            sObjectFieldList.add(new DataExtractWrapper(fieldName, fieldMap.get(fieldName).getDescribe().getLabel()));
        }
        return sObjectFieldList;
    }
    
    //method to delete the data extract
    @RemoteAction
    global static boolean deleteExtract(String extractId){
        try {
            String batchJobId;
            for(Data_Extract__c tempExtract : [SELECT Batch_Job_Id__c FROM Data_Extract__c WHERE Id =: extractId]) {
                batchJobId = tempExtract.Batch_Job_Id__c;
            }
            
            for(CronTrigger cTrigger : [SELECT ID FROM CronTrigger WHERE ID =: batchJobId]) {
                System.abortJob(batchJobId);
            }            

            delete new Data_Extract__c(Id = extractId);            
        } catch(DMLException e) {
            return false;
        }
        return true;
    }
    
    //method to disable the scheduled data extract
    @RemoteAction
    global static boolean disableExtract(String extractId){
        try {
            update new Data_Extract__c(Id = extractId, Active__c = false);
            String batchJobId;
            for(Data_Extract__c tempExtract : [SELECT Batch_Job_Id__c FROM Data_Extract__c WHERE Id =: extractId]) {
                batchJobId = tempExtract.Batch_Job_Id__c;
            }
            
            for(CronTrigger cTrigger : [SELECT ID FROM CronTrigger WHERE ID =: batchJobId]) {
                System.abortJob(batchJobId);
            }
        } catch(DMLException e) {
            return false;
        }
        return true;
    }
    
    //get all data extract to show in Existing Extracts tab
    @RemoteAction
    global static List<Object> getAllDataExtract(String orgURL) {
        
        String query = 'SELECT Id, Dataset_Name__c, Name, Type__c, Metadata__c, Active__c,' +
            'Schedule__c, Operation__c, Time_Interval__c, Day_Date_Selector__c, Report_Id__c,' +
            'Report_Name__c, SOQL_Query__c, oData_URL__c, oData_Object__c, oData_Object_href__c,' +
            'CreatedDate, Timestamp__c, Timestamp_String__c, Batch_Job_Id__c FROM Data_Extract__c ORDER BY CreatedDate DESC';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(orgURL + '/services/data/' + TrendingSnapshotsController.API_VERSION + '/query/?q=' + EncodingUtil.urlEncode(query, 'UTF-8'));
        req.setMethod('GET');
        string autho = 'Bearer '+ userInfo.getsessionId();
        req.setHeader('Authorization', autho);
        Http http = new Http();
        
        if(!Test.isRunningTest()) {
            HTTPResponse res = http.send(req);
            String response = res.getBody();
            
            Map<String, Object> objectDetails = (Map<String, Object>)JSON.deserializeUntyped(response);
            return (List<Object>)objectDetails.get('records');
        } else { 
            return new List<Object>();
        }
    }
    
    //method to populate the reports drop down values to select
    @RemoteAction
    global static List<Object> getReportList(String orgURL){

        String query = 'SELECT id, name FROM Report WHERE Format=\'Tabular\' ORDER BY Name';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(orgURL + '/services/data/' + TrendingSnapshotsController.API_VERSION + '/query/?q=' + EncodingUtil.urlEncode(query, 'UTF-8'));
        req.setMethod('GET');
        string autho = 'Bearer '+ userInfo.getsessionId();
        req.setHeader('Authorization', autho);
        
        if(!Test.isRunningTest()) {
            Http http = new Http();
            HTTPResponse res = http.send(req);
            String response = res.getBody();
            
            Map<String, Object> objectDetails = (Map<String, Object>)JSON.deserializeUntyped(response);
            return (List<Object>)objectDetails.get('records');
        } else { 
            return new List<Object>();
        }
    }
    
    //this method will populate values in oData Object drop down
    @RemoteAction
    global static List<DataExtractWrapper> addValuesTooDataObjectList(String oDataURL) {   
        try{
            if(oDataURL == null || oDataURL == '') {    
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error,  'oData URL must be filled'));
                return null;
            }
            
            // Create remote site setting for the URL
            String remoteSiteSettingName;
            List<String> tempRemoteList = oDataURL.replace('http://', '').replace('https://', '').split('/');
            if(tempRemoteList.size() > 0) {
                remoteSiteSettingName = tempRemoteList[0].replace('.', '_');
            }
            
            CreateRemoteSiteSetting.createRemoteSiteSettings(remoteSiteSettingName, oDataURL);
            List<DataExtractWrapper> oDataObjectList = new List<DataExtractWrapper>();
            
            if(oDataURL != null && oDataURL != '') {
                
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(oDataURL);
                req.setMethod('GET');
                req.setHeader('Accept', 'application/xml');
                
                HttpResponse res;
                Dom.Document doc;
                Dom.XMLNode xmlFeed;
                
                if(!Test.isRunningTest()){
                    res = h.send(req); 
                    doc = new DOM.Document();
                    doc.load(res.getBody());  
                } else {  
                    doc = new Dom.Document();
                    doc.load(TrendingSnapshotsMockSOQLResponse.getDummyObjectXMLoData());
                    xmlFeed = doc.getRootElement();
                } 
                
                DOM.XMLNode root = doc.getRootElement();
                String objectName = '';
                
                for (Dom.XMLNode child : root.getChildElements()){
                   if(child.getNodeType() == DOM.XMLNodeType.ELEMENT && child.getName() == 'workspace') {
                       for (Dom.XMLNode nextChild : child.getChildElements()){
                           if(nextChild.getName() == 'collection') {
                               objectName = nextChild.getChildElements()[0].getText().trim();
                               oDataObjectList.add(new DataExtractWrapper(nextChild.getAttributeValue('href', null), objectName));
                           }
                       }
                   }
                }
            }
            return oDataObjectList;
            
        } catch(Exception e) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error,  e.getMessage()));
           return null;
        }
    }
    
    //Method to generate SOQL row response
    @RemoteAction
    global static String getSOQLRowResponse(String query, String orgURL) {
        
        try {
            //Create list of field's api names
            String tempQuery = query.toLowerCase();
            Pattern p = Pattern.compile('\\slimit\\s');
            Matcher m = p.matcher(tempQuery);
            if (!m.find()) {
               tempQuery = tempQuery.replace('\\s+limit\\s+\\d+','');
            }
            
            Database.query(tempQuery + ' limit 1');
                
            tempQuery = query.toLowerCase();
            List<String> queryPart = tempQuery.split('\\sfrom\\s');
            List<String> tempList = queryPart[1].split(' ');
            
            List<String> fieldAPINameSet = new List<String>();
            for(String field : queryPart[0].toLowerCase().replaceAll('\\s*select\\s+', '').split(',')) {
                fieldAPINameSet.add(field.trim());               
            }
            fieldAPINameSet.sort();
            
            String objName = tempList[0].trim();            
            return generateMetaData(objName, fieldAPINameSet, orgURL);
            
        } catch(Exception e) {
            return e.getMessage();
        }
        return null;
    }
    
    //This method will create data for oData data table
    @RemoteAction
    global static ODATAWrapper getoData(String oDataURL, String oDataHref){
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(oDataURL + '/' + oDataHref + '?$top=200');    
        req.setHeader('Accept', '*/*');
        req.setMethod('GET');
        String conType = '';
        HttpResponse res;
        
        if(!Test.isRunningTest()){
            res = h.send(req);
            conType = res.getHeader('Content-Type');
        } else {
            conType = (TrendingSnapshotsMockSOQLResponse.isJson) ? 'json' : 'xml';
        }

        ODATAWrapper oData;
        List<String> oDataFieldNameList = new List<String>();
        List<Map<String, String>> rowList = new List<Map<String, String>>();
        
        if(conType.contains('json')) {
            
            String response = '';
            if(Test.isRunningTest()) {
                response = TrendingSnapshotsMockSOQLResponse.getDummyJSONoData(); 
            } else {    
                response = res.getBody();
            }
            
            //Get object details after Deserialization of the response body
            Map<String, Object> objectDetails = (Map<String, Object>)JSON.deserializeUntyped(response);
            Map<String, String> tempValuesMap = new Map<String, String>();
            
            if(objectDetails != null && objectDetails.get('value') != null){
                    
                Map<String, Object> fieldDetails = (Map<String, Object>)(((List<Object>)objectDetails.get('value'))[0]);
                if(fieldDetails != null && oDataFieldNameList.size() == 0){
                    for(String fName : fieldDetails.keySet()){
                        oDataFieldNameList.add(fName);
                    }
                }
                
                for(Object resultRow : (List<Object>)objectDetails.get('value')) {
                    
                    Map<String, Object> tempRowDetail = (Map<String, Object>)(resultRow);
                    tempValuesMap = new Map<String, String>();
                    
                    for(String key : tempRowDetail.keySet()) {
                        key = key.replace('_', '');
                        if(tempRowDetail.get(key) != null){
                            tempValuesMap.put(key, String.valueOf(tempRowDetail.get(key)));
                        } else {
                            tempValuesMap.put(key, '');
                        }
                    }
                    rowList.add(tempValuesMap);
                }
            }
            
        } else {
            
            Map<String, String> tempValuesMap = new Map<String, String>();            
            Dom.Document doc;
            Dom.XMLNode xmlFeed;
            
            if(!Test.isRunningTest()){
                res = h.send(req); 
                doc = res.getBodyDocument();
                xmlFeed = doc.getRootElement();
            } else {
                doc = new Dom.Document();
                doc.load(TrendingSnapshotsMockSOQLResponse.getDummyXMLoData());
                xmlFeed = doc.getRootElement();
            } 
            
            for(Dom.XMLNode child : xmlFeed.getChildElements()) {
               if(child.getName() == 'entry') {
                   for(Dom.XMLNode innerChild : child.getChildElements()) {
                       if(innerChild.getName() == 'content') {
                           for(Dom.XMLNode internalChild : innerChild.getChildElements()) {
                               if(internalChild.getName() == 'properties') {
                                   
                                   tempValuesMap = new Map<String, String>();
                                   for(Dom.XMLNode dataChild : internalChild.getChildElements()){                                         
                                       tempValuesMap.put(dataChild.getName().replace('_', ''), '');
                                       if(dataChild.getText() != null) {
                                           tempValuesMap.put(dataChild.getName().replace('_', ''), dataChild.getText());
                                       }
                                   }
                               }
                           }
                           
                           if(oDataFieldNameList.size() == 0){
                               oDataFieldNameList.addAll(tempValuesMap.keySet());
                           }
                           
                           rowList.add(tempValuesMap);
                       }
                   }
               }
            }
        }
        oData = new ODATAWrapper(oDataFieldNameList, rowList);
        return oData;
    }  
    
    //Wrapper class to be used for oData "Run Now" data table result
    global class ODATAWrapper{
        global List<String> columns;
        global List<Map<String, String>> dataRows;
        
        global ODATAWrapper(List<String> columns, List<Map<String, String>> dataRows){
            this.columns = columns;
            this.dataRows = dataRows;
        }
    }
    
    //This method will generate Metadata JSON for oData type Data Extract
    @RemoteAction
    global static String getExternalObjectMetaData(String oDataObjName, String oDataURL, String objectHref){
        try {
            
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(oDataURL + '/$metadata/');
            req.setMethod('GET');
            req.setHeader('Accept', 'application/xml');
            HttpResponse res;
            Dom.Document doc;
            Dom.XMLNode xmlFeed;
            
            if(!Test.isRunningTest()) {
                res = h.send(req); 
                doc = res.getBodyDocument();
                xmlFeed = doc.getRootElement();
            } else {  
                doc = new Dom.Document();
                doc.load(TrendingSnapshotsMockSOQLResponse.getDummyJSONoDataMedataDetails());
                xmlFeed = doc.getRootElement();
            }
            
            //Get FiscalMonthOffset value
            Integer orgFiscalMonth = 1;
            for(Organization org : [SELECT FiscalYearStartMonth FROM Organization]){
                orgFiscalMonth = org.FiscalYearStartMonth;
            }
            
            Integer fiscalMonthOffset = orgFiscalMonth -1;
            
            //Wrapper class variables for different type of data type
            TextFieldWrapper tempTextFieldDetail;
            NumericFieldWrapper tempNumericFieldDetail;
            DateFieldWrapper tempDateFieldDetail;
            
            //Create Metadata JSON fields information
            List<Object> tempList = new List<Object>();
            
            String fielddataType;            
            String fieldName;
            String entityName;
            String objectName;
            String fieldLabel;

            if(oDataObjName != null) {                
                objectName = objectHref.replace('-', '_');
            }
    
            for(Dom.XMLNode child : xmlFeed.getChildElements()) {
               if(child.getName() == 'DataServices'){
                    for(Dom.XMLNode innerChild : child.getChildElements()) {
                        if(innerChild.getName() == 'Schema') {
                            
                            for(Dom.XMLNode internalChild : innerChild.getChildElements()) {
                                entityName = internalChild.getAttributeValue('Name', null);    
                                if(internalChild.getName() == 'EntityType' && 
                                   (objectHref == entityName ||
                                    objectHref == entityName + 's' ||
                                    objectHref == entityName.subString(0, entityName.length() -1) + 'ies')){
                                    
                                    for(Dom.XMLNode dataChild : internalChild.getChildElements()){                                        
                                        if(dataChild.getName() == 'Property') {
                                            fielddataType = dataChild.getAttributeValue('Type', null);
                                            fieldName = dataChild.getAttributeValue('Name', null);
                                            fieldLabel = fieldName;
                                            
                                            if(fieldName != null) {
                                                fieldName = fieldName.replace('.','_').replace('__', '_');
                                            }
                                            
                                            //Create config information for Numeric JSON
                                            if(fielddataType.contains('Byte') || fielddataType.contains('Decimal')
                                               || fielddataType.contains('Double') || fielddataType.contains('Int16')
                                               || fielddataType.contains('Single') || fielddataType.contains('Int32')
                                               || fielddataType.contains('Int64') || fielddataType.contains('SByte')) {
                                                
                                                tempNumericFieldDetail = new NumericFieldWrapper();
                                            
                                                tempNumericFieldDetail.description = '';
                                                tempNumericFieldDetail.fullyQualifiedName = objectName + '.' + fieldName;
                                                tempNumericFieldDetail.label = fieldLabel;
                                                tempNumericFieldDetail.name = fieldName;
                                                tempNumericFieldDetail.isSystemField = false;
                                                tempNumericFieldDetail.isUniqueId = false;                                                
                                                tempNumericFieldDetail.defaultValue = ''; 
                                                tempNumericFieldDetail.type = 'Numeric';
                                                tempNumericFieldDetail.defaultValue = '0';
                                                tempNumericFieldDetail.precision = '18';
                                                tempNumericFieldDetail.scale = '2';
                                                
                                                tempList.add((Object)tempNumericFieldDetail);
                                        
                                            } else if(fielddataType.contains('DateTime') || fielddataType.contains('DateTimeOffset')) {//Create config information for Date JSON
                                                
                                                tempDateFieldDetail = new DateFieldWrapper();
                                                tempDateFieldDetail.description = '';
                                                tempDateFieldDetail.fullyQualifiedName = objectName + '.' + fieldName;
                                                tempDateFieldDetail.label = fieldLabel;
                                                tempDateFieldDetail.name = fieldName;
                                                tempDateFieldDetail.isSystemField = false;
                                                tempDateFieldDetail.isUniqueId = false;
                                                tempDateFieldDetail.fiscalMonthOffset = fiscalMonthOffset;
                                                tempDateFieldDetail.type = 'Date';
                                                tempDateFieldDetail.format = TrendingSnapshotsController.DATE_FORMAT;
                                                
                                                tempList.add((Object)tempDateFieldDetail);
                                            
                                            } else {//Create config information for Text JSON
                                                tempTextFieldDetail = new TextFieldWrapper();
                                            
                                                tempTextFieldDetail.description = '';
                                                tempTextFieldDetail.fullyQualifiedName = objectName + '.' + fieldName;
                                                tempTextFieldDetail.label = fieldLabel;
                                                tempTextFieldDetail.name = fieldName;
                                                tempTextFieldDetail.isSystemField = false;
                                                tempTextFieldDetail.isUniqueId = false;
                                                tempTextFieldDetail.isMultiValue = false;
                                                tempTextFieldDetail.defaultValue = '';
                                                tempTextFieldDetail.type = 'Text';
                                                
                                                tempList.add((Object)tempTextFieldDetail);
                                            }
                                        }
                                    }       
                                    break;
                                } 
                            }
                            break;
                        }
                    }
                    break;
                }
            }
            
            tempDateFieldDetail = new DateFieldWrapper();
                                            
            tempDateFieldDetail.description = '';
            tempDateFieldDetail.fullyQualifiedName = objectName + '.' + 'Timestamp__c';
            tempDateFieldDetail.label = 'Timestamp';
            tempDateFieldDetail.name = 'Timestamp__c';
            tempDateFieldDetail.isSystemField = false;
            tempDateFieldDetail.isUniqueId = false;
            tempDateFieldDetail.fiscalMonthOffset = fiscalMonthOffset;
            tempDateFieldDetail.type = 'Date';
            tempDateFieldDetail.format = TrendingSnapshotsController.DATE_FORMAT;
            
            tempList.add((Object)tempDateFieldDetail);
            
            tempTextFieldDetail = new TextFieldWrapper();
        
            tempTextFieldDetail.description = '';
            tempTextFieldDetail.fullyQualifiedName = objectName + '.' + 'Timestamp_String__c';
            tempTextFieldDetail.label = 'Timestamp String';
            tempTextFieldDetail.name = 'Timestamp_String__c';
            tempTextFieldDetail.isSystemField = false;
            tempTextFieldDetail.isUniqueId = false;
            tempTextFieldDetail.defaultValue = '';
            tempTextFieldDetail.type = 'Text';
            tempTextFieldDetail.isMultiValue = false;
            tempList.add((Object)tempTextFieldDetail);
            
            String fieldJson = '';
            
            if(tempList.size() > 0) {
                  //Remove extra characters from the JOSN string
                  fieldJson += JSON.serialize(tempList).replace('"precision":"18"', '"precision":18').replace('"scale":"2"', '"scale":2');
            }
            
            //remove the extra charcters from JSON
            fieldJson = fieldJson.replace('][', ','); 
            String datasetName = sanitizeDatasetName(objectName);
            
            String rowResponse = '{"fileFormat": {' +
                                '"charsetName": "UTF-8",' +
                                '"fieldsDelimitedBy": ",",' +
                                '"fieldsEnclosedBy": "\\"" ,' +
                                '"linesTerminatedBy": "\\n",' +
                                '"numberOfLinesToIgnore": 1 },';
            
            rowResponse += '"objects": [{"name": "' + datasetName + '",' +
                                  '"fullyQualifiedName": "' + datasetName + '",' +
                                  '"connector": "ScheduledConnector",' +
                                  '"label": "' + oDataObjName + '",' +
                                  '"description": "",';
            
            rowResponse += '"fields": ' + fieldJson + '}]}';        
            return rowResponse;
                
        } catch(Exception e) {  
            return e.getMessage();
        }
        return null;
    }
    
    //Method to generate metadata for SOQL
    public static String generateMetaData(String objName, List<String> fieldNameList, String orgURL){
        
        //Create set of Field's API names to be used for contains method
        Set<String> fieldAPINameSet = new Set<String>();
        fieldAPINameSet.addAll(fieldNameList);
            
        //Call rest api for get describe details of the SOQL's object
        HttpRequest req = new HttpRequest();
        req.setEndpoint(orgURL + '/services/data/' + TrendingSnapshotsController.API_VERSION + '/sobjects/' + objName + '/describe');
        req.setMethod('GET');    
        String autho = 'Bearer '+ userInfo.getsessionId();
        req.setHeader('Authorization', autho);
            
        String response;
        
        if(Test.isRunningTest()){
            response = TrendingSnapshotsMockSOQLResponse.getSOQLJSON();
        } else {
            Http http = new Http();
            HTTPResponse res = http.send(req);
            response = res.getBody();
        }            
            
        Map<String, Object> objectDetails = (Map<String, Object>)JSON.deserializeUntyped(response);
        String objLabel = String.valueOf(objectDetails.get('label'));
        List<Object> tempFieldDetails = (List<Object>)objectDetails.get('fields');
        
        //Get FiscalMonthOffset value
        Integer orgFiscalMonth = 1;
        for(Organization org : [SELECT FiscalYearStartMonth FROM Organization]) {
            orgFiscalMonth = org.FiscalYearStartMonth;
        }
            
        Integer fiscalMonthOffset = orgFiscalMonth -1;
        
        //Wrapper class variables for different type of data type
        TextFieldWrapper tempTextFieldDetail;
        NumericFieldWrapper tempNumericFieldDetail;
        DateFieldWrapper tempDateFieldDetail;
        
        fieldNameList.sort();
        List<Object> fieldDetails = new List<Object>();
        String tempJSONString ;
        RelationalFieldWrapper fieldWrapper;
        
        for(String fieldName : fieldNameList) {
            
            //check if the field is relational field
            if(fieldName.contains('.')) {
                
                //Create describe information for relational field
                fieldWrapper = new RelationalFieldWrapper();
                
                fieldWrapper.name = fieldName;
                fieldWrapper.label = fieldName;
                fieldWrapper.defaultValue ='';
                fieldWrapper.type = 'Text';
                fieldWrapper.unique = 'false';
                
                tempJSONString = JSON.serialize(fieldWrapper);
                
                fieldDetails.add((Object)JSON.deserializeUntyped(tempJSONString));
            }
            
            for (Integer i=0; i< tempFieldDetails.size(); i++) {
                Map<String, Object> fieldMap = (Map<String, Object>)tempFieldDetails[i];
                if(fieldName.trim().toLowerCase().equals(String.valueOf(fieldMap.get('name')).trim().toLowerCase())) {
                    fieldDetails.add(tempFieldDetails[i]);
                }
            }                
        }
            
        //Create Metadata JSON fields information
        List<Object> tempList = new List<Object>();
        String relationalFieldName = '';
        
        for (Integer i=0; i< fieldDetails.size(); i++) {
            
            Map<String, Object> fieldMap = (Map<String, Object>)fieldDetails[i]; 
            relationalFieldName = String.valueOf(fieldMap.get('name'));
            
            if(fieldAPINameSet.contains(relationalFieldName.toLowerCase())) {
                
                String fieldLabel = String.valueOf(fieldMap.get('label'));
                String fielddataType = String.valueOf(fieldMap.get('type'));
                
                //Create config information for Numeric JSON
                if(fielddataType =='Currency' || fielddataType == 'Double' || fielddataType == 'Integer' || fielddataType == 'Percent') {
                       
                    tempNumericFieldDetail = new NumericFieldWrapper();
                    tempNumericFieldDetail.description = '';
                    if(relationalFieldName.contains('.')) {
                        tempNumericFieldDetail.fullyQualifiedName = relationalFieldName;
                    } else {
                        tempNumericFieldDetail.fullyQualifiedName = objName + '.' + fieldMap.get('name');
                    }
                    
                    tempNumericFieldDetail.label = fieldLabel;
                    tempNumericFieldDetail.name = String.valueOf(fieldMap.get('name')).replace('.', '_').replace('__','_');                    
                    tempNumericFieldDetail.isSystemField = false;
                    tempNumericFieldDetail.isUniqueId = boolean.valueOf(fieldMap.get('unique'));
                    tempNumericFieldDetail.defaultValue = fieldMap.get('defaultValue') != null ?String.valueOf(fieldMap.get('defaultValue')) : '';
                    tempNumericFieldDetail.type = 'Numeric';
                    tempNumericFieldDetail.defaultValue = fieldMap.get('defaultValue') != null ?String.valueOf(fieldMap.get('defaultValue')) : '0';
                    tempNumericFieldDetail.precision = '18';
                    tempNumericFieldDetail.scale = '2';
                    tempList.add((Object)tempNumericFieldDetail);
                    
                } else if(fielddataType == 'Date' || fielddataType == 'DateTime') {//Create config information for Date JSON
                    tempDateFieldDetail = new DateFieldWrapper();
                    tempDateFieldDetail.description = '';
                    
                    if(relationalFieldName.contains('.')) {
                        tempDateFieldDetail.fullyQualifiedName = relationalFieldName;
                    } else {    
                        tempDateFieldDetail.fullyQualifiedName = objName + '.' + fieldMap.get('name');
                    }
                    
                    tempDateFieldDetail.label = fieldLabel;
                    tempDateFieldDetail.name = String.valueOf(fieldMap.get('name')).replace('.', '_').replace('__','_');
                    tempDateFieldDetail.isSystemField = false;
                    tempDateFieldDetail.isUniqueId = boolean.valueOf(fieldMap.get('unique'));
                    tempDateFieldDetail.type = 'Date';
                    tempDateFieldDetail.format = TrendingSnapshotsController.DATE_FORMAT;
                    tempDateFieldDetail.fiscalMonthOffset = fiscalMonthOffset;
                    tempList.add((Object)tempDateFieldDetail);
                    
                } else { //Create config information for Text JSON
                    
                    tempTextFieldDetail = new TextFieldWrapper();
                    tempTextFieldDetail.description = '';
                    
                    if(relationalFieldName.contains('.')){
                        tempTextFieldDetail.fullyQualifiedName = relationalFieldName;
                    }else{
                        tempTextFieldDetail.fullyQualifiedName = objName + '.' + fieldMap.get('name');
                    }
                    
                    tempTextFieldDetail.label = fieldLabel;
                    tempTextFieldDetail.name = String.valueOf(fieldMap.get('name')).replace('.', '_').replace('__','_');                    
                    tempTextFieldDetail.isSystemField = false;
                    tempTextFieldDetail.isUniqueId = boolean.valueOf(fieldMap.get('unique'));
                    tempTextFieldDetail.defaultValue = fieldMap.get('defaultValue') != null ?String.valueOf(fieldMap.get('defaultValue')) : '';
                    tempTextFieldDetail.type = 'Text';
                    tempTextFieldDetail.isMultiValue = (fielddataType == 'multipicklist');
                    
                    tempList.add((Object)tempTextFieldDetail);
                }
            }
        }
        
        tempDateFieldDetail = new DateFieldWrapper();        
        tempDateFieldDetail.description = '';
        tempDateFieldDetail.fullyQualifiedName = objName + '.Timestamp__c';
        tempDateFieldDetail.label = 'Timestamp';
        tempDateFieldDetail.name = 'Timestamp__c';
        tempDateFieldDetail.isSystemField = false;
        tempDateFieldDetail.isUniqueId = false;
        tempDateFieldDetail.type = 'Date';
        tempDateFieldDetail.format = TrendingSnapshotsController.DATE_FORMAT;
        tempDateFieldDetail.fiscalMonthOffset = fiscalMonthOffset;
        tempList.add((Object)tempDateFieldDetail);
        
        tempTextFieldDetail = new TextFieldWrapper();
        tempTextFieldDetail.description = '';
        tempTextFieldDetail.fullyQualifiedName = objName + '.' + 'Timestamp_String__c';
        tempTextFieldDetail.label = 'Timestamp String';
        tempTextFieldDetail.name = 'Timestamp_String__c';
        tempTextFieldDetail.isSystemField = false;
        tempTextFieldDetail.isUniqueId = false;
        tempTextFieldDetail.defaultValue = '';
        tempTextFieldDetail.type = 'Text';
        tempTextFieldDetail.isMultiValue = false;
        tempList.add((Object)tempTextFieldDetail);
        
        String fieldJson = '';
        if(tempList.size() > 0){
            fieldJson += JSON.serialize(tempList).replace('"precision":"18"', '"precision":18').replace('"scale":"2"', '"scale":2');
        }
        fieldJson = fieldJson.replace('][', ','); 

        String datasetName = sanitizeDatasetName(objName);
        String rowResponse = '{"fileFormat": {' +
            '"charsetName": "UTF-8",' +
            '"fieldsDelimitedBy": ",",' +
            '"fieldsEnclosedBy": "\\"" ,' +
            '"linesTerminatedBy": "\\n",' +
            '"numberOfLinesToIgnore": 1 },';
        
        rowResponse += '"objects": [{"name": "' + datasetName + '",' +
            '"fullyQualifiedName": "' + datasetName + '",' +
            '"connector": "ScheduledConnector",' +
            '"label": "' + objLabel + '",' +
            '"description": "",';
        
        rowResponse += '"fields": ' + fieldJson + '}]}';
        return rowResponse;
    }
    
    //Method to generate report row response
    @RemoteAction
    global static String getReportRowResponse(String selectedReportId, String orgURL){
        try{
            //Call rest api to get selected report data
            HttpRequest req = new HttpRequest();
            req.setEndpoint(orgURL + '/services/data/' + TrendingSnapshotsController.API_VERSION + '/analytics/reports/' + selectedReportId);
            req.setMethod('GET');
            String autho = 'Bearer '+ userInfo.getsessionId();
            req.setHeader('Authorization', autho);
            
            String response;
            if(Test.isRunningTest()) {
                response = TrendingSnapshotsMockSOQLResponse.getReportJSON();
            } else {
                Http http = new Http();
                HTTPResponse res = http.send(req);
                response = res.getBody();
            } 
            
            ReportParser reportParser = new ReportParser(response, 2);
            reportParser.getHeader();            
            
            //Get FiscalMonthOffset value
            Integer orgFiscalMonth = 1;
            for(Organization org : [SELECT FiscalYearStartMonth FROM Organization]){
                orgFiscalMonth = org.FiscalYearStartMonth;
            }
            
            Integer fiscalMonthOffset = orgFiscalMonth -1;
            Map<String, Object> fieldMap;
            String fieldLabel;
            String fielddataType;
            
            List<String> fieldNameList = new List<String>();
            if(reportParser.reportColumnDetailMap != null && reportParser.reportColumnDetailMap.keySet() != null) {
                fieldNameList.addAll(reportParser.reportColumnDetailMap.keySet());
            }
            
            TextFieldWrapper tempTextFieldDetail;
            NumericFieldWrapper tempNumericFieldDetail;
            DateFieldWrapper tempDateFieldDetail;
            
            List<Object> tempList = new List<Object>();
            String fieldAPIName = '';
            
            for (String fieldName : fieldNameList) {
                fieldMap = (Map<String, Object>)reportParser.reportColumnDetailMap.get(fieldName);
                fieldLabel = String.valueOf(fieldMap.get('label'));
                fielddataType = String.valueOf(fieldMap.get('dataType')).toLowerCase();
                fieldAPIName = fieldName.replace('.', '_').replace('__', '_');
                
                //Create config information for Numeric JSON
                if(fielddataType == 'double' || fielddataType == 'integer' || fielddataType == 'percent' || fielddataType =='currency') {
                    
                    tempNumericFieldDetail = new NumericFieldWrapper();
                    
                    tempNumericFieldDetail.description = '';
                    tempNumericFieldDetail.fullyQualifiedName = fieldName;
                    tempNumericFieldDetail.label = String.valueOf(fieldMap.get('label'));
                    tempNumericFieldDetail.name = fieldAPIName;
                    tempNumericFieldDetail.isSystemField = false;
                    tempNumericFieldDetail.isUniqueId = false;
                    tempNumericFieldDetail.defaultValue = ''; 
                    tempNumericFieldDetail.type = 'Numeric';
                    tempNumericFieldDetail.defaultValue = '0';
                    tempNumericFieldDetail.precision = '18';
                    tempNumericFieldDetail.scale = '2';
                    
                    tempList.add((Object)tempNumericFieldDetail);
                    
                } else if(fielddataType == 'date' || fielddataType == 'datetime') {//Create config information for Date JSON
                    tempDateFieldDetail = new DateFieldWrapper();
                    
                    tempDateFieldDetail.description = '';
                    tempDateFieldDetail.fullyQualifiedName = fieldName;
                    tempDateFieldDetail.label = String.valueOf(fieldMap.get('label'));
                    tempDateFieldDetail.name = fieldAPIName;
                    tempDateFieldDetail.isSystemField = false;
                    tempDateFieldDetail.isUniqueId = false;
                    tempDateFieldDetail.fiscalMonthOffset = fiscalMonthOffset;
                    tempDateFieldDetail.type = 'Date';
                    tempDateFieldDetail.format = TrendingSnapshotsController.DATE_FORMAT;
                    
                    tempList.add((Object)tempDateFieldDetail);
                    
                } else { //Create config information for Text JSON
                    tempTextFieldDetail = new TextFieldWrapper();
                    
                    tempTextFieldDetail.description = '';
                    tempTextFieldDetail.fullyQualifiedName = fieldName;
                    tempTextFieldDetail.label = String.valueOf(fieldMap.get('label'));
                    tempTextFieldDetail.name = fieldAPIName;
                    tempTextFieldDetail.isSystemField = false;
                    tempTextFieldDetail.isUniqueId = false;
                    tempTextFieldDetail.defaultValue = '';
                    tempTextFieldDetail.type = 'Text';
                    tempTextFieldDetail.isMultiValue = (fielddataType == 'multipicklist');

                    tempList.add((Object)tempTextFieldDetail);
                }
            }
                                        
            tempDateFieldDetail = new DateFieldWrapper();
            tempDateFieldDetail.description = '';
            tempDateFieldDetail.fullyQualifiedName = 'Timestamp__c';
            tempDateFieldDetail.label = 'Timestamp';
            tempDateFieldDetail.name = 'Timestamp__c';
            tempDateFieldDetail.isSystemField = false;
            tempDateFieldDetail.isUniqueId = false;
            tempDateFieldDetail.fiscalMonthOffset = fiscalMonthOffset;
            tempDateFieldDetail.type = 'Date';
            tempDateFieldDetail.format = TrendingSnapshotsController.DATE_FORMAT;
            
            tempList.add((Object)tempDateFieldDetail);
            
            tempTextFieldDetail = new TextFieldWrapper();
            tempTextFieldDetail.description = '';
            tempTextFieldDetail.fullyQualifiedName = 'Timestamp_String__c';
            tempTextFieldDetail.label = 'Timestamp String';
            tempTextFieldDetail.name = 'Timestamp_String__c';
            tempTextFieldDetail.isSystemField = false;
            tempTextFieldDetail.isUniqueId = false;
            tempTextFieldDetail.defaultValue = '';
            tempTextFieldDetail.type = 'Text';
            tempTextFieldDetail.isMultiValue = false;
            tempList.add((Object)tempTextFieldDetail);
            
            String fieldJson = '';
            
            if(tempList.size() > 0){
                fieldJson += JSON.serialize(tempList).replace('"precision":"18"', '"precision":18').replace('"scale":"2"', '"scale":2');
            }
            
            fieldJson = fieldJson.replace('][', ','); 
            String datasetName = sanitizeDatasetName(reportParser.reportObjectType);
            
            String rowResponse = '{"fileFormat": {' + 
                '"charsetName": "UTF-8",' +
                '"fieldsDelimitedBy": ",",' +
                '"fieldsEnclosedBy": "\\"" ,' +
                '"linesTerminatedBy": "\\n",' + 
                '"numberOfLinesToIgnore": 1 },'; 
            rowResponse += '"objects": [{"name": "' + datasetName + '",' +
                '"fullyQualifiedName": "' + datasetName + '",' +
                '"connector": "ScheduledConnector",' +
                '"label": "' + datasetName + '",' +
                '"description": "",';
            rowResponse += '"fields": ' + fieldJson + '}]}';
            
            //Set Metadata JSON to Metadata__c field of data Extract Object after removing extra text
            return rowResponse.replace('CustomEntity$', '');
            
        } catch(Exception e) {
            return e.getMessage();     
        }
    }

    global static String sanitizeDatasetName(String name) {
        return name.replace('$','_').replace('__','_');
    }
    
    //Method to save the data extract record
    @RemoteAction
    global static String saveDataExtract(String query, String datasetName,
                                         String metadata, String schedule,
                                         String selectdayDate, String operation,
                                         String timeInterval, String selectedReportName,
                                         String selectedReportId,
                                         String oDataURL, String oDataObject,
                                         String oDataHref, String extractType,
                                         String existingExtractId){
           try{
               //Validations for data extract fields
               String errorMessage = validateDataExtract(datasetName, metadata, 
                                                         operation, schedule, 
                                                         timeInterval, selectdayDate, (existingExtractId == null || existingExtractId == ''));
                
                if(errorMessage != null) {
                    return errorMessage;
                }
                
                Data_Extract__c dataExtract = new Data_Extract__c();
                if(existingExtractId != null && existingExtractId != '') {
                    dataExtract.Id = existingExtractId;
                } else {
                    dataExtract.Dataset_Name__c = datasetName;
                    dataExtract.Name = datasetName;
                }
                
                dataExtract.Type__c = extractType;
                dataExtract.Metadata__c = metadata;
                dataExtract.Active__c = true;
                dataExtract.Schedule__c = schedule;
                dataExtract.Operation__c = operation;
                dataExtract.Time_Interval__c = timeInterval;
                dataExtract.Day_Date_Selector__c = selectdayDate;
                
                if(extractType == 'Report') {
                    dataExtract.Report_Id__c = selectedReportId;
                    dataExtract.Report_Name__c = selectedReportName;
                    dataExtract.SOQL_Query__c = '';
                    dataExtract.oData_URL__c = '';
                    dataExtract.oData_Object__c = '';
                    dataExtract.oData_Object_href__c = '';
                } else if(extractType == 'oData') {
                    
                    if(oDataObject == null || oDataObject == '') {
                        return 'Object must be filled';
                    }
                    if(oDataURL == null || oDataURL == '') {
                        return 'oData URL must be filled';
                    }

                    dataExtract.Type__c = extractType;
                    dataExtract.oData_URL__c = oDataURL;
                    dataExtract.oData_Object__c = oDataObject;
                    dataExtract.oData_Object_href__c = oDataHref;
                    dataExtract.SOQL_Query__c = '';
                    dataExtract.Report_Id__c = '';
                    dataExtract.Report_Name__c = '';
                    
                } else {
                    dataExtract.SOQL_Query__c = query;
                    dataExtract.Report_Id__c = '';
                    dataExtract.Report_Name__c = '';
                    dataExtract.oData_URL__c = '';
                    dataExtract.oData_Object__c = '';
                    dataExtract.oData_Object_href__c = '';
                }
                
                upsert dataExtract;
                if(existingExtractId != null) {
                    
                    String batchJobId;
                    for(Data_Extract__c tempExtract : [SELECT Batch_Job_Id__c FROM
                                                       Data_Extract__c WHERE 
                                                       Id =: existingExtractId]) {
                        
                        batchJobId = tempExtract.Batch_Job_Id__c;
                    }
                    
                    for(CronTrigger cTrigger : [SELECT ID FROM CronTrigger WHERE ID =: batchJobId]) {
                        System.abortJob(batchJobId);
                    }
                }
                return 'Success,' + dataExtract.Id;
           } catch(DMLException e) {   
                return e.getMessage();
           }
    }
    
    //Method to schedule the new batch job
    @RemoteAction
    global static String scheduledBatch(String timeInterval, String schedule,
                                        String daydateSelector, String dataExtractName,
                                        String dataExtractId){
        //try{
            
            ScheduleTrendingSnapshotsBatch scheduler = new ScheduleTrendingSnapshotsBatch(); 
            String cronExpression = ''; 
            
            // Create Cron Expression if time interval is given and scheduler is Active
            if(timeInterval != null){
                
                //Remove the extra text from time interval selected value
                String timeToSchedule = timeInterval.replace(':00 AM', '').replace(':00 PM', '').trim();
                
                if(timeInterval.contains('PM')) { 
                    timeToSchedule = Math.mod(Integer.valueOf(timeToSchedule) + 12, 24) + ''; 
                }
                
                if(timeInterval.equals('12:00 AM')) {
                    timeToSchedule = '0';
                }
                
                if(timeInterval.equals('12:00 PM')) {
                    timeToSchedule = '12'; 
                }
                
                // write cron expression for daily running batch
                if(schedule == 'Daily') {
                    cronExpression = '0 0 ' + timeToSchedule + ' ? * MON-SUN' ;
                }
                
                // write cron expression for Weekly running batch
                if(schedule == 'Weekly') {
                    cronExpression = '0 0 ' + timeToSchedule + ' ? * '  + daydateSelector + ' *';
                }
                
                // write cron expression for Monthly running batch
                if(schedule == 'Monthly'){
                    
                    //Set last day of month to schedule if 31 is selected day to run the job
                    if(daydateSelector.equals('31')){
                        cronExpression = '0 0 ' + timeToSchedule + ' L * ?';
                    } else {//else Set selected day to schedule the job
                        cronExpression = '0 0 ' + timeToSchedule + ' ' + daydateSelector + ' 1/1 ? *';
                    }
                }
            }
            
            if(cronExpression != '') {
                Id jobId = System.schedule(dataExtractName, cronExpression, scheduler);
                updateJobId(jobId, dataExtractId);
            }
            
            return 'Data Extract Saved and Scheduled successfully';
        
        //}catch(DMLException e){
            
            //return e.getDmlMessage(0);
        //} 
    }
    
    //Method to update the Batch_Job_Id__c in data extract record
    @future 
    public static void updateJobId(Id jobId, Id dataExtractId) {
        
        Data_Extract__c dataExtract = new Data_Extract__c(Id = dataExtractId, 
                                                                              Batch_Job_Id__c = jobId);
                                                          
        update dataExtract;
    }
    
    @RemoteAction
    global static String testQuery(String queryString, String orgURL) {
        
        try {
            //Validation for Query field
            if(queryString == null || queryString == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, 'Please enter a query to test'));
                return null;
            }
            
            // Check if Inner Query is entered by user, if yes give error message to not allow inner query
            List<String> fromParts = queryString.toLowerCase().split('\\sfrom\\s');
            if(fromParts.size() > 2) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error, 'Inner SOQL is not allowed'));
                return null;
            }
            
            String query = queryString.toLowerCase();
            Pattern p = Pattern.compile('\\slimit\\s');
            Matcher m = p.matcher(query);
            if (!m.find()) {
               query += ' limit 200 ';
            }
            
            //Call rest api to get result of the SOQL query
            HttpRequest req = new HttpRequest();
            req.setEndpoint(orgURL + '/services/data/' + TrendingSnapshotsController.API_VERSION + '/query/?q=' + EncodingUtil.urlEncode(query, 'UTF-8'));
            req.setMethod('GET');
            string autho = 'Bearer '+ userInfo.getsessionId();
            req.setHeader('Authorization', autho);
            
            String response;
            
            if(!Test.isRunningTest()) {
                Http http = new Http();
                HTTPResponse res = http.send(req);
                response = res.getBody();
            }
            
            return response;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error,  e.getMessage()));
        }
        return null;
    }
    
    @RemoteAction
    global static String testReportQuery(String selectedReportId, String orgURL) {

        try {
            
            // Call REST api to get data to show in report Data Table on page
            HttpRequest req = new HttpRequest();
            req.setEndpoint(orgURL + '/services/data/' + TrendingSnapshotsController.API_VERSION + '/analytics/reports/' + selectedReportId);
            req.setMethod('GET');
            String autho = 'Bearer '+ userInfo.getsessionId();
            req.setHeader('Authorization', autho);
             
            String response;
            
            if(Test.isRunningTest()){
                response = TrendingSnapshotsMockSOQLResponse.getReportJSON();
            } else {  
                Http http = new Http();
                HTTPResponse res = http.send(req);
                response = res.getBody();
            } 
            return response;
            
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.error,  e.getMessage()));
            return null;
        }
    }
    
    //Method to save the data extract record
    @RemoteAction
    global static Data_Extract__c getSelectedDataExtract(String selectedExtractId) {
        
           try { 
                Data_Extract__c dataExtract = new Data_Extract__c();
                for(Data_Extract__c extract : [SELECT Id, Dataset_Name__c,
                                                         Name, Type__c, Metadata__c, Active__c,
                                                         Schedule__c, Operation__c, Time_Interval__c,
                                                         Day_Date_Selector__c, Report_Id__c, Timestamp_String__c,
                                                         Report_Name__c, SOQL_Query__c, oData_URL__c,
                                                         oData_Object__c, oData_Object_href__c, Timestamp__c
                                                         FROM Data_Extract__c WHERE Id =: selectedExtractId]) {
                    
                    dataExtract = extract;
                }   
                return dataExtract;
           } catch(DMLException e) {
                return null;
           }
    }

    // Execute a job immediately
    @RemoteAction
    global static void runExtractNow(String jobId) {
        ScheduleTrendingSnapshotsBatch s = new ScheduleTrendingSnapshotsBatch();
        s.execute(jobId);        
    }
    
    public static String validateDataExtract(String datasetName, String metadataName,
                                             String operation, String schedule,
                                             String timeInterval, String daySelector, boolean isNew) {
        
        if(isNew) {
            if(datasetName == null || datasetName =='') {
                return 'Target dataset name must be filled';
            }
            
            //this regex is for Target Dataset Name
            //Target Dataset Name must begin with letter and can only contain letter/number/underscores
            String strRegEx = '^[a-zA-Z][a-zA-Z0-9 _]+$';
            
            Pattern MyPattern = Pattern.compile(strRegEx);
            Matcher MyMatcher = MyPattern.matcher(datasetName);
            Boolean result = MyMatcher.find();
            
            if(!result) {
                return 'Target dataset name must begin with letter and can only contain letters/numbers/underscores.';
            }            
        }
        
        if(metadataName == null || metadataName =='') return 'Please generate metadata first';
        if(operation == null || operation =='') return 'Operation must be filled';
        if(schedule == null || schedule =='') return 'Schedule must be filled';
        if(timeInterval == null || timeInterval =='') return 'Time Interval must be filled';
        if(schedule != 'Daily' && (daySelector =='' || daySelector == null)) return 'Please select Day/Date';
        
        return null;
    }
    
    //Wrapper class to be used for Id, Name pair values
    global class DataExtractWrapper {
        global String id;
        global String name;
         
        global DataExtractWrapper(String id, String name) {
            this.id = id;
            this.name = name;
        }
    }
    
    public class ReportParser {
    
        private Map<String,Object> mpTopLevelParse = new Map<String,Object>();
        private boolean showReport;
        private Integer reportLimit;
        private Integer totalData;
        public Map<String,Object> reportColumnDetailMap;
        public String reportObjectType;
        public String reportObjectLabel;
        public Map<String,String> reportLabelNameMap;

        public ReportParser(String inputJSONStr, Integer rLimit) {
             this.mpTopLevelParse = (Map<String,Object>)JSON.deserializeUntyped(inputJSONStr);
             showReport = true;
             reportLimit = rLimit;
             reportColumnDetailMap = new Map<String,Object>();
             reportLabelNameMap = new Map<String, String>();
        }

        public List<String> getHeader() {
            List<String> lstHeader = new List<String>();
            Map<String,Object> mpReportMetadata = (Map<String,Object>)mpTopLevelParse.get('reportMetadata');
            List<Object> mpReportDetailColumnLst = (List<Object>)mpReportMetadata.get('detailColumns');
            Map<String,Object> mpReportExtendedMetadata = (Map<String,Object>)mpTopLevelParse.get('reportExtendedMetadata');
            Map<String,Object> mpReportDetailColumn = (Map<String,Object>)mpReportExtendedMetadata.get('detailColumnInfo');
            Map<String,Object> mpReportType = (Map<String,Object>)mpReportMetadata.get('reportType');
            
            reportObjectType = String.valueOf(mpReportType.get('type'));
            reportObjectLabel = String.valueOf(mpReportType.get('label'));
            reportColumnDetailMap = mpReportDetailColumn;
            lstHeader.add('S.No');
            
            for(Object detailCol : mpReportDetailColumnLst){
                  Map<String,Object> mpDetail = (Map<String,Object>)mpReportDetailColumn.get((String)detailCol);
                  reportLabelNameMap.put(String.valueOf(mpDetail.get('label')), (String)detailCol);
                  lstHeader.add(String.valueOf(mpDetail.get('label')));
            }
            
            lstHeader.add('Last Run');
            return lstHeader;
        }
    }
    
    public class RelationalFieldWrapper{
        String name;
        String label;
        String type;
        String unique;
        String defaultValue;
        
        public RelationalFieldWrapper() {}
    }
    
    public class TextFieldWrapper{
        String description;
        String fullyQualifiedName;
        String label;
        String name;
        boolean isSystemField;
        boolean isUniqueId;
        String type;
        boolean isMultiValue;
        String defaultValue;

        public TextFieldWrapper() {}
    }
    
    public class NumericFieldWrapper {    
        String description;
        String fullyQualifiedName;
        String label;
        String name;
        boolean isSystemField;
        boolean isUniqueId;
        String type;
        String precision;
        String scale;
        String defaultValue;
        
        public NumericFieldWrapper() {}
    }
    
    public class DateFieldWrapper {
        String description;
        String fullyQualifiedName;
        String label;
        String name;
        boolean isSystemField;
        boolean isUniqueId;
        String type;
        String format;
        Integer fiscalMonthOffset;
        
        public DateFieldWrapper() {}
    }
}