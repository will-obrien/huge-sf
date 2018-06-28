/**
 * This utility handles Report Delivery.
 *
 * @author Diego Febles <diego.febles@roundfusion.com>
 * @since 2014-08
 */
public with sharing class ReportDeliveryUtility implements Database.AllowsCallouts { 
    
    private static final String REPORT_URL = 'https://' + URL.getSalesforceBaseUrl().getHost() + '/';
    
    private static String errorMsg = '';
     
    /*** PRIVATE STATIC METHODS ***/

    /*
     * Get report delivery info record that is associated to the currently running scheduled job
     *
     * @param Id jobId
     * @return Report_Delivery_Info
     */
    private static Report_Delivery_Info__c getReportDeliveryInfo(String jobId) {
        Report_Delivery_Info__c reportDeliveryInfo = null;
        if (jobId != null) {
            List<Report_Delivery_Info__c> reportDeliveryInfos = [SELECT Id, Email_Recipients__c,Email_body__c,Field_Id__c, Filter__c, Report_Id__c,Email_Subject__C FROM Report_Delivery_Info__c
                                                                  WHERE Job_Id__c =: jobId];
            
            if (reportDeliveryInfos.size() == 1) {
                reportDeliveryInfo = reportDeliveryInfos.get(0);
            }
        }                                                             
        
        return reportDeliveryInfo; 
    }
     
    /*
     * Send individual reports based on the filter 
     */
    private static void sendEmail(Id reportId, String filter, Map<String, String> options, String otherRecipients,string body,string subject) {
        
        String username ;
        String password ;
        for(LoginDetail__c cs: LoginDetail__c.getAll().values()){
                username = cs.Name;
                password = cs.Password__c + cs.Security_Token__c;
        }
        
        system.debug('Options Size: '+options.size());
        if(options != null && options.size() > 0){
            
        
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            ApexPages.PageReference report = null;
            
            Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
            Reports.ReportMetadata rm = results.getReportMetadata();
            Reports.ReportExtendedMetadata rem = results.getReportExtendedMetadata();
            List<Reports.ReportFilter> filters = rm.getReportFilters();
            
            Integer filterNumber = filters.size();
            
            string booleanfilter= rm.getReportBooleanFilter();
            System.debug('options: '+options.keySet());
            Map<Id,Contact> contacts = new Map<Id, Contact>([SELECT Id, email FROM Contact WHERE Id =: options.keySet()]); 
            Map<Id,User> users = new Map<Id,User>([SELECT Id, email FROM User WHERE Id =: options.keySet()]);
            Map<id,SFDC_Employee__c> employee=new Map<Id,SFDC_Employee__c>([SELECT Id, Email_Address__c FROM SFDC_Employee__c WHERE Id =: options.keySet()]);
            try {
                System.debug('Other Top:'+otherRecipients);
                for (String ownerId : options.keySet()) {
                    
                    string email='';
                    Boolean hasEmail = false;
                    if (contacts.containsKey(ownerId) && contacts.get(ownerId).Email != null){
                            hasEmail = true; 
                            email=contacts.get(ownerId).Email;
                    }else if (users.containsKey(ownerId) && users.get(ownerId).Email != null){
                            hasEmail = true;
                            email=users.get(ownerId).Email;
                    }else if(employee.containsKey(ownerId) && employee.get(ownerId).Email_Address__c != null){
                            hasEmail = true;
                            email=employee.get(ownerId).Email_Address__c;
                    }
                    System.debug('Email: '+email);
                    if(hasEmail){
                        //for contact Name set Constant ID
                        if(filter=='Contact.Name'){
                            filter='072b0000000M3Gg';
                        }
                         
                        String urlForReport = reportId + '?pc' + filterNumber + '=' + filter + '&pn' + filterNumber + '=eq&pv' + filterNumber + '=';
                        urlForReport += EncodingUtil.urlEncode(options.get(ownerId), 'UTF-8');
                        
                        if(booleanfilter!=null && booleanfilter!=''){
                            urlForReport +='&bool_filter=( '+booleanfilter+' ) and '+(filterNumber+1); //ERROR fixed : The additional filterNumber + 1 is not required
                            //urlForReport +='&bool_filter=( '+ booleanfilter +' )';
                        }   
                        urlForReport=urlForReport  + '&csv=1&exp=1';
                        string reportUrl=URL.getSalesforceBaseUrl().toExternalForm().replace('http:', 'https:')+'/'+urlForReport;
                        system.debug('--ReportURL--'+reportUrl); 
                        string requestUrl=URL.getSalesforceBaseUrl().toExternalForm().replace('http:', 'https:')+'/services/apexrest/sendExcelmail';
                        String emailBody = 'Hi,<br/><br/>'+body+'<br/><br/> Please use the following link to open the result: ';
                        emailBody += '<a href=' + REPORT_URL + reportId + '>Report</a>';
                        
                        sendHttpCallOut(requestUrl,email,emailBody,reportUrl,username,password,subject);
                        
                    }
                }
                System.debug('Other:'+otherRecipients);
                // generate a single email report for other recipients
                if (otherRecipients != null && otherRecipients != '') {
                    
                    generateEmailForOtherRecipients(otherRecipients,body, reportId,username,password,subject);
                }
            } catch (Exception e) {
                System.debug('### Exception while attempting to send an email attachment: ' + e.getMessage());                
            }
        }
        else{
            //If No Filter is selected 
            if (otherRecipients != null && otherRecipients != '') {
                generateEmailForOtherRecipients(otherRecipients,body, reportId,username,password,subject);
            }
        }
    }
    
    @future(callout=true)
    private static void sendHttpCallOut(string requestUrl,string email,string emailBody,string reportUrl,string username,string password,string subject) {
        // get session id 
        String sessionId= LoginClass.login(username,password);
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(requestUrl);
        req.setMethod('POST');
        
        req.setHeader('Authorization', 'OAuth '+sessionId);
        req.setHeader('Content-Type','application/json');

        Map<String,String> postBody = new Map<String,String>();
        postBody.put('EmailIdCSV',email);
        postBody.put('Subject',subject);
        postBody.put('body',emailBody);
        postBody.put('urlForReport', reportUrl);
        String reqBody = JSON.serialize(postBody);

        req.setBody(reqBody);
        Http http = new Http();
        if(!Test.isRunningTest()) {
            HttpResponse response = http.send(req);
        }
    }
    
    /*
     * Generate a single email with a single report for other recipients without applying the filter
     */ 
    @future(callout=true)
    private static void generateEmailForOtherRecipients(String otherRecipients,string body, String reportId,string username,string password,string subject) {
        
        // split other recipients
        List<String> recipients = otherRecipients.split(';');

        if (recipients.size() > 0) {
            
            // get session id 
            String sessionId= LoginClass.login(username,password);
            string reportUrl=URL.getSalesforceBaseUrl().toExternalForm().replace('http:', 'https:')+'/' + reportId  + '?csv=1&exp=1';
            string requestUrl=URL.getSalesforceBaseUrl().toExternalForm().replace('http:', 'https:')+'/services/apexrest/sendExcelmail';
            String emailBody = 'Hi,<br/><br/>'+body+'<br/><br/> Please use the following link to open the result: ';
            emailBody += '<a href=' + REPORT_URL + reportId + '>Report</a>';
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(requestUrl);
            req.setMethod('POST');
            
            req.setHeader('Authorization', 'OAuth '+sessionId);
            req.setHeader('Content-Type','application/json');

            Map<String,String> postBody = new Map<String,String>();
            postBody.put('EmailIdCSV',otherRecipients);
            postBody.put('Subject',subject);
            //postBody.put('Subject','TEST Dimagi Report Delivery');
            postBody.put('body',emailBody);
            postBody.put('urlForReport', reportUrl);
            String reqBody = JSON.serialize(postBody);

            req.setBody(reqBody);
            Http http = new Http();
            if(!Test.isRunningTest()) {
                HttpResponse response = http.send(req);
            }
        }
    }
    
    /*** PUBLIC STATIC METHODS ***/
    
    /*
     * Create Report_Delivery_Info record
     *
     * @param Id reportId, String filter, List<String> emailRecipients
     * @return Boolean - true if record is created successfully
     */
    public static Boolean createReportDeliveryInfo(Id jobId, Id reportId, String filter, String fieldId, String emailRecipients,string emailBody,string subject) {

        Boolean isSuccess = true;
        
        Report_Delivery_Info__c reportDeliveryInfo = new Report_Delivery_Info__c();
        reportDeliveryInfo.Job_Id__c = jobId;
        reportDeliveryInfo.Report_Id__c = reportId;
        reportDeliveryInfo.Filter__c = filter;
        reportDeliveryInfo.Field_Id__c = fieldId;
        reportDeliveryInfo.Email_Recipients__c = emailRecipients;
        reportDeliveryInfo.Email_Body__C=emailBody;
        reportDeliveryInfo.Email_Subject__C=subject;
                   
        try {
            insert reportDeliveryInfo;
        } catch (Exception e) {
            isSuccess = false;
            errorMsg = e.getMessage();
            System.debug('### ReportDeliveryUtility:createReportDeliveryInfo - An error has ocurred while attempting to create Report Delivery Info record: ' + e.getMessage());
        }
        
        return isSuccess;    
    }
    
    /*
     * This method get the report & filter using the information from report delivery info record. 
     */
    public static void deliverReport(String jobId) {
        // Get the report that is related with jobId
        Report_Delivery_Info__c reportDeliveryInfo = getReportDeliveryInfo(jobId);
 
        if (reportDeliveryInfo != null) {
            
            Map<String, String> groupingMap  = new Map<String, String>();
            
            if (reportDeliveryInfo.Report_Id__c != null && reportDeliveryInfo.Report_Id__c != '' && reportDeliveryInfo.Filter__c != null &&
                reportDeliveryInfo.Filter__c != '') {
                
                Id reportId = reportDeliveryInfo.Report_Id__c;
                String filter = reportDeliveryInfo.Filter__c;
                
                // Run a report
                Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
                // Get the report metadata
                Reports.ReportMetadata rm = results.getReportMetadata();
                Reports.ReportExtendedMetadata rem = results.getReportExtendedMetadata();
                // Get report format
                Reports.ReportFormat reportType = rm.getReportFormat();
                
                // Construct a fact map key, using the grouping key value
                String factMapKey = '';
                
                List<String> factMapKeyList = new List<String>();
                
                // Construct a fact map key, using the grouping key value
                if(reportType == Reports.ReportFormat.SUMMARY) {
                    // Get the first down-grouping in the report
                    Reports.Dimension dim = results.getGroupingsDown();
                    
                    List<Reports.GroupingValue> groupingVals = dim.getGroupings();
                    
                    for(Reports.GroupingValue s : groupingVals){
                        factMapKeyList.add(s.getKey() + '!T');
                    }
                } else if (reportType == Reports.ReportFormat.TABULAR) {
                    factMapKeyList.add('T!T');
                }
                
                // Get the index of the column in order to get data from row.
                MAP<String, Reports.DetailColumn> columnsMap = rem.getDetailColumnInfo();
                Integer colIndex = 0;
                Boolean isExist = false;
                
                system.debug(filter);
                
                for(String s : columnsMap.keySet()) {
                    //system.debug('--filter::--columnsMap.get(s).getName');
                    
                    if (filter == columnsMap.get(s).getLabel()) {
                        isExist = true;
                        break;
                    }
                    
                    colIndex = colIndex + 1;
                }
                
                // hold information about where to send the report
                Map<String,String> recipients = new Map<String,String>();

                if (isExist) {
                    System.debug(isExist);
                    System.debug('Column Index:'+colIndex);
                    for (String s : factMapKeyList) {
                        System.debug(s);
                        factMapKey = s;
                        
                        // Get the fact map from the report results
                        Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get(factMapKey);  
                        
                        for(Reports.ReportDetailRow r : factDetails.getRows()) {
                            Reports.ReportDataCell cell = r.getDataCells()[colIndex];
                            if (cell.getValue() != null && !recipients.containsKey((String)cell.getValue())) {
                                recipients.put((String)cell.getValue(), cell.getLabel());
                            }
                        }
                    }
                } else {
                     // Get the first down-grouping in the report
                    Reports.Dimension dim = results.getGroupingsDown();
                    
                    List<Reports.GroupingValue> groupingVals = dim.getGroupings();
                    
                    for (Reports.GroupingValue s : groupingVals) {
                        if (s.getValue() != null) {
                            string valueType = getType(s.getValue());
                            string value = valueType == 'Date' || valueType == 'DateTime' || valueType == 'Time'? String.valueOf(s.getValue()): (String)s.getValue();
                            if(!recipients.containsKey(value)) {
                            	recipients.put(value, s.getLabel());
                            }
                        }
                    }
                }
                system.debug('--recipients--'+recipients);
                
                string body=reportDeliveryInfo.Email_Body__C!=null?reportDeliveryInfo.Email_Body__C:'';
                string subject=reportDeliveryInfo.Email_Subject__C!=null?reportDeliveryInfo.Email_Subject__C:'';
                sendEmail(reportDeliveryInfo.Report_Id__c, reportDeliveryInfo.Field_Id__c, recipients, reportDeliveryInfo.Email_Recipients__c,body,subject); 
            }
        }                           
    }
    
    public static String getFieldId(Boolean isCustomObject, String objectName, String fieldName) {
        String fieldId = null;
        
        if (objectName != null && objectName != '' && fieldName != null && fieldName != '') {
        
            ToolingAPI toolingAPI = new ToolingAPI();
                    
            String tableEnumOrId = null;
            
            // if objectName is a custom object then we need to get objectName's ID
            if (isCustomObject) {
                
                // Get CustomObject Id
                ToolingAPI.QueryResult result = toolingAPI.query('Select Id From CustomObject Where DeveloperName = \'' + objectName + '\'');
                
                if (result != null) {
                    List<ToolingAPI.CustomObject> customObjects = (List<ToolingAPI.CustomObject>) result.records;
                
                    if (customObjects.size() == 1) {
                        tableEnumOrId = customObjects.get(0).Id;
                    }               
                }               
            } else {
                tableEnumOrId = objectName; // object is a standard object, thus we use its enum value
            }
            
            if (tableEnumOrId != null) {
                
                // Get custom field Id
                ToolingAPI.QueryResult result = toolingAPI.query('Select Id, DeveloperName, TableEnumOrId From CustomField Where DeveloperName = \'' + fieldName + '\' and TableEnumOrId = \'' + tableEnumOrId + '\''); 
                
                if (result != null) {
                    List<ToolingAPI.CustomField> customFields = (List<ToolingAPI.CustomField>) result.records;
                
                    if (customFields.size() == 1) {
                        fieldId = customFields.get(0).Id;   
                    }
                }
            }
        }
        
        return fieldId;    
    }       
    
    public static string getType(Object o) {
        if(o==null) return '';              // we can't say much about null with our current techniques
        if(o instanceof SObject)            return ((SObject)o).getSObjectType().getDescribe().getName()+''; 
        if(o instanceof Boolean)            return 'Boolean';
        if(o instanceof Id)                 return 'Id';
        if(o instanceof String)             return 'String';
        if(o instanceof Blob)               return 'Blob';
        if(o instanceof Date)               return 'Date';
        if(o instanceof Datetime)           return 'Datetime';
        if(o instanceof Time)               return 'Time';
        if(o instanceof String)             return 'String';
        if(o instanceof Integer)            return 'Integer';
        if(o instanceof Long)               return 'Long';
        if(o instanceof Decimal)            return 'Decimal';  // we can't distinguish between decimal and double
        if(o instanceof Double)             return 'Double';   // we can't distinguish between decimal and double
        if(o instanceof List<object>)       return 'List';
        return 'Object';                    // actually we can't detect maps and sets and maps
	}
}