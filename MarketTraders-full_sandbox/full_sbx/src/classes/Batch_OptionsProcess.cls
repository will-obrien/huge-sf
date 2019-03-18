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
*   Author:             ???
*   Last Modified:      12/19/2015
*   Last Modified By:   Asha Calderon
*
*   12.18.15 - added fields to determine client attendance - used to check if stage changes for opp - only on 1st attendance 
*   12.28.15 - removed update to substage for opp as part of changes for opp stage value changes
*
**********************************************************************************************************************/
/********************************
*
* @description: used to batch process webinar attendance records from citrix - works with options webinars
*
**/

global with sharing class Batch_OptionsProcess implements Database.Batchable<sObject>,Database.Stateful{
    
    private set<String> noTouchOppStages = new set<String>{'Pending Charge','Pending Signature','Pending Post-Signature','Closed Won','Closed Won - Recovered Bad Debt'};
    private map<String,String> monthConversionMap = new map<String,String>{'jan'=>'1','feb'=>'2','mar'=>'3','apr'=>'4','may'=>'5','jun'=>'6','jul'=>'7','aug'=>'8','sep'=>'9','oct'=>'10','nov'=>'11','dec'=>'12'};
    
    global set<Id> opportunityIds;
    global set<Id> webinarAttendanceIds;
    
    global final String query;
    global final Processor_Log__c log;
    global final ProcessorConfiguation configuration;
    global final Webinar__c webinar;
    
    /**************************************
    *
    * @description:
    * constructor
    *  
    * @params: 
    * log - object record where processor record attachments were stored when parsed earlier in processor
    * configuration - configuration of the processor being run 
    * webinar - webinar that was processed  
    *
    **/
    global Batch_OptionsProcess(Processor_Log__c log,ProcessorConfiguation configuration,Webinar__c webinar){
        this.log = log;
        this.configuration = configuration;
        this.webinar = webinar;

        this.opportunityIds = new set<Id>();
        this.webinarAttendanceIds = new set<Id>();
        
        this.query = 'SELECT id, Name, Body FROM Attachment WHERE Name = \'Processor Records\' AND ParentId = \'' + this.log.Id + '\'';
    }

    /**************************************
    * @method start
    *
    * @description
    * required method for batch processes; uses query locator
    *  
    * @since 4.9.15
    * 
    * @params BC - batchable context 
    *
    **/ 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    /**************************************
    * @method execute
    *
    * @description
    * iterates over the attachment and related processor records returned from the query, 
    * converts leads to accounts if the webinar was attended or updates account tasks and webinar attendance registration
    * if tasks/ webinar attendance records are found then it creates webinar attendance records, Opportunities (not backend or micro products) and
    * task records, converts any leads created or found to an account
    * 
    * @params attachments - the processor record is stored as a JSON file in an attachment and then de-serialized to created webinar
    * attendance records and tasks
    *
    **/ 
    global void execute(Database.BatchableContext BC, List<Attachment> attachments){
        try{
         Handler_Account.BYPASSPROCESSOR = true;
            Logger logger = new Logger('Front End Processor Batch Log');
            for(Attachment processorRecordsAttachment : attachments){
                String serializedProcessorRecords = processorRecordsAttachment.body.toString();
                map<String,ProcessorRecord> processorRecords = (map<String,ProcessorRecord>)JSON.deserialize(serializedProcessorRecords,map<String,ProcessorRecord>.class);
            
                map<String,Account> accountMap = new map<String,Account>();
                map<String,Opportunity> opportunityMap = new map<String,Opportunity>();
                map<String,Task> taskMap = new map<String,Task>();
                map<String,Webinar_Attendance__c> webinarAttendanceMap = ProccessorHelperMethods.getWebinarAttendanceMap(processorRecords.keySet(),this.webinar.id,this.webinar.Event_Date_Time__c);
                map<String,decimal> durationMap = new map<String,decimal>();
        
                /* Query accounts and leads by Email */
                set<Id> whoIds = new set<Id>();
                //added aac 12.18.15 changes to opp stage
                map<id,Boolean> webattndexistmap = new map<id,Boolean>();
                map<String,Account> accountEmailMap = ProccessorHelperMethods.getAccountMap(processorRecords.keySet(),this.configuration.opportunityProduct);
                for(Account account : accountEmailMap.values()){
                    whoIds.add(account.PersonContactId);
                    //added aac 12.18.15 
                    Boolean iswebattd = false;
                    iswebattd = (account.Webinar_UTP_First_Attd__c != null)? true : iswebattd;
                    iswebattd = (account.Webinar_Client_First_Attd__c != null)? true : iswebattd;
                    iswebattd = (account.Webinar_UOC_First_Attd__pc != null)? true : iswebattd;
                    iswebattd = (account.Webinar_USC_First_Attd__pc != null)? true : iswebattd;
                    iswebattd = (account.Webinar_LMFS_First_Attd__pc != null)? true : iswebattd;
                    webattndexistmap.put(account.Id, iswebattd);
                }
                map<String,Lead> leadEmailMap = ProccessorHelperMethods.getLeadMap(processorRecords.keySet(),this.configuration.leadRecordTypeId);
                for(Lead lead : leadEmailMap.values()){
                    whoIds.add(lead.Id);                    
                }
                map<Id,list<Task>> relatedTasksMap = ProccessorHelperMethods.getTaskMap(whoIds,this.webinar.Webinar_ID__c);
        
                map<String,Lead> leadsToInsert = new map<String,Lead>();
                map<String,Lead> leadsToConvert = new map<String,Lead>();
               
                map<String,Webinar_Attendance__c> webinarAttendanceToUpsert = new map<String,Webinar_Attendance__c>();
               
                for(String email : processorRecords.keySet()) { 
                    ProcessorRecord record = processorRecords.get(email);
                    Webinar_Attendance__c relatedWebinarAttendance = webinarAttendanceMap.get(email);
                    System.debug('@asha @debug: Batch_OptionsProcess: Webinar Attendance Record: '+ relatedWebinarAttendance);
                    Account relatedAccount = accountEmailMap.get(email);
                    Lead relatedLead= leadEmailMap.get(email);
                    boolean attended = record.attended == 'Yes' ? true : false;
                    String webinarSource;
                    String creditId;
                    String creditName;
                    durationMap.put(email,record.inSessionDuration);
                    
                     if(relatedAccount != null || relatedLead != null){ 
                        if(relatedAccount != null){
                            accountMap.put(email,relatedAccount);
                        }
                        if(relatedLead != null){
                            if(record.attended == 'Yes'){
                                leadsToConvert.put(email,relatedLead);
                            }else{
                                relatedLead.Status = 'Missed Webinar/Seminar';
                            }
                            leadsToInsert.put(email,relatedLead);
                        }   
                        
                       // System.debug('@asha @debug: Batch_OptionsProcess: Inserting Lead: ' + email+' Lead: ' + relatedLead);
                    }else{
                        relatedLead = new Lead();
                        relatedLead.RecordTypeId = this.configuration.leadRecordTypeId;
                        relatedLead.FirstName = record.firstName;
                        relatedLead.LastName = record.lastName;
                        relatedLead.Phone = record.phone;
                        relatedLead.Email = record.email;
                        relatedLead.LeadSource = 'Processor Created Lead';
                        if(record.attended == 'Yes'){
                            leadsToConvert.put(email,relatedLead);
                        }else{
                            relatedLead.Status = 'Missed Webinar/Seminar';
                        }
                        leadsToInsert.put(email,relatedLead);
                        //System.debug('@asha @debug: Batch_OptionsProcess: Inserting Lead: ' + email+' Lead: ' + relatedLead);
                    
                    }
                    
                    String whoId = relatedAccount != null ? relatedAccount.PersonContactId : relatedLead.id;
                    Task relatedTask = null;
                    if(whoId != null){
                        list<Task> relatedTasks = relatedTasksMap.get(whoId);
                        if(relatedTasks != null){
                            for(Task task : relatedTasks){
                                if(relatedTask == null){
                                    relatedTask = task;
                                }else if(task.Status == 'Complete'){
                                    relatedTask = task;
                                    break;
                                }
                            }
                        }
                        
                        //added by aac 9.2.15 to check to see if tasks exist on the lead and on the account
                       if(relatedLead != null){
                           if(whoId != relatedLead.id){
                                if(leadEmailMap.containskey(email)){   //checks to see if email has a lead if so then the relatedlead should exist    
                                    list<Task> relatedTasks_lead = new list<Task>();     
                                    relatedTasks_lead = relatedTasksMap.get(relatedLead.id);   
                                    if(relatedTasks_lead != null && relatedTasks_lead.size() > 0){                                    
                                        System.debug('@asha: Batch_Options: relatedtasks size: '+relatedTasks_lead.size()); 
                                        relatedTask = relatedTasks_lead[0];
                                    }
                                }
                            }
                        }                   
                    }
        
                    if(relatedTask == null){
                        this.log.Number_of_Tasks_Created__c++;
                        relatedTask = ProccessorHelperMethods.createTask(this.webinar,whoId,this.configuration.taskActivityType,this.configuration.taskWebinarType);
                        relatedTask.Registration_Date__c =  (record.registrationDate != null)? record.registrationDate.Date(): relatedTask.Registration_Date__c; 
                    }else{
                        this.log.Number_of_Tasks_Found__c++;
                    }
                    
                    
                    webinarSource = relatedTask.Webinar_Source_Other__c;
                    creditId = relatedTask.Webinar_Source_User_ID__c;
                    creditName = relatedTask.Webinar_Source_User_ID_NAME__c;
                    
                    /* Task Details */
                    if(this.webinar != null){
                        relatedTask.Event_Date_Time__c = this.webinar.Event_Date_Time__c;
                        if(this.webinar.DiscountPercent__c != null)
                            relatedTask.Webinar_Discount_Offer_Percent__c = Decimal.valueOf(this.webinar.DiscountPercent__c);
                        if(this.webinar.DiscountDollar__c != null)
                            relatedTask.Webinar_Discount_Offer__c = Decimal.valueOf(this.webinar.DiscountDollar__c);
                        relatedTask.Webinar_Presenter__c = this.webinar.PrimaryPresenter__c;
                        relatedTask.Webinar_Presenter_secondary__c = this.webinar.SecondaryPresenter__c;
                        if(record.joinTime != null){
                            relatedTask.Join_Time__c = String.valueOf(record.joinTime);
                        }    
                        relatedTask.Status = 'Complete';
                        //calc the duration from leave - actual start
                        Decimal minutesdurationcalc = null;
                        if(record.leaveTime != null){
                            Long dt1Long = this.webinar.Actual_Start_Time__c.getTime();                        
                            Long dt2Long = record.leaveTime.getTime();
                            Long milliseconds = dt2Long - dt1Long;
                            Long secondsduration = milliseconds / 1000;
                            minutesdurationcalc = Decimal.valueOf(secondsduration / 60);
                        }
                        
                        relatedTask.Duration__c = (minutesdurationcalc != null)? minutesdurationcalc :record.inSessionDuration;
                        relatedTask.Duration__c = record.inSessionDuration;
                        relatedTask.Attended__c = attended;
                        relatedTask.Event_Name__c = this.webinar.Name;
                        relatedTask.Activity_Type__c = this.configuration.taskActivityType;
                        relatedTask.Webinar_Type__c = this.configuration.taskWebinarType;
                        taskMap.put(email,relatedTask);
                    }
        
                    /* Create or Update the related Webinar Attendance */
                    if(relatedWebinarAttendance == null){
                        this.log.Number_of_Webinar_Attendance_Created__c++;
                        System.debug('@asha @debug: Batch_OptionsProcess: Creating new Webinar Attendance Record.');
                        relatedWebinarAttendance = new Webinar_Attendance__c();
                        relatedWebinarAttendance.Registration_Date__c = Date.valueOf(record.registrationDate);
                        relatedWebinarAttendance.Webinar__c = this.webinar.Id;
                        relatedWebinarAttendance.Raised_Hands__c = null;
                    }else{
                        this.log.Number_of_Webinar_Attendance_Found__c++;
                    }
                    
                    relatedWebinarAttendance.Stamp_Type__c = 'UOC';
                    relatedWebinarAttendance.Join_Time__c = record.joinTime;
                    relatedWebinarAttendance.Leave_Time__c = record.leaveTime;
                    relatedWebinarAttendance.Account__c = relatedAccount == null ? null : relatedAccount.id;
                    relatedWebinarAttendance.Lead__c = (relatedLead != null && relatedAccount == null) ? relatedLead.id : null;
                    relatedWebinarAttendance.Attended__c = attended;
                    relatedWebinarAttendance.Duration__c = record.inSessionDuration;
                    relatedWebinarAttendance.Status__c = 'Complete';
                                    //aac limited null info from copying over from task to web attn record
                    if(creditId != null && (creditId.trim().length() == 15 || creditId.trim().length() == 18))
                        relatedWebinarAttendance.Credit_User__c = creditId;
                    relatedWebinarAttendance.Credit_Name__c = (creditName != null)? creditName : relatedWebinarAttendance.Credit_Name__c;
                    relatedWebinarAttendance.Source_Other__c = (webinarSource != null)? webinarSource : relatedWebinarAttendance.Source_Other__c;
                    
                    webinarAttendanceToUpsert.put(email,relatedWebinarAttendance);
                }
        
                /* Gurantee all leads exist in our DB before conversion */
                        System.debug('@asha: @debug: Handler_Lead bypass autoconverter'); 
                Handler_Lead.BYPASS = true; //skips autoconverter since it is at future call
                Handler_Account.BYPASS = true;
                list<Database.UpsertResult> upsertResults = Database.upsert(leadsToInsert.values(),false);
                Handler_Lead.BYPASS = false;
                Handler_Account.BYPASS = false;
                for(Database.UpsertResult result : upsertResults){
                    if(!result.isSuccess() || !result.isCreated()){
                        for(Database.Error error : result.getErrors()){
                            logger.log(error.getMessage());
                        }
                    }
                }
                
                for(String email : leadsToInsert.keySet()){                    
                        Lead lead = leadsToInsert.get(email);
                        if(webinarAttendanceToUpsert.containskey(email)){                                        
                            Webinar_Attendance__c relatedWebinarAttendance = webinarAttendanceToUpsert.get(email);
                            relatedWebinarAttendance.Lead__c =  lead.id ;    
                        }                     
                }
        
                /* Add whoId to tasks newly inserted leads */
                for(String email : leadsToInsert.keySet()){
                    if(taskMap.get(email) != null && taskMap.get(email).WhoId == null){
                        taskMap.get(email).WhoId = leadsToInsert.get(email).id;
                    } 
                }
                
                /* Update all tasks */
                list<Database.UpsertResult> taskUpsertResults = Database.upsert(taskMap.values(),false);
                for(Database.UpsertResult result : taskUpsertResults){
                    if(!result.isSuccess() || !result.isCreated()){
                        for(Database.Error error : result.getErrors()){
                            logger.log(error.getMessage());
                        }
                    }
                }
                
                /* Convert Leads, Track Failures */
                Handler_Account.BYPASS = true;
                Handler_Lead.BYPASS = true; 
                list<Database.LeadConvert> leadconversions = new list<Database.LeadConvert>();
                LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                for(String emailstr : leadsToConvert.keySet() ){ //leadsToConvert.values()){
                   Lead lead = leadsToConvert.get(emailstr);
                   if(lead != null){
                    if(lead.Id != null){
                        Database.LeadConvert lc = new Database.LeadConvert();
                        lc.setLeadId(lead.id);
                            if(accountEmailMap.containskey(emailstr)){
                                    lc.setAccountId(accountEmailMap.get(emailstr).id);
                            }
                        lc.setConvertedStatus(convertStatus.MasterLabel);
                        lc.setDoNotCreateOpportunity(true);
                        lc.setOwnerId(this.configuration.getOpportunityOwnerId());
                        leadconversions.add(lc);
                   }
                  }  
                }
                Handler_Account.BYPASS = false;
                Handler_Lead.BYPASS = false; 
                if(!leadConversions.isEmpty()){
                  //  if(TriggerDispatcher.ActiveHandler.handlerType.equals('Lead')){                     
                      Handler_Lead.AFTERFIRED = false;
                  //  }
                  Handler_Lead.BYPASS = true; 
                  Handler_Account.BYPASS = true;
                    list<Database.LeadConvertResult> lcr = Database.convertLead(leadconversions);
                    set<String> convertedLeadAccountIDs = new set<String>();
                    for(Database.LeadConvertResult result : lcr){
                        if(result.isSuccess()){
                            this.log.Number_of_Converted_Leads__c++;
                            convertedLeadAccountIDs.add(result.getAccountId());
                        }else{
                            for(Database.Error error : result.getErrors()){
                                logger.log(error.getMessage());
                            }
                            this.log.Number_of_Failed_Converted_Leads__c++;
                        }
                    }
                    Handler_Lead.BYPASS = false; 
                    Handler_Account.BYPASS = false;
                    /* Add recently created accounts to accountMap */
                    list<Account> convertedLeadAccounts = [SELECT id,Phone,Phone_Num_Exists_date_entered__c,CreatedDate,PersonEmail,PersonContactId,FirstName,LastName,(SELECT id,CloseDate,AccountId,Product__c,StageName,RecordTypeId,OwnerId,Account_Email__c,Account_Phone__c,Account_First_Name__c,Account_Last_Name__c,Owner_Name__c,x3Clogic_Stage_Score__c FROM Opportunities WHERE RecordTypeId = :configuration.opportunityRecordTypeId ORDER BY CreatedDate ASC) FROM Account WHERE id in :convertedLeadAccountIDs];
                    for(Account account : convertedLeadAccounts){
                        if(account.Phone != null){
                            account.Phone_Num_Exists_date_entered__c  = this.webinar.Event_Date_Time__c.Date();
                        }
                        accountMap.put(account.PersonEmail,account);
                    }
                    
                }
                
                /* Loop through accounts being processed to pull out existing opportunities or create a new one */
                for(String email : accountMap.keySet()) {
                    Account account = accountMap.get(email);
                    Webinar_Attendance__c relatedWebinarAttendance = webinarAttendanceToUpsert.get(email);
                    
                    if(account != null){
                        
                        /* Pre-Process Opps */
                        ProcessorRecord record = processorRecords.get(email);
                        if(record == null){
                            continue;
                        }
                            
                        /* Update WebinarAttendance References */
                        if(relatedWebinarAttendance != null){
                            relatedWebinarAttendance.Lead__c = null;
                            relatedWebinarAttendance.Account__c = account.id;
                        }
                        
                        /* Update the Phone Num Exists Date if a phone exists but that field is empty */
                        if(account.Phone != null && account.Phone_Num_Exists_date_entered__c == null){
                            account.Phone_Num_Exists_date_entered__c  = this.webinar.Event_Date_Time__c.Date();
                        }
                        
                        if(this.configuration.bypassOpportunityLogic == false){
                        
                            Opportunity primaryOpportunity;
                            boolean skip = false;
                            if(record.attended == 'No'){
                                this.log.Number_of_Untouched_Opps__c++;
                                skip = true;
                            }else if(account.Opportunities != null && !account.Opportunities.isEmpty()){
                            //aac 12.18.15
                            Boolean isattend = webattndexistmap.get(account.id);
                                for(Opportunity opportunity : account.Opportunities){
                                    if ((this.noTouchOppStages.contains(opportunity.StageName) || isattend) && (opportunity.StageName != 'Closed Lost') ) {
                                        this.log.Number_of_Untouched_Opps__c++;
                                        primaryOpportunity = null;
                                        skip = true;
                                        break;
                                    }
                                    if(primaryOpportunity == null){
                                        this.log.Number_of_Updated_Opps__c++;
                                        if(!opportunity.StageName.equals('Closed Lost')){
                                            this.log.Number_of_New_Deals__c++;
                                        }
                                        primaryOpportunity = opportunity;
                                    }
                                }
                            }
                        
                            if(skip != true){
                                if(primaryOpportunity != null){
                                    primaryOpportunity.StageName = (primaryOpportunity.StageName == 'Closed Lost')? 'Re-Attendee' : this.configuration.opportunityStageName;
                                    //aac 12.28.15 updated for opp stage value changes - no longer change sub stage
                                    //primaryOpportunity.Sub_Stage__c = this.configuration.opportunitySubStage;
                                    primaryOpportunity.Payment_Plan__c = this.configuration.paymentPlan;
                                    if(primaryOpportunity.CloseDate <= Date.today()){
                                        primaryOpportunity.CloseDate = this.configuration.opportunityCloseDate;
                                    }
                                    opportunityMap.put(email,primaryOpportunity);
                                }else{
                                    this.log.Number_Of_New_Opps__c++;
                                    this.log.Number_of_New_Deals__c++;
                                    primaryOpportunity = ProccessorHelperMethods.createOpportunity(this.configuration.opportunityName,this.configuration.opportunityRecordTypeId,this.configuration.opportunityCloseDate,this.configuration.opportunityStageName,this.configuration.opportunitySubStage,this.configuration.paymentPlan,this.configuration.opportunityProduct,account.id);   
                                    primaryOpportunity.OwnerId = this.configuration.getOpportunityOwnerId();
                                    opportunityMap.put(email,primaryOpportunity);
                                }
                                //account.OwnerId = primaryOpportunity.OwnerId;
                            }
                        }
                    }
                  
                }
                Handler_Lead.BYPASS = true; 
                Handler_Account.BYPASS = true;
                    list<Database.SaveResult> accountUpdateResults = Database.update(accountMap.values(),false);
                Handler_Account.BYPASS = false;
                Handler_Lead.BYPASS = false; 
                if(this.configuration.bypassOpportunityLogic == false){
                
                Handler_Lead.BYPASS = true; 
                Handler_Account.BYPASS = true;
                    list<Database.UpsertResult> oppUpsertResults = Database.upsert(opportunityMap.values(),false);
                Handler_Account.BYPASS = false;    
                Handler_Lead.BYPASS = false; 
                    for(Database.UpsertResult result : oppUpsertResults){
                        if(!result.isSuccess() || !result.isCreated()){
                            for(Database.Error error : result.getErrors()){
                                logger.log(error.getMessage());
                            }
                        }
                    }
                    for(Opportunity opp : opportunityMap.values()){
                        this.opportunityIds.add(opp.id);
                    }
                }
                Handler_Lead.BYPASS = true; 
                Handler_Account.BYPASS = true; //to bypass at future or batch calls
                list<Database.UpsertResult> webinarAttendanceResults = Database.upsert(webinarAttendanceToUpsert.values(),false);
                Handler_Account.BYPASS = false;
                Handler_Lead.BYPASS = false; 
                
                for(Database.UpsertResult result : webinarAttendanceResults){
                    if(!result.isSuccess() || !result.isCreated()){
                        for(Database.Error error : result.getErrors()){
                            logger.log(error.getMessage());
                        }
                    }
                }
                
                for(Webinar_Attendance__c webinarAttendance : webinarAttendanceToUpsert.values()){
                    this.webinarAttendanceIds.add(webinarAttendance.Id);
                }
                
                logger.emailDebugResults(new list<String>{'sfdev@markettraders.com',UserInfo.getUserEmail()});
                 Handler_Account.BYPASSPROCESSOR = false;
            }
       }catch(Exception ex){
            system.debug(ex);
            Logger logger = new Logger('CRITICAL ERROR: Options Processor Batch');
            logger.log(ex.getMessage());
            logger.log(ex.getStackTraceString());
            logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});
        } 
        
    }
    
    /**************************************
    * @method finish
    *
    * @description
    * required method for batch processes - creates attachments of webinar attendance records and opportunity ids
    * and attaches it to processor log. also sends email to admins and individuals in custom setting LoggerEmailRecipients
    * that are marked admin after to notify that the processor is completed
    * 
    * @params Database.BatchableContext - batch-able context for batch processes
    *
    **/
    global void finish(Database.BatchableContext BC){
        try{    
            
            if(this.configuration.bypassOpportunityLogic == false){
                Attachment opportunitiesAttachment = new Attachment();
                opportunitiesAttachment.ContentType = '.json';
                opportunitiesAttachment.Description = 'This attachment contains a JSONified map of Opportunity Ids';
                opportunitiesAttachment.Name = 'Opportunities';
                opportunitiesAttachment.ParentId = this.log.id;
                opportunitiesAttachment.body = Blob.valueOf(JSON.serialize(this.opportunityIds));
                Database.insert(opportunitiesAttachment,false);
            }
            
            Attachment webinarAttendanceAttachment = new Attachment();
            webinarAttendanceAttachment.ContentType = '.json';
            webinarAttendanceAttachment.Description = 'This attachment contains a JSONified map of Webinar Attendance Ids';
            webinarAttendanceAttachment.Name = 'Webinar Attendance';
            webinarAttendanceAttachment.ParentId = this.log.id;
            webinarAttendanceAttachment.body = Blob.valueOf(JSON.serialize(this.webinarAttendanceIds));
            Database.insert(webinarAttendanceAttachment,false);
            
            Database.update(this.log,false);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> emailstrs = new List<String>();
            List<LoggerEmailRecipients__c> emaillist = LoggerEmailRecipients__c.getAll().values();
            For(LoggerEmailRecipients__c e : emaillist){
                if(e.Processors__c){
                    emailstrs.add(e.Users_Email__c);    
                }
            }            

            String[] toAddresses = new String[] {'sfdev@markettraders.com',UserInfo.getUserEmail(),'processor-uoc@markettraders.com'}; 
            toAddresses.addAll(emailstrs);
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('dev@markettraders.com');
            mail.setSenderDisplayName('Options Processor');
            mail.setSubject('Options Processor Completed ' + String.valueOf(DateTime.now()));
            String body = 'View the results <a href="https://login.salesforce.com/' + log.Id + '">here</a>';
            mail.setHtmlBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        }catch(Exception ex){
            system.debug(ex);
            Logger logger = new Logger('CRITICAL ERROR: Front End Processor Batch');
            logger.log(ex.getMessage());
            logger.log(ex.getStackTraceString());
            logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});
        }
        
    }

}