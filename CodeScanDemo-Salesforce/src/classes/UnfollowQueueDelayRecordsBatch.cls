global with sharing class UnfollowQueueDelayRecordsBatch implements Database.Batchable<sObject>{
//This class gets the record ID's that meet delay rule criteria, and inserts them into UnfollowQueue__c

   //Sample query to help you see an example criteria.  This query is defined in the button controller
   global String sObjectQuery ='Select Id FROM Case WHERE Stage = \'Closed\'' ;
   
   //Sample object to help you see how the code flows.  This is defined in the button controller
   global String objectName='Case'; 

   //Tracks the # rules used - this is defined in the button controller.
   global List<UnfollowRule__c> delayRules=new List<UnfollowRule__c>();

   global Boolean evalateEachRecordForDaysDelay;

   global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('the query syntax is:'+sObjectQuery);

        return Database.getQueryLocator(sObjectQuery);
   }

   global void execute(Database.BatchableContext BC, List<sObject> scope){
//        system.debug('Going into the for loop');
        List<UnfollowQueue__c> queuedRecords=new List<UnfollowQueue__c>();
        UnfollowQueue__c queuedRecord=new UnfollowQueue__c();
        
        Integer daysDelay=0;
        if(evalateEachRecordForDaysDelay==FALSE){
            daysDelay=delayRules[0].daysDelay__c.intValue();
        }//if 2
        
        //loop through every record in the list
        for(sObject s : scope){
            //Loop through all of the rules
            for (UnfollowRule__c delayRule:delayRules){             
                //grab the daysDelay of the rule this record matches criteria for
                if (evaluateCriteria(delayRule.Value__c, 
                                         delayRule.Operator__c,
                                         String.ValueOf(s.get(delayRule.FieldName__c)),
                                         delayRule.fieldType__c)){

                    daysDelay=delayRule.daysDelay__c.intValue();
//                    break;//I commented this out as ironically, in the worst case, this adds a script statement to the limit so I have to sacrifice speed on the 90% use case for worst case
                }//if 3
            }//for 1

            //this is unreadable to make sure it complies with script statement limits if there are a lot fo rules (over 100).  Less readable = less statements counted by governor limits
            //It also handles the case where the batch queue is slow and fires later than intended (around midnight).
            queuedRecords.add(new UnfollowQueue__c (recordId__c=s.Id, CriteriaMetDate__c=dateTime.now().addHours(-11).date(), daysDelay__c=daysDelay));
        }//for
        
        //Now remove the dupes
        Set<string> qrIds=new Set<string>();
        for(UnfollowQueue__c qr:queuedRecords){
            qrIds.add(qr.recordId__c);
        }//for 1    
        
        List<UnfollowQueue__c> dupes=[SELECT Id, recordId__c FROM UnfollowQueue__c WHERE recordId__c IN: qrIds];
        Set<string> dupeIds=new Set<string>();
        for(UnfollowQueue__c dupe:dupes){
            dupeIds.add(dupe.recordId__c);
        }//for 1

        //remove the dupe from the list to be inserted
        List<UnfollowQueue__c> queuedRecordsMinusDupes=new List<UnfollowQueue__c>();
        for (UnfollowQueue__c qr:queuedRecords){
            if(dupeIds.contains(qr.recordId__c)==FALSE){
                queuedRecordsMinusDupes.add(qr);
            }//if 1
        }//for 1
//        system.debug('the number of records to add without dupes is: '+queuedRecordsMinusDupes.size());
//        Set<String> screwupIds=new Set<String>();
//        for(UnfollowQueue__c qr2:queuedRecordsMinusDupes){
//            screwupIds.add(qr2.recordId__c);
//        }
//        List<UnfollowQueue__c> screwUps=[SELECT Id, RecordId__c FROM UnfollowQueue__c WHERE RecordId__c IN:   screwupIds];
//        system.debug('screw up size'+screwups.size());  
        //This is the method that unfollows all people from the records 
        try{
            insert queuedRecordsMinusDupes;
//            system.debug(queuedRecords.size()+' have been added to the unfollow queue.');
        } catch (Exception e) {
//            system.debug('The following error occurred when trying to add records to the unfollow queue: '+e);
        }//try
    }//execute

    public static Boolean evaluateCriteria(String ruleFieldValue, String operator, String recordFieldValue, String ruleFieldType){
        //This evaluates the rule criteria in the minimum # script statments possible (~5)          
        Boolean metCriteria=false;
            if (operator=='equals TODAY'){//if 1
                if (recordFieldValue!=null && ruleFieldType=='DATE'){
                    metCriteria=Date.today().isSameDay(Date.newInstance(Integer.valueOf(recordFieldValue.substring(0,4)),Integer.valueOf(recordFieldValue.substring(5,7)), Integer.valueOf(recordFieldValue.substring(8,10))));
                }else if(ruleFieldType=='DATETIME'){
//                    metCriteria=Date.today().isSameDay(dateTime.parse(recordFieldValue).date());
                    metCriteria=Date.today().isSameDay(Date.newInstance(Integer.valueOf(recordFieldValue.substring(0,4)),Integer.valueOf(recordFieldValue.substring(5,7)), Integer.valueOf(recordFieldValue.substring(8,10))));
                }
            }else if (operator=='equals'){//if 1
                if (recordFieldValue!=null&&(ruleFieldType=='STRING' || ruleFieldType=='ComboBox'  ||ruleFieldType=='Picklist' ||ruleFieldType=='email'||ruleFieldType=='encryptedString'||ruleFieldType=='Phone'||ruleFieldType=='url')){
                        metCriteria=(ruleFieldValue.equalsIgnoreCase(recordFieldValue));
                } else if (ruleFieldType=='BOOLEAN'){//if 2
                        metCriteria=(recordFieldValue.toLowerCase()==ruleFieldValue.toLowerCase());
                } else if (recordFieldValue!=null&&(ruleFieldType=='Double'||ruleFieldType=='Currency'||ruleFieldType=='Percent' ||ruleFieldType=='Integer' )){
                        metCriteria=(decimal.valueOf(recordFieldValue)==decimal.valueOf(ruleFieldValue));
                }//if 2                
            }else if (operator=='not equal to'){//if 1
                if (ruleFieldType=='BOOLEAN'){//if 2
                        metCriteria=!(ruleFieldValue.equalsIgnoreCase(recordFieldValue));
                } else if (recordFieldValue!=null&&(ruleFieldType=='Double'||ruleFieldType=='Currency'||ruleFieldType=='Percent' ||ruleFieldType=='Integer' )){
                        metCriteria=(decimal.valueOf(recordFieldValue)!=decimal.valueOf(ruleFieldValue));
                } else if (recordFieldValue!=null&&(ruleFieldType=='STRING' || ruleFieldType=='ComboBox'  ||ruleFieldType=='Picklist' ||ruleFieldType=='email' ||ruleFieldType=='encryptedString' ||ruleFieldType=='Phone' ||ruleFieldType=='url')){
                        metCriteria=(recordFieldValue.toLowerCase()!=ruleFieldValue.toLowerCase());
                }//if 2                
           } else if (operator=='greater than'){//if 1
                if (recordFieldValue!=null&&(ruleFieldType=='STRING' || ruleFieldType=='ComboBox'  ||ruleFieldType=='Picklist' ||ruleFieldType=='email'||ruleFieldType=='encryptedString'||ruleFieldType=='Phone'||ruleFieldType=='url')){
                        metCriteria=(recordFieldValue.toLowerCase()>ruleFieldValue.toLowerCase());
                } else if (recordFieldValue!=null&&(ruleFieldType=='Double'||ruleFieldType=='Currency'||ruleFieldType=='Percent' ||ruleFieldType=='Integer' )){
                        metCriteria=(decimal.valueOf(recordFieldValue)>decimal.valueOf(ruleFieldValue));
                }//if 2  
           } else if (operator=='less than'){//if 1
                if (recordFieldValue!=null&&(ruleFieldType=='STRING' || ruleFieldType=='ComboBox'  ||ruleFieldType=='Picklist' ||ruleFieldType=='email'||ruleFieldType=='encryptedString'||ruleFieldType=='Phone'||ruleFieldType=='url')){
                        metCriteria=(recordFieldValue.toLowerCase()<ruleFieldValue.toLowerCase());
                } else if (recordFieldValue!=null&&(ruleFieldType=='Double'||ruleFieldType=='Currency'||ruleFieldType=='Percent' ||ruleFieldType=='Integer' )){
                        metCriteria=(decimal.valueOf(recordFieldValue)<decimal.valueOf(ruleFieldValue));
                }//if 2  
           } else if (operator=='greater or equal'){//if 1
                if (recordFieldValue!=null&&(ruleFieldType=='STRING' || ruleFieldType=='ComboBox'  ||ruleFieldType=='Picklist' ||ruleFieldType=='email'||ruleFieldType=='encryptedString'||ruleFieldType=='Phone'||ruleFieldType=='url')){
                        metCriteria=(recordFieldValue.toLowerCase()>=ruleFieldValue.toLowerCase());
                } else if (recordFieldValue!=null&&(ruleFieldType=='Double'||ruleFieldType=='Currency'||ruleFieldType=='Percent' ||ruleFieldType=='Integer' )){
                        metCriteria=(decimal.valueOf(recordFieldValue)>=decimal.valueOf(ruleFieldValue));
                }//if 2  
           }else if (operator=='less or equal'){//if 1
                if (recordFieldValue!=null&&(ruleFieldType=='STRING' || ruleFieldType=='ComboBox'  ||ruleFieldType=='Picklist' ||ruleFieldType=='email'||ruleFieldType=='encryptedString'||ruleFieldType=='Phone'||ruleFieldType=='url')){
                        metCriteria=(recordFieldValue.toLowerCase()<=ruleFieldValue.toLowerCase());
                } else if (recordFieldValue!=null&&(ruleFieldType=='Double'||ruleFieldType=='Currency'||ruleFieldType=='Percent' ||ruleFieldType=='Integer' )){
                        metCriteria=(decimal.valueOf(recordFieldValue)<=decimal.valueOf(ruleFieldValue));
                }//if 2  
             }else if (operator=='contains'){//if 1
                    if(recordFieldValue!=null){//if 3;  Checks for null values to avoid null pointer exception for blank lead or cm values
                        metCriteria=recordFieldValue.toLowerCase().contains(ruleFieldValue.toLowerCase());
                    }//if 3    
             }else if (operator=='does not contain'){//if 1
                    if(recordFieldValue!=null){//if 3;  Checks for null values to avoid null pointer exception for blank lead or cm values
                            metCriteria=!recordFieldValue.toLowerCase().contains(ruleFieldValue.toLowerCase());
                    }//if 3    
             }else if (operator=='starts with'){//if 1
            //took out the DisplayType check with the assumption that the controller code only allows string types to use Starts With
                if(recordFieldValue!=null){//if 3;  Checks for null values to avoid null pointer exception for blank lead or cm values
                    metCriteria=recordFieldValue.startsWith(ruleFieldValue);
                }//if 2 
           }//if 1        
        return metCriteria;
    }//evaluateCriteria

   global void finish(Database.BatchableContext BC){
       //Send an email once done with success message
       AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
/*Emails are annoying, so commenting them out here
        //Might want to get rid of all of the below as emails could be pretty annoying for a nightly batch job.
       String emailMessage='';       

       // Send an email to the Apex job's submitter notifying of job completion. 
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {a.CreatedBy.Email};
       mail.setToAddresses(toAddresses);
       mail.setSubject('Unfollow delay queuing has completed for this object: '+objectName+'.  Status: ' + a.Status);
       if(a.NumberOfErrors >0){
           emailMessage=a.TotalJobItems + ' groups of 200 ' + objectName +' records have been queued for later unfollowing.  '+ a.NumberOfErrors + ' groups of 200 records had at least 1 error.  Errors likely result from rules with incorrect field names or impossible values.  Please confirm the criteria used in your active Unfollow Rules.  ' + delayRules.size()+ ' active Unfollow Rules were used on these records.';
       }else{
           emailMessage=a.TotalJobItems + ' groups of 200 ' + objectName + ' records have been queued for later unfollowing.  There were no errors.  ' + delayRules.size()+ ' active Unfollow Rules were used on these records.';
       }        
       mail.setPlainTextBody(emailMessage);
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
*/   
   }//finish

}//UnfollowQueueDelayRecordsBatch