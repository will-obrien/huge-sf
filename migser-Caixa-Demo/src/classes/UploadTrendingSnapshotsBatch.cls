global class UploadTrendingSnapshotsBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
        
    global String metadataJson;
    global String dataSetName;
    global Integer partNumber;
    global String query;
    global String insightExternalDataId;
    global String dataExtractType;
    global Id reportId;   
    global String oDataURL;
    global String oDataObject;  
    global String triggerId;   
    global String nextoDataURL;
    global String contentType;
    global String dataExtractId;
    global String oDataObjectHref;
    global List<String> oDataFieldNameList;
    global List<List<Map<String, String>>> oDataQueryResult;
    global List<InsightsExternalDataPart> oDataExternalDataParts;
    global String scheduledDataExtractId;
    
    public static final String DATE_FORMAT = 'yyyy/MM/dd';
    public static final String DATE_FORMAT_STRING = 'yyyy~~~MM~~~dd';   
    public static final Decimal CONST_MAX_DATAPART_SIZE = 7.5 * 1024 * 1024;    
    
    global String currDate;
    global String currDateString; 
    
    //Constructor : It contains the all variables initialization
    global UploadTrendingSnapshotsBatch(String nextURL, String extractId, String insightDataId, Integer pNumber, String cType, String schDataExtractId, String strDate) {
        nextoDataURL = nextURL; 
        dataExtractId = extractId;
        insightExternalDataId = insightDataId;
        partNumber = pNumber;
        contentType = cType;
        scheduledDataExtractId = schDataExtractId;
        currDateString = strDate;
    }
    
    //Start method that will fetch the records those need to be processed
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String operation;
        
        if(!Test.isRunningTest()) {
            
            // If oData response contains URL for next set of data, then Intialize the 
            // variables with same values as previous batch
            if(nextoDataURL != null && nextoDataURL != '') {
                
                // Query the correct Data Extract record based on the Apex_Job_Id__c field
                for(Data_Extract__c dExtract : [SELECT Id, Metadata__c, SOQL_Query__c, Report_Id__c,
                                                          Dataset_Name__c, Type__c, Operation__c, 
                                                          oData_Object_href__c, oData_Object__c, oData_URL__c, 
                                                          Timestamp_String__c, Timestamp__c 
                                                          FROM Data_Extract__c WHERE Id =: dataExtractId]) {
                                                    
                                                              dataSetName = dExtract.Dataset_Name__c; metadataJson = dExtract.Metadata__c;
                                                              oDataURL = dExtract.oData_URL__c; oDataObject = dExtract.oData_Object__c;
                                                              dataExtractId = dExtract.Id; dataExtractType = dExtract.Type__c;
                                                              oDataObjectHref = dExtract.oData_Object_href__c;
                                                              
                                                              //if(dExtract.Timestamp__c != null) {
                                                              //    currDateString = dExtract.Timestamp_String__c;
                                                              //} else {
                                                              //    Datetime dateNow = Datetime.now();
                                                              //    currDateString = dateNow.format(UploadTrendingSnapshotsBatch.DATE_FORMAT_STRING);
                                                              //}
                                                          }
                
                //return a dummy record so that excute method run for report
                return Database.getQueryLocator('SELECT Metadata__c, SOQL_Query__c, Report_Id__c,' +
                                                'Dataset_Name__c, Type__c, Timestamp_String__c, Timestamp__c FROM Data_Extract__c limit 1');
            } else {
                
                //Query the correct Data Extract record based on the Apex_Job_Id__c field
                for(Data_Extract__c dExtract : [SELECT Id, Metadata__c, SOQL_Query__c, Report_Id__c,
                                                          Dataset_Name__c, Type__c, Operation__c, 
                                                          oData_Object_href__c, oData_Object__c, oData_URL__c, 
                                                          Timestamp_String__c, Timestamp__c 
                                                          FROM Data_Extract__c WHERE Id =: scheduledDataExtractId AND Active__c =: true]) {
                                                    
                                                    query = dExtract.SOQL_Query__c; dataSetName = dExtract.Dataset_Name__c;
                                                    metadataJson = dExtract.Metadata__c; dataExtractType = dExtract.Type__c;
                                                    reportId = dExtract.Report_Id__c; operation = dExtract.Operation__c;
                                                    oDataURL = dExtract.oData_URL__c; oDataObject = dExtract.oData_Object__c;
                                                    dataExtractId = dExtract.Id; oDataObjectHref = dExtract.oData_Object_href__c;
                                                    
                                                    //if(dExtract.Timestamp__c != null) {
                                                    //    currDateString = dExtract.Timestamp_String__c;
                                                    //} else {
                                                    //    Datetime dateNow = Datetime.now();
                                                    //    currDateString = dateNow.format(UploadTrendingSnapshotsBatch.DATE_FORMAT_STRING);
                                                    //}
                                                }
            }
        } else { //This is dummy data for test class purpose

            for(Data_Extract__c dExtract : [SELECT Metadata__c, SOQL_Query__c, Report_Id__c,
                                                      oData_Object__c, oData_URL__c, oData_Object_href__c,
                                                      Dataset_Name__c, Type__c, Operation__c, 
                                                      Timestamp_String__c, Timestamp__c 
                                                      FROM Data_Extract__c LIMIT 1]) {
                                                
                                                query = dExtract.SOQL_Query__c; dataSetName = dExtract.Dataset_Name__c;                                             
                                                metadataJson = dExtract.Metadata__c; dataExtractType = dExtract.Type__c;
                                                reportId = dExtract.Report_Id__c; operation = dExtract.Operation__c;
                                                oDataURL = dExtract.oData_URL__c; oDataObject = dExtract.oData_Object__c;
                                                dataExtractId = dExtract.Id; dataExtractType = dExtract.Type__c;
                                                oDataObjectHref = dExtract.oData_Object_href__c;
                                                
                                                //if(dExtract.Timestamp__c != null) {
                                                //    currDateString = dExtract.Timestamp_String__c;
                                                //} else {
                                                //    Datetime dateNow = Datetime.now();
                                                //    currDateString = dateNow.format(UploadTrendingSnapshotsBatch.DATE_FORMAT_STRING);
                                                //}
                                            }
        }      
        
        if(dataSetName != null) { 
            if(query != null && dataExtractType == 'SOQL') {
                
                InsightsExternalData insightExternalData = new InsightsExternalData();
                insightExternalData.Format = 'Csv';
                
                //replace invalid characters with valid characters for EdgemartAlias field
                insightExternalData.EdgemartAlias = dataSetName.trim().replaceAll(' ', '_').replace('__', '_');
                insightExternalData.EdgemartLabel = dataSetName;
                insightExternalData.MetadataJson = blob.valueOf(metadataJson);
                insightExternalData.Operation = operation;
                insightExternalData.Action ='None';
                
                if(!Test.isRunningTest()) insert insightExternalData;
                
                insightExternalDataId = insightExternalData.Id;
                return Database.getQueryLocator(query);
                
            } else {
                
                InsightsExternalData insightExternalData = new InsightsExternalData();
                insightExternalData.Format = 'Csv';
                
                //replace invalid characters with valid characters for EdgemartAlias field
                insightExternalData.EdgemartAlias = dataSetName.trim().replaceAll(' ', '_').replace('__', '_');
                insightExternalData.EdgemartLabel = dataSetName;
                insightExternalData.Operation = operation;
                insightExternalData.MetadataJson = blob.valueOf(metadataJson);
                insightExternalData.Action ='None'; 
                
                if(!Test.isRunningTest()) insert insightExternalData;
                
                insightExternalDataId = insightExternalData.Id;
                
                //return a dummy record so that excute method run for report
                return Database.getQueryLocator('SELECT Metadata__c, SOQL_Query__c, Report_Id__c,' +
                                                'Dataset_Name__c, Type__c FROM Data_Extract__c LIMIT 1');
            }
        }
        return null;
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
                            
        if(dataExtractType == 'SOQL') {
            
            //Create list of field api names
            List<String> queryPart = query.toLowerCase().split('\\sfrom\\s');            
            List<String> tempList = queryPart[1].split(' ');      
            List<String> fieldNameList = new List<String>();
            
            for(String field : queryPart[0].toLowerCase().replace('select', '').split(',')){
                fieldNameList.add(field.trim());
            }
            fieldNameList.sort();
            
            String objName = tempList[0].trim();
            String csvString = '';
            String header = '';
            
            if(partNumber == 1) {
                for(String field : fieldNameList) {
                    header += ((header == '') ? '' : ',') + field.replace('.', '_').replace('__', '_');
                }
                header += ',Timestamp__c,Timestamp_String__c\n';
                csvString = header;
            }
                        
            List<String> soqlCSVList = new List<String>();                                
            blob currCSVBlob;
            String fieldType;
            String dataValue;

            Schema.DescribeSObjectResult objectMetadata = Schema.getGlobalDescribe().get(objName).getDescribe();
            Map<String, String> cachedFieldMetadata = new Map<String, String> {};
        
            String dataRow;                
            for(sObject obj : scope){
                
                dataRow = '';
                
                for(String field : fieldNameList) {
                    
                    if(cachedFieldMetadata.get(field) == null) {
                        String fType = 'String';
                        if(objectMetadata.fields.getMap().get(field) != null) {
                            fType = getFieldType(objectMetadata.fields.getMap().get(field).getDescribe());
                        }
                        cachedFieldMetadata.put(field, fType);
                    }
                    
                    fieldType = field.contains('.') ? 'String' : cachedFieldMetadata.get(field);
                    if(fieldType == 'String') {
                        
                        dataValue = '';
                        if(field.contains('.')) {
                            
                            List<String> fieldLevels = field.split('\\.');
                            sObject sobj = obj.getSobject(fieldLevels[0]);
                            
                            for(Integer j = 1; j < fieldLevels.size(); j++) {
                                if(sobj != null) {
                                    if(j == fieldLevels.size()-1) {
                                        if(sobj.get(fieldLevels[fieldLevels.size()-1]) != null) { 
                                            dataValue = String.valueOf(sobj.get(fieldLevels[fieldLevels.size()-1]));
                                        } else {
                                            dataValue = '';
                                        }
                                    } else {  
                                        sobj = sobj.getSobject(fieldLevels[j]);
                                    }
                                }
                            }
                        } else {
                            dataValue = String.valueOf(obj.get(field)) != null ? String.valueOf(obj.get(field)) : '';
                        }
                        
                        dataValue = (dataValue == null) ? '' : dataValue.trim().replaceAll('"', '\'');
                        dataRow += ((dataRow == '') ? '' : ',') + '"' + dataValue + '"';
                        
                    } else if(fieldType == 'Numeric') {
                        Double dValue = Double.valueOf(obj.get(field)) != null ? Double.valueOf(obj.get(field)) : 0;
                        dataRow += ((dataRow == '') ? '' : ',') + dValue;

                    } else if(fieldType == 'Date' || fieldType == 'DateTime') {
                        Date dateValue = Date.valueOf(obj.get(field));
                        String formattedDate = '';

                        if(dateValue != null) {
                            Datetime dt = datetime.newInstance(dateValue.year(), dateValue.month(),dateValue.day());
                            formattedDate = dt.format(UploadTrendingSnapshotsBatch.DATE_FORMAT);
                        }
                        
                        dataRow += ((dataRow == '') ? '' : ',') + formattedDate;
                    }
                }
                
                csvString += dataRow + ',' + currDateString.replaceAll('~~~','/') + ',' + currDateString + '\n';
                currCSVBlob = blob.valueOf( csvString );
                
                if(currCSVBlob.size() > UploadTrendingSnapshotsBatch.CONST_MAX_DATAPART_SIZE) {
                    soqlCSVList.add(csvString);
                    csvString = '';
                }
            }
            
            if(csvString != header && csvString != '') {
                soqlCSVList.add(csvString);
            }
            
            if(soqlCSVList.size() > 0) {
                List<InsightsExternalDataPart> soqlExternalDataParts = new List<InsightsExternalDataPart>();
                InsightsExternalDataPart dataPart;
                
                for(Integer i=0; i<soqlCSVList.size(); i++){
                    dataPart = new InsightsExternalDataPart();
                    dataPart.DataFile = blob.valueOf(soqlCSVList[i]);
                    dataPart.InsightsExternalDataId = insightExternalDataId;
                    dataPart.PartNumber = partNumber;
                    soqlExternalDataParts.add(dataPart);
                    
                    partNumber = partNumber +1;
                }
                
                if(!Test.isRunningTest()) insert soqlExternalDataParts;
            }
            
        } else if(dataExtractType == 'oData' && oDataURL != null && oDataObject != null) { //Generate CSV for oData type data extract and create InsightsExternalDataParts
            
            oDataFieldNameList = new List<String>();
            oDataExternalDataParts = new List<InsightsExternalDataPart>();
            
            getoData();
            if(!Test.isRunningTest()) insert oDataExternalDataParts; 
            
        } else if(reportId != null) {
            
            List<String> reportCSVFiles = new List<String> {};
            Integer fieldCounter = 0;
            String csvData = '';
            
            if(!Test.isRunningTest()) {
                Reports.ReportResults res = Reports.ReportManager.runReport(reportId, true);
                Reports.ReportFactWithDetails details = (Reports.ReportFactWithDetails)res.getFactMap().get('T!T');
                Map<String, Reports.DetailColumn> columnDetails = res.getReportExtendedMetadata().getDetailColumnInfo();
                
                String[] fieldTypes = new String[columnDetails.keySet().size()];
                for (String field : columnDetails.keySet()) {
                    csvData += (csvData.equals('') ? '' : ',') + field.replace('.', '_').replace('__', '_');
                    fieldTypes[fieldCounter++] = columnDetails.get(field).getDataType().name().replace('_DATA','').toLowerCase();
                }
                csvData += ',Timestamp__c,Timestamp_String__c\n';
        
                for(Reports.ReportDetailRow reportRow : details.getRows()) {        
                    String rowData = '';
                    fieldCounter = 0;            
                    for(Reports.ReportDataCell reportCell : reportRow.getDataCells()) {
                        rowData += (rowData.equals('') ? '' : ',') + getFieldValue(reportCell, fieldTypes[fieldCounter++]);
                    }
                    rowData += ',' + currDateString.replaceAll('~~~','/') + ',' + currDateString + '\n';
                    
                    if(blob.valueOf(csvData + rowData).size() > UploadTrendingSnapshotsBatch.CONST_MAX_DATAPART_SIZE) {
                        reportCSVFiles.add(csvData);
                        csvData = '';
                    }
                    csvData += rowData;
                }
            } else {
                csvData = 'Id,Name\n1,ABC';
            }
            reportCSVFiles.add(csvData);
            if(reportCSVFiles.size() > 0) {
                
                List<InsightsExternalDataPart> reportExternalDataParts = new List<InsightsExternalDataPart>();
                InsightsExternalDataPart dataPart;
                
                for(Integer i=0; i<reportCSVFiles.size(); i++){
                    dataPart = new InsightsExternalDataPart(); 
                    dataPart.DataFile = blob.valueOf(reportCSVFiles[i]);
                    dataPart.InsightsExternalDataId = insightExternalDataId;
                    dataPart.PartNumber = i+1;
                    reportExternalDataParts.add(dataPart);
                    
                    partNumber += 1;
                }
                
                if(!Test.isRunningTest()) insert reportExternalDataParts;
            }
        }
    }

    public String getFieldValue(Reports.ReportDataCell cell, String fieldType) {
        Set<String> NUMERIC_TYPES = new Set<String> {'int','currency','double','percent'};
            
        if(fieldType.equals('date') || fieldType.equals('datetime')) {
            if(cell == null || cell.getValue() == null) return '';
            
            String strDate = String.valueOf(cell.getValue()).split(' ')[0];
            List<String> arrDate = strDate.split('-');
            Datetime dateValue = DateTime.newInstance(Integer.valueOf(arrDate[0]), Integer.valueOf(arrDate[1]), Integer.valueOf(arrDate[2]));
            return dateValue.format(UploadTrendingSnapshotsBatch.DATE_FORMAT);
            
        } else if (fieldType.equals('currency')) {
            if(cell == null || cell.getValue() == null) return '0';            
            Reports.ReportCurrency curr = (Reports.ReportCurrency)cell.getValue();
            return String.valueOf(curr.getAmount());
            
        } else if (NUMERIC_TYPES.contains(fieldType)) {
            return (cell.getValue() == null ? '0' : String.valueOf(cell.getValue()));
        } else {
            if(cell != null) {            
                String dataValue = cell.getLabel();
                dataValue = (dataValue == null) ? '' : dataValue.trim().replaceAll('"', '\'');
                return '"' + dataValue + '"';
            } else {
                return '';
            }
        }
    }    
    
    public static String getFieldType(Schema.DescribeFieldResult field) {
        
        Schema.DisplayType type = (field != null) ? field.getType() : Schema.DisplayType.String;
        if (type == Schema.DisplayType.Currency || type == Schema.DisplayType.Double
            || type == Schema.DisplayType.Integer || type == Schema.DisplayType.Percent) {
                
                return 'Numeric';
                
            } else if(type == Schema.DisplayType.Date) {
                return 'Date';
            } else if(type == Schema.DisplayType.DateTime) {
                return 'DateTime';
            } else {
                return 'String';
            }
    }
    
    public void getoData() {
       
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        //Check if URL is nextoDataURL or first page URL
        if(nextoDataURL != null) {
            req.setEndpoint((contentType == 'xml') ? nextoDataURL : (oDataURL + '/' + nextoDataURL));
        } else {
            req.setEndpoint(oDataURL + '/' + oDataObjectHref);    
        }
        
        req.setMethod('GET');
        req.setHeader('Accept', '*/*');
        String conType = '';
        HttpResponse res;
        
        if(!Test.isRunningTest()) {
            res = h.send(req);
            conType = res.getHeader('Content-Type');
        } else {
            conType = (TrendingSnapshotsMockSOQLResponse.isJson) ? 'json' : 'xml';
        }
        
        nextoDataURL = '';
        
        if(conType.contains('json')) {
            
            contentType = 'json';
            String response = !Test.isRunningTest() ? res.getBody() : TrendingSnapshotsMockSOQLResponse.getDummyJSONoData();             
            Map<String, Object> objectDetails = (Map<String, Object>)JSON.deserializeUntyped(response);
            oDataQueryResult = new List<List<Map<String, String>>>();
            
            //Parse JSON and populate required variables for CSV generation
            Map<String, String> tempValuesMap = new Map<String, String>();
            List<Map<String, String>> tempoDataQueryResult = new List<Map<String, String>>();
            
            if(objectDetails != null && objectDetails.get('value') != null) {
                
                Map<String, Object> fieldDetails = (Map<String, Object>)(((List<Object>)objectDetails.get('value'))[0]);
                
                if(fieldDetails != null && oDataFieldNameList.size() == 0) {
                    oDataFieldNameList.addAll(fieldDetails.keySet());
                }
                
                for(Object resultRow : (List<Object>)objectDetails.get('value')){
                    
                    Map<String, Object> tempRowDetail = (Map<String, Object>)(resultRow);
                    tempValuesMap = new Map<String, String>();
                    
                    for(String key : tempRowDetail.keySet()) {
                        if(tempRowDetail.get(key) != null) {  
                            tempValuesMap.put(key, String.valueOf(tempRowDetail.get(key)));
                        } else {   
                            tempValuesMap.put(key, '');
                        }
                    }
                    
                    tempoDataQueryResult.add(tempValuesMap);
                    if(tempoDataQueryResult.size() == 900) { // Why 900?
                        oDataQueryResult.add(tempoDataQueryResult);
                        tempoDataQueryResult = new List<Map<String, String>>();
                    }
                }
                
                if(tempoDataQueryResult.size() > 0) {
                    oDataQueryResult.add(tempoDataQueryResult);
                }
                nextoDataURL = String.valueOf(objectDetails.get('@odata.nextLink'));
            }
        } else { //Get reponse if the content type is XML
            
            contentType = 'xml';  
            oDataQueryResult = new List<List<Map<String, String>>>();
            Map<String, String> tempValuesMap = new Map<String, String>();            
            List<Map<String, String>> tempoDataQueryResult = new List<Map<String, String>>();
            Dom.Document doc;
            Dom.XMLNode xmlFeed;
            
            if(!Test.isRunningTest()) {
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
                                        
                                        if(dataChild.getText() != null) {  
                                            tempValuesMap.put(dataChild.getName(), dataChild.getText());
                                        } else {
                                            tempValuesMap.put(dataChild.getName(), '');
                                        }
                                    }
                                    break;
                                }
                            }
                            
                            if(oDataFieldNameList.size() == 0) {
                                oDataFieldNameList.addAll(tempValuesMap.keySet());
                            }
                            
                            tempoDataQueryResult.add(tempValuesMap);
                            if(tempoDataQueryResult.size() == 900) { // Why 900?
                                oDataQueryResult.add(tempoDataQueryResult);
                                tempoDataQueryResult = new List<Map<String, String>>();
                            }   
                            
                            break;
                        } 
                    }
                }
                
                if(child.getName() == 'link' && child.getAttributeValue('rel', null) == 'next') {
                    nextoDataURL = child.getAttributeValue('href', null);
                }
            }
            
            if(tempoDataQueryResult.size() > 0) {
                oDataQueryResult.add(tempoDataQueryResult);
            }
        }
        
        if(oDataQueryResult.size() > 0 && oDataFieldNameList.size() > 0){

            String csvString = '';
            String header = '';
            
            if(partNumber == 1) {
                for(String field : oDataFieldNameList) {
                    header += ((header == '') ? '' : ',') + field.replace('.', '_').replace('__','_');
                }
                
                header += ',Timestamp__c,Timestamp_String__c\n';
                csvString = header;
            }
            
            String dataRow;

            List<String> oDataCSVList = new List<String>();
            blob currCSVBlob;
            String dataValue;
            Map<String, String> fieldTypeMap = getoDataFieldTypeMap(oDataURL, oDataObjectHref);
            String fielddataType;
            
            for(List<Map<String, String>> rowMapList : oDataQueryResult) {
                
                for(Map<String, String> rowMap : rowMapList) {
                    dataRow = '';
                    
                    for(String field : oDataFieldNameList) {
                        dataValue = '';
                        if(rowMap.containsKey(field)) {
                            dataValue = String.valueOf(rowMap.get(field)) != null ? String.valueOf(rowMap.get(field)) : '';
                        }
                        
                        //Check if the field is relational field, if yes set type to String
                        if(field.contains('.')) {
                            fielddataType = 'String';
                        } else {
                            if(fieldTypeMap.containsKey(field) && fieldTypeMap.get(field) != null) {
                                fielddataType = fieldTypeMap.get(field);
                            } else {
                                fielddataType = 'String';
                            }
                        }
                        
                        if(fielddataType.contains('Byte') || fielddataType.contains('Decimal')
                           || fielddataType.contains('Double') || fielddataType.contains('Int16')
                           || fielddataType.contains('Single') || fielddataType.contains('Int32')
                           || fielddataType.contains('Int64') || fielddataType.contains('SByte')) {
                               
                               Double dValue = dataValue != null ? Double.valueOf(dataValue) : 0;
                               dataRow += ((dataRow == '') ? '' : ',') + dValue;

                           } else if(fielddataType.contains('DateTime') || fielddataType.contains('DateTimeOffset')) {
                                        
                               String formattedDate = '';
                               Date dateValue = (dataValue != null && dataValue != '') ? Date.valueOf(dataValue) : null;                               
                               if(dateValue != null) {
                                    Datetime dt = datetime.newInstance(dateValue.year(), dateValue.month(),dateValue.day());
                                    formattedDate = dt.format(UploadTrendingSnapshotsBatch.DATE_FORMAT);                                   
                               }
                               
                               dataRow += ((dataRow == '') ? '' : ',') + formattedDate;
                               
                           } else {
                                dataValue = (dataValue == null) ? '' : dataValue.trim().replaceAll('"', '\'');
                                dataRow += ((dataRow == '') ? '' : ',') + '"' + dataValue + '"';
                           }
                    }
                    
                    csvString += dataRow + ',' + currDateString.replaceAll('~~~', '/') + ',' + currDateString + '\n';
                    currCSVBlob = blob.valueOf( csvString );
                    
                    if(currCSVBlob.size() > UploadTrendingSnapshotsBatch.CONST_MAX_DATAPART_SIZE) {
                        oDataCSVList.add(csvString);
                        csvString = '';
                    }
                }
            }
            
            if(csvString != header && csvString != '') {
                oDataCSVList.add(csvString);
            }
            
            if(oDataCSVList.size() > 0) {
                
                InsightsExternalDataPart dataPart;
                
                for(Integer i=0; i<oDataCSVList.size(); i++) {
                    dataPart = new InsightsExternalDataPart();
                    dataPart.DataFile = blob.valueOf(oDataCSVList[i]);
                    dataPart.InsightsExternalDataId = insightExternalDataId;
                    dataPart.PartNumber = partNumber;
                    oDataExternalDataParts.add(dataPart);
                    
                    partNumber = partNumber +1;
                }
            }
        }
    }
    
    //This method will return the Map of Field Name and Field Type for oData Metadata
    global Map<String, String> getoDataFieldTypeMap(String oDataURL, String objectName){
        
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
        
        String entityName;
        Map<String, String> oDataFieldTypeMap = new Map<String, String>();
        
        for(Dom.XMLNode child : xmlFeed.getChildElements()) {           
            if(child.getName() == 'DataServices') {
                for(Dom.XMLNode innerChild : child.getChildElements()) {
                    if(innerChild.getName() == 'Schema') {
                        
                        for(Dom.XMLNode internalChild : innerChild.getChildElements()) {    
                            entityName = internalChild.getAttributeValue('Name', null);  
                            
                            System.debug(LoggingLevel.ERROR, 'Obj: ' + objectName + '...' + entityName);
                            
                            if(internalChild.getName() == 'EntityType' && 
                               (objectName == entityName + 's' ||
                                objectName == entityName.subString(0, entityName.length() -1) + 'ies' ||
                                objectName == entityName)){
                                    
                                    for(Dom.XMLNode dataChild : internalChild.getChildElements()){
                                        if(dataChild.getName() == 'Property') {      
                                            oDataFieldTypeMap.put(dataChild.getAttributeValue('Name', null), 
                                                                  dataChild.getAttributeValue('Type', null));
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
        return oDataFieldTypeMap;
    }
    
    global void finish(Database.BatchableContext BC){
        
        if(dataExtractType == 'oData') {
            
            if(nextoDataURL != null && nextoDataURL != '') {
                if(!Test.isRunningTest()) {
                    Database.executeBatch(new UploadTrendingSnapshotsBatch(nextoDataURL, dataExtractId, insightExternalDataId, partNumber, contentType, scheduledDataExtractId, currDateString));
                }
            } else {//Upload data set parts when all InsightsExternalDataParts are created
                if(insightExternalDataId != null) {            
                    InsightsExternalData obj = new InsightsExternalData(Id = insightExternalDataId, Action = 'Process');
                    
                    if(partNumber == 1) {
                        delete obj;
                    } else {                
                        update obj;
                    }
                }
            } 
        } else {
            if(insightExternalDataId != null) {             
                InsightsExternalData obj = new InsightsExternalData(Id = insightExternalDataId, Action = 'Process');
                
                if(partNumber == 1) {
                    delete obj;
                } else {                
                    update obj;
                }
            }
        }
    }
}