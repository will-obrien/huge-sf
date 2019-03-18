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
*   Date Created:       ???
*   Author:             Jim Hutcherson 
*   Last Modified:      7/10/2015
*   Last Modified By:   Asha Calderon
*
*   
*   
**********************************************************************************************************************/
/*************************************
*   TalkpointProcessor
*   @description: controller for the talkpoint processor
*
**/
public with sharing class TalkpointProcessor extends Processor{
    
  /***************************
  * @method: constructor
  *
  **/ 
    public TalkpointProcessor(){
        
    }
    
    /************************
     @method: configure
     @description: override method from abstract class Processor, used to setup the variables for the processor
    **/
    public override void configure() {
        this.configuration = new ProcessorConfiguation();
        
        /* Configure Processor Data Options */
        this.configuration.csv = true;
        this.configuration.api = false;
        this.configuration.manualWebinarSelection = false;
        this.configuration.manualDateSelection = true;
        
        /* Configure Processor Settings Options */
        this.configuration.skipSettings = true;

        /* Configure Opportunity Details */
        this.configuration.opportunityRecordTypeId = '012600000005Cwx';
        this.configuration.opportunityRecordTypeName = 'Education';
        this.configuration.opportunityName = 'UTP OnDemand (' + String.valueOf(Date.today()) + ')';
        this.configuration.opportunityProduct = 'UTP OnDemand';
        this.configuration.opportunityStageName = 'New Deal';
        this.configuration.opportunitySubStage = null;
        this.configuration.paymentPlan = null;
        this.configuration.opportunityCloseDate = ProccessorHelperMethods.getEndOfQuarterDate(Date.today());
        
        this.configuration.opportunityOwnersMap = this.getOpportunityOwners();
        this.configuration.setOpportunityOwnerAssignmentVariables();
        
        this.configuration.leadRecordTypeId = '012600000005Cwi';
        
        this.configuration.taskWebinarType = 'UTP OnDemand';
        this.configuration.taskActivityType = 'OnDemand Webinar';
    }
    
    
    /***************************
    * @method: parseData
    * 
    * @description: takes the information from the talkpoint csv file and parses the data using the formatting from a custom setting
    *  TalkpointColMap__c. Adds the necessary data to the webinar record or creates a new processor record from the lines of attendance
    *  data. Sends the data to a json attachment on the webinar for later processing
    *
    * @param: dataToParse - the converted string of the csv file
    *
    **/    
    public override void parseData(String dataToParse){
        this.intializeLog();
        Boolean send_email = false;
        String errormailmsg = '<br/> Please check TALKPOINT PROCESSOR csv file - the following errors occurred:<br/>';
                 //remove any double quotes from csv file
        
            String newddataToParse = dataToParse;
        if(!Test.isRunningtest()){
        String regx = '\"[^\"]*\"';
        Pattern pattn = Pattern.compile(regx);
        Matcher matcher = pattn.matcher(dataToParse);
        newddataToParse = matcher.replaceAll(' ');
        }
        CSVParser parser = new CSVParser(newddataToParse,0);
        parser.setEndOfFile(0);
        String webinarId = null;
        map<String,ProcessorRecord> processorRecords = new map<String,ProcessorRecord>();           
        list<String> columns = parser.readLine();
        Map<String,TalkpointColMap__c> talkpointmap = TalkpointColMap__c.getAll();
        
        if(talkpointmap.isEmpty() && !Test.isRunningtest()){
           send_email = true;
           errormailmsg = 'Error pulling the custom setting data mapping.<br/> Please check the TalkpointColMap__c Custom Setting to verify.';
        }else{
           Integer datarow = 1;
           Integer emailcol = 7;
           Integer eventidcol = 0;
           Integer eventidrow = 1;
           Integer firstnamecol = 4;
           Integer insessiondurationcol = 26;
           Integer lastnamecol = 5;
           Integer numsessionscol = 22;
           Integer phonecol = 15;
           Integer registeredoncol = 3;
           
           List<String> listcolnames = new List<String>();
           listcolnames.add('datarow');
           listcolnames.add('eventidrow');
           listcolnames.add('emailcol');
           listcolnames.add('eventidrow');
           listcolnames.add('firstnamecol');
           listcolnames.add('lastnamecol');
           listcolnames.add('insessiondurationcol');
           listcolnames.add('numsessionscol');
           listcolnames.add('phonecol');
           listcolnames.add('registeredoncol');
            
           For(String s : listcolnames){ 
            if(talkpointmap.get(s) != null){ 
              if(talkpointmap.get(s).col__c != null){
                  Integer dataint = Integer.valueOf(talkpointmap.get(s).col__c);
                  if(s =='datarow'){datarow = dataint; }
                  if(s =='eventidrow'){eventidrow = dataint; }
                  if(s =='emailcol'){emailcol = dataint; }
                  if(s =='eventidrow'){eventidrow = dataint; }
                  if(s =='firstnamecol'){firstnamecol = dataint; }
                  if(s =='lastnamecol'){lastnamecol = dataint; }
                  if(s =='insessiondurationcol'){insessiondurationcol = dataint;}
                  if(s =='numsessionscol'){numsessionscol = dataint; }
                  if(s =='phonecol'){phonecol = dataint; }
                  if(s =='registeredoncol'){registeredoncol = dataint; }
              } 
            }
           }
        
        integer rowCount = 0;
        while(columns != null){
            if(rowCount == eventidrow) {
                String eventNumberString = columns[eventidcol]; 
                webinarId = eventNumberString.replace('Event#:','').trim();
            }
            
            if(rowCount >=  datarow) {
            System.debug('@asha: TalkpointProcessor : Email col: '+emailcol+' email: '+columns[7]);
                String email = columns[emailcol].trim().toLowerCase();
                if(!String.isblank(email) && email.contains('@')){
                        if(email.contains('@markettraders.com') || email.contains('@nextstepfinancialholdings.com')){
                            this.log.Number_of_Employees_Registered__c++;
                        }
                        
                        ProcessorRecord record = processorRecords.get(email); 
                        if(record == null) {
                            record = new ProcessorRecord();
                            record.attended = 'Yes';
                            record.firstName = columns[firstnamecol];
                            record.lastName = columns[lastnamecol];
                            if(record.lastName == null || record.lastName == ''){
                                record.lastName = '[not provided]';
                            }
                            record.email = email;
                            record.phone = columns[phonecol];
                            try{
                                String registrationDate = columns[registeredoncol];
                                if(registrationDate.length() == 26){
                                    String timePostfix = registrationDate.substring(registrationDate.length()-6,registrationDate.length()-4);
                                    String dt = registrationDate.substring(0,registrationDate.length()-10);
                                    String fullDateTime = dt + ' ' + timePostfix;
                                    record.registrationDate = DateTime.parse(fullDateTime);
                                }else{
                                    record.registrationDate = DateTime.parse(registrationDate);
                                }
                            }catch(Exception ex){
                                record.registrationDate = DateTime.now();
                            }
                            
                            processorRecords.put(email,record);
                            this.log.Did_attend__c++;
                            this.log.Number_of_Registered__c++;
                        }
                        
                        try{
                            decimal duration = record.inSessionDuration == null ? 0 : record.inSessionDuration;
                            if(columns[insessiondurationcol].contains(':')) {
                                String[] demandDuration = columns[insessiondurationcol].split(':',4);
                                if(demandDuration[0] != null && demandDuration[0].isNumeric()){
                                    duration += integer.valueOf(demandDuration[0]) * 60;
                                }
                                if(demandDuration[1] != null && demandDuration[1].isNumeric()){
                                    duration += integer.valueOf(demandDuration[1]);
                                }
                                if(demandDuration[2] != null && demandDuration[2].isNumeric()){
                                    if(integer.valueOf(demandDuration[2]) > 0){
                                        duration++;
                                    }
                                }
                            }
                            record.inSessionDuration = duration;
                        }catch(Exception ex){
                            record.inSessionDuration = 0;
                        }
                        
                        integer numberOfSessions = record.numberOfSessions == null ? 0 : record.numberOfSessions;
                        numberOfSessions += integer.valueOf(columns[numsessionscol]);
                        record.numberOfSessions = numberOfSessions;
                        
                }else{
                    send_email = true;
                    errormailmsg += 'Error with email field  - email listed: ' +email + ' <br/>';
                    errormailmsg += 'Event id listed'+webinarId + ' Date/Time run: '+datetime.now()+' <br/><br/>';
                }
            }
                    rowCount++;
                    columns = parser.readLine();
                
        }
       } 
         if(send_email){
               List<String> emailstrs = new List<String>();
               emailstrs.add('sfdev@markettraders.com');
               List<LoggerEmailRecipients__c> emaillist = LoggerEmailRecipients__c.getAll().values();
               For(LoggerEmailRecipients__c e : emaillist){
                   if(e.Admin__c && e.Users_Email__c != null){                 
                       emailstrs.add(e.Users_Email__c);    
                   }
               }   
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
               emailstrs.add('sfdev@markettraders.com');
               emailstrs.add(UserInfo.getUserEmail());
               mail.setToAddresses(emailstrs);
               mail.setReplyTo('sfdev@markettraders.com');
               mail.setSenderDisplayName('TALKPOINT PROCESSOR MONITOR');
               mail.setSubject('TALKPOINT DATA ERROR');
               mail.setHtmlBody(errormailmsg);          
               
               Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        }
         
        this.setWebinar(webinarId);
        this.log.Webinar__c = this.webinar.id;
        Database.insert(this.log);
        
        integer batchSize = 50;
        integer recordCount = 0;
        integer batchCount = 0;
        map<String,ProcessorRecord> processorRecordBatch = new map<String,ProcessorRecord>();
        list<Attachment> processorRecordsAttachments = new list<Attachment>();
        for(String email : processorRecords.keySet()){
            ProcessorRecord record = processorRecords.get(email);
            processorRecordBatch.put(email,record);
            batchCount++;
            recordCount++;
            if(batchCount == batchSize || recordCount == processorRecords.size()){
                Attachment processedRecordsAttachment = new Attachment();
                processedRecordsAttachment.ContentType = '.json';
                processedRecordsAttachment.Description = 'This attachment contains a JSONified list of Processor Records taken from the provided CSV file';
                processedRecordsAttachment.Name = 'Processor Records';
                processedRecordsAttachment.ParentId = this.log.Id;
                processedRecordsAttachment.body = Blob.valueOf(JSON.serialize(processorRecordBatch));
                processorRecordsAttachments.add(processedRecordsAttachment);
                processorRecordBatch = new map<String,ProcessorRecord>();
                batchCount = 0;
            }
        }   
        Database.insert(processorRecordsAttachments);
        
        
    }

    /**
        @method: setWebinar
    *   This method allows the webinar to be set based off the provided webinarId. 
    **/
    public void setWebinar(String webinarId) {
        DateTime selectedTime = this.webinar.Event_Date_Time__c;
        this.webinar = [SELECT id,Event_Date_Time__c,Name,Webinar_ID__c,Platform__c,PrimaryPresenter__c,SecondaryPresenter__c,Down_Payment__c,Actual_Duration__c,Actual_Start_Time__c,Additional_Discount_Offer__c,Time_at_Close__c,Type_of_Webinar__c,People_at_Price__c,Attentive_Rate_at_Close__c,Promotion__c,DiscountPercent__c,DiscountDollar__c,Discount_Type__c FROM Webinar__c WHERE Webinar_Id__c = :webinarId LIMIT 1];
        system.debug('Webinar ID: ' + webinarId);
        this.webinar.Event_Date_Time__c = selectedTime;
    }
    
    /**
    *    @method: updateWebinar
    *   This method is an overridden method and called from the processor controller. 
    *   Include any logic and updates you need when updating the webinar related to 
    *   the current processor run. The controller will call it when loading the preview page.
    **/
    public override void updateWebinar() {
        if(this.webinar.Event_Date_Time__c != null)
            Database.update(this.webinar);
    }
    
    /***************************
    * @method: preprocess
    * 
    * @description: starts the batch process to convert the processor attachment records to webinar attendance records
    *
    **/     
    public override void preprocess() {

        Batch_TalkpointProcess frontEndPreProcess = new Batch_TalkpointProcess(this.log,this.configuration,this.webinar);
        this.processId = Database.executeBatch(frontEndPreProcess,1);   
        
    }
    
    
    /***************************
    * @method: run
    * 
    * @description: method for visualforce - not currently used
    *
    * @return: detail view of the webinar record
    *
    **/      
    public override PageReference run(){
        Database.update(this.log);
        ApexPages.StandardController sc = new ApexPages.StandardController(log);
        /* Future Data Manipulation */
        return sc.view();
    }
    
    /***************************
    * @method: getOpportunities
    * 
    * @description: - not currently used by the processor 
    *
    * @return: outputpanel visualforce component
    *
    **/   
    public override Component.Apex.OutputPanel getOpportunities(){
        
        Component.Apex.OutputPanel panel = new Component.Apex.OutputPanel();
        
        Component.Apex.PanelGrid navigation = new Component.Apex.PanelGrid();
        navigation.columns = 6;
        panel.childComponents.add(navigation);
        
        Component.Apex.CommandButton gotoFirst = new Component.Apex.CommandButton();
        gotoFirst.value = '|<';
        gotoFirst.expressions.action = '{!processor.First}';
        gotoFirst.expressions.disabled = '{!!processor.HasPrevious}';
        gotoFirst.rerender = new set<String>{'processorPreviewBlock'};
        gotoFirst.status = 'navstatus';
        navigation.childComponents.add(gotoFirst);
        
        Component.Apex.CommandButton previous = new Component.Apex.CommandButton();
        previous.value = '<';
        previous.expressions.action = '{!processor.Previous}';
        previous.expressions.disabled = '{!!processor.HasPrevious}';
        previous.rerender = new set<String>{'processorPreviewBlock'};
        previous.status = 'navstatus';
        navigation.childComponents.add(previous);

        Component.Apex.CommandButton next = new Component.Apex.CommandButton();
        next.value = '>';
        next.expressions.action = '{!processor.Next}';
        next.expressions.disabled = '{!!processor.HasNext}';
        next.rerender = new set<String>{'processorPreviewBlock'};
        next.status = 'navstatus';
        navigation.childComponents.add(next);
        
        Component.Apex.CommandButton gotoLast = new Component.Apex.CommandButton();
        gotoLast.value = '>|';
        gotoLast.expressions.action = '{!processor.Last}';
        gotoLast.expressions.disabled = '{!!processor.HasNext}';
        gotoLast.rerender = new set<String>{'processorPreviewBlock'};
        gotoLast.status = 'navstatus';
        navigation.childComponents.add(gotoLast);
        
        Component.Apex.ActionStatus status = new Component.Apex.ActionStatus();
        status.startText = 'Loading Next Page...';
        status.id = 'navstatus';
        status.startStyle = 'color:red;';
        navigation.childComponents.add(status);
        
        Component.Apex.CommandButton massUpdateOwner = new Component.Apex.CommandButton();
        massUpdateOwner.value = 'Mass Update Owner';
        //massUpdateOwner.expressions.action = '{!processor.Next}';
        massUpdateOwner.rerender = new set<String>{'processorPreviewBlock'};
        massUpdateOwner.status = 'navstatus';
        navigation.childComponents.add(massUpdateOwner);
                
        Component.Apex.PageBlockTable table = new Component.Apex.PageBlockTable();
        table.expressions.value = '{!processor.records}';
        table.var = 'opportunity';
        
        Component.Apex.Column createdDate = new Component.Apex.Column();
        createdDate.expressions.value = '{!opportunity["CreatedDate"]}';
        table.childComponents.add(createdDate);
        
        Component.Apex.Column firstName = new Component.Apex.Column();
        firstName.expressions.value = '{!opportunity["AccountId"]}';
        table.childComponents.add(firstName);
        
        Component.Apex.Column email = new Component.Apex.Column();
        email.expressions.value = '{!opportunity["Account_Email__c"]}';
        table.childComponents.add(email);
        
        Component.Apex.Column closeDate = new Component.Apex.Column();
        closeDate.expressions.value = '{!opportunity["CloseDate"]}';
        table.childComponents.add(closeDate);
        
        Component.Apex.Column stageName = new Component.Apex.Column();
        stageName.expressions.value = '{!opportunity["StageName"]}';
        table.childComponents.add(stageName);
        
        Component.Apex.Column owner = new Component.Apex.Column();
        owner.expressions.value = '{!opportunity["OwnerId"]}';
        table.childComponents.add(owner);
                
        panel.childComponents.add(table);
        
        return panel;
        
    }
    
    /***************************
    * @method: getWebinarAttendanceComponent
    * 
    * @description: - not currently used by the processor 
    *
    * @return: outputpanel visualforce component
    *
    **/     
    public override Component.Apex.OutputPanel getWebinarAttendanceComponent(){
        Component.Apex.OutputPanel panel = new Component.Apex.OutputPanel();
        
        Component.Apex.PanelGrid navigation = new Component.Apex.PanelGrid();
        navigation.columns = 5;
        panel.childComponents.add(navigation);
        
        Component.Apex.CommandButton gotoFirst = new Component.Apex.CommandButton();
        gotoFirst.value = '|<';
        gotoFirst.expressions.action = '{!processor.First}';
        gotoFirst.expressions.disabled = '{!!processor.HasPrevious}';
        gotoFirst.rerender = new set<String>{'processorPreviewBlock'};
        gotoFirst.status = 'webattendancenav';
        navigation.childComponents.add(gotoFirst);
        
        Component.Apex.CommandButton previous = new Component.Apex.CommandButton();
        previous.value = '<';
        previous.expressions.action = '{!processor.Previous}';
        previous.expressions.disabled = '{!!processor.HasPrevious}';
        previous.rerender = new set<String>{'processorPreviewBlock'};
        previous.status = 'webattendancenav';
        navigation.childComponents.add(previous);

        Component.Apex.CommandButton next = new Component.Apex.CommandButton();
        next.value = '>';
        next.expressions.action = '{!processor.Next}';
        next.expressions.disabled = '{!!processor.HasNext}';
        next.rerender = new set<String>{'processorPreviewBlock'};
        next.status = 'webattendancenav';
        navigation.childComponents.add(next);
        
        Component.Apex.CommandButton gotoLast = new Component.Apex.CommandButton();
        gotoLast.value = '>|';
        gotoLast.expressions.action = '{!processor.Last}';
        gotoLast.expressions.disabled = '{!!processor.HasNext}';
        gotoLast.rerender = new set<String>{'processorPreviewBlock'};
        gotoLast.status = 'webattendancenav';
        navigation.childComponents.add(gotoLast);
        
        Component.Apex.ActionStatus status = new Component.Apex.ActionStatus();
        status.startText = 'Loading Next Page...';
        status.id = 'webattendancenav';
        status.startStyle = 'color:red;';
        navigation.childComponents.add(status);
                
        Component.Apex.PageBlockTable table = new Component.Apex.PageBlockTable();
        table.expressions.value = '{!processor.records}';
        table.var = 'webattendance';
        
        Component.Apex.Column attended = new Component.Apex.Column();
        attended.expressions.value = '{!webattendance["Attended__c"]}';
        table.childComponents.add(attended);
        
        Component.Apex.Column account = new Component.Apex.Column();
        account.expressions.value = '{!webattendance["Account__c"]}';
        table.childComponents.add(account);
        
        Component.Apex.Column lead = new Component.Apex.Column();
        lead.expressions.value = '{!webattendance["Lead__c"]}';
        table.childComponents.add(lead);
        
        Component.Apex.Column registrationDate = new Component.Apex.Column();
        registrationDate.expressions.value = '{!webattendance["Registration_Date__c"]}';
        table.childComponents.add(registrationDate);
        
        Component.Apex.Column duration = new Component.Apex.Column();
        duration.expressions.value = '{!webattendance["Duration__c"]}';
        table.childComponents.add(duration);
        
        Component.Apex.Column source = new Component.Apex.Column();
        source.expressions.value = '{!webattendance["Source_Other__c"]}';
        table.childComponents.add(source);
        
        Component.Apex.Column raisedHands = new Component.Apex.Column();
        raisedHands.expressions.value = '{!webattendance["Raised_Hands__c"]}';
        table.childComponents.add(raisedHands);
                
        panel.childComponents.add(table);
        
        return panel;
    }
    
     /***************************
    * @method: getWebinars
    * 
    * @description: get webinars for LMFS, query by name - not currently used by the processor 
    *
    * @return: outputpanel visualforce component
    *
    **/     
    public override List<SelectOption> getWebinars() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','--Select--'));
        String credentialId =  [SELECT id FROM Webinar_Credentials__c WHERE Credentials_ID__c = '0' limit 1].id;
        list<Webinar__c> webinars = [SELECT id,Webinar_ID__c,Name FROM Webinar__c WHERE Webinar_Credentials__c = :credentialId];
        for(Webinar__c webinar : webinars){
            options.add(new SelectOption(webinar.Webinar_ID__c,webinar.Name));
        }
        return options;
    }
  
  
    /***************************
    * @method: getOpportunityOwners
    * 
    * @description: queries the next step financial holdings user to use for the owner
    *
    * @return: map of user id to user name
    *
    **/      
    public override map<String,String> getOpportunityOwners() {
        map<String,String> opportunityOwnerMap = new map<String,String>();
        list<User> users = [SELECT id,FirstName,LastName FROM User WHERE Id = '00560000000mIAO'];
        //list<User> users = [SELECT id,FirstName,LastName FROM User WHERE UserRoleId = '00E60000000yemg'];
        for(User user : users){
            opportunityOwnerMap.put(user.id,user.FirstName + ' ' + user.LastName);
        }
        
        return opportunityOwnerMap;
    }

}