global without sharing class AgileProjectStatusUpdateApexBatch implements Database.Batchable<sObject>, 
    Database.Stateful, Database.AllowsCallouts{
    
    global List<AgileProject__c> agileProjectList;
    global Map<String, String> agileProjectEmailMap;
    global Map<String, String> agileProjectSortedEmailMap;
    global List<String> emailSortedList;
    global Set<Id> teamMemberId;

    global AgileProjectStatusUpdateApexBatch()
    {
        this.agileProjectList = new List<AgileProject__c>();
        this.agileProjectEmailMap = new Map<String, String>();
        this.agileProjectSortedEmailMap = new Map<String, String>();
        this.emailSortedList = new List<String>();
        this.teamMemberId = new Set<Id>();
    }            
        
        
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String statusCompleted = 'Completed';
        String statusCancelled = 'Cancelled';
        String query = 'select Id, Name, End_Date__c, Status__c, OwnerId, Product_Owner__c, Scrum_Master__c ' +
                        'from AgileProject__c where Status__c NOT IN (\'' + statusCompleted + '\'' + 
                        ',\'' + statusCancelled + '\'' + ')';
        
        System.debug('~~~~~~~~~~ AgileProject Notification : ' + query);
        return Database.getQueryLocator(query);     
    }
        
    global void execute(Database.BatchableContext BC, List<AgileProject__c> objectBatch)
    {
    
        try{

            System.debug('~~~~~~~~AgileProjectBatch : objectBatch size : ' + objectBatch.size());
            for(AgileProject__c a : objectBatch){
                this.agileProjectList.add(a);
                this.agileProjectEmailMap.put(a.Id, a.Product_Owner__c);
                this.teamMemberId.add(a.Product_Owner__c);
                System.debug('~~~~~~~~~~ Agile Project Id : ' + a.Id + ', Product Owner Id : ' + a.Product_Owner__c);
            }
            System.debug('~~~~~~~~AgileProjectBatch : agileProjectList size' + agileProjectList.size());
            System.debug('~~~~~~~~AgileProjectBatch : agileProjectEmailMap size' + agileProjectEmailMap.size());
             
            //get all the email id of the product owner
            Map<Id, Team_Member__c> teamMemberMap = new Map<Id, Team_Member__c>([select Id, Email__c from Team_Member__c where Id IN :teamMemberId]);
            
            for(String d : agileProjectEmailMap.keySet()){
                String productOwnerId = agileProjectEmailMap.get(d);
                System.debug('~~~~~~~~ Product Owner Id : ' + productOwnerId);
                if(teamMemberMap.containsKey(productOwnerId)){
                    //update the Map from Product_Owner__c to their corresponding email id
                    agileProjectEmailMap.put(d, teamMemberMap.get(productOwnerId).Email__c);
                    System.debug('~~~~~~~~~ Product Owner Email Address : ' + agileProjectEmailMap.get(d));
                    
                    //put the key value pair in reverse in sortemMap
                     agileProjectSortedEmailMap.put(teamMemberMap.get(productOwnerId).Email__c, d);

                }
            }
            //sort the map using the list
            emailSortedList.addAll(agileProjectSortedEmailMap.keySet());
            emailSortedList.sort();
            for(String s : emailSortedList){
                System.debug('~~~~~~ Sorted list : ' + s);
                agileProjectSortedEmailMap.put(s, agileProjectSortedEmailMap.get(s));
            }
        
        }catch(Exception e){
            System.debug('~~~~~~~~~~ AgileProjectBatchNotification : Error - ' + e);
        }
    }

    global void finish(Database.BatchableContext BC)
    {
    
        //create a task and also send an email
        try{
        
            if(agileProjectList.size() > 0){
            
                for(AgileProject__c a : agileProjectList){
                    System.debug('~~~~~~~~ AgileProjectBatch : ' + a.End_Date__c);
                    //create a task if the agile project end date is past due
                    //integer NoOfDays = Integer.valueOf( Date.today().daysBetween(a.End_Date__c) );
                    integer NoOfDays = Integer.valueOf( a.End_Date__c.daysBetween(Date.today()));
                    
                    System.debug('~~~~~~~~~ AgileProjectNotification : No of days - ' + NoOfDays);
                    
                    if(NoOfDays > 0){
                        //create a task for the Agile project
                        Task t = new Task();
                        t.OwnerId = a.OwnerId;
                        t.Status = 'Not Started';
                        t.Subject = 'Other';
                        //t.ActivityDate = Date.today();
                        t.WhatId = a.Id;
                        t.Priority = 'Normal';
                        t.Description = 'Please update Status of the agile project, it is past due.';
                        t.isRecurrence = true;
                        t.RecurrenceInterval = 1;
                        t.RecurrenceDayOfWeekMask = 2;
                        t.RecurrenceType = 'RecursWeekly';
                        t.RecurrenceStartDateOnly = Date.Today();
                        t.RecurrenceEndDateOnly = (Date.Today() + 7);
                        t.IsReminderSet = true;
                        t.ReminderDateTime = Date.today();
                        
                        insert t;
                        System.debug('~~~~~~~~~ AgileProjectBatch : Task Id - ' + t.id);
                        
                        //send an email
                        //String emailBody = 'Project is past due, need to update status of the project.' + '\r\n';
                        //emailBody += URL.getSalesforceBaseUrl().toExternalForm() + '/' + a.Id + '\r\n';                           
                        //SendEmailToProductOwner('Agile project status update', emailBody, agileProjectEmailMap.get(a.id));
                        //System.debug('~~~~~~~~~~ Sent email to : ' + agileProjectEmailMap.get(a.id));                                                
                     }
                }//end for loop
            }//end if AgileProjectList
        
        }catch(Exception e){
            System.debug('~~~~~~~~~~ AgileProjectBatch : finish - ' + e);
        }
    }
    


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
        

    private static void SendEmailToProductOwner(String subject, String body, String email){
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