/**********************************************************************************************************************
*   Market Traders Institute, Inc.    CONFIDENTIAL
* ---------------------------------------------------------------------------------------------------------------------
*   [2015] Market Traders Institute
*   All Rights Reserved
*
*   NOTICE:  All information contained herein is, and remains the property of Market Traders Institute, Inc. and its
*   suppliers, if any.  The intellectual and technical concepts contained herein are proprietary to Market Traders 
*   Institute, Inc. and its suppliers and may be covered by U.S. and Foreign Patents, patents in process, and are 
*   protected by trade secret or copyright law.  Dissemination of this information or reproduction of this material
*   is strictly forbidden unless prior written permission is obtained from Market Traders Institute, Inc.
*
*   Date Created:       2/10/2014
*   Author:             Jim Hutcherson 
*   Last Modified:      2/29/2016
*   Last Modified By:   Asha Calderon
*
*   11/28/15 - sm: code clean up
*   2/7/16 - aac: added Social Webinar Processor 
*   2/8/16 - sm: modifications to support moodle webinar processing
*  2/23/16 - sm: modification to support orientation webinar processing
*   2/29/16 - aac: updated stamp type (webinartypeother) for ctr processor
*   
**********************************************************************************************************************/
/*************************************
*   ProcessorController
*   @description: controller for the processor functionality
*
**/
global class ProcessorController {
    
    public Boolean debug {get; set;}
    public String debugNotify {get; set;}
        
    /**
    *   The following variables are used with bound elements on the following pages:    
    *
    **/
    public String selected_Prod {get; set;}
    public String selectedWebinar {get; set;}
    public String selectedProcessor {get; set;}
    public String selectedProcessorName {get; set;}
    public String datasourceName {get; set;}
    
    public Processor processor {get; set;}
    public Attachment upload {get; set;}
    public String preview {get; set;}
    public String recordsPerPage {get; set;}
    public Boolean processorCalled {get; set;}
    
    /*************************************
    *   
    *   @description: constructor
    *
    **/
    public ProcessorController() {
        this.processorCalled = false;
        this.upload = new Attachment();
        this.preview = '0';
        this.recordsPerPage = '50';
    }
    
    /*************************************
    *
    *   @method: setProcessorRecordsetController
    *   @description: sets up Opportunities to work with a record set controller and paginate through records
    *   like a list view 
    *
    **/ 
    public void setProcessorRecordsetController() {
        try {
            if ((preview != null) && (preview.equals('1'))) {
                /* Deserialize Previously Stored Opps */
                Attachment opportunitiesAttachment = [SELECT Id, body FROM Attachment 
                                                        WHERE ParentId = :this.processor.getLog().id 
                                                        AND Name = 'Opportunities'];
                                                        
                String serializedOpportunities = opportunitiesAttachment.body.toString();
                Set<Id> oppIds = (Set<Id>)JSON.deserialize(serializedOpportunities, Set<Id>.class);
                this.processor.recordsetController = new ApexPages.StandardsetController(Database.getQueryLocator(
                            [SELECT Name, CloseDate, Mass_Update_Select__c, CreatedDate, AccountId, StageName, RecordTypeId,
                                    OwnerId, Product__c, Account_Email__c
                                FROM Opportunity 
                                WHERE Id in :oppIds ORDER BY CreatedDate ASC]));
                this.processor.recordsetController.setPageSize(Integer.valueOf(this.recordsPerPage));
            }
            else if ((preview != null) && (preview.equals('2'))) {
                /* Deserialize Previously Stored Webinar Attendance */
                Attachment webinarAttendanceAttachment = [SELECT Id, body FROM Attachment 
                                                            WHERE ParentId = :this.processor.getLog().id 
                                                            AND Name = 'Webinar Attendance'];
                                                            
                String serializedWebinarAttendance = webinarAttendanceAttachment.body.toString();
                Set<Id> webinarAttendanceIds = (Set<Id>)JSON.deserialize(serializedWebinarAttendance, Set<Id>.class);
                this.processor.recordsetController = new ApexPages.StandardsetController(Database.getQueryLocator(
                            [SELECT Id ,Account__r.PersonEmail, Lead__r.Email, Lead__r.Alternate_Email__c, First_Name__c, Last_Name__c,
                                    Email__c, Lead__c, Account__c, Citrix_Join_URL__c, Duration__c, Attended__c, Registration_Date__c,
                                    Source_Other__c, Raised_Hands__c, Join_Time__c, Leave_Time__c 
                                FROM Webinar_Attendance__c 
                                WHERE Id in :webinarAttendanceIds 
                                ORDER BY Attended__c DESC, Join_Time__c ASC,Account__c ASC NULLS LAST,Lead__c ASC NULLS LAST]));
                                
                this.processor.recordsetController.setPageSize(Integer.valueOf(this.recordsPerPage));
            }
            else {
                this.processor.recordsetController = null;
            }
        }
        catch(Exception ex) {
            System.debug(ex);           
        }
    }
    
    /*************************************
    *
    *   @method: setProcessorRecordsetControllerPageSize
    *   @description: sets up Opportunities to work with a record set controller and paginate through records
    *   like a list view - sets the number of records per page
    *
    **/ 
    public void setProcessorRecordsetControllerPageSize() {
        if (this.processor.recordsetController != null) {
            this.processor.recordsetController.save();
            this.processor.recordsetController.setPageSize(Integer.valueOf(this.recordsPerPage));
        }
    }
    
    /**
    *
    *   @method: loadProcessorHomePage
    *   @description: navigation Methods to bring user through processor wizard - loads the first visualforce page of the processor
    *   @return: Processor_Home visualforce page  
    *   
    **/    
    public PageReference loadProcessorHomePage() {
        PageReference processorHome = Page.Processor_Home;
        processorHome.setRedirect(true);
        return processorHome;
    }
 
    /**
    *
    *   @method: loadProcessorDataPage
    *   @description: navigation Methods to bring user through processor wizard - loads the second visualforce page of the processor
    *   associates the processor variable with its appropriate processor class with the configuration needed and data parser needed
    *   based on the picklist value chosen in the processor home page.
    *   @return: Processor_Data visualforce page  
    *   
    **/   
    public PageReference loadProcessorDataPage() {
        if (this.selectedProcessor != null) {
            if (this.selectedProcessor.equals('3')) {
                this.processor = new FrontEndProcessor();
                this.selectedProcessorName = 'Front End';
                this.processor.configure();
            }
            else if (this.selectedProcessor.equals('4')) {
                this.processor = new OptionsProcessor();
                this.selectedProcessorName = 'Options Processor';
                this.processor.configure();
            }
            else if (this.selectedProcessor.equals('5')) {
                this.processor = new TalkpointProcessor();
                this.selectedProcessorName = 'Talkpoint Processor';
                this.processor.configure();
             }
             else if (this.selectedProcessor.equals('6')) {
                this.processor = new LMFSProcessor();
                this.selectedProcessorName = 'Micro Processor';
                this.processor.configure();       
            }
            else if (this.selectedProcessor.equals('7')) {
                this.processor = new BackEndProcessor(); 
                this.selectedProcessorName = 'BackEnd Processor';
                this.processor.configure();
            }
            else if (this.selectedProcessor.equals('9')) {
                this.processor = new USCProcessor(); 
                this.processor.webinartypeother = 'USOP'; // USOP webinar attendance stamp
                this.processor.leadtypeother = '012110000000pk4'; //usc lead record type
                this.selectedProcessorName = 'USOP Processor';
                this.processor.configure();
            }
            else if (this.selectedProcessor.equals('8')) {
                this.processor = new LMFSProcessor(); 
                this.processor.webinartypeother = 'UMS'; // UMS webinar attendance stamp
                this.processor.leadtypeother = '012600000005NvK'; //ums lead record type
                this.selectedProcessorName = 'UMS Processor';
                this.processor.configure();
            }
            else if (this.selectedProcessor.equals('10')) {
                this.processor = new ReadyTalkProcessor(); 
                this.processor.webinartypeother = 'UTP'; // stamping
                this.processor.leadtypeother = '012600000005Cwi'; // lead record type
                this.processor.opprectypeother = '012600000005Cwx'; //opp record type
                this.processor.producttypeother =  'UTP OnDemand';  //product      
                this.selectedProcessorName = 'ReadyTalk-Frontend Processor';
                this.processor.configure();
            }
            else if (this.selectedProcessor.equals('12')) {
                this.processor = new ReadyTalkProcessor(); 
                this.processor.webinartypeother = 'Continued Education'; 
                this.processor.leadtypeother = '012600000005Izy'; 
                this.processor.opprectypeother = '012600000005Cwx';
                this.processor.producttypeother = 'Continued Education Sales';        
                this.selectedProcessorName = 'ReadyTalk-Backend Processor';
                this.processor.configure();
            }
            else if (this.selectedProcessor.equals('11')) {
                this.processor = new ReadyTalkProcessor(); 
                this.processor.webinartypeother = 'USOP Sales';  
                this.processor.leadtypeother = '012600000005Nyd'; 
                this.processor.opprectypeother = '012600000005Nyi';
                this.processor.producttypeother =  'Ultimate Stock and Options Package';    
                this.selectedProcessorName = 'ReadyTalk-USOP Processor';
                this.processor.configure();                
            }
            else if (this.selectedProcessor.equals('13')) {
                this.processor = new ReadyTalkProcessor(); 
                this.processor.webinartypeother = 'Micro'; 
                this.processor.leadtypeother = '012600000005Nmr'; 
                this.processor.opprectypeother = '012600000005Cwx';
                this.processor.producttypeother = 'Micro';       
                this.selectedProcessorName = 'ReadyTalk-Micro Processor';
                this.processor.configure();
            }
            else if (this.selectedProcessor.equals('14')) {
                this.processor = new ClassesProcessor();
                this.selectedProcessorName = 'Classes Processor';
                this.processor.configure();
            }
            else if (this.selectedProcessor.equals('18')) {            // For orientation (uses classes processor)
                this.processor = new ClassesProcessor();
                this.selectedProcessorName = 'Classes Processor';
                this.processor.configure();
                this.processor.webinartypeother = 'Orientation';
            }
            else if (this.selectedProcessor.equals('16')) {
                this.processor = new SocialProcessor(); 
                this.processor.webinartypeother = 'Social Media Preview';
                this.processor.leadtypeother = '012600000005Cwi'; 
                this.processor.opprectypeother = '012600000005Cwx';
                this.processor.producttypeother = '';       
                this.selectedProcessorName = 'Social Processor';
                this.processor.configure();
            }
            else if (this.selectedProcessor.equals('17')) {
                this.processor = new CTRProcessor(); 
                this.processor.webinartypeother = 'Chiefs Trading Club'; //todo
                this.processor.leadtypeother = '012600000005Izy'; //todo
                this.processor.opprectypeother = '012600000005Cwx'; //todo
                this.processor.producttypeother = 'FX Chief Trading Club';       
                this.selectedProcessorName = 'CTR Processor';
                this.processor.configure();
            }
            else if (this.selectedProcessor.equals('15')) {
                this.processor = new CTRProcessor(); 
                this.processor.webinartypeother = 'Chiefs Trading Club'; //todo
                this.processor.leadtypeother = '012600000005Izy'; //todo
                this.processor.opprectypeother = '012600000005Cwx'; //todo
                this.processor.producttypeother = 'FX Chief Trading Club Elite';       
                this.selectedProcessorName = 'CTR Elite Processor';
                this.processor.configure();
            }
        }                  
        else {
            return null;
        }
        
        PageReference processorData = Page.Processor_Data;
        processorData.setRedirect(false);
        return processorData; 
    }
    
    /****************
    *
    *   @method: loadProcessorVerifyWebinarPage
    *   @description: navigation Methods to bring user through processor wizard - loads the third visualforce page
    *   calls the parseData method in processor class determined from the picklist on the home page of the wizard
    *   @return: Processor_Verify_Webinar visualforce page  
    *   
    **/ 
    public PageReference loadProcessorVerifyWebinarPage() {
        try {
            if (this.processor.getConfiguration().csv) {
                this.datasourceName = this.upload.Name;
                this.processor.parseData(this.upload.Body.toString());
                this.upload = null;
            }
            else {
                this.datasourceName = 'Ready Talk Records';
                this.processor.parseData(this.selectedWebinar);
                this.upload = null;
            }
            
            PageReference verifyWebinar = Page.Processor_Verify_Webinar;
            return verifyWebinar;
        }
        catch(Exception ex) {
            System.debug('loadProcessorVerifyWebinarPage: ' + ex.getMessage());
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage() + ' at line ' + String.valueOf(ex.getLineNumber()) + ' ***STACK TRACE*** ' + ex.getStackTraceString());
            if (ex.getMessage().contains('UTF')) {               
               errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'Encoded characters found in upload file. Please contact an Administrator to save the file in a UTF-8 format.  Error:'+ex.getMessage() + ' at line ' + String.valueOf(ex.getLineNumber()) + ' ***STACK TRACE*** ' + ex.getStackTraceString());            
            }

            ApexPages.addMessage(errorMessage);
            return null;            
        }
    }
    
    
    /****************
    *
    *   @method: loadProcessorSettingsPage
    *   @description: navigation Methods to bring user through processor wizard - loads the fourth visualforce page
    *   @return: Processor_Settings visualforce page  
    *   
    **/ 
    public PageReference loadProcessorSettingsPage() {
        PageReference processorSettings = Page.Processor_Settings;
        processorSettings.setRedirect(false);
        return processorSettings;
    }
    
    /****************
    *
    *   @method: loadProcessorPreviewPage
    *   @description: navigation Methods to bring user through processor wizard - loads the last visualforce page
    *   @return: Processor_Preview visualforce page  
    *   
    **/ 
    public PageReference loadProcessorPreviewPage() {
        try {
            return Page.Processor_Preview;
        }
        catch(Exception ex) {
            System.debug('loadProcessorPreviewPage: ' + ex.getMessage());
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage() + ' at line ' + String.valueOf(ex.getLineNumber()) + ' ***STACK TRACE*** ' + ex.getStackTraceString());
            ApexPages.addMessage(errorMessage);
            return null;    
        }
    }
    
    /****************
    *
    *   @method: startPreProcess
    *   @description: navigation Methods to bring user through processor wizard - calls the parseData method in 
    *   the processor class determined from the picklist on the home page of the wizard
    *   
    **/ 
    public void startPreProcess() {
        try {
            if (this.processorCalled == false) {
                this.processor.updateWebinar();
                this.processor.preprocess();
                this.processorCalled = true;
            }
        }
        catch(Exception ex) {
            System.debug('loadProcessorPreviewPage: ' + ex.getMessage());
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage() + ' at line ' + String.valueOf(ex.getLineNumber()) + ' ***STACK TRACE*** ' + ex.getStackTraceString());
            ApexPages.addMessage(errorMessage); 
        }
    }
    /****************
    *
    *   @method: loadProcessorResults
    *   @description: navigation Methods to bring user through processor wizard - calls the run method in 
    *   the processor class determined from the picklist on the home page of the wizard
    *   
    **/ 
    public PageReference loadProcessorResults() {
        try {
            return this.processor.run();
        }
        catch(Exception ex) {
            System.debug('loadProcessorResults: ' + ex.getMessage());
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage() + ' at line ' + String.valueOf(ex.getLineNumber()) + ' ***STACK TRACE*** ' + ex.getStackTraceString());
            ApexPages.addMessage(errorMessage);
            return null;        
        }
    }
    
    /****************
    *
    *   @method: getPreProcessStatus
    *   @description: visual force remote call gets the status of the processor apex batch job and displays the status on the visualforce page
    *   @return: status from the job or a -2 to state that the job is finished or a -1 if there is an error
    *   
    **/ 
    //Asha: 1/30/15 added handling for apex with null results - handles issue with apex error on page for delayed batch processing
    @RemoteAction
    global static String getPreProcessStatus(String processId) {
        try {
            System.debug('@asha: @debug: ProcessorController - processorid = ' + processId);
            List<AsyncApexJob> aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors 
                                        FROM AsyncApexJob 
                                        WHERE ID =:processId LIMIT 1];
                                        
            if (aaj != null && aaj.size() > 0 ) {
                return JSON.serialize(aaj[0]);
            }
            else {
                List<CronTrigger> ctrg = [Select Id, State from CronTrigger WHERE Id = :processId LIMIT 1];
                if (ctrg != null && ctrg.size() > 0 ) {
                    return JSON.serialize(ctrg[0]);
                }
            }
            
            return '-2';    
        }
        catch(Exception ex) {
            System.debug(ex);
            return '-1';
        }
    }
    
    /****************
    *
    *   @method: getProcessors
    *   @description: creates the picklist of processor types on the processor home visual force page
    *   @return: returns the selectoptions list for display
    *   
    **/ 
    /* Picklist Methods */
    //Asha: 1/30/15 added Forex Continued Education and LMFS select options  for new processors
    public List<SelectOption> getProcessors() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0', 'Select'));
        options.add(new SelectOption('3', 'Front End'));
        options.add(new SelectOption('5', 'Talkpoint'));    
        options.add(new SelectOption('6', 'Micro')); 
        options.add(new SelectOption('8', 'UMS'));
        options.add(new SelectOption('9', 'USOP'));                          
        options.add(new SelectOption('7', 'Continued Education Sales'));            
        options.add(new SelectOption('10', 'ReadyTalk-Frontend')); 
        options.add(new SelectOption('11', 'ReadyTalk-USOP'));        
        options.add(new SelectOption('12', 'ReadyTalk-Backend'));        
        options.add(new SelectOption('13', 'ReadyTalk-Micro')); 
        options.add(new SelectOption('14', 'Classes'));
        options.add(new SelectOption('18', 'Orientation'));       
        options.add(new SelectOption('16', 'Social'));   
        options.add(new SelectOption('17', 'FX Chief Trading Club'));   
        options.add(new SelectOption('15', 'FX Chief Trading Club Elite'));      
        return options;
    }

    /****************
    *
    *   @method: getPreviewOptions
    *   @description: creates the picklist options for the preview - not currently in use
    *   @return: returns the select options list for display
    *   
    **/ 
    public List<SelectOption> getPreviewOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0', '--Select--'));
        options.add(new SelectOption('1', 'Opportunities'));
        options.add(new SelectOption('2', 'Webinar Attendance'));
        return options;
    }
    
    /****************
    *
    *   @method: getTableSizeOptions
    *   @description: creates the picklist options for the preview - not currently in use
    *   @return: returns the selectoptions list for display
    *   
    **/     
    public List<SelectOption> getTableSizeOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('5', '5'));
        options.add(new SelectOption('10', '10'));
        options.add(new SelectOption('25', '25'));
        options.add(new SelectOption('50', '50'));
        options.add(new SelectOption('100', '100'));
        options.add(new SelectOption('250', '250'));
        options.add(new SelectOption('500', '500'));
        return options;
    } 
    
    /****************
    *
    *   @method: getPromotions
    *   @description: creates the picklist options for the preview - not currently in use
    *   @return: returns the selectoptions list for display
    *   
    **/     
    public List<SelectOption> getPromotions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0', '--None--'));
        options.add(new SelectOption('0', '--Select--'));
        Schema.DescribeFieldResult fieldResult = Opportunity.Promotions_Received__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    
    public Boolean getIsNotClassesProcessor() {
        return (this.selectedProcessorName != 'Classes Processor');
    }
}