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
*   Date Created:       2/1/2015
*   Author:             Asha Calderon
*   Last Modified:      2/1/2015
*   Last Modified By:   Asha Calderon
*
*   
*   
**********************************************************************************************************************/
public with sharing class SocialProcessor extends Processor{
  
  /***************************
  * @method: constructor
  * @param: webinartypeother - used to update field stamptype on the webinar attendance record.
  *
  **/ 
  public SocialProcessor(){

  }
  
  /***************************
    * @method: configure
    * 
    * @description: override method from abstract class Processor, used to setup the variables for the processor
    *
    * @param: configuration - ProcessorConfiguration class variable 
    * @param: csv - records uploaded through csv extract of webinar attendances
    * @param: api - records uploaded through api - not currently in use
    * @param: manualWebinarSelection - not currently in use
    * @param: manualDateSelection - allows for selection of event date time field in processor data visualforce page
    * @param: showPresenter - makes PrimaryPresenter__c field visible on Processor_Settings visualforce page 
    * @param: showSecondaryPresenter - makes SecondaryPresenter__c field visible Processor_Settings  on visualforce page 
    * @param: showDiscount - makes DiscountDollar__c field visible on Processor_Settings  visualforce page 
    * @param: showDownPayment - makes Down_Payment__c field visible on Processor_Settings  visualforce page 
    * @param: showActualStarttime - makes field visible on Processor_Settings  visualforce page - not currently in use
    * @param: showActualDuration - makes field visible on Processor_Settings  visualforce page - not currently in use
    * @param: showWebinarType - makes Type_of_Webinar__c field visible on Processor_Settings  visualforce page 
    * @param: showTimeAtClose - makes Time_at_Close__c field visible on Processor_Settings  visualforce page 
    * @param: showPeopleAtPrice - makes People_at_Price__c field visible on Processor_Settings  visualforce page 
    * @param: showAttentiveRate - makes Attentive_Rate_at_Close__c field visible on Processor_Settings  visualforce page 
    * @param: showPromotion - makes Promotion__c field visible on Processor_Settings  visualforce page 
    * @param: skipSettings - variable to determine whether to show the settings page during the processor 
    * @param: opportunityRecordTypeId - static id for Education record type id on the opportunity    
    * @param: opportunityRecordTypeName - static name of the Education record type on the Opportunity
    * @param: opportunityName - sets the Opportunity name if opp was created during processing 
    * @param: opportunityProduct - sets the product list of the Opportunity
    * @param: opportunityStageName - sets the stageName field for the Opportunity
    * @param: opportunitySubStage - sets the sub stageName on the opportunity  
    * @param: paymentPlan - sets the payment plan on the Opportunity   
    * @param: opportunityCloseDate - sets the Opportunity name if opp was created during processing
    * @param: opportunityOwnersMap - sets the Opportunity owners the Opportunity
    * @param: bypassOpportunityLogic - sets the stageName field for the Opportunity    
    * @param: leadRecordTypeId - static id of the record type to set for lead
    * @param: taskWebinarType - sets the webinar type field in the activity 
    * @param: taskActivityType - sets the activity type in the activity - standard for 'Webinar attendance'
    * 
    **/ 
  public override void configure() {
    this.configuration = new ProcessorConfiguation();   
    
    
        /* Configure Processor Data Options */
        this.configuration.csv = true;
        this.configuration.api = false;
        this.configuration.manualWebinarSelection = false;
        this.configuration.manualDateSelection = false;
        
        /* Configure Processor Settings Options */
        this.configuration.showPresenter = true;
        this.configuration.showSecondaryPresenter = true;
        this.configuration.showDiscount = true;
        this.configuration.showDownPayment = true;
        this.configuration.showActualStarttime = true;
        this.configuration.showActualDuration = true;
        this.configuration.showWebinarType = true;
        this.configuration.showTimeAtClose = true;
        this.configuration.showPeopleAtPrice = true;
        this.configuration.showAttentiveRate = true;
        this.configuration.showPromotion = true;
        this.configuration.skipSettings = false;

    /* Configure Opportunity Details */
     //aac no opps should be touched for lmfs or backend processor        
        this.configuration.opportunityRecordTypeId = opprectypeother; //opportunity record type chosen by either utp,be,micro,usop
        this.configuration.opportunityRecordTypeName = 'Education'; //not used
        this.configuration.opportunityName =  producttypeother +' (' + String.valueOf(Date.today()) + ')';
        this.configuration.opportunityProduct = producttypeother ;
        this.configuration.opportunityStageName = 'New Deal';
        this.configuration.opportunitySubStage = null;
        this.configuration.paymentPlan = null;
        this.configuration.opportunityCloseDate = ProccessorHelperMethods.getEndOfQuarterDate(Date.today());
    
        this.configuration.opportunityOwnersMap = this.getOpportunityOwners();
        this.configuration.setOpportunityOwnerAssignmentVariables();
    
        this.configuration.leadRecordTypeId = leadtypeother; 
        this.configuration.taskWebinarType = webinartypeother; 
        this.configuration.taskActivityType = 'Webinar Attendance';
        
        //aac added to handle choice of Opp rectypes to update
        this.configuration.bypassOpportunityLogic = true;        
        this.configuration.webinarstamptype = webinartypeother;
  }
  
   /***************************
    * @method: parseData
    * 
    * @description: takes the information from the readytalk meeting member with the same webinar id 
    *  adds the necessary data to the webinar record or creates a new processor record from the lines of attendance
    *  data. Sends the data to a json attachment on the webinar for later processing
    *
    * @param: dataToParse - the webinar id chosen from the picklist
    *
    **/ 
   public override void parseData(String dataToParse) {    
        Logger logger = new Logger();
        this.intializeLog();
        map<String,ProcessorRecord> processorRecords = new map<String,ProcessorRecord>();
        //remove any double quotes from csv file
        String regx = '\"[^\"]*\"';
        Pattern pattn = Pattern.compile(regx);
        Matcher matcher = pattn.matcher(dataToParse);
        String newddataToParse = matcher.replaceAll(' ');
        
        CSVParser parser = new CSVParser(newddataToParse,0);
        parser.setEndOfFile(0);
        list<String> columns = parser.readLine();
        integer rowCount = 0;
        while(columns != null){
            System.debug(LoggingLevel.ERROR, '@@@ reading line ' + rowCount + ' with columns value ' + columns);
            if(rowCount < 8){ 
                if(rowCount == 4){
                    String webinarId = columns[0].replaceAll('-',''); 
                    this.webinar = [SELECT id,Event_Date_Time__c,Name,Webinar_ID__c,Platform__c,PrimaryPresenter__c,SecondaryPresenter__c,Down_Payment__c,Actual_Duration__c,Actual_Start_Time__c,Additional_Discount_Offer__c,Time_at_Close__c,Type_of_Webinar__c,People_at_Price__c,Attentive_Rate_at_Close__c,Promotion__c,DiscountPercent__c,DiscountDollar__c,Discount_Type__c FROM Webinar__c WHERE Webinar_Id__c = :webinarId LIMIT 1];
                    //format hours and minutes 
                    this.webinar.Actual_Start_Time__c = this.convertDateTime(columns[1]); 
                    if(columns[2] != null && columns[2] != '' && (columns[2].contains('minute') || columns[2].contains('hour'))){
                        List<String> splitdurationhours = columns[2].trim().split(' ');
                        Decimal minutesdisplayed = columns[2].contains('minute')? Decimal.valueOf(splitdurationhours[splitdurationhours.size()-2]) : 0;
                        this.webinar.Actual_Duration__c = columns[2].contains('hour') ? Integer.valueOf(splitdurationhours[0])*60 + minutesdisplayed : minutesdisplayed;
                    }
                }
            }else{
                System.debug(LoggingLevel.ERROR, '@@@ row count >= 8 ' + columns);
                String email = columns[4].toLowerCase().trim();
                if(email != null && email.contains('@')){
                if(email.contains('@markettraders.com') || email.contains('@nextstepfinancialholdings.com')){
                    this.log.Number_Of_Employees_Registered__c++;
                }else{
                    System.debug('@@@ processing email: ' + email);
                    logger.log('Email: ' + email);
                    ProcessorRecord record = new ProcessorRecord();
                    record.attended = columns[0];
                    if(columns[1] != null && columns[1].isNumeric())
                        record.interestRating = Integer.valueOf(columns[1]);
                    record.firstName = columns[3]; 
                    record.lastName = columns[2];  
                    record.email = email;
                    record.registrationDate = this.convertDateTime(columns[5]);
                    record.joinTime = this.convertDateTime(columns[6]);
                    record.leaveTime = this.convertDateTime(columns[7]);
                    record.inSessionDuration = 0;
                    if(columns[8] != null && columns[8] != '' && ( columns[8].contains('minute') || columns[8].contains('hour') )){
                        List<String> splitinsessionhours = columns[8].trim().split(' ');
                        Decimal minutedisplayed = columns[8].contains('minute')? Decimal.valueOf(splitinsessionhours[splitinsessionhours.size()-2]) : 0;
                        record.inSessionDuration = columns[8].contains('hour') ? Decimal.valueOf(splitinsessionhours[0])*60 + minutedisplayed : minutedisplayed;
                    }
                    String phone = columns[9];
                    string nondigits = '[^0-9]';
                    record.phone = phone.replaceAll(nondigits,'');
                    
                    record.unsubscribed = columns[10];
                    
                    if(processorRecords.get(email) == null){
                        if(record.attended == 'Yes'){
                            this.log.Did_attend__c++;
                        }else{
                            this.log.Did_not_attend__c++;
                        }
                        System.debug('@@@ adding proc record for ' + email);
                        this.log.Number_of_Registered__c++;
                        processorRecords.put(email,record);
                    }

                }
              }  
            }
            rowCount++;
            columns = parser.readLine();
        }
        this.log.Webinar__c = this.webinar.id;
        Database.insert(this.log);
        
        integer batchSize = 5;
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
    
    
     /***************************
    * @method: convertDateTime
    * 
    * @description: converts the date time format- not needed for readytalk but part of abstract class
    *
    * @param: dateTimeString - the string of the datatime citrix formatted 
    *
    **/  
    public DateTime convertDateTime(String dateTimeString){
        try{
            DateTime convertedDateTime = null;
            String dateString = dateTimeString.replaceAll('EST', '').replaceAll('EDT', '').replaceAll(',','').trim();
            if(!dateTimeString.contains('/')){
                string[] dateParts = dateString.split(' ');
                dateParts[0] = this.monthConversionMap.get(dateParts[0].toLowerCase());
                convertedDateTime = DateTime.parse(dateParts[0] + '/' + dateParts[1] + '/' + dateParts[2] + ' ' + dateParts[3] + ' ' + dateParts[4]);
            }else{
               convertedDateTime = datetime.parse(dateString);            
            }
            return convertedDateTime;
        }catch(Exception ex){
            return null;
        }
    }
    
    /***************************
    * @method: updateWebinar
    * 
    * @description: updates the current webinar that was updated in the parseData method
    *
    * @param: dataToParse - the converted string of the csv file
    *
    **/     
    public override void updateWebinar() {
        Database.update(this.webinar);
    }
  
    /***************************
    * @method: preprocess
    * 
    * @description: starts the batch process to convert the processor attachment records to webinar attendance records
    *
    **/     
  public override void preprocess() {
     Batch_FrontEndPreProcess batchedProcess = new  Batch_FrontEndPreProcess(this.log,this.configuration,this.webinar);
      this.processId = Database.executeBatch(batchedProcess,1);
  }
  
    /***************************
    * @method: run
    * 
    * @description: method for visualforce - not currently used
    *
    * @return: detail view of the webinar record
    *
    **/  
  public override PageReference run() {
        Database.update(this.log);
    ApexPages.StandardController sc = new ApexPages.StandardController(this.webinar);
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
    table.Id = 'opportunitiesTable';
    
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
    table.id = 'webinarAttendanceTable';
    
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
    
    Component.Apex.Column joinTime = new Component.Apex.Column();
    joinTime.expressions.value = '{!webattendance["Join_Time__c"]}';
    table.childComponents.add(joinTime);
    
    Component.Apex.Column leaveTime = new Component.Apex.Column();
    leaveTime.expressions.value = '{!webattendance["Leave_Time__c"]}';
    table.childComponents.add(leaveTime);
    
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
    * @description: get webinars for readytalk, query by webinar id chosen in processor page
    *
    * @return: outputpanel visualforce component
    *
    **/  
    public override List<SelectOption> getWebinars() {
    List<SelectOption> options = new List<SelectOption>();
   
    list<Webinar__c> webinars = [SELECT id,Webinar_ID__c,Name,Event_Date_Time__c,Presentation_Deck__c,Price_Presented__c,Product_Presented__c FROM Webinar__c WHERE   Platform__c = 'ReadyTalk' AND Event_Date_Time__c >= LAST_90_DAYS AND Event_Date_Time__c <= NEXT_90_DAYS ORDER BY Event_Date_Time__c ASC];
    options.add(new SelectOption('0','--Select--'));
    for(Webinar__c webinar : webinars){
      String webinarname = (webinar.Name.length() > 200)? webinar.Name.left(200) + '...' :webinar.Name;  
      options.add(new SelectOption(webinar.Webinar_ID__c, webinarname +' '+webinar.Event_Date_Time__c.format('MM/dd/yyyy HH:mm:ss','America/New_York')));
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
      for(User user : users){
        opportunityOwnerMap.put(user.id,user.FirstName + ' ' + user.LastName);
      }
      
      return opportunityOwnerMap;
    } 
    
}