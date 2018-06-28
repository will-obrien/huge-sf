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
*   Date Created:       3/14/2014
*   Author:             Jim Hutcherson
*   Last Modified:      2/8/16
*   Last Modified By:   Sean Murphy
*
*   10.12.15 aac added platform to logger emails that go out at the end of processing
*   12.19.15 aac added fields to track attendance for the account - determines if opp stage is updated
*   12.28.15 aac removed sub stage update for opportunities as part of opp stage update
*   2/8/16 msm: modified execute method to support processing moodle webinars
*    3.1.16 aac: added check for if phone number exists for the phone num exist date entered field updates
*
**********************************************************************************************************************/
/********************************
*
* @description: used to batch process webinar attendance records from citrix - works with front end, back end, micro and stock webinars
* 
**/
global with sharing class Batch_FrontEndPreProcess implements Database.Batchable<sObject>,Database.Stateful{
    
    private set<String> noTouchOppStages = new set<String>{'Pending Charge', 'Pending Signature', 'Pending Post-Signature', 'Closed Won', 'Closed Won - Recovered Bad Debt'};
    private map<String,String> monthConversionMap = new map<String,String>{'jan'=>'1', 'feb'=>'2', 'mar'=>'3', 'apr'=>'4', 'may'=>'5', 'jun'=>'6', 'jul'=>'7', 'aug'=>'8', 'sep'=>'9', 'oct'=>'10', 'nov'=>'11', 'dec'=>'12'};
    
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
    global Batch_FrontEndPreProcess(Processor_Log__c log,ProcessorConfiguation configuration,Webinar__c webinar) {
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
    global Database.QueryLocator start(Database.BatchableContext BC) {
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
    global void execute(Database.BatchableContext BC, List<Attachment> attachments) {
      //  try{
        Handler_Account.BYPASSPROCESSOR = true;
        System.debug(Logginglevel.ERROR,'@asha: Batch_FrontEndPreProcess : starting batch');
        String loggername = (this.webinar.Platform__c == 'ReadyTalk') ? 'ReadyTalk-' : '';
        loggername =+ String.isblank(this.configuration.webinarstamptype)? 'Front End' : this.configuration.webinarstamptype;
        Logger logger = new Logger(loggername  + ' Processor Batch Log');
        Map<String, Webinar_Attendance__c> orphanAttendances = ProccessorHelperMethods.getOrphanWebinarAttendanceMap(this.webinar.id);
        
        // MAIN for loop
        for (Attachment processorRecordsAttachment : attachments) {
            String serializedProcessorRecords = processorRecordsAttachment.body.toString();
            // get processor records from attachment
            map<String, ProcessorRecord> processorRecords = (map<String, ProcessorRecord>)JSON.deserialize(serializedProcessorRecords,map<String, ProcessorRecord>.class);
            
            //added aac 12.18.15 changes to opp stage
            map<String,Boolean> webattndexistmap = new map<String,Boolean>();
            map<String,Account> accountMap = new map<String,Account>();
            map<String,Opportunity> opportunityMap = new map<String,Opportunity>();
            map<String,Task> taskMap = new map<String,Task>();
            map<String,decimal> durationMap = new map<String,decimal>();
            
            // query webinar attendance by email
            map<String,Webinar_Attendance__c> webinarAttendanceMap = ProccessorHelperMethods.getWebinarAttendanceMap(processorRecords.keySet(),this.webinar.id,this.webinar.Event_Date_Time__c);
            
            // query accounts by email and collect ids to be used to query tasks
            set<Id> whoIds = new set<Id>();
            map<String,Account> accountEmailMap = ProccessorHelperMethods.getAccountMap(processorRecords.keySet(),this.configuration.opportunityProduct);
            map<String, Boolean> accountPhoneExistsMap = new Map<String, Boolean>();
            
            for (Account account : accountEmailMap.values()) {
                whoIds.add(account.PersonContactId);
                accountPhoneExistsMap.put(account.Id, account.Phone != null);
                //added aac 12.18.15 
                Boolean iswebattd = false;
                iswebattd = (account.Webinar_UTP_First_Attd__c != null) ? true : iswebattd;
                iswebattd = (account.Webinar_Client_First_Attd__c != null) ? true : iswebattd;
                iswebattd = (account.Webinar_UOC_First_Attd__pc != null) ? true : iswebattd;
                iswebattd = (account.Webinar_USC_First_Attd__pc != null) ? true : iswebattd;
                iswebattd = (account.Webinar_LMFS_First_Attd__pc != null) ? true : iswebattd;
                webattndexistmap.put(account.Id, iswebattd);
            }
            
            // query leads by email and collect ids to be used to query tasks
            map<String,Lead> leadEmailMap = ProccessorHelperMethods.getLeadMap(processorRecords.keySet(),this.configuration.leadRecordTypeId);
            for (Lead lead : leadEmailMap.values()) {
                whoIds.add(lead.Id);
            }
            
            // query tasks related to queried leads and accounts and the webinar being processed
            map<Id,list<Task>> relatedTasksMap = ProccessorHelperMethods.getTaskMap(whoIds,this.webinar.Webinar_ID__c);
        
            map<String,Lead> leadsToInsert = new map<String,Lead>();
            map<String,Lead> leadsToConvert = new map<String,Lead>();
            map<String, Webinar_Attendance__c> webinarAttendanceToUpsert = new map<String,Webinar_Attendance__c>();
            
            // loop over processor records 
            // for loop A (on ProcessorRecords) =======================================================================================
            // ========================================================================================================================              
            for (String email : processorRecords.keySet()) {
                // get the processor record by email 
                ProcessorRecord record = processorRecords.get(email); 
                // get webinar attendance record(s) by email
                Webinar_Attendance__c relatedWebinarAttendance = webinarAttendanceMap.get(email);
                
                if ((this.configuration.webinarstamptype == 'CE Classes') && (relatedWebinarAttendance == null)) {
                    for (Webinar_Attendance__c owa : orphanAttendances.values()) {
                        if (owa.Orphan_Attendance_Info__c.contains(email.toLowerCase())) {
                            relatedWebinarAttendance = owa;
                            break;
                        }
                    }
                }
                
                // get account record by email
                Account relatedAccount = accountEmailMap.get(email);
                
                // get lead record by email
                Lead relatedLead = leadEmailMap.get(email);
                Boolean attended = record.attended == 'Yes' ? true : false;
                String webinarSource;
                String creditId;
                String creditName;
                
                // save in session duration by email  
                durationMap.put(email, record.inSessionDuration);
                // if there is a related account or lead, store account by email (as necessary), and store lead as to be inserted and converted (as necessary)
                // else create a new lead to be inserted and converted (as necessary)
                if (relatedAccount != null || relatedLead != null) { 
                    if (relatedAccount != null) {
                        accountMap.put(email, relatedAccount);
                    }
                    
                    if (relatedLead != null) {
                        if (record.attended == 'Yes') {
                            leadsToConvert.put(email,relatedLead);
                        }
                        else {
                            relatedLead.Status = 'Missed Webinar/Seminar';
                        }
                        leadsToInsert.put(email,relatedLead);
                    }
                }
                else if (this.configuration.webinarstamptype != 'CE Classes') {                          // NO MATCHES
                    relatedLead = new Lead();
                    relatedLead.RecordTypeId = this.configuration.leadRecordTypeId;
                    System.debug('@asha: @debug: BatchFrontEndPreProcess : record type id = '+  this.configuration.leadRecordTypeId);
                    relatedLead.FirstName = record.firstName;
                    relatedLead.LastName = (record.lastName != null)? record.lastName : 'WebinarLead';
                    relatedLead.Phone = record.phone;
                    relatedLead.Email = record.email;
                    relatedLead.LeadSource = 'Processor Created Lead';
                        
                    if (record.attended == 'Yes') {
                        leadsToConvert.put(email,relatedLead);
                    }
                    else {
                        relatedLead.Status = 'Missed Webinar/Seminar';
                    }
                    
                    leadsToInsert.put(email,relatedLead);
                }
                
                // if there is a related account, then use the id, else use the related lead id (can be null if newly created)
                
                String whoId;
                if ((relatedAccount != null) || (relatedLead != null)) {
                    whoId = relatedAccount != null ? relatedAccount.PersonContactId : relatedLead.id;
                }

                if (this.configuration.webinarstamptype != 'CE Classes') {   
                    Task relatedTask = null;
                    // get the related tasks for the account/lead (unless newly created lead)
                    if (whoId != null) {
                        list<Task> relatedTasks = relatedTasksMap.get(whoId);
                        if (relatedTasks != null) {
                            // loop over related tasks and find the first "Completed" one, or the last one if no completed task is found
                            // each task list should be sorted in ascending order by created date
                            // if there is more than 1 task in the task list, the first (earliest creation date) task will not be saved off  
                            for (Task task : relatedTasks) {
                                if (relatedTask == null) {
                                    relatedTask = task;
                                }
                                else if (task.Status == 'Complete') {
                                    relatedTask = task;
                                    break;
                                }
                            }
                        }
                        
                        //added by aac 9.2.15 to check to see if tasks exist on the lead and on the account
                        // if both an existing account and existing lead were found, get the tasks for the lead, and then get the 1st task in the list
                        // and make it the related task (should be the 1st created task on the lead)
                        // this will overwrite any task identified on the account
                        if (relatedLead != null) {
                            if (whoId != relatedLead.id) {
                                if (leadEmailMap.containskey(email)) {                            
                                    list<Task> relatedTasks_lead = relatedTasksMap.get(relatedLead.id);
                                    if (relatedTasks_lead != null && relatedTasks_lead.size() > 0) {                                    
                                        relatedTask = relatedTasks_lead[0];
                                    }
                                }
                            }
                        }
                    }
        
                    // if no related task obtained, create a task and increment created task counter, else increment found task counter
                    if (relatedTask == null) {
                        this.log.Number_of_Tasks_Created__c++;
                        // create a task and relate it to the account or lead
                        relatedTask = ProccessorHelperMethods.createTask(this.webinar,whoId,this.configuration.taskActivityType,this.configuration.taskWebinarType);
                        relatedTask.Registration_Date__c =   (record.registrationDate != null) ? record.registrationDate.Date() : relatedTask.Registration_Date__c; 
                    }
                    else {
                        this.log.Number_of_Tasks_Found__c++;
                    }
            //aac 2.15.16 - since the task is updated by the web dev side more often than the webinar attendance
            //if there is a preexisting related task which has the webinar source, that information 
            //needs to be taken from the pre-existing task and moved to the webinar attendance record        
             webinarSource = relatedTask.Webinar_Source_Other__c;
             creditId = relatedTask.Webinar_Source_User_ID__c;
             creditName = relatedTask.Webinar_Source_User_ID_NAME__c;
                
                    // update task details 
                    if (this.webinar != null) {
                        relatedTask.Event_Date_Time__c = this.webinar.Event_Date_Time__c;
                        if (this.webinar.DiscountPercent__c != null) {
                            relatedTask.Webinar_Discount_Offer_Percent__c = Decimal.valueOf(this.webinar.DiscountPercent__c);
                        }
                        if (this.webinar.DiscountDollar__c != null) {
                            relatedTask.Webinar_Discount_Offer__c = Decimal.valueOf(this.webinar.DiscountDollar__c);
                        }
                        relatedTask.Webinar_Presenter__c = this.webinar.PrimaryPresenter__c;
                        relatedTask.Webinar_Presenter_secondary__c = this.webinar.SecondaryPresenter__c;
                        if (record.joinTime != null) {
                            relatedTask.Join_Time__c = String.valueOf(record.joinTime);
                        }    
                        relatedTask.Status = 'Complete';
                        Decimal minutesdurationcalc = null;
                        if (record.leaveTime != null) {
                            Long dt1Long = this.webinar.Actual_Start_Time__c.getTime();                        
                            Long dt2Long = record.leaveTime.getTime();
                            Long milliseconds = dt2Long - dt1Long;
                            Long secondsduration = milliseconds / 1000;
                            minutesdurationcalc = Decimal.valueOf(secondsduration / 60);
                        }
                        
                        relatedTask.Duration__c = (minutesdurationcalc != null)? minutesdurationcalc :record.inSessionDuration;
                        relatedTask.Attended__c = attended;
                        relatedTask.Event_Name__c = this.webinar.Name;
                        relatedTask.Activity_Type__c = this.configuration.taskActivityType;
                        relatedTask.Webinar_Type__c = this.configuration.taskWebinarType;
                        taskMap.put(email,relatedTask);
                    }
                }
        
                // if no related webinar attendance obtained, create a web att and increment created web att counter, else increment found web att counter
                if (relatedWebinarAttendance == null) {
                    this.log.Number_of_Webinar_Attendance_Created__c++;
                    relatedWebinarAttendance = new Webinar_Attendance__c();
                    relatedWebinarAttendance.Registration_Date__c = Date.valueOf(record.registrationDate);
                    relatedWebinarAttendance.Webinar__c = this.webinar.Id;
                    relatedWebinarAttendance.Raised_Hands__c = null;
                }
                else {
                    this.log.Number_of_Webinar_Attendance_Found__c++;
                }
                
                // update webinar attendance details
                if (this.configuration.webinarstamptype != 'CE Classes') {
                    relatedWebinarAttendance.Stamp_Type__c = String.isblank(this.configuration.webinarstamptype) ? 'UTP' : this.configuration.webinarstamptype;
                }
                else {
                    relatedWebinarAttendance.Stamp_Type__c = String.isblank(this.configuration.webinarstamptype) ? 'CE Classes' : this.configuration.webinarstamptype;
                }
                relatedWebinarAttendance.Join_Time__c = record.joinTime;
                relatedWebinarAttendance.Leave_Time__c = record.leaveTime;
                
                relatedWebinarAttendance.Account__c = relatedAccount == null ? null : relatedAccount.id;
                relatedWebinarAttendance.Lead__c = relatedLead == null ? null : relatedLead.id;
                
                if ((this.configuration.webinarstamptype == 'CE Classes') && (relatedWebinarAttendance.Account__c == null) && (relatedWebinarAttendance.Lead__c == null)) {
                    String orphanContactInfo = ('Name: ' + record.firstName + ' ' + record.lastName);
                    orphanContactInfo += ', ';
                    orphanContactInfo += ('Email: ' + record.email.toLowerCase());
                    orphanContactInfo += ', ';
                    orphanContactInfo += ('Phone: ' + record.phone);
                    relatedWebinarAttendance.Orphan_Attendance_Info__c = orphanContactInfo;
                }
                
                relatedWebinarAttendance.Attended__c = attended;
                relatedWebinarAttendance.Duration__c = record.inSessionDuration;
                relatedWebinarAttendance.Status__c = 'Complete';
                if (creditId != null && (creditId.trim().length() == 15 || creditId.trim().length() == 18)) {
                    relatedWebinarAttendance.Credit_User__c = creditId;
                }
                relatedWebinarAttendance.Credit_Name__c = (!String.isblank(creditName))? creditName : relatedWebinarAttendance.Credit_Name__c;
                relatedWebinarAttendance.Source_Other__c = (!String.isblank(webinarSource))? webinarSource : relatedWebinarAttendance.Source_Other__c;
                webinarAttendanceToUpsert.put(email,relatedWebinarAttendance);
            } 
            // end for loop A (on ProcessorRecords) ===================================================================================
            // ========================================================================================================================
            
            // Gurantee all leads exist in our DB before conversion
            System.debug(Logginglevel.ERROR,'@asha: @debug: Batch_FrontEndPreProcess: Handler_Lead bypass autoconverter'); 
            // enable bypasses prior to upsert
            Handler_Lead.BYPASS = true; //skips autoconverter since it is at future call
            Handler_Account.BYPASS = true;
            List<lead> listleadvals = new list<lead>();
            Map<id,lead> mapleadsToUpdate = new Map<id,lead>();
            
            for (Lead a : leadsToInsert.values()) {
                // if existing lead
                if (a.id != null) {
                    mapleadsToUpdate.put(a.id, a);
                    System.debug(LoggingLevel.Error, '@asha - lead id not null');
                    System.debug(LoggingLevel.Error, '@asha -lead: '+ a);
                }
                else {
                    if (a != null) {
                        listleadvals.add(a);
                        System.debug(LoggingLevel.Error, '@asha - lead id is null ');
                        System.debug(LoggingLevel.Error, '@asha -lead: '+ a);
                    }
                }
            }
            
            listleadvals.addall(mapleadsToUpdate.values());
            
            // upsert leads (existing and newly created)
            list<Database.UpsertResult> upsertResults = Database.upsert(listleadvals,false);
            // disable bypasses following upsert
            Handler_Lead.BYPASS = false;
            Handler_Account.BYPASS = false;
            System.debug(Logginglevel.ERROR,'@asha: @debug: Batch_FrontEndPreProcess : upserted leads');
           
            // log lead upsert errors
            for (Database.UpsertResult result : upsertResults) {
                if (!result.isSuccess() || !result.isCreated()) {
                    for (Database.Error error : result.getErrors()) {
                        logger.log(error.getMessage());
                        System.debug(Logginglevel.ERROR,'@asha: @debug: Batch_FrontEndPreProcess : Error upserting lead'+ error.getMessage());
                    }
                }
            }
            
            // iterate over leads to insert (should be inserted at this point unless they failed), get the webinar attendance by email and relate to
            // inserted lead using newly created lead's id; this list is built in for loop A
            Set<String> newAcctsFromConversion = new Set<String>();
            for (String email : leadsToInsert.keySet()) {
                Lead lead = leadsToInsert.get(email);
                if (webinarAttendanceToUpsert.containskey(email)) { 
                    Webinar_Attendance__c relatedWebinarAttendance = webinarAttendanceToUpsert.get(email);
                    relatedWebinarAttendance.Lead__c = lead.id;
                    System.debug(Logginglevel.Error,'@asha: @debug: Batch_FrontEndPreProcess : Updated web attendance with lead id '+ lead.id);
                }
            }
                
            if (this.configuration.webinarstamptype != 'CE Classes') {
                // Add whoId to tasks newly inserted leads; this list is built in for loop A
                // loop over leads (now newly inserted) and use email to get task and relate to lead using newly created lead ids
                for (String email : leadsToInsert.keySet()) {
                    if (taskMap.get(email) != null && taskMap.get(email).WhoId == null) {
                        taskMap.get(email).WhoId = leadsToInsert.get(email).id;
                    } 
                }
                
                // prep tasks for upsert tasks
                Map<id,Task> mapTaskToUpdate = new Map<id,Task>();
                List<task> listtask = new list<task>();
                for (Task a : taskMap.values()) {
                    if (a.id != null) {                            
                        mapTaskToUpdate.put(a.id, a);
                        System.debug(Logginglevel.ERROR,'@asha: task id: '+a.id +' task info: '+ a );
                    }
                    else {
                        if (a != null) {
                            System.debug(LoggingLevel.Error, '@asha - task id null ' + a);
                            listtask.add(a);
                        }
                    }
                }
                
                listtask.addall(mapTaskToUpdate.values());
                system.debug(logginglevel.error, '@asha: size'+ listtask.size());
                // upsert the tasks
                list<Database.UpsertResult> taskUpsertResults = Database.upsert(listtask,false);
            
                // log task upsert errors
                for (Database.UpsertResult result : taskUpsertResults) {
                    if (!result.isSuccess() || !result.isCreated()) {
                        for (Database.Error error : result.getErrors()) {
                            logger.log(error.getMessage());
                            System.debug('@asha: @debug: Batch_FrontEndPreProcess : task upsert error '+ error.getMessage());
                        }
                    }
                }
            }
                
            // Convert Leads, Track Failures
            list<Database.LeadConvert> leadconversions = new list<Database.LeadConvert>();
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            Handler_Account.BYPASS = true;
            Handler_Lead.BYPASS = true;
            
            // leads in this list may be newly inserted or existing leads
            set<Id> leadsConvertedWithNoTargetAccount = new set<Id>();
            for (String emailstr : leadsToConvert.keySet() ) {
                Lead lead = leadsToConvert.get(emailstr);
                if (lead != null) {
                    System.debug(LoggingLevel.ERROR, '@@@ leads to be converted are found.');
                    if (lead.Id != null) {
                        System.debug(LoggingLevel.ERROR, '@@@ front end preproc adding lead to convert...');
                        Database.LeadConvert lc = new Database.LeadConvert();
                        lc.setLeadId(lead.id);
                        // if there is an match in the email account map, use it to merge during conversion
                        if (accountEmailMap.containskey(emailstr)) {
                            System.debug('@asha: Batch_FrontEndPreProcessor : Adding existing email to lead conversion '+ accountEmailMap.get(emailstr).id +' email '+ accountEmailMap.get(emailstr).personemail );
                            lc.setAccountId(accountEmailMap.get(emailstr).id);
                        }
                        else {
                            leadsConvertedWithNoTargetAccount.add(lead.Id);
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
            
            // if there are leads to convert
            if (!leadConversions.isEmpty()) {
                //aac  To verify that lead conversion occurs
                // set handler flags (including bypass) prior to conversion                    
                Handler_Lead.AFTERFIRED = false;
                Handler_Account.BYPASS = true;
                Handler_Lead.BYPASS = true;
            
                System.debug(LoggingLevel.ERROR, '@@@ front end pre proc converting leads...');
                // CONVERT LEAD(s)
                list<Database.LeadConvertResult> lcr = Database.convertLead(leadconversions);
                set<String> convertedLeadAccountIDs = new set<String>();
            
                // log conversion errors, collect converted account ids, and increment failed conversion counter if applicable
                for (Database.LeadConvertResult result : lcr) {
                    if (result.isSuccess()) {
                        this.log.Number_of_Converted_Leads__c++;
                        System.debug('@asha: Account ID after lead conversion: '+ result.getAccountId());
                        if (leadsConvertedWithNoTargetAccount.contains(result.getLeadId())) {
                            newAcctsFromConversion.add(result.getAccountId());
                        }
                        convertedLeadAccountIDs.add(result.getAccountId());
                    }
                    else {
                        for (Database.Error error : result.getErrors()) {
                            logger.log(error.getMessage());
                            System.debug('@asha: Error with lead conversion: '+ error.getMessage());
                        }
                        this.log.Number_of_Failed_Converted_Leads__c++;
                    }
                } // end for loop
                
                // enable bypass after conversion
                Handler_Account.BYPASS = false;
                Handler_Lead.BYPASS = false;
                
                /******************************************************************************************************
                    at this point, the account map only contains existing accounts (i.e., those already in SF that matched by email)
                    so now we are going to add the accounts that were just created during lead conversion
                ******************************************************************************************************/
            
                // Add recently created accounts to accountMap and set Phone_Num_Exists_date_entered__c if applicable 
                list<Account> convertedLeadAccounts = [SELECT Id, ContEd_Sub_Stage__c, Phone, Phone_Num_Exists_date_entered__c,
                                                            CreatedDate, PersonEmail, Alternate_Email__c, PersonContactId, FirstName, LastName,
                                                            (SELECT Id, CloseDate, AccountId, Product__c, StageName, RecordTypeId,
                                                                    OwnerId, Account_Email__c, Account_Phone__c, Account_First_Name__c,
                                                                    Account_Last_Name__c, Owner_Name__c, x3Clogic_Stage_Score__c,
                                                                    Country_List__c 
                                                                FROM Opportunities 
                                                                WHERE RecordTypeId = :configuration.opportunityRecordTypeId 
                                                                ORDER BY CreatedDate ASC) 
                                                        FROM Account 
                                                        WHERE id in :convertedLeadAccountIDs];
                                                    
                for (Account account : convertedLeadAccounts) {
                    // FOR ACCOUNTS DUE TO CONVERTED LEADS ONLY
                    //if ((account.Phone != null) && ((Date.today() > this.webinar.Event_Date_Time__c.Date()) || (account.Phone_Num_Exists_date_entered__c == null))) {
                    //  account.Phone_Num_Exists_date_entered__c  = this.webinar.Event_Date_Time__c.Date();
                    //}
                    accountMap.put(account.PersonEmail,account);
                    if(account.Alternate_Email__c != null){
                        accountMap.put(account.Alternate_Email__c,account);
                        System.debug('@asha: BatchFrontEndPreProcessor: adding alternate email to account map here '+ account.Alternate_Email__c);
                    }
                }
            } // end if
            
            System.debug('@asha, AccountMap Size : ' + accountMap.size());              
            // Loop through accounts being processed to pull out existing opportunities or create a new one
            
            // for loop B (on Accounts) ===============================================================================================
            //=========================================================================================================================
            for (String email : accountMap.keySet()) {
                Account account = accountMap.get(email);
                    
                System.debug(Logginglevel.ERROR,'@asha: updating account :' + account.id);
                Webinar_Attendance__c relatedWebinarAttendance = webinarAttendanceToUpsert.get(email);
              
   
                if (account != null) {
                    // Pre-Process Opps
                    ProcessorRecord record = processorRecords.get(email);
                    if (record == null) {
                        continue;
                    }
                            
                    // Update WebinarAttendance References
                    if (relatedWebinarAttendance != null) {
                        System.debug(Logginglevel.ERROR,'@asha: relatedWebinarAttendance attended is :' + relatedWebinarAttendance.Attended__c);
                 
                        relatedWebinarAttendance.Lead__c = null;
                        relatedWebinarAttendance.Account__c = account.id;
                        webinarAttendanceToUpsert.put(email,relatedWebinarAttendance); //added aac 3 5 15
                            
                        System.debug(Logginglevel.ERROR,'@asha: start new deal');
                        //Continued Education Sales Update the substage
                        if (relatedWebinarAttendance.Attended__c) {
                            if (!String.isblank(this.configuration.webinarstamptype) && (this.configuration.webinarstamptype == 'Continued Education')) {
                                //aac 6.25.15 added from request to not change substage if in webinar watchers
                                if (account.ContEd_Sub_Stage__c != 'Webinar Watchers') {
                                    account.ContEd_Sub_Stage__c = 'New Deal';
                                    System.debug(Logginglevel.ERROR,'@asha: updated new deal');
                                } 
                            }
                        }
                        
                        System.debug(Logginglevel.ERROR,'@asha: end new deal');  
                    }
                    
                    // msm:  corrected with deployment on 12/7/2015  
                    //aac: 3.1.16 added check for if account.phone is not null otherwise date will be filled with no phone  
                    if (newAcctsFromConversion.contains(account.Id) && account.Phone != null) {                  // NEW ACCOUNT DUE TO CONVERSION
                        if (account.Phone_Num_Exists_date_entered__c > this.webinar.Event_Date_Time__c.Date()) {
                            account.Phone_Num_Exists_date_entered__c = this.webinar.Event_Date_Time__c.Date();
                        }
                    }
                    //else if ((accountPhoneExistsMap.containsKey(account.Id)) && (accountPhoneExistsMap.get(account.Id))) {                        // EXISTING ACCOUNT
                    else if (accountPhoneExistsMap.containsKey(account.Id)) {
                        // if existing account with phone number and no date OR existing account with no phone number 
                        if (((accountPhoneExistsMap.get(account.Id)) && (account.Phone_Num_Exists_date_entered__c == null))) { // aac: 3.1.16 remove second check  if theres no phone then field doesnt need to  be updated || (!accountPhoneExistsMap.get(account.Id) )) {
                        //if (account.Phone_Num_Exists_date_entered__c == null) {                           
                            account.Phone_Num_Exists_date_entered__c = this.webinar.Event_Date_Time__c.Date();
                        }
                    }
                        
                    if (this.configuration.bypassOpportunityLogic == false) {
                        Opportunity primaryOpportunity;
                        Boolean skip = false;
                        if (record.attended == 'No') {
                            this.log.Number_of_Untouched_Opps__c++;
                            skip = true;
                        }
                        else if (account.Opportunities != null && !account.Opportunities.isEmpty()) {
                           
                            //aac 12.18.15
                                Boolean isattend = webattndexistmap.get(account.id);
                                Boolean isclosedlost = false;
                            for (Opportunity opportunity : account.Opportunities) {
                                isclosedlost = (opportunity.StageName == 'Closed Lost')? true : isclosedlost ;
                                if ((this.noTouchOppStages.contains(opportunity.StageName) || isattend) && !isclosedLost ) {
                                    this.log.Number_of_Untouched_Opps__c++;
                                    primaryOpportunity = null;
                                    skip = true;
                                    break;
                                }
                                
                                if (primaryOpportunity == null) {
                                    this.log.Number_of_Updated_Opps__c++;
                                    if(!isclosedlost){
                                        this.log.Number_of_New_Deals__c++;
                                    }
                                    primaryOpportunity = opportunity;
                                }
                            }
                        }
                        
                        if (skip != true) {
                            if (primaryOpportunity != null) {
                                primaryOpportunity.StageName = (primaryOpportunity.StageName == 'Closed Lost')? 'Re-Attendee' : this.configuration.opportunityStageName;
                               // aac 12.28.15 updated for opp stage update - no longer needed to update substage
                                //primaryOpportunity.Sub_Stage__c = this.configuration.opportunitySubStage;
                                primaryOpportunity.Payment_Plan__c = this.configuration.paymentPlan;
                                if (primaryOpportunity.CloseDate <= Date.today()) {
                                    primaryOpportunity.CloseDate = this.configuration.opportunityCloseDate;
                                }
                                opportunityMap.put(email,primaryOpportunity);
                            }
                            else {
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
            } // end for loop B (on Accounts)
                
            // update accounts
            Handler_Lead.BYPASS = true;
            Handler_Account.BYPASS = true;
            Map<id,account> mapaccountToUpdate = new Map<id,Account>();
            list<account> newaccts = new list<Account>();
            for (Account a : accountMap.values()) {
                if (a.id != null) {    
                    mapaccountToUpdate.put(a.id, a);
                    System.debug(logginglevel.error,'@asha accounts not null');
                    System.debug(logginglevel.error,'@asha account ' + a);
                }
                else {
                    newaccts.add(a);    
                    System.debug(logginglevel.error,'@asha accounts is null');
                    System.debug(logginglevel.error,'@asha account ' + a);
                }                        
            }
            
            newaccts.addall(mapaccountToUpdate.values());                    
            list<Database.SaveResult> accountUpdateResults = Database.update(newaccts,false);
                
            // upsert opportunities    
            Handler_Account.BYPASS = false;
            Handler_Lead.BYPASS = false;
            if (this.configuration.bypassOpportunityLogic == false) {
                Handler_Lead.BYPASS = true; 
                Handler_Account.BYPASS = true;

                list<Database.UpsertResult> oppUpsertResults = Database.upsert(opportunityMap.values(),false);
                Handler_Account.BYPASS = false;
                Handler_Lead.BYPASS = false;   
                for (Database.UpsertResult result : oppUpsertResults) {
                    if (!result.isSuccess() || !result.isCreated()) {
                        for (Database.Error error : result.getErrors()) {
                            logger.log(error.getMessage());
                        }
                    }
                }
                    
                for (Opportunity opp : opportunityMap.values()) {
                    this.opportunityIds.add(opp.id);
                }
            }
            
            
            // upsert webinar attendances
            Handler_Lead.BYPASS = true;
            Handler_Account.BYPASS = true;
            List<Webinar_Attendance__c> newwebattnd = new List<Webinar_Attendance__c>();
            Map<id,Webinar_Attendance__c> mapWAToUpdate = new Map<id,Webinar_Attendance__c>();
            for (Webinar_Attendance__c a : webinarAttendanceToUpsert.values()) {
                if (a.id != null) {
                    mapWAToUpdate.put(a.id, a);
                    System.debug(logginglevel.error, '@asha: Web Attnd value '+ a);
                }
                else {
                    newwebattnd.add(a);
                    System.debug('Web Attnd id IS null '+ a);
                }
            }
           
            newwebattnd.addall(mapWAToUpdate.values());
            System.debug(logginglevel.error, '@asha: Web Attnd size'+ newwebattnd.size());
            list<Database.UpsertResult> webinarAttendanceResults = Database.upsert(newwebattnd,false);
            
            Handler_Account.BYPASS = false;
            Handler_Lead.BYPASS = false;
            Handler_Account.BYPASSMERGE = false;
            for (Database.UpsertResult result : webinarAttendanceResults) {
                if (!result.isSuccess() || !result.isCreated()) {
                    for (Database.Error error : result.getErrors()) {
                        logger.log(error.getMessage());
                    }
                }
            }
                
            for (Webinar_Attendance__c webinarAttendance : webinarAttendanceToUpsert.values()) {
                this.webinarAttendanceIds.add(webinarAttendance.Id);
            }
                
            logger.emailDebugResults(new list<String>{'sfdev@markettraders.com',UserInfo.getUserEmail()});
            System.debug('@asha: Batch_FrontEndPreProcess ending batch'); 
            Handler_Account.BYPASSPROCESSOR = false;
        } // end MAIN for loop (on Attachments) 
     /*   }catch(Exception ex) {
            system.debug(ex);
            Logger logger = new Logger('CRITICAL ERROR: Front End Processor Batch');
            logger.log(ex.getMessage());
            logger.log(ex.getStackTraceString());
            logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});
        } */
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
    global void finish(Database.BatchableContext BC) {
        try {
            if (this.configuration.bypassOpportunityLogic == false) {
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
            String loggername = (this.webinar.Platform__c == 'ReadyTalk') ? 'ReadyTalk-' : '';
            loggername =+ String.isblank(this.configuration.webinarstamptype)? 'Front End' :this.configuration.webinarstamptype;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> emailstrs = new List<String>();
            List<LoggerEmailRecipients__c> emaillist = LoggerEmailRecipients__c.getAll().values();
            
            for (LoggerEmailRecipients__c e : emaillist) {
                if (e.Processors__c) {
                    emailstrs.add(e.Users_Email__c);    
                }
            }            
            
            String[] toAddresses = new String[] {'sfdev@markettraders.com',UserInfo.getUserEmail(),'processor-utp@markettraders.com'}; 
            toAddresses.addAll(emailstrs);
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('dev@markettraders.com');
            mail.setSenderDisplayName(loggername +' Processor');
            mail.setSubject(loggername+' Processor Completed ' + String.valueOf(DateTime.now()));
            String body = 'View the results <a href="https://login.salesforce.com/' + log.Id + '">here</a>';
            mail.setHtmlBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        }
        catch(Exception ex) {
            system.debug(ex);
            String loggername = (this.webinar.Platform__c == 'ReadyTalk') ? 'ReadyTalk-' : '';
            loggername =+ String.isblank(this.configuration.webinarstamptype)? 'Front End' :this.configuration.webinarstamptype;
            Logger logger = new Logger('CRITICAL ERROR: '+loggername+' Processor Batch');
            logger.log(ex.getMessage());
            logger.log(ex.getStackTraceString());
            logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});
        }
    }
}