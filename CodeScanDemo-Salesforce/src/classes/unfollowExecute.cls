global with sharing class unfollowExecute{

	public static Integer numBatchJobsQueued(){
		List<AsyncApexJob> queuedBatchJobs=[SELECT Id, Status FROM AsyncApexJob WHERE JobType = 'BatchApex' AND ( Status = 'Queued' OR Status = 'Processing')];
		return queuedBatchJobs.size();
	}

    public static void unfollowQueueBatchJobs(Boolean runFromButton){
        List<String> objectNames=new List<String>();
        Integer numBatchApexJobsLimit=5;//at time of coding, there are at most 5 concurrent batch apex jobs in any org
        
        //This is the number of jobs that can be queued up by this method
        Integer numJobsAvailable=numBatchApexJobsLimit - numBatchJobsQueued();
        Map<String,List<UnfollowRule__c>> objectRulesMap=new Map<String,List<UnfollowRule__c>>();
        Map<String,List<UnfollowRule__c>> objectDelayRulesMap=new Map<String,List<UnfollowRule__c>>();
        Boolean delayQuery=FALSE;
        String query='';
        Map<String,Set<Integer>> objectDelayDaysMap=new Map<String, Set<Integer>>();
                        
        //This will store the job definition for the jobs over the numBatchApexJobsLimit to be run later
        List<UnfollowBatchJobsQueue__c> batchJobsQueued=new List<UnfollowBatchJobsQueue__c>();

        List<UnfollowRule__c> activeNonDelayedRules=[Select Id, ObjectName__c, Active__c, FieldName__c, FieldType__c, Operator__c, Value__c, DaysDelay__c FROM UnfollowRule__c WHERE (DaysDelay__c<1 OR DaysDelay__c=null) AND Active__c = TRUE];
        
        //now count the # rules for each object to pass into the email later
        For (UnfollowRule__c rule:activeNonDelayedRules){
            List<UnfollowRule__c> rules=new List<UnfollowRule__c>();
            if(objectRulesMap.containsKey(rule.ObjectName__c)){
                //get the existing rules in the map & add the new one
                rules=objectRulesMap.get(rule.ObjectName__c);
                rules.add(rule);
                objectRulesMap.remove(rule.ObjectName__c);
                objectRulesMap.put(rule.ObjectName__c, rules);
            } else {
                rules.add(rule);
                objectRulesMap.put(rule.ObjectName__c,rules);
            }//if 1
        }//for 1

        //Now queue up all the batch jobs
        for (String objectName:objectRulesMap.keyset()){
            //First check if there's a slot available - max of 5 concurrent jobs across all apps
            delayQuery=FALSE;            
            query=buildQuery(objectName, objectRulesMap.get(objectName), delayQuery);
            if(numJobsAvailable>0){
                numJobsAvailable--;//subtract one from the limit
                UnfollowRecordsBatch  unfollowRecords= new UnfollowRecordsBatch();
                unfollowRecords.ObjectName=objectName;
    
                unfollowRecords.numRulesUsedInThisObject=objectRulesMap.get(objectName).size();
                unfollowRecords.sObjectQuery =  query;
//                system.debug('The sObjectQuery string is: '+unfollowRecords.sObjectQuery);
                
                Id unfollowRulesProcessId = Database.executeBatch(unfollowRecords, 200); 
            }else{
                String sObjectQuery = query;
//                system.debug('There are 5 batch jobs already running, so this job is not scheduled.  Delay Job: TRUE, Object: '+objectName+', # Rules: '+objectRulesMap.get(objectName).size()+', Query: '+sObjectQuery );
                UnfollowBatchJobsQueue__c job=new UnfollowBatchJobsQueue__c(delayJob__c=FALSE, delayRulesIncluded__c=FALSE, objectName__c=objectName, numRulesUsedInThisObject__c=objectRulesMap.get(objectName).size(), sObjectQuery__c=sObjectQuery);
                batchJobsQueued.add(job);
            }//if 1
        }//for 1
        try{
            if(batchJobsQueued.size()>0){
                insert batchJobsQueued;
            }//if 1
        }catch (DMLException e){
//            system.debug('The batch jobs were not added to the queue successfully, likely due to dupe object name.  Error: '+e);
        }//try

        //Now add all the delayed records in the custom object UnfollowQueue__c
        if (runFromButton==FALSE){
            List<UnfollowRule__c> activeDelayRules=[Select Id, ObjectName__c, Active__c, FieldName__c, FieldType__c, Operator__c, Value__c, DaysDelay__c FROM UnfollowRule__c WHERE DaysDelay__c>0 AND Active__c = TRUE];
            //It's going to find 3 rules - case, issue, and fedex.  Closed, Closed, Delivered = TRUE, delay = 7,7,5
            for (UnfollowRule__c delayRule:activeDelayRules){
                //loop through each of the 3 delay rules
                List<UnfollowRule__c> delayRules=new List<UnfollowRule__c>();
                if(objectDelayRulesMap.containsKey(delayRule.ObjectName__c)){
                    //get the existing rules in the map & add the new one
                    delayRules=objectDelayRulesMap.get(delayRule.ObjectName__c);
                    delayRules.add(delayRule);
                    objectDelayRulesMap.remove(delayRule.ObjectName__c);
                    objectDelayRulesMap.put(delayRule.ObjectName__c, delayRules);
                } else {
                    delayRules.add(delayRule);
                    objectDelayRulesMap.put(delayRule.ObjectName__c,delayRules);
                    
                }//if 2

                //This whole section is to determine whether there are more than 1 different values for DaysDelay
                //across all of the rules for one object.
                //If only 1 DaysDelay value, then no need to evaluate which records should be delayed how many days
                //If multiple DaysDelay values, then each record needs to be evaluated & assigned a DaysDelay
                Set<Integer> uniqueDaysDelay=new Set<Integer>();
                Integer daysDelay=delayRule.DaysDelay__c.intValue();
                
                if(objectDelayDaysMap.containsKey(delayRule.ObjectName__c)){
                //At first iteration, this map is empty.  Note it's different than DelayRulesMap - this is DelayDays
                    //get the existing Set of DaysDelay in the map & add the new one
                    if(objectDelayDaysMap.get(delayRule.ObjectName__c).contains(daysDelay)==FALSE){
                        uniqueDaysDelay=objectDelayDaysMap.get(delayRule.ObjectName__c);
                        uniqueDaysDelay.add(daysDelay);
                        objectDelayDaysMap.remove(delayRule.ObjectName__c);
                        objectDelayDaysMap.put(delayRule.ObjectName__c, uniqueDaysDelay);
                    } else {
                        uniqueDaysDelay.add(daysDelay);
                        objectDelayDaysMap.put(delayRule.ObjectName__c, uniqueDaysDelay);
                    }//if 3
                } else {
                    uniqueDaysDelay.add(daysDelay);
                    objectDelayDaysMap.put(delayRule.ObjectName__c, uniqueDaysDelay);
                }//if 2
            }//for 1
    
            //Now queue up all the batch jobs
            for (String objectName:objectDelayRulesMap.keySet()){
                //First check if there's a slot available - max of 5 concurrent jobs across all apps
                delayQuery=TRUE;//Can't directly query EntitySubscription due to the joins issue (can't join text field to ID)

                query=buildQuery(objectName, objectDelayRulesMap.get(objectName), delayQuery);

                Boolean evalateEachRecordForDaysDelay=FALSE;
                if(objectDelayDaysMap.get(objectName).size()>1){
                        evalateEachRecordForDaysDelay=TRUE;
                }//if 2 
                if(numJobsAvailable>0){
                    numJobsAvailable--;//subtract one from the limit
                    UnfollowQueueDelayRecordsBatch queueDelayRecords= new UnfollowQueueDelayRecordsBatch();
                    queueDelayRecords.ObjectName=objectName;
                    queueDelayRecords.delayRules=objectDelayRulesMap.get(objectName);
                    queueDelayRecords.sObjectQuery =  query;
                    queueDelayRecords.evalateEachRecordForDaysDelay=evalateEachRecordForDaysDelay;

//                    system.debug('The sObjectQuery string is: '+queueDelayRecords.sObjectQuery);
                    
                    Id unfollowRulesProcessId = Database.executeBatch(queueDelayRecords, 200); 
                }else{
                    String sObjectQuery = query;
//                    system.debug('There are 5 batch jobs already running, so this job is not scheduled.  Delay Job: TRUE, Object: '+objectName+', # Rules: '+objectRulesMap.get(objectName).size()+', Query: '+sObjectQuery );
                    UnfollowBatchJobsQueue__c job=new UnfollowBatchJobsQueue__c(delayJob__c=FALSE, delayRulesIncluded__c=TRUE, evalateEachRecordForDaysDelay__c=evalateEachRecordForDaysDelay, objectName__c=objectName, numRulesUsedInThisObject__c=objectDelayRulesMap.get(objectName).size(), sObjectQuery__c=sObjectQuery);
                    batchJobsQueued.add(job);
                }//if 2
            }//for 1
            try{
                if(batchJobsQueued.size()>0){
                    insert batchJobsQueued;
                }//if 1
            }catch (DMLException e){
//                system.debug('The batch jobs were not added to the queue successfully, likely due to dupe object name.  Error: '+e);
            }//try
        }//if 1
    }//unfollowQueueBatchJobs
        
    public static String buildQuery(String objectName, List<UnfollowRule__c> rules, Boolean delayQuery){
//        system.debug('objectName = '+objectName+' # Rules: '+rules.size()+'addFieldNames = '+addFieldNames);
        String sObjectQuery='SELECT Id, ParentId FROM EntitySubscription WHERE ParentId IN (';
        if(delayQuery==TRUE){
            sObjectQuery='';//reset it to NOT scope by EntitySubscripton as that join doesn't work for delay queryies given 
                            //UnfollowQueue__c.RecordId__c is a text field, and semijoins require joining to an ID field 
                            //(need polymorphic ID's here, but the platform doesn't support it)
        }//if 1
        String testQueryNameSpaceAddition='';
    
        if(objectName=='UnfollowTest__c'){        
            testQueryNameSpaceAddition='chttrunfollow__';//there's an apex bug that creates an internal salesforce error in the query locator if the namespace of a managed package isn't referenced in batch apex query strings.  This is a workaround for that issue.
        }//if//http://boards.developerforce.com/t5/Apex-Code-Development/bug-Database-getQueryLocator-requires-namespace-prefix/m-p/207792/highlight/false#M36573
        Integer ruleCount=0;
        sObjectQuery+='SELECT Id ';

        //Unfortunately, we can't filter by just records that have subscribers or records not in UnfollowQueue__c as you can't join an ID field to a text field :(
        if(delayQuery==TRUE){
            Set<String> fieldNames=new Set<String>();
            for(UnfollowRule__c rule:rules){
                //enforces adding the same fieldname only once
                if(fieldNames.contains( rule.FieldName__c)==FALSE){
                    fieldNames.add(rule.FieldName__c);
                    if(rule.FieldName__c.substring(rule.FieldName__c.length()-3)=='__c'){
                        sObjectQuery+=', '+testQueryNameSpaceAddition+rule.FieldName__c;
                    } else {
                        sObjectQuery+=', '+rule.FieldName__c;
                    }
                }//if 2
            }//for 1
        }//if 1
        sObjectQuery+=' FROM '+testQueryNameSpaceAddition+objectName+' WHERE (';//all will have a where clause - this app doesnt support unfollowing all from one object
        for (UnfollowRule__c rule:rules){
            String ruleSOQL='';//making this separate from sObjectQuery to more easily handle the dumb corner cases like Does Not Contain
            ruleCount++;
            if(rule.FieldName__c.substring(rule.FieldName__c.length()-3)=='__c'){
                ruleSOQL+=testQueryNameSpaceAddition+rule.FieldName__c+' ';
            }else {
                ruleSOQL+=rule.FieldName__c+' ';
            }
            If (rule.Operator__c=='equals TODAY'){
                //this is a special case dealt with below in addFormattedValue()
                ruleSOQL+= ' = ';
            } else if(rule.Operator__c=='equals'){
                ruleSOQL+= ' = ';
            } else if(rule.Operator__c=='not equal to'){
                ruleSOQL+= ' <> ';
            } else if(rule.Operator__c=='greater than'){
                ruleSOQL+= ' > ';
            } else if(rule.Operator__c=='less than'){
                ruleSOQL+= ' < ';
            } else if(rule.Operator__c=='greater or equal'){
                ruleSOQL+= ' >= ';
            } else if(rule.Operator__c=='less or equal'){
                ruleSOQL+= ' <= ';
            } else if(rule.Operator__c=='contains'){
                ruleSOQL+= ' LIKE ';
            } else if(rule.Operator__c=='does not contain'){
                ruleSOQL=' NOT '+ruleSOQL+' LIKE ';//funky syntax to do "Does not contain"
            } else if(rule.Operator__c=='starts with'){
                ruleSOQL+= ' LIKE ';
            }//if 2
            ruleSOQL+=addFormattedValue(rule.Value__c, rule.FieldType__c, rule.Operator__c);
            ruleSOQL='(' + ruleSOQL + ')';//wrap to ensure the "NOT" only impacts this statement
            if(ruleCount>1){
                ruleSOQL=' OR '+ruleSOQL;
            }//if 1
            sObjectQuery+=ruleSOQL;
        }//if 1
        if(delayQuery==FALSE){
            sObjectQuery+='))';//If this is not for delay rules, need the closing ) so that the semijoin is well formed
        }else{
			//attempt to only create records queued that have at least one follow.  Not sure if it will scale.

//asdfasdfasdf - screwed up the SOQL syntax in this line.  Example:
//SELECT Id, ParentId FROM EntitySubscription WHERE ParentId IN (SELECT Id  FROM chttrunfollow__UnfollowTest__c WHERE ((chttrunfollow__string__c  = 'test' ))
 
        	sObjectQuery+=') AND (Id IN (Select ParentId FROM EntitySubscription))';
        }//if 1
        system.debug('The query syntax is: '+sObjectQuery);
        return sObjectQuery;
   }//buildQuery
   
   public static String addFormattedValue(String value, String fieldType, String operator){
       String formattedValue='';
       if(fieldType=='DATE' || fieldType=='DATETIME'){
           //the only possible value in "value" should be TODAY for these.  Let's hope I'm right
           formattedValue=' TODAY '; //note I'm effectively overwriting the Value field here just in case some craziness occurred. 
       }else if( fieldType=='BOOLEAN' ||fieldType=='CURRENCY'|| fieldType=='DOUBLE'|| fieldType=='INTEGER'  || fieldType=='PERCENT' ){
            formattedValue=' '+value+' ';
       }else if(fieldType=='STRING' || fieldType=='PICKLIST' || fieldType=='PHONE' || fieldType=='EMAIL' || fieldType=='URL'  || fieldType=='ComboBox'){
            if(operator=='Contains' ||operator=='Does Not Contain'){
                formattedValue+='\'%'+value+'%\'';
            }else if(operator=='starts with'){
                formattedValue+='\''+value+'%\'';
            }else{
                formattedValue+='\''+value+'\' ';
            }//if 2
       }//if 1
       return formattedValue;
   }//addFormattedValue



}//class