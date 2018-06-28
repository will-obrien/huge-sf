global with sharing class KVApexBatch implements Database.Batchable<sObject>, 
    Database.Stateful, Database.AllowsCallouts{
    
    //If there are any errors processing the Goal Achiever List in the apex job
    // it should be put in the list and notified accordingly.
    global List<Goal_Achiever__c> errorList {get; private set;}
    global List<Goal_Achiever__c> goalAchieverList {get; private set;}
    
    global KVApexBatch()
    {
        this.errorList = new List<Goal_Achiever__c>();
        this.goalAchieverList = new List<Goal_Achiever__c>();
    }    

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
    
        String query = 'SELECT ';
        query += 'Id, Name, Object_Name__c, Object_Id__c, Description__c, Goal_Team__r.Goal__c, ';
        query += 'Goal_Team__c, Goal_Team__r.User__c,'; 
        query += 'Goal_Team__r.User__r.Name, CreatedDate, Status__c '; 
        query += 'FROM Goal_Achiever__c '; 
        query += 'WHERE Status__c != \'Complete\' '; 
        query += 'ORDER BY CreatedDate'; 
        
        return Database.getQueryLocator(query);    
    
    
    }
    
    // This is called with only one row at a time
    global void execute(Database.BatchableContext BC, List<sObject> objectBatch)
    {
        Goal_Achiever__c goalAchiever = (Goal_Achiever__c) objectBatch[0];    
        try{
            goalAchiever.Status__c = 'Complete';
            this.goalAchieverList.add(goalAchiever);
        }catch(Exception e){
            goalAchiever.Status__c = 'Incomplete';
            this.errorList.add(goalAchiever);        
            System.debug('~~~~~~~~ Exception in KVApexBatch : ' + e);
        }finally{
            update goalAchiever;
        }
    
        /*
        Goal_Achiever__c goalAchiever = (Goal_Achiever__c) objectBatch[0];

        if(KVApexBatchExecute.mockCallout(goalAchiever)){
            goalAchiever.Status__c = 'Complete';
            this.goalAchieverList.add(goalAchiever);
        }
        else
        {
            goalAchiever.Status__c = 'Incomplete';
            this.errorList.add(goalAchiever);
        }

        update goalAchiever;
        */
    }
    
 
    global void finish(Database.BatchableContext BC)
    {
        //this email will be sent with error content
        if(this.errorList.size() > 0)
        {
            
            
            
            String body = '';
            String GoalId = '';
            Map<String, String> goalEmail = new Map<String, String>();
            
            
            for(Goal_Achiever__c goalAchiever : this.goalAchieverList){
                
                //populate the map with Goal Id and corresponding email id of the goal owner record
                if(!goalEmail.containsKey((String) goalAchiever.Goal_Team__r.Goal__c)){
                    
                    //If the size of the goalEmail map is not zero send the email for the 
                    //previous batch processed.
                    if(goalEmail.size() > 0){
                        KVApexUtilityEngine.SendEmailToGoalOwner('Goal Error List', body, goalEmail.get(GoalId));
                        body='';
                        goalEmail.clear();
                    }
                    
                    GoalId = (String) goalAchiever.Goal_Team__r.Goal__c;
                    Goal__c goal = [select OwnerId from Goal__c where Id = :GoalId];
                    User user = [select email from User where Id = :goal.OwnerId];
                    goalEmail.put(GoalId,(String)user.Email);
                    
                    body += 'The following goals were not processed: \n\n';
                }
                
                body += URL.getSalesforceBaseUrl().toExternalForm() + '/' + goalAchiever.Id + '\r\n';

                
            } 
                       
            //at this point only one record will exist in the map
            if(goalEmail.size() > 0){
                KVApexUtilityEngine.SendEmailToGoalOwner('Goal Achiever List', body, goalEmail.get(GoalId));
                body='';
                goalEmail.clear();
            }            
            
        }else if(this.goalAchieverList.size() > 0){
            //this email will be sent with success content
            
            String body = '';
            String GoalId = '';
            Map<String, String> goalEmail = new Map<String, String>();
            
            
            for(Goal_Achiever__c goalAchiever : this.goalAchieverList){
                
                //populate the map with Goal Id and corresponding email id of the goal owner record
                if(!goalEmail.containsKey((String) goalAchiever.Goal_Team__r.Goal__c)){
                    
                    //If the size of the goalEmail map is not zero send the email for the 
                    //previous batch processed.
                    if(goalEmail.size() > 0){
                        KVApexUtilityEngine.SendEmailToGoalOwner('Goal Achiever List', body, goalEmail.get(GoalId));
                        body='';
                        goalEmail.clear();
                    }
                    
                    GoalId = (String) goalAchiever.Goal_Team__r.Goal__c;
                    System.debug('~~~~~~~~~~~~~ Apex Batch : Goal Id : ' + GoalId);
                    Goal__c goal = [select OwnerId from Goal__c where Id = :GoalId];
                    System.debug('~~~~~~~~~~~~~ Apex Batch : Goal Owner Id : ' + goal.OwnerId);
                    User user = [select email from User where Id = :goal.OwnerId];
                    System.debug('~~~~~~~~~~~~~ Apex Batch : Email Address : ' + (String)user.Email);
                    goalEmail.put(GoalId,(String)user.Email);
                    
                    body += 'The following goals were processed: \n\n';
                }//end if check for unique email in map
                
                body += URL.getSalesforceBaseUrl().toExternalForm() + '/' + goalAchiever.Id + '\r\n';
            }//end of for loop
            
            //at this point only one record will exist in the map
            if(goalEmail.size() > 0){
                System.debug('~~~~~~~ goal email size : ' + goalEmail.size());
                KVApexUtilityEngine.SendEmailToGoalOwner('Goal Achiever List', body, goalEmail.get(GoalId));
                body='';
                goalEmail.clear();
            }
            
        }//end of eles if
    } 
 
    
}