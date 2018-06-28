/**
 * This controller handles Report Delivery.
 *
 * @author Pablo Vigil <pablo.vigil@roundfusion.com>
 * @since 2014-08
 */
public with sharing class ReportDeliveryController {
    
     // Constants
    private static final String REPORT_URL = 'https://' + URL.getSalesforceBaseUrl().getHost() + '/';
    
    private String fieldId = null; // It is used if selected filter is a custom field
    
    public String folderId {get; set;}
    public String reportId {get; set;}
    public String filterId {get; set;}
    
    public string EmailBody{get;set;}
    public string EmailSubject{get;set;}
    public String jobName {get; set;}
    public String otherRecipient {get; set;}
    public String frequency {get; set;}
    public List<String> weeklyFrequency {get;set;}
    public String preferredTime {get; set;}
    public String frequencyMonthly {get; set;}
    public String theMonth {get; set;}
    public String theMonthDay {get; set;}
    public List<String> errorMsgs {get; set;}
    
    public String JOB_NAME_IS_REQUIRED_ERROR = 'Job name is required';
    public String PREFERRED_TIME_IS_REQUIRED_ERROR = 'Preferred time is required';
    public String FOLDER_IS_REQUIRED_ERROR = 'Folder is required';
    public String REPORT_IS_REQUIRED_ERROR = 'Report is required';
    public String FILTER_IS_REQUIRED_ERROR = 'Filter is required';
    public String WEEKLY_FREQUENCY_REQUIRED_ERROR = 'Weekly frequency is required';
    public String OTHER_RECIPIENT_ERROR = 'Other recipient emails are incorrect';
    public String SUBJECT_IS_REQUIRED_ERROR = 'Subject is required';

    public ReportDeliveryController() {
        weeklyFrequency = new List<String>();
        errorMsgs = new List<String>();
        frequency = 'Weekly';
    }
    
    /*** PRIVATE METHODS ***/
    
    /*
     * Validate data
     *
     * @param - 
     * @return Boolean
     */
    private Boolean validateData() {
                                        
        errorMsgs.clear(); // clean up errorMsgs, just in case
        
        // Validate required data
        if (jobName == '') {
            errorMsgs.add(JOB_NAME_IS_REQUIRED_ERROR);
        }
        if (preferredTime == 'None') {
            errorMsgs.add(PREFERRED_TIME_IS_REQUIRED_ERROR);
        }
        if (folderId == null) {
            errorMsgs.add(FOLDER_IS_REQUIRED_ERROR);
        }
        if (reportId == null) {
            errorMsgs.add(REPORT_IS_REQUIRED_ERROR);
        }
        if (filterId == null) {
            errorMsgs.add(FILTER_IS_REQUIRED_ERROR);
        }
        if(frequency == 'Weekly'){
            if (weeklyFrequency.size() == 0) {
                errorMsgs.add(WEEKLY_FREQUENCY_REQUIRED_ERROR);
            }
        }   
        if(otherRecipient != ''){
            if(!validateEmail()){
                //errorMsgs.add(OTHER_RECIPIENT_ERROR);
            }
        }
        if(EmailSubject==null || EmailSubject==''){
            errorMsgs.add(SUBJECT_IS_REQUIRED_ERROR );
        }
                                  
        return (errorMsgs.size() == 0);                        
    }
    
    /*
     * Validate email
     *
     * @param - 
     * @return Boolean
     */
    private Boolean validateEmail(){
        Boolean correctEmail = true;
        String pat = '[a-zA-Z0-9\\.\\!\\#\\$\\%\\&\\*\\/\\=\\?\\^\\_\\+\\-\\`\\{\\|\\}\\~\'._%+-]+@[a-zA-Z0-9\\-.-]+\\.[a-zA-Z]+';
        List<String> otherRecipients = otherRecipient.split(';');
        for (String recipient : otherRecipients) {
            if(!Pattern.matches(pat, recipient)){
                correctEmail = false;
            }
        }
        return correctEmail;
    }
    
    /*
     * Process filter first: If selected filter is a standard field leave as it is, otherwise get the id of the selected field
     * (if the selected filter is a standard field the report url uses the name of the field, otherwise the url requires the id of the custom field)
     */
    private void processFilter() {

        System.debug('FilterId:'+filterId);
        //check if the filter has a custom field or object
        boolean isAnyCustom = filterId.contains('__c') || filterId.contains('.'); 
        /**
        if(isAnyCustom){
    
            List<String> filterTypes = filterId.split('\\.');
            if (filterTypes.size() == 2) {
                // selected filter is a custom field
                
                //check if the object or the field are custom
                boolean isCustomObject = filterTypes.get(0).contains('__c');
                boolean isCustomField = filterTypes.get(1).contains('__c');
                
                String objectName = '';
                String fieldName = '';
                
                //if one is custom, the __c must be remove
                if(isCustomObject){
                    objectName = filterTypes.get(0).subString(0, filterTypes.get(0).length() - 3);
                }else{
                    objectName = filterTypes.get(0);
                }
                //if one is custom, the __c must be remove
                if(isCustomField){
                    fieldName = filterTypes.get(1).subString(0, filterTypes.get(1).length() - 3);
                }else{
                    fieldName = filterTypes.get(1);
                }
                System.debug('FieldName: '+fieldName );
                
                fieldId = ReportDeliveryUtility.getFieldId(isCustomObject, objectName, fieldName).subString(0, 15);
                 System.debug('fieldId: '+fieldId );

            } else {
                fieldId = filterId; // selected filter is a standard field
            } 
        }else {
            fieldId = filterId; // selected filter is a standard field
        }           

        **/
        
        String salesforceHost;
        Organization org = [SELECT id,isSandbox FROM Organization limit 1];
        if(org.isSandbox)
            salesforceHost = 'https://dimagi--dsandbox.cs20.my.salesforce.com';
        else
            salesforceHost = 'https://dimagi.my.salesforce.com';    

        
        String reportUrl1 = salesforceHost + '/' + reportId;
        //String reportUrl1 = 'https://dimagi--dsandbox.cs20.my.salesforce.com/00Om0000000Oxzn';
        system.debug('--reportUrl1--'+reportUrl1);
        PageReference ref = new PageReference(reportUrl1);
        ref.setRedirect(true);
        Blob b;
        if (Test.IsRunningTest())
		{
        	b = Blob.valueOf('UNIT.TEST');
   		}
   		else
   		{
        	b = ref.getContent();
   		}
        

        String output = b.toString();
        System.debug('Check file content: '+output);
        
        try
        {
            String str1 = Output.substring(Output.indexOf('Summarize information by:'));
            system.debug('--str1---'+str1);
            String str2 = str1.substring(0,str1.indexOf(filterId));
            system.debug('--str2---'+str2);
            String str3 = str2.substring(str2.lastIndexOf('<option value="'));
            system.debug('--str3---'+str3);
            String str4 = str3.replace('<option value="','');
            system.debug('--str4---'+str4);
            String str5 = str4.substring(0,str4.indexOf('"'));
            system.debug('--str5---'+str5);
            fieldId = str5;
        }catch(exception e)
        {
            fieldId = '';   
        }
    }
    
    /*** PUBLIC METHODS ***/
    
    /*
     * This methods schedule the report and creates a report delivery info record
     */   
    public PageReference scheduleReport(){
         
        if (validateData()){
        // Process filter first: If selected filter is a standard field leave as it is, otherwise get the id of the selected field
            processFilter();
            
            // Schedule the report
            Id jobId = SchedulerUtility.schedule(jobName, frequency, preferredTime, weeklyFrequency, frequencyMonthly, theMonthDay, theMonth);
            
            System.debug('JobId: '+jobId);
            
            String scheuldeError = SchedulerUtility.getErrorMsg();
            if(!scheuldeError.equals('')){
                errorMsgs.add(scheuldeError);
            }
            
            // if job is scheduled create a report delivery info records        
            if (jobId != null) {
                // create report delivery info record
                
                Boolean isCreated = ReportDeliveryUtility.createReportDeliveryInfo(jobId, reportId, filterId, fieldId, otherRecipient,emailBody,EmailSubject);
                System.debug('Is Created: '+isCreated );
            }
            
            if(errorMsgs.size() == 0){
                PageReference pageRef = Page.ReportDeliverySchedule;
            
                return pageRef;
            }else{
                return null;
            }
            
        }
        return null;
    }    
    
    public List<SelectOption> getFrequencySelectList() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Weekly','Weekly')); 
        options.add(new SelectOption('Monthly','Monthly')); 
        return options; 
    }
    
    public List<SelectOption> getFrequencyMonthlySelectList() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('On day','On day')); 
        options.add(new SelectOption('On','On')); 
        return options; 
    }
    
    public List<SelectOption> getWeeklyFrequencySelectedList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','Sunday'));
        options.add(new SelectOption('2','Monday'));
        options.add(new SelectOption('3','Tuesday'));
        options.add(new SelectOption('4','Wednesday'));
        options.add(new SelectOption('5','Thursday'));
        options.add(new SelectOption('6','Friday'));
        options.add(new SelectOption('7','Saturday'));
        return options;
    }
    
    public List<SelectOption> getTheMonthList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','the 1st'));
        options.add(new SelectOption('2','the 2nd'));
        options.add(new SelectOption('3','the 3rd'));
        options.add(new SelectOption('4','the 4th'));
        options.add(new SelectOption('L','the last'));
        return options;
    }
    
    public List<SelectOption> getMonthlyFrequencySelectedList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','1'));
        options.add(new SelectOption('2','2'));
        options.add(new SelectOption('3','3'));
        options.add(new SelectOption('4','4'));
        options.add(new SelectOption('5','5'));
        options.add(new SelectOption('6','6'));
        options.add(new SelectOption('7','7'));
        options.add(new SelectOption('8','8'));
        options.add(new SelectOption('9','9'));
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('11','11'));
        options.add(new SelectOption('12','12'));
        options.add(new SelectOption('13','13'));
        options.add(new SelectOption('14','14'));
        options.add(new SelectOption('15','15'));
        options.add(new SelectOption('16','16'));
        options.add(new SelectOption('17','17'));
        options.add(new SelectOption('18','18'));
        options.add(new SelectOption('19','19'));
        options.add(new SelectOption('20','20'));
        options.add(new SelectOption('21','21'));
        options.add(new SelectOption('22','22'));
        options.add(new SelectOption('23','23'));
        options.add(new SelectOption('24','24'));
        options.add(new SelectOption('25','25'));
        options.add(new SelectOption('26','26'));
        options.add(new SelectOption('27','27'));
        options.add(new SelectOption('28','28'));
        options.add(new SelectOption('29','29'));
        options.add(new SelectOption('30','30'));
        options.add(new SelectOption('31','31'));
        options.add(new SelectOption('L','last'));
        return options;
    }
    
    public List<SelectOption> getPreferredTimeSelectedList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--None--'));
        options.add(new SelectOption('0','12:00 AM'));
        options.add(new SelectOption('1','1:00 AM'));
        options.add(new SelectOption('2','2:00 AM'));
        options.add(new SelectOption('3','3:00 AM'));
        options.add(new SelectOption('4','4:00 AM'));
        options.add(new SelectOption('5','5:00 AM'));
        options.add(new SelectOption('6','6:00 AM'));
        options.add(new SelectOption('7','7:00 AM'));
        options.add(new SelectOption('8','8:00 AM'));
        options.add(new SelectOption('9','9:00 AM'));
        options.add(new SelectOption('10','10:00 AM'));
        options.add(new SelectOption('11','11:00 AM'));
        options.add(new SelectOption('12','12:00 PM'));
        options.add(new SelectOption('13','1:00 PM'));
        options.add(new SelectOption('14','2:00 PM'));
        options.add(new SelectOption('15','3:00 PM'));
        options.add(new SelectOption('16','4:00 PM'));
        options.add(new SelectOption('17','5:00 PM'));
        options.add(new SelectOption('18','6:00 PM'));
        options.add(new SelectOption('19','7:00 PM'));
        options.add(new SelectOption('20','8:00 PM'));
        options.add(new SelectOption('21','9:00 PM'));
        options.add(new SelectOption('22','10:00 PM'));
        options.add(new SelectOption('23','11:00 PM'));
        return options;
    }
    
    public List<SelectOption> getFolderSelectList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '-- Select Folder --',true));

        List<Folder> ff = [select Id, Name from Folder where (Type = 'Report' and Name != null) order by name];
        for (Folder folder : ff) {
            if(folder.Name != null && folder.Name != '*') {
            options.add(new SelectOption(folder.Id, folder.Name));
            }
        }
        return options;
    }

    public List<SelectOption> getReportSelectList() {
        //returns a list of Reports as SelectOptions - limited to 500
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '-- Select Report --',true));

        List<Report> reports = [SELECT Id, Name FROM Report where ownerid =: folderId order by name LIMIT 500];
        for (Report report : reports) {
            options.add(new SelectOption(report.Id, report.Name));
        }
        return options;
    }

    public List<SelectOption> getfilterSelectList() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '-- Select filter --',true));
        options.add(new SelectOption('No Filter', 'No Filter'));
        if (reportId != null && reportId != '') {
            // Run a report
            Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
            // Get the report metadata
            Reports.ReportMetadata rm = results.getReportMetadata();
            Reports.ReportExtendedMetadata rem = results.getReportExtendedMetadata();

            MAP<String,Reports.DetailColumn> columnsMap = rem.getDetailColumnInfo();
            for(String s : columnsMap.keySet()) {
                options.add(new SelectOption(columnsMap.get(s).getLabel(), columnsMap.get(s).getLabel()));
            }
            MAP<String,Reports.GroupingColumn> groupingMap = rem.getGroupingColumnInfo();
            for(String s : groupingMap.keySet()) {
                options.add(new SelectOption(groupingMap.get(s).getLabel(), groupingMap.get(s).getLabel()));
            }
        }

        return options;
   }

   public String getPopularGroupingJSON() {
        Map<String, String> popularGrouping = new Map<String, String>();
        if(String.isNotEmpty(reportId)) { 
            Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
            // Get the report metadata
            Reports.ReportMetadata rm = results.getReportMetadata();
            Reports.ReportExtendedMetadata rem = results.getReportExtendedMetadata();
            if (reportId != null) {
                MAP<String,Reports.GroupingColumn> groupingMap = rem.getGroupingColumnInfo();
                for(String s : groupingMap.keySet()) {
                    popularGrouping.put(groupingMap.get(s).getName(), groupingMap.get(s).getLabel());
                }
            }
        }
        return JSON.serialize(popularGrouping);
    }
     
}