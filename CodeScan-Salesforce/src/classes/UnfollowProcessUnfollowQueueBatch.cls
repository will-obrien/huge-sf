global with sharing class UnfollowProcessUnfollowQueueBatch implements Database.Batchable<sObject>{

   //note I'm using "less or equal to today" as if it's less, than the batch apex queue was backed up and missed a day
   global String sObjectQuery ='Select Id, recordId__c, objectName__c FROM chttrunfollow__UnfollowQueue__c WHERE scheduledUnfollowDate__c<= TODAY' ;
   
   global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(sObjectQuery);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
        Set<Id> recordIds=new Set<Id>();

        for(sObject s : scope){
            recordIds.add(String.ValueOf(s.get('recordId__c')));
        }//for
    
        UnfollowRuleJob__c job= new UnfollowRuleJob__c();
        //This is the method that unfollows all people from the records 
        try{
            job.NumFollows__c=UnfollowRecords.UnfollowRecordsButtonAction(recordIds);
            if (job.numFollows__c>0){
                job.NumRecords__c=recordIds.size();//No longer needed and doesn't add much value anyhow
                delete scope;//doing this first as it's more important in the case where the insert job fails below.
                job.DelayRuleJob__c=TRUE;
                job.Name=BC.getJobId();
                job.NumRules__c=0;//unknown as that data isn't saved in each record
                job.ObjectName__c='';//unknown unless we do a complex prefix check for every record id, refactor the deletion, and create multiple batch jobs - one for each object type.  Not worth it solely for reporting on objectname.
                insert job;
             }//only insert the job if there is at least 1 follow removed.
        } catch (Exception e) {
//            system.debug('The following error occurred when trying to unfollow everyone from the delayed records: '+e);
        }//try
   }

   global void finish(Database.BatchableContext BC){
       AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];

/*  Left this in just in case people want an email every day when this fires.  Personally I think the emails are annoying.       
       String emailMessage='';       

       // Send an email to the Apex job's submitter notifying of job completion. 
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {a.CreatedBy.Email};
       mail.setToAddresses(toAddresses);
       mail.setSubject('Unfollow has completed for all selected records: ' + a.Status);
       if(a.NumberOfErrors >0){
           emailMessage=a.TotalJobItems + ' groups of 200 ' + objectName +' records have been stripped of all followers.  '+ a.NumberOfErrors + ' groups of 200 records had at least 1 error.  Errors likely result from rules with incorrect field names or impossible values.  Please confirm the criteria used in your active Unfollow Rules.  ' + numRulesUsedInThisObject + ' active Unfollow Rules were used on these records.';
       }else{
           emailMessage=a.TotalJobItems + ' groups of 200 ' + objectName + ' records have been stripped of all followers.  There were no errors.  ' + numRulesUsedInThisObject + ' active Unfollow Rules were used on these records.';
       }        
       mail.setPlainTextBody(emailMessage);
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
*/   
   }

}//UnfollowRecordsFromDelayQueueBatch