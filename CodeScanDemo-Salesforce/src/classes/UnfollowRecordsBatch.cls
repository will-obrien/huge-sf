global  with sharing class UnfollowRecordsBatch implements Database.Batchable<sObject>{

   //Sample query to help you see an example criteria.  This query is defined in the button controller
   global String sObjectQuery ='Select Id, ParentId FROM EntitySubscription WHERE parentId IN [SELECT Id from Case WHERE Stage = \'Closed\']' ;
   
   //Sample object to help you see how the code flows.  This is defined in the button controller
   global String objectName='Case'; 

   //Tracks the # rules used - this is defined in the button controller.
   global Integer numRulesUsedInThisObject=0; 

   global Boolean sendEmail=FALSE;

   global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(sObjectQuery);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
        Set<Id> recordIds=new Set<Id>();
  
        for(sObject s : scope){
            recordIds.add(s.Id);
        }//for
    
        try{
            UnfollowRuleJob__c job= new UnfollowRuleJob__c();
            job.NumFollows__c=scope.size();
            if(job.NumFollows__c>0){
                delete scope;
                job.Name=BC.getJobId();
//                job.NumRecords__c=recordIds.size();//Maybe not include this as it doesn't have as much value?  Would still be in the dashboard, but today the number is wrong anyhow
                job.NumRules__c=numRulesUsedInThisObject;
                job.ObjectName__c=objectName;
                insert job;
            }//only insert the job if the number of follows is greater than zero                
            
        }catch(DMLException e){
//            system.debug('Followers were not removed properly.  Error: '+e);
        }//try
/*    
        UnfollowRuleJob__c job= new UnfollowRuleJob__c();
        //This is the method that unfollows all people from the records 
        try{
            job.NumFollows__c=UnfollowRecords.UnfollowRecordsButtonAction(recordIds);
            if (job.numFollows__c>0){
                job.Name=BC.getJobId();
                job.NumRecords__c=recordIds.size();
                job.NumRules__c=numRulesUsedInThisObject;
                job.ObjectName__c=objectName;
                insert job;
            }//only insert the job if the number of follows is greater than zero
//            system.debug(recordIds.size()+' records have been stripped of all followers');
        } catch (Exception e) {
//            system.debug('The following error occurred when trying to unfollow everyone from the records impacted by the Unfollow Rules: '+e);
        }//try
*/        
   }//execute

   global void finish(Database.BatchableContext BC){
       //Send an email once done with success message
       AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
       if (sendEmail==TRUE){

           String emailMessage='';       
           // Send an email to the Apex job's submitter notifying of job completion. 
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           String[] toAddresses = new String[] {a.CreatedBy.Email};
           mail.setToAddresses(toAddresses);
           mail.setSubject('Unfollow for your rule has completed.  Status: ' + a.Status);
           if(a.NumberOfErrors >0){
               emailMessage=a.TotalJobItems + ' groups of 200 follows on ' + objectName +' have been deleted.  '+ a.NumberOfErrors + ' groups of 200 records had at least 1 error.  Errors likely result from rules with incorrect field names or impossible values.  Please confirm the criteria used in your rules.';
           }else{
               emailMessage=a.TotalJobItems + ' groups of 200 follows on ' + objectName +' have been deleted.  There were no errors.';
           }//if        
           mail.setPlainTextBody(emailMessage);
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       }//if
   }//finish

}//UnfollowRecordsBatch