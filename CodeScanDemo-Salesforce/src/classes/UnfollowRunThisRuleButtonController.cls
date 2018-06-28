Global with sharing class UnfollowRunThisRuleButtonController{

    public Boolean RunRuleRendered {get;set;}
    public Boolean notRunRuleRendered {get;set;}
    public final UnfollowRule__c u;

    public UnfollowRunThisRuleButtonController(ApexPages.StandardController controller) {
        this.u=(UnfollowRule__c)controller.getRecord();
        renderRunRuleButton();
    }
    
    public void renderRunRuleButton(){
        RunRuleRendered = TRUE;
        if (u.DaysDelay__c!=null){
            if(u.DaysDelay__c>0){
                RunRuleRendered =FALSE;
            }//if 2
        }//if 1
        notRunRuleRendered =!RunRuleRendered ;
    }//renderRunRuleButton

    // Code we will invoke on button click.
    public void runThisNonDelayedRuleNow() {
        Integer numBatchApexJobsLimit=5;//at time of coding, there are at most 5 concurrent batch apex jobs in any org
        List<AsyncApexJob> numBatchJobs = [SELECT Id, Status FROM AsyncApexJob WHERE Status = 'Queued' OR Status = 'Processing'];
        //This is the number of jobs that can be queued up by this method
        Integer numJobsAvailable=numBatchApexJobsLimit - numBatchJobs.size();
      
        List<UnfollowRule__c> rules = [Select Id, ObjectName__c, Active__c, FieldName__c, FieldType__c, Operator__c, Value__c, DaysDelay__c FROM UnfollowRule__c WHERE ID = :u.Id];
        
        //First check if there's a slot available - max of 5 concurrent jobs across all apps
        Boolean addFieldNames=FALSE;            
        String query=unfollowExecute.buildQuery(rules[0].objectName__c, rules, addFieldNames);
        if(numJobsAvailable>0){
            UnfollowRecordsBatch  unfollowRecords= new UnfollowRecordsBatch();
            unfollowRecords.ObjectName=rules[0].objectName__c;
            unfollowRecords.numRulesUsedInThisObject=rules.size();
            unfollowRecords.sObjectQuery =  query;
//                system.debug('The sObjectQuery string is: '+unfollowRecords.sObjectQuery);
            unfollowRecords.sendEmail=TRUE;
            Id unfollowRulesProcessId = Database.executeBatch(unfollowRecords, 200); 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Unfollow scheduled to begin now.  This can take ~10-30 minutes for each 10,000 followers.  You will receive a confirmation email once completed.');
            ApexPages.addMessage(myMsg);
        }else{
            u.addError('There are already 5 batch jobs running for your org, so more cannot be added.  To view the queue, click Setup-->Monitoring-->Apex Jobs');
        }//if 1
    }//runThisNonDelayedRuleNow
}