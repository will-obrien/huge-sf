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
*   Date Created:       2/23/2016
*   Author:             Sean Murphy
*   Last Modified:      2/23/16
*   Last Modified By:   Sean Murphy
*
*	2/23/16  sm: created class
*
**********************************************************************************************************************/

global without sharing class Batch_WebinarPostProcessing implements Database.Batchable<sObject>,Database.Stateful {
	
	private Set<String> noTouchOppStages = new Set<String>{'Pending Charge', 'Pending Signature', 'Pending Post-Signature', 'Closed Won', 'Closed Won - Recovered Bad Debt'};
    private Map<String,String> monthConversionMap = new Map<String,String>{'jan'=>'1', 'feb'=>'2', 'mar'=>'3', 'apr'=>'4', 'may'=>'5', 'jun'=>'6', 'jul'=>'7', 'aug'=>'8', 'sep'=>'9', 'oct'=>'10', 'nov'=>'11', 'dec'=>'12'};
    
    global Set<Id> webinarAttendanceIds;
    
    global final String query;
    global final Processor_Log__c log;
    global final ProcessorConfiguation configuration;
    global final Webinar__c webinar;

    /**************************************
    *
    *	@description:
    *	constructor 
    *  
    *	@params: 
    *		log - object record where processor record attachments were stored when parsed earlier in processor
    *		configuration - configuration of the processor being run 
    *		webinar - webinar that was processed  
    *
    **/
    global Batch_WebinarPostProcessing(Processor_Log__c log, ProcessorConfiguation configuration, Webinar__c webinar) {
        this.log = log;
        this.configuration = configuration;
        this.webinar = webinar;

        this.webinarAttendanceIds = new Set<Id>();
                
        this.query = 'SELECT id, Name, Body FROM Attachment WHERE Name = \'Processor Records\' AND ParentId = \'' + this.log.Id + '\'';
    }

    /**************************************
    *
    *	@method start
    *
    *	@description
    *		required method for batch processes; uses query locator
    *  
    *	@params
    *		BC - batchable context 
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
        Handler_Account.BYPASSPROCESSOR = true;
        System.debug(Logginglevel.ERROR, '@@@@ Batch_WebinarPostProcessing : starting batch');
        String loggername = '';
        loggername =+ String.isblank(this.configuration.webinarstamptype) ? 'Education' : this.configuration.webinarstamptype;
        Logger logger = new Logger(loggername  + ' Processor Batch Log');
        Map<String, Webinar_Attendance__c> orphanAttendances = ProccessorHelperMethods.getOrphanWebinarAttendanceMap(this.webinar.id);
        
        // MAIN for loop
        for (Attachment processorRecordsAttachment : attachments) {
            String serializedProcessorRecords = processorRecordsAttachment.body.toString();
            // get processor records from attachment
            Map<String, ProcessorRecord> processorRecords = (Map<String, ProcessorRecord>)JSON.deserialize(serializedProcessorRecords, Map<String, ProcessorRecord>.class);
            
            //added aac 12.18.15 changes to opp stage
            Map<String,Boolean> webattndexistmap = new Map<String,Boolean>();
            Map<String,Account> accountMap = new Map<String,Account>();
            Map<String,decimal> durationMap = new Map<String,decimal>();
            
            // query webinar attendance by email
            Map<String,Webinar_Attendance__c> webinarAttendanceMap = ProccessorHelperMethods.getWebinarAttendanceMap(processorRecords.keySet(), this.webinar.id, this.webinar.Event_Date_Time__c);
            
            // query webinar attendance orphan records
            Map<String, Webinar_Attendance__c> orphanWebinarAttendanceMap = ProccessorHelperMethods.getOrphanWebinarAttendanceMap(this.webinar.id);
            
            // query accounts by email and collect ids to be used to query tasks
            Set<Id> whoIds = new Set<Id>();
            Map<String,Account> accountEmailMap = ProccessorHelperMethods.getAccountMap(processorRecords.keySet(), this.configuration.opportunityProduct);
            
            for (Account account : accountEmailMap.values()) {
                whoIds.add(account.PersonContactId);
            }
            
            // query leads by email and collect ids to be used to query tasks
            Map<String,Lead> leadEmailMap = ProccessorHelperMethods.getLeadMap(processorRecords.keySet(), this.configuration.leadRecordTypeId);
            for (Lead lead : leadEmailMap.values()) {
                whoIds.add(lead.Id);
            }
            
            Map<String, Webinar_Attendance__c> webinarAttendanceToUpsert = new map<String,Webinar_Attendance__c>();
            
            // loop over processor records 
            // for loop A (on ProcessorRecords) ===============================================================================================================
            // ================================================================================================================================================
            for (String email : processorRecords.keySet()) {
                // get the processor record by email 
                ProcessorRecord record = processorRecords.get(email); 
                // get webinar attendance record(s) by email
                Webinar_Attendance__c relatedWebinarAttendance = webinarAttendanceMap.get(email);
                
                if (relatedWebinarAttendance == null) {
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
                // save in session duration by email  
                durationMap.put(email, record.inSessionDuration);

                String whoId;
                if ((relatedAccount != null) || (relatedLead != null)) {
                    whoId = relatedAccount != null ? relatedAccount.PersonContactId : relatedLead.id;
                }

                // if no related webinar attendance obtained, create a web att and increment created web att counter, else increment found web att counter
                for (Webinar_Attendance__c owa : orphanWebinarAttendanceMap.values()) {
                	if ((owa.Orphan_Attendance_Info__c != null) && (owa.Orphan_Attendance_Info__c.contains(email))) {
                		relatedWebinarAttendance = owa;
                		break;
                	}
                }
                
                // if no related webinar attendance found
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
                relatedWebinarAttendance.Stamp_Type__c = String.isblank(this.configuration.webinarstamptype) ? 'CE Classes' : this.configuration.webinarstamptype;
                relatedWebinarAttendance.Join_Time__c = record.joinTime;
                relatedWebinarAttendance.Leave_Time__c = record.leaveTime;
                
                relatedWebinarAttendance.Account__c = relatedAccount == null ? null : relatedAccount.id;
                relatedWebinarAttendance.Lead__c = relatedLead == null ? null : relatedLead.id;
                
                if ((relatedWebinarAttendance.Account__c == null) && (relatedWebinarAttendance.Lead__c == null)) {
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
                webinarAttendanceToUpsert.put(email, relatedWebinarAttendance);
            } 
            // end for loop A (on ProcessorRecords) ===========================================================================================================
            // ================================================================================================================================================
            
            /******************************************************************************************************
            	at this point, the account map only contains existing accounts (i.e., those already in SF that matched by email)
                so now we are going to add the accounts that were just created during lead conversion
            ******************************************************************************************************/
            
            System.debug('@@@@ AccountMap Size : ' + accountMap.size());              
            // Loop through accounts being processed to pull out existing opportunities or create a new one
            
            // for loop B (on Accounts) =======================================================================================================================
            //=================================================================================================================================================
//MSM            for (String email : accountMap.keySet()) {
//MSM                Account account = accountMap.get(email);
//MSM                Webinar_Attendance__c relatedWebinarAttendance = webinarAttendanceToUpsert.get(email);
//MSM            } // end for loop B (on Accounts)
                
            // upsert webinar attendances
            Handler_Lead.BYPASS = true;
            Handler_Account.BYPASS = true;
            
            List<Webinar_Attendance__c> newWebAttnd = new List<Webinar_Attendance__c>();
            Map<id,Webinar_Attendance__c> mapWAToUpdate = new Map<id, Webinar_Attendance__c>();
            
            for (Webinar_Attendance__c a : webinarAttendanceToUpsert.values()) {
                if (a.id != null) {
                    mapWAToUpdate.put(a.id, a);
                    System.debug(logginglevel.error, '@@@@: Web Attnd value ' + a);
                }
                else {
                    newWebAttnd.add(a);
                    System.debug('Web Attnd id IS null ' + a);
                }
            }
           
            newWebAttnd.addAll(mapWAToUpdate.values());
            System.debug(logginglevel.error, '@@@@: newWebAttnd size: ' + newWebAttnd.size());
            List<Database.UpsertResult> webinarAttendanceResults = Database.upsert(newWebAttnd, false);
            
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
                
            logger.emailDebugResults(new List<String>{'sfdev@markettraders.com', UserInfo.getUserEmail()});
            System.debug('@@@@: Batch_WebinarPostProcessing ending batch'); 
            Handler_Account.BYPASSPROCESSOR = false;
        } // end MAIN for loop (on Attachments) 
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
            Attachment webinarAttendanceAttachment = new Attachment();
            webinarAttendanceAttachment.ContentType = '.json';
            webinarAttendanceAttachment.Description = 'This attachment contains a JSONified map of Webinar Attendance Ids';
            webinarAttendanceAttachment.Name = 'Webinar Attendance';
            webinarAttendanceAttachment.ParentId = this.log.id;
            webinarAttendanceAttachment.body = Blob.valueOf(JSON.serialize(this.webinarAttendanceIds));
            Database.insert(webinarAttendanceAttachment,false);
            
            Database.update(this.log, false);
            String loggerName = '';
            loggerName =+ String.isblank(this.configuration.webinarstamptype) ? 'Education' : this.configuration.webinarstamptype;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
/*MSM            List<String> emailStrings = new List<String>();
            List<LoggerEmailRecipients__c> emailList = LoggerEmailRecipients__c.getAll().values();
            
            for (LoggerEmailRecipients__c e : emailList) {
                if (e.Processors__c) {
                    emailStrings.add(e.Users_Email__c);    
                }
            }*/            
            
            String[] toAddresses = new String[] {'sfdev@markettraders.com', UserInfo.getUserEmail()}; 
//MSM            toAddresses.addAll(emailStrings);
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('sfdev@markettraders.com');
            mail.setSenderDisplayName(loggername + ' Processor');
            mail.setSubject(loggername+' Processor Completed ' + String.valueOf(DateTime.now()));
            String body = 'View the results <a href="https://login.salesforce.com/' + log.Id + '">here</a>';
            mail.setHtmlBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        }
        catch (Exception ex) {
            System.debug(ex);
            String loggerName = '';
            loggerName =+ String.isBlank(this.configuration.webinarstamptype) ? 'Education' : this.configuration.webinarstamptype;
            Logger logger = new Logger('CRITICAL ERROR: ' + loggerName +' Processor Batch');
            logger.log(ex.getMessage());
            logger.log(ex.getStackTraceString());
            logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});
        }
    }
}