public with sharing class ClassesProcessor extends Processor {
    
    /*****************************************************************************************************************
    *
    *	This processor should only create webinar attendances.  No opportunities should be created as this is
    *	processing "Sales" webinars, but "Classes" webinars.
    *
    ******************************************************************************************************************/
    
    
    public ClassesProcessor(){
        
    }
    
    public override void configure() {
        this.configuration = new ProcessorConfiguation();
        this.configuration.webinarstamptype = 'CE Classes';
        
        /* Configure Processor Data Options */
        this.configuration.csv = true;
        this.configuration.api = false;
        this.configuration.manualWebinarSelection = false;
        this.configuration.manualDateSelection = false;
        
        /* Configure Processor Settings Options */
        this.configuration.showPresenter = true;
        this.configuration.showSecondaryPresenter = true;
        this.configuration.showDiscount = false;
        this.configuration.showDownPayment = false;
        this.configuration.showActualStarttime = true;
        this.configuration.showActualDuration = true;
        this.configuration.showWebinarType = true;
        this.configuration.showTimeAtClose = false;
        this.configuration.showPeopleAtPrice = false;
        this.configuration.showAttentiveRate = false;
        this.configuration.showPromotion = false;

        /* Configure Opportunity Details */
        this.configuration.bypassOpportunityLogic = true;
//MSM        this.configuration.opportunityOwnersMap = this.getOpportunityOwners();
//MSM        this.configuration.setOpportunityOwnerAssignmentVariables();
//MSM        this.configuration.leadRecordTypeId = '012600000005Izy';
    }

    public override void parseData(String dataToParse) {    
        Logger logger = new Logger();
        this.intializeLog();
        Map<String, ProcessorRecord> processorRecords = new Map<String, ProcessorRecord>();
        //remove any double quotes from csv file
        String regx = '\"[^\"]*\"';
        Pattern pattn = Pattern.compile(regx);
        Matcher matcher = pattn.matcher(dataToParse);
        String newddataToParse = matcher.replaceAll(' ');
        
        CSVParser parser = new CSVParser(newddataToParse, 0);
        parser.setEndOfFile(0);
        List<String> columns = parser.readLine();
        Integer rowCount = 0;
        
        while (columns != null) {
            System.debug(LoggingLevel.ERROR, '@@@ reading line ' + rowCount + ' with columns value ' + columns);
            if (rowCount < 8) { //changed from 14 to 8
                if (rowCount == 4) { //changed from 5 to 4
                    String webinarId = columns[0].replaceAll('-',''); //changed from 1 to 0 and added removal of dashes
                    this.webinar = [SELECT Id, Event_Date_Time__c, Name, Webinar_ID__c, Platform__c, PrimaryPresenter__c, SecondaryPresenter__c, Down_Payment__c, Actual_Duration__c, 
                    						Actual_Start_Time__c, Additional_Discount_Offer__c, Time_at_Close__c, Type_of_Webinar__c, People_at_Price__c, Attentive_Rate_at_Close__c, 
                    						Promotion__c, DiscountPercent__c, DiscountDollar__c, Discount_Type__c
                    					FROM Webinar__c 
                    					WHERE Webinar_Id__c = :webinarId LIMIT 1];
                    
                    //format changed from just mintues to hours and minutes 
                    this.webinar.Actual_Start_Time__c = this.convertDateTime(columns[1]); //this.convertDateTime(columns[0]); changed because of new date format
                    
                    if ((columns[2] != null) && (columns[2] != '') && (columns[2].contains('minute') || columns[2].contains('hour'))) {
                        List<String> splitdurationhours = columns[2].trim().split(' ');
                        Decimal minutesdisplayed = columns[2].contains('minute') ? Decimal.valueOf(splitdurationhours[splitdurationhours.size()-2]) : 0;
                        this.webinar.Actual_Duration__c = columns[2].contains('hour') ? Integer.valueOf(splitdurationhours[0]) * 60 + minutesdisplayed : minutesdisplayed;
                    }
                }
            }
            else {
                System.debug(LoggingLevel.ERROR, '@@@ row count >= 8 ' + columns);
                String email = columns[4].toLowerCase().trim();
                if (email != null && email.contains('@')) {
                	if (email.contains('@markettraders.com') || email.contains('@nextstepfinancialholdings.com')) {
                    	this.log.Number_Of_Employees_Registered__c++;
                	}
                	else {
                    	System.debug('@@@ processing email: ' + email);
                    	logger.log('Email: ' + email);
                    	ProcessorRecord record = new ProcessorRecord();
                    	record.attended = columns[0];
                    	if (columns[1] != null && columns[1].isNumeric()) {
                        	record.interestRating = Integer.valueOf(columns[1]);
                    	}

                    	if ((columns[2].startsWith('(')) && (columns[2].endsWith(')')) ||
                    		((columns[2].startsWith('-')) && (columns[2].substring(1).isNumeric()))) {
                    		if (columns[3].containsWhitespace()) {
								record.firstName = columns[3].left(columns[3].indexOf(' '));
								record.lastName = columns[3].right(columns[3].length() - columns[3].indexOf(' ') - 1);
                    		}
                    		else {
                    			record.lastName = columns[3];
                    		}
                    	}
                    	else { 
	                    	record.firstName = columns[3]; //columns[2];aac 2/2/15 changed formatting
    	                	record.lastName = columns[2];  //columns[3];aac 2/2/15 changed formatting
                    	}
                    
                    	record.email = email;
                    	record.registrationDate = this.convertDateTime(columns[5]);
                    
                    	record.joinTime = this.convertDateTime(columns[6]);
                    
                   		record.leaveTime = this.convertDateTime(columns[7]);
                    	record.inSessionDuration = 0;
                    	
                    	if (columns[8] != null && columns[8] != '' && (columns[8].contains('minute') || columns[8].contains('hour'))) {
                        	List<String> splitinsessionhours = columns[8].trim().split(' ');
                        	Decimal minutedisplayed = columns[8].contains('minute')? Decimal.valueOf(splitinsessionhours[splitinsessionhours.size()-2]) : 0;
                        	record.inSessionDuration = columns[8].contains('hour') ? Decimal.valueOf(splitinsessionhours[0]) * 60 + minutedisplayed : minutedisplayed;
                    	}
                    
                    	String phone = columns[9];
                    	String nondigits = '[^0-9]';
                    	record.phone = phone.replaceAll(nondigits,'');
                    
                    	record.unsubscribed = columns[10];
                    
                    	if (processorRecords.get(email) == null) {
                        	if (record.attended == 'Yes') {
                            	this.log.Did_attend__c++;
                        	}
                        	else {
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
        
        // end of read line loop for csv file (all processor record objects created at this point)
        
        // insert the log
        this.log.Webinar__c = this.webinar.id;
        Database.insert(this.log);
        
        // map processor records by email address and create attachments of size defined in batch size, relate Attachments to the log and insert the Attachments
        Integer batchSize = 5;
        Integer recordCount = 0;
        Integer batchCount = 0;
        Map<String, ProcessorRecord> processorRecordBatch = new map<String, ProcessorRecord>();
        List<Attachment> processorRecordsAttachments = new list<Attachment>();
        for (String email : processorRecords.keySet()) {
            ProcessorRecord record = processorRecords.get(email);
            processorRecordBatch.put(email, record);
            batchCount++;
            recordCount++;
            
            if (batchCount == batchSize || recordCount == processorRecords.size()){
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
    
    
    public DateTime convertDateTime(String dateTimeString){
        try {
            DateTime convertedDateTime = null;
            String dateString = dateTimeString.replaceAll('EST', '').replaceAll('EDT', '').replaceAll(',','').trim();
            
            if (!dateTimeString.contains('/')) {
                String[] dateParts = dateString.split(' ');
                dateParts[0] = this.monthConversionMap.get(dateParts[0].toLowerCase());
                convertedDateTime = DateTime.parse(dateParts[0] + '/' + dateParts[1] + '/' + dateParts[2] + ' ' + dateParts[3] + ' ' + dateParts[4]);
            }
            else {
               convertedDateTime = datetime.parse(dateString);            
            }
            
            return convertedDateTime;
        }
        catch(Exception ex) {
            return null;
        }
    }
    

	public override void updateWebinar() {
        Database.update(this.webinar);
    }
    
    
    public override void preprocess() {
    	// send to batch process passing log (with processor record attachments), the configuration, and the webinar 
    	if (this.webinartypeother == 'Orientation') {
    		this.configuration.webinarstamptype = this.webinartypeother;
    	}
        Batch_WebinarPostProcessing batchedProcess = new Batch_WebinarPostProcessing(this.log, this.configuration, this.webinar);
        this.processId = Database.executeBatch(batchedProcess,1);
    }
    
    
    public override PageReference run() {
        Database.update(this.log);
        ApexPages.StandardController sc = new ApexPages.StandardController(this.webinar);
        /* Future Data Manipulation */
        return sc.view();
    }
    
    
    public override Component.Apex.OutputPanel getOpportunities() {
        
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
    
    
    public override List<SelectOption> getWebinars() {
        List<SelectOption> options = new List<SelectOption>();
        String credentialId =  [SELECT Id FROM Webinar_Credentials__c WHERE Credentials_ID__c = '1' OR Credentials_ID__c = '3' limit 1].id;
        list<Webinar__c> webinars = [SELECT Id, Webinar_ID__c, Name, Event_Date_Time__c FROM Webinar__c WHERE Webinar_Credentials__c = :credentialId ORDER BY Event_Date_Time__c ASC];
        options.add(new SelectOption('0','--Select--'));
        
        for (Webinar__c webinar : webinars) {
            options.add(new SelectOption(webinar.Webinar_ID__c,webinar.Event_Date_Time__c.format('MM/dd/yyyy HH:mm:ss','America/New_York')));
        }
        
        return options;
    }
    
    
    public override map<String, String> getOpportunityOwners() {
        Map<String, String> opportunityOwnerMap = new Map<String, String>();
        List<User> users = [SELECT Id, FirstName, LastName FROM User WHERE Id = '00560000000mIAO'];
        for (User user : users) {
            opportunityOwnerMap.put(user.id, user.FirstName + ' ' + user.LastName);
        }
        
        return opportunityOwnerMap;
    }
}