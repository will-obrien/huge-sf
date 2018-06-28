global without sharing class SprintStatusUpdateApexBatch implements Database.Batchable<sObject>, 
    Database.Stateful, Database.AllowsCallouts{
        
        
        global List<Sprint__c> sprintList;
        
        global SprintStatusUpdateApexBatch(){
            sprintList = new List<Sprint__c>();
        }
        
        global Database.QueryLocator start(Database.BatchableContext BC){
            string query = '';
            /*
            String statusCompleted = 'Completed';
            String statusCancelled = 'Cancelled';            
            String query = 'select Id, Name, CreatedById, Start_Date__c, End_Date__c, Status__c ' +
                            ' from Sprint__c where Status__c NOT IN (\'' + statusCompleted + '\'' + 
                            ',\'' + statusCancelled + '\'' + ')' ; 
            */
            return Database.getQueryLocator(query);
			
        }
        
        global void execute(Database.BatchableContext BC, List<Sprint__c> objectBatch){
            try{
            
                System.debug('~~~~~~~~~ SprintStatusUpdate - objectBatch size() ' + objectBatch.size());
                for(Sprint__c s : objectBatch){
                    this.sprintList.add(s);
                }
                System.debug('~~~~~~~~~ SprintStatusUpdate - sprintList size : ' + sprintList.size());
            
            }catch(Exception e){
                System.debug('~~~~~~~~~ SprintStatusUpdate - execute : ' + e);
            }
        }
        
        global void finish(Database.BatchableContext BC){
            
            try{
                
                for(Sprint__c s : sprintList){
                    System.debug('~~~~~~~~~ Sprint End Date : ' + s.End_Date__c);
                    
                    integer NoOfDays = Integer.valueOf(((DateTime.Now().getTime()) - (s.End_Date__c.getTime()))/(1000*60*60*24));
                    
                    System.debug('~~~~~~~~~ SprintStatusUpdate : No of days - ' + NoOfDays);
                    
                    if(NoOfDays > 0){                    
                        //create a task for the Agile project
                        Task t = new Task();
                        t.OwnerId = s.CreatedById;
                        t.Status = 'Not Started';
                        t.Subject = 'Other';
                        //t.ActivityDate = Date.today();
                        t.WhatId = s.Id;
                        t.Priority = 'Normal';
                        t.Description = 'Please update Status of the sprint, it is past due.';
                        t.isRecurrence = true;
                        t.RecurrenceInterval = 1;
                        t.RecurrenceDayOfWeekMask = 2;
                        t.RecurrenceType = 'RecursWeekly';
                        t.RecurrenceStartDateOnly = Date.Today();
                        t.RecurrenceEndDateOnly = (Date.Today() + 7);
                        t.IsReminderSet = true;
                        t.ReminderDateTime = Date.today();
                        
                        insert t;
                        System.debug('~~~~~~~~~ SprintStatusUpdate : Task Id - ' + t.id);                    
                    
                    }//end if NoOfDays
                    
                }//end for loop for Sprint
            
            }catch(Exception e){
                System.debug('~~~~~~~ SprintStatusUpdate - finish : ' + e);
            }
        }
        
        

}