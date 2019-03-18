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
*   Last Modified:      12/28/2015
*   Last Modified By:   Asha Calderon
*
*   
*   
**********************************************************************************************************************/
/********************************
*
* @description: used to batch process webinar attendance records from talkpoint (webinar on demand) - see batch_frontendpreprocessor w similar architecture
*
**/
global with sharing class Batch_TalkpointProcess implements Database.Batchable<sObject>,Database.Stateful{
    
    private set<String> noTouchOppStages = new set<String>{'Pending Charge','Pending Signature','Pending Post-Signature','Closed Won','Closed Won - Recovered Bad Debt'};
    private map<String,String> monthConversionMap = new map<String,String>{'jan'=>'1','feb'=>'2','mar'=>'3','apr'=>'4','may'=>'5','jun'=>'6','jul'=>'7','aug'=>'8','sep'=>'9','oct'=>'10','nov'=>'11','dec'=>'12'};
 
    
    global set<Id> opportunityIds;
    global set<Id> webinarAttendanceIds;
    
    global final String query;
    global final Processor_Log__c log;
    global final ProcessorConfiguation configuration;
    global final Webinar__c webinar;
    

    global Batch_TalkpointProcess(Processor_Log__c log,ProcessorConfiguation configuration,Webinar__c webinar){
        this.log = log;
        this.configuration = configuration;
        this.webinar = webinar;

        this.opportunityIds = new set<Id>();
        this.webinarAttendanceIds = new set<Id>();
        
        this.query = 'SELECT id, Name, Body FROM Attachment WHERE Name = \'Processor Records\' AND ParentId = \'' + this.log.Id + '\'';
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Attachment> attachments){
        try{
         Handler_Account.BYPASSPROCESSOR = true;
            for(Attachment processorRecordsAttachment : attachments){
                String serializedProcessorRecords = processorRecordsAttachment.body.toString();
                map<String,ProcessorRecord> processorRecords = (map<String,ProcessorRecord>)JSON.deserialize(serializedProcessorRecords,map<String,ProcessorRecord>.class);
        
                map<String,Account> accountMap = new map<String,Account>();
                map<String,Opportunity> opportunityMap = new map<String,Opportunity>();
                map<String,Task> taskMap = new map<String,Task>();
                map<String,Webinar_Attendance__c> webinarAttendanceMap = ProccessorHelperMethods.getWebinarAttendanceMap(processorRecords.keySet(),this.webinar.id,this.webinar.Event_Date_Time__c);
                map<String,decimal> durationMap = new map<String,decimal>();
                
                //added aac 12.18.15 changes to opp stage
                map<String,Boolean> webattndexistmap = new map<String,Boolean>();
                /* Query accounts and leads by Email */
                set<Id> whoIds = new set<Id>();
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
        
                map<String,Lead> leadsToConvert = new map<String,Lead>();
                map<String,Webinar_Attendance__c> webinarAttendanceToUpsert = new map<String,Webinar_Attendance__c>();       
                
                for(String email : processorRecords.keySet()) {
                    
                    ProcessorRecord record = processorRecords.get(email);
                    Webinar_Attendance__c relatedWebinarAttendance = webinarAttendanceMap.get(email);
                    Account relatedAccount = accountEmailMap.get(email);
                    Lead relatedLead= leadEmailMap.get(email);
                    Date attendedDate = Date.valueOf(this.webinar.Event_Date_Time__c);
                    durationMap.put(email,record.inSessionDuration);
                    String webinarSource;
                    
                    if(relatedAccount != null){
                        accountMap.put(email,relatedAccount);
                    }else if(relatedLead != null){
                        leadsToConvert.put(email,relatedLead);
                    }else{
                        relatedLead = new Lead();
                        relatedLead.RecordTypeId = this.configuration.leadRecordTypeId;
                        relatedLead.FirstName = record.firstName;
                        relatedLead.LastName = record.lastName;
                        if(relatedLead.LastName == null){
                            relatedLead.LastName = '[not provided]';
                        }
                        relatedLead.Phone = record.phone;
                        relatedLead.Email = record.email;
                        leadsToConvert.put(email,relatedLead);
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
                    }
                    
                     /* Create or Update the related Webinar Attendance */
                    if(relatedWebinarAttendance == null){
                        this.log.Number_of_Webinar_Attendance_Created__c++;
                        boolean isAccount = relatedAccount != null ? true : false;
                        String sfid = relatedAccount != null ? relatedAccount.id : relatedLead.id;
                        relatedWebinarAttendance = new Webinar_Attendance__c();
                        if(relatedAccount != null){
                            relatedWebinarAttendance.Account__c = relatedAccount.id;
                        }
                        relatedWebinarAttendance.Attended__c = true;
                        
                        relatedWebinarAttendance.OnDemand_Attendance_Date__c = Date.valueOf(this.webinar.Event_Date_Time__c);
                        relatedWebinarAttendance.Duration__c = record.inSessionDuration;
                        relatedWebinarAttendance.OnDemand_Views__c = record.numberOfSessions;
                        relatedWebinarAttendance.Registration_Date__c = Date.valueOf(record.registrationDate);
                        relatedWebinarAttendance.Webinar__c = this.webinar.Id;
                        relatedWebinarAttendance.Source_Other__c = webinarSource;
                        webinarAttendanceToUpsert.put(email,relatedWebinarAttendance);
                    }else{
                        this.log.Number_of_Webinar_Attendance_Found__c++;
                        if(relatedAccount != null){
                            relatedWebinarAttendance.Account__c = relatedAccount.id;
                        }
                        relatedWebinarAttendance.Attended__c = true;
                        relatedWebinarAttendance.Duration__c = record.inSessionDuration;
                        relatedWebinarAttendance.OnDemand_Views__c = record.numberOfSessions;
                        webinarAttendanceToUpsert.put(email,relatedWebinarAttendance);
                    }
                    
                    relatedWebinarAttendance.Stamp_Type__c = 'OnDemand';
                    relatedWebinarAttendance.Status__c = 'Complete';
                    
                    /* Create or Update the related task */
                    if(relatedTask == null){
                        this.log.Number_of_Tasks_Created__c++;
                        relatedTask = ProccessorHelperMethods.createTask(this.webinar,whoId,this.configuration.taskActivityType,this.configuration.taskWebinarType);
                        relatedTask.Registration_Date__c = Date.today();
                    }else{
                        this.log.Number_of_Tasks_Found__c++;
                        webinarSource = relatedTask != null ? relatedTask.Webinar_Source_Other__c : null;
                    }
        
                    /* Task Details */
                    if(this.webinar != null){
                        if(this.webinar.Event_Date_Time__c != null){
                            Date webinarDate = Date.valueOf(this.webinar.Event_Date_Time__c);
                            relatedTask.Event_Date_Time__c = DateTime.newInstance(webinarDate,Time.newInstance(6, 0, 0, 0));
                        }
                        if(this.webinar.DiscountPercent__c != null)
                            relatedTask.Webinar_Discount_Offer_Percent__c = Decimal.valueOf(this.webinar.DiscountPercent__c);
                        
                        if(this.webinar.DiscountDollar__c != null)
                            relatedTask.Webinar_Discount_Offer__c = Decimal.valueOf(this.webinar.DiscountDollar__c);
                            
                        relatedTask.Webinar_Presenter__c = this.webinar.PrimaryPresenter__c;
                        relatedTask.Webinar_Presenter_secondary__c = this.webinar.SecondaryPresenter__c;
                        if(record.joinTime != null)
                            relatedTask.Join_Time__c = String.valueOf(record.joinTime);
                        relatedTask.Status = 'Scheduled';
                        relatedTask.Duration__c = relatedWebinarAttendance.Duration__c;
                        if(relatedTask.WebinarOD_Attendance_Count__c == null){
                            relatedTask.WebinarOD_Attendance_Count__c = 0;  
                        }
                        relatedTask.WebinarOD_Attendance_Count__c += record.numberOfSessions;
                        relatedTask.Attended__c = true;
                        relatedTask.Registration_Date__c = Date.valueOf(record.registrationDate);
                        taskMap.put(email,relatedTask);
                    }
        
                }
                
                /* Gurantee all leads exist in our DB before conversion */
                 System.debug('@asha: @debug: Handler_Lead bypass autoconverter'); 
                Handler_Lead.BYPASS = true; //skips autoconverter since it is at future call
                Handler_Account.BYPASS = true;
                Database.upsert(leadsToConvert.values());
                Handler_Lead.BYPASS = false;
                Handler_Account.BYPASS = false;
                
                /* Add whoId to tasks */
                for(String email : leadsToConvert.keySet()){
                    if(taskMap.get(email) != null && taskMap.get(email).WhoId == null){
                        taskMap.get(email).WhoId = leadsToConvert.get(email).id;
                    }
                }
                
                list<Database.UpsertResult> taskUpsertResults = Database.upsert(taskMap.values());
        
                /* Convert Leads, Track Failures */
                Handler_Lead.BYPASS = true; 
                 Handler_Account.BYPASS = true;
                list<Database.LeadConvert> leadconversions = new list<Database.LeadConvert>();
                LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                for(Lead lead : leadsToConvert.values()){
                    Database.LeadConvert lc = new Database.LeadConvert();
                    lc.setLeadId(lead.id);
                    lc.setConvertedStatus(convertStatus.MasterLabel);
                    lc.setDoNotCreateOpportunity(false);
                    lc.setOwnerId(this.configuration.getOpportunityOwnerId());
                    leadconversions.add(lc);
                }
                
                
                if(!leadConversions.isEmpty()){
                    list<Database.LeadConvertResult> lcr = Database.convertLead(leadconversions,false);
                    set<String> convertedLeadAccountIDs = new set<String>();
                    for(Database.LeadConvertResult result : lcr){
                        if(result.isSuccess()){
                            this.log.Number_of_Converted_Leads__c++;
                            convertedLeadAccountIDs.add(result.getAccountId());
                        }else{
                            this.log.Number_of_Failed_Converted_Leads__c++;
                            for(Database.Error error : result.getErrors()){
                            }
                        }
                    }
                 Handler_Account.BYPASS = false;
                 Handler_Lead.BYPASS = false; 
                    /* Add recently created accounts to accountMap */
                    list<Account> convertedLeadAccounts = [SELECT id,Phone,Phone_Num_Exists_date_entered__c,CreatedDate,PersonEmail,PersonContactId,FirstName,LastName,WebinarOD_UTP_Total_Duration__pc,(SELECT id,CloseDate,AccountId,Product__c,StageName,RecordTypeId,OwnerId,Account_Email__c,Country_List__c FROM Opportunities WHERE RecordTypeId = :configuration.opportunityRecordTypeId ORDER BY CreatedDate ASC) FROM Account WHERE id in :convertedLeadAccountIDs];
                    for(Account account : convertedLeadAccounts){
                        if(account.Phone != null){
                            account.Phone_Num_Exists_date_entered__c  = this.webinar.Event_Date_Time__c.Date();
                        }
                        accountMap.put(account.PersonEmail,account);
                    }
                    
                }
                
                /* Loop through accounts being processed to pull out existing opportunities or create a new one */
                list<Opportunity> oppsToCreate = new list<Opportunity>();
                map<String,Opportunity> oppMap = new map<String,Opportunity>();
                for(String email : accountMap.keySet()) {
                    Account account = accountMap.get(email);
                    if(account != null){
        
                        /* Update WebinarAttendance References */
                        Webinar_Attendance__c relatedWebinarAttendance = webinarAttendanceToUpsert.get(email);
                        if(relatedWebinarAttendance != null){
                            relatedWebinarAttendance.Lead__c = null;
                            relatedWebinarAttendance.Account__c = account.id;
                            /* Update the Phone Num Exists Date if a phone exists but that field is empty */
                            if(account.Phone != null && account.Phone_Num_Exists_date_entered__c == null){
                                account.Phone_Num_Exists_date_entered__c  = this.webinar.Event_Date_Time__c.Date();
                            }
                        }
        
                        decimal totalDuration = account.WebinarOD_UTP_Total_Duration__pc == null ? 0 : account.WebinarOD_UTP_Total_Duration__pc;
                        totalDuration += durationMap.get(email) == null ? 0 : durationMap.get(email);
                        
                        if(this.configuration.bypassOpportunityLogic == false){
                            Opportunity primaryOpportunity;
                            boolean skip = false;
                            if(account.Opportunities != null && !account.Opportunities.isEmpty()){
                            //aac 12.18.15
                            Boolean isattend = webattndexistmap.get(account.id);
                                for(Opportunity opportunity : account.Opportunities){
                                    if((this.noTouchOppStages.contains(opportunity.StageName) || isattend) && (opportunity.StageName != 'Closed Lost') ){
                                        this.log.Number_of_Untouched_Opps__c++;
                                        primaryOpportunity = null;
                                        skip = true;
                                        break;
                                    }
                                    if(primaryOpportunity == null){
                                        primaryOpportunity = opportunity;
                                    }
                                }
            
                            }
                            
                            if(skip != true && totalDuration >= 30){
                                if(primaryOpportunity != null){
                                    primaryOpportunity.StageName = (primaryOpportunity.StageName == 'Closed Lost')? 'Re-Attendee' : this.configuration.opportunityStageName;
                                   //aac 12.28.15 updated for opp stage value changes - no longer change sub stage
                                    //primaryOpportunity.Sub_Stage__c = this.configuration.opportunitySubStage;
                                    primaryOpportunity.Payment_Plan__c = this.configuration.paymentPlan;
                                    if(primaryOpportunity.CloseDate >= Date.today()){
                                        primaryOpportunity.CloseDate = this.configuration.opportunityCloseDate;
                                    }
                                    if(primaryOpportunity.CreatedDate >= DateTime.now().addMinutes(-30)){
                                        this.log.Number_of_New_Opps__c++;
                                        this.log.Number_of_New_Deals__c++;
                                    }else{
                                        this.log.Number_of_Updated_Opps__c++;
                                        this.log.Number_of_New_Deals__c++;
                                    }
                                    opportunityMap.put(email,primaryOpportunity);
                                }else{
                                    this.log.Number_Of_New_Opps__c++;
                                    this.log.Number_of_New_Deals__c++;
                                    primaryOpportunity = ProccessorHelperMethods.createOpportunity(this.configuration.opportunityName,this.configuration.opportunityRecordTypeId,this.configuration.opportunityCloseDate,this.configuration.opportunityStageName,this.configuration.opportunitySubStage,this.configuration.paymentPlan,this.configuration.opportunityProduct,account.id);   
                                    primaryOpportunity.OwnerId = this.configuration.getOpportunityOwnerId();
                                    primaryOpportunity.LeadSource = account.PersonLeadSource;
                                    opportunityMap.put(email,primaryOpportunity);
                                }
                                account.OwnerId = primaryOpportunity.OwnerId;
                            }
                        }
                        
                    }
                }
                Handler_Lead.BYPASS = true; 
                Handler_Account.BYPASS = true;
                    Database.update(accountMap.values(),false);
                Handler_Account.BYPASS = false;
                Handler_Lead.BYPASS = false; 
                if(this.configuration.bypassOpportunityLogic == false){
                    Handler_Lead.BYPASS = true; 
                    Handler_Account.BYPASS = true;
                    Database.upsert(opportunityMap.values());
                    Handler_Account.BYPASS = false;
                    Handler_Lead.BYPASS = false; 
                    for(Opportunity opp : opportunityMap.values()){
                        this.opportunityIds.add(opp.id);
                    }
                }
                Handler_Lead.BYPASS = true; 
                Handler_Account.BYPASS = true;
                Database.upsert(webinarAttendanceToUpsert.values());
                Handler_Account.BYPASS = false;
                Handler_Lead.BYPASS = false; 
                for(Webinar_Attendance__c webinarAttendance : webinarAttendanceToUpsert.values()){
                    this.webinarAttendanceIds.add(webinarAttendance.Id);
                }

            }
             Handler_Account.BYPASSPROCESSOR = false;
        }catch(Exception ex){
            system.debug(ex);
            Logger logger = new Logger('CRITICAL ERROR: Talkpoint Processor Batch');
            logger.log(ex.getMessage());
            logger.log(ex.getStackTraceString());
            logger.emailDebugResults(new list<String>{'sfdev@markettraders.com'});
        }
        
    }

    global void finish(Database.BatchableContext BC){
        try{
            if(this.configuration.bypassOpportunityLogic == false){
                Attachment opportunitiesAttachment = new Attachment();
                opportunitiesAttachment.ContentType = '.json';
                opportunitiesAttachment.Description = 'This attachment contains a JSONified map of Opportunity Ids';
                opportunitiesAttachment.Name = 'Opportunities';
                opportunitiesAttachment.ParentId = this.log.id;
                opportunitiesAttachment.body = Blob.valueOf(JSON.serialize(this.opportunityIds));
                Database.insert(opportunitiesAttachment);
            }
            
            Attachment webinarAttendanceAttachment = new Attachment();
            webinarAttendanceAttachment.ContentType = '.json';
            webinarAttendanceAttachment.Description = 'This attachment contains a JSONified map of Webinar Attendance Ids';
            webinarAttendanceAttachment.Name = 'Webinar Attendance';
            webinarAttendanceAttachment.ParentId = this.log.id;
            webinarAttendanceAttachment.body = Blob.valueOf(JSON.serialize(this.webinarAttendanceIds));
            Database.insert(webinarAttendanceAttachment);
           
            Handler_Lead.BYPASS = true; 
            Handler_Account.BYPASS = true;
            Database.update(this.log);
            Handler_Account.BYPASS = false;
            Handler_Lead.BYPASS = false; 
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List<String> emailstrs = new List<String>();
            List<LoggerEmailRecipients__c> emaillist = LoggerEmailRecipients__c.getAll().values();
            For(LoggerEmailRecipients__c e : emaillist){
                if(e.Processors__c){
                    emailstrs.add(e.Users_Email__c);    
                }
            }        
            String[] toAddresses = new String[] {'sfdev@markettraders.com',UserInfo.getUserEmail(),'processor-odw@markettraders.com'}; 
            toAddresses.addAll(emailstrs);
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('dev@markettraders.com');
            mail.setSenderDisplayName('Talkpoint Processor');
            mail.setSubject('Talkpoint Processor Completed ' + String.valueOf(DateTime.now()));
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