global without sharing class SprintNotificationApexBatch implements Database.Batchable<sObject>, 
    Database.Stateful, Database.AllowsCallouts
{

    global List<Sprint_Burndown__c> sprintBurndownErrorList {get; private set;}
    global List<Sprint_Burndown__c> sprintBurndownList {get; private set;}
    global Map<Id,Id> sprintMapId { get; private set; }
    
    global SprintNotificationApexBatch()
    {
        this.sprintBurndownErrorList = new List<Sprint_Burndown__c>();
        this.sprintBurndownList = new List<Sprint_Burndown__c>();
        this.sprintMapId = new Map<Id,Id>();
    }    
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        string query = '';
        /*
        string query = 'select Name, Active__c, LastModifiedDate, Activity_Date__c, Product_Master_Email__c, Scrum_Master_Email__c, '+
                        'Sprint__c, Total_Hours__c, Total_Remaining_Hours__c, kavayah__Sprint__r.CreatedById '+
                        'from Sprint_Burndown__c ' +
                        'where Active__c = true ' +
                        'and Total_Remaining_Hours__c = null ' +
                        'order by Scrum_Master_Email__c, Sprint__c ';
                        
        System.debug('~~~~~~~~~~~~~ Scrum Batch Query : ' + query);                        
		*/
        return Database.getQueryLocator(query); 
    }//end of start
    
    global void execute(Database.BatchableContext BC, List<Sprint_Burndown__c> objectBatch)
    {
        //Sprint_Burndown__c sprintBurndown = (Sprint_Burndown__c) objectBatch[0];
        //List<Sprint_Burndown__c> sprintBurndown = (Sprint_Burndown__c) objectBatch[0];
        try{
            System.debug('~~~~~~~~~~ List Size : ' + objectBatch.size());
            for(Sprint_Burndown__c sb : objectBatch){
                this.sprintBurndownList.add(sb);
            }
            
        }catch(Exception e){
            System.debug('~~~~~~~~ Error adding sprint burndown : ' + e);
        }
    }//end of execute
    
    global void finish(Database.BatchableContext BC)
    {
    
        try{
        
            integer counter = 0;
            if(this.sprintBurndownList.size() > 0){
                String body = '';
                String sprintBurndownId = '';
                Map<String, String> sprintNotificationEmail = new Map<String, String>();
                Map<String, String> sprintEmailContent = new Map<String, String>();
                Set<String> scrumEmailAddr = new Set<String>();
                String sprintName = '';
                
                for(Sprint_Burndown__c sb : this.sprintBurndownList){
                    System.debug('~~~~~~~ Sprint Apex Job : Activity Date : ' + sb.Activity_Date__c );
                    System.debug('~~~~~~~ Sprint Apex Job : Date now : ' + DateTime.Now());
                    integer NoOfDays = Integer.valueOf(((DateTime.Now().getTime()) - (sb.Activity_Date__c.getTime()))/(1000*60*60*24));
                    System.debug('~~~~~~~~ No of days passed : ' + NoOfDays);
                    //if(sb.LastModifiedDate < sb.Activity_Date__c){
                    if(NoOfDays > 0){
                        System.debug('~~~~~~~~~ Sprint to be emailed : ' + sb.Sprint__c);
                        if(!sprintNotificationEmail.containsKey(sb.Sprint__c)){

                            //set the unique map ids for activity generation
                            sprintMapId.put(sb.Sprint__c, sb.Sprint__r.CreatedById);
                            
                            sprintBurndownId = sb.Sprint__c;
                            System.debug('~~~~~~~~~~~~~ Apex Batch : Sprint Id : ' + sprintBurndownId);
                            sprintNotificationEmail.put(sprintBurndownId, sb.Scrum_Master_Email__c);
                            //check if the email address is changing, then reset the content of the email.
                            if(!scrumEmailAddr.contains(sb.Scrum_Master_Email__c)){
                                body = URL.getSalesforceBaseUrl().toExternalForm() + '/' + sb.Sprint__c + '\r\n';                                
                            }else{
                                body += URL.getSalesforceBaseUrl().toExternalForm() + '/' + sb.Sprint__c + '\r\n';   
                            }
                            //store unique email addresses
                            scrumEmailAddr.add(sb.Scrum_Master_Email__c);
                            //create a map of unique email address and combine all sprint notification for
                            //one email address.
                            if(!sprintEmailContent.containsKey(sb.Scrum_Master_Email__c)){
                                sprintEmailContent.put(sb.Scrum_Master_Email__c, body);
                                System.debug('~~~~~~~~~~ Email body 1 - ' + body);                                
                            }else{
                                sprintEmailContent.remove(sb.Scrum_Master_Email__c);
                                sprintEmailContent.put(sb.Scrum_Master_Email__c, body);
                                System.debug('~~~~~~~~~~ Email body 2 - ' + body);
                            }
                        }
                    }            
                }//end of for loop
                
                //at this point only one record will exist in the map

                //send email
                for(String s : scrumEmailAddr){
                    String emailBody = 'Remaining hours of the following sprints have not been updated.' + '\r\n';
                    emailBody = 'For accuracy of sprint burndown chart, it is important remaining hours is updated end of each work day.' + '\r\n';
                    SendEmailToScrumMaster('Sprint Backlog: Remaining hours not updated', emailBody + sprintEmailContent.get(s), s);
                    System.debug('~~~~~~~~~~ Sent email to : ' + s);                        
                }
                
                
                //create recurring activity
                for (Id d : sprintMapId.keyset()){
                        //create a task for the Agile project
                        Task t = new Task();
                        t.OwnerId = sprintMapId.get(d);
                        t.Status = 'Not Started';
                        t.Subject = 'Other';
                        //t.ActivityDate = Date.today();
                        t.WhatId = d;
                        t.Priority = 'Normal';
                        t.Description = 'Please update estimated hours of the sprint backlog item, it is past due.';
                        t.isRecurrence = true;
                        t.RecurrenceInterval = 1;
                        t.RecurrenceDayOfWeekMask = 2;
                        t.RecurrenceType = 'RecursWeekly';
                        t.RecurrenceStartDateOnly = Date.Today();
                        t.RecurrenceEndDateOnly = (Date.Today() + 1);
                        t.IsReminderSet = true;
                        t.ReminderDateTime = Date.today();
                        
                        insert t;
                        System.debug('~~~~~~~~~ Sprint Backlog Update : Task Id - ' + t.id);                     
                }
                
                //clear all the maps and sets
                sprintNotificationEmail.clear();
                sprintEmailContent.clear();
                scrumEmailAddr.clear();

            }        
            System.debug('~~~~~ Total # of email records ' + counter);
        }catch(Exception e){
            System.debug('~~~~~~~~~~ SprintNotificationApexBatch - FINISH - Exception : ' + e);
        }
    
        System.debug('~~~~~~~~~~ Method: FINISH - Sprint burndown List Size : ' + this.sprintBurndownList.size());

        
    }//end of finish
    
    //utility methods
    private static boolean CheckEmailCapacity(){
        if(System.Limits.getLimitEmailInvocations() - System.Limits.getEmailInvocations() > 0){
            System.debug('~~~~~~~~~ Email limit : true' );
            return true;        
        }else{
            System.debug('~~~~~~~~~ Email limit : false' );        
            return false;
        }
    }//end of CheckEmailCapacity
    
    private static void SendEmailToScrumMaster(String subject, String body, String email){
        try{
            if(CheckEmailCapacity()){
                System.debug('~~~~~~~~~ Subject : ' + subject);
                System.debug('~~~~~~~~~ body : ' + body);
                System.debug('~~~~~~~~~ To Address : ' + email);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {email}; 
        
                mail.setToAddresses(toAddresses);
                mail.setReplyTo(email);
            
                mail.setSenderDisplayName('Agile project setup support');
                mail.setSubject(subject);
                mail.setUseSignature(false);
                mail.setPlainTextBody(body);
                mail.setHtmlBody(body);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
                System.debug('~~~~~~~~~~ Success sending email to ' + email);                
            }
        }catch(Exception e){
            System.debug('~~~~~~~~~~ Error sending email : ' + e);
        }
    }

}