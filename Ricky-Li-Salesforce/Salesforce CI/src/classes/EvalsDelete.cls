/*
 *    Purpose: This class is defined to schedule the deletes of empty evals & Leaders that have no scores in them. These evals are created 
 *             by a mis-sync between clicktools and SF.
 *    Scheduled: This class is also scheduled and called by a schedulable interface class named 'SchedEvalsDelete'
 */
Public Class EvalsDelete {
        //Properties  
        List <Tour_Evaluation_Leader__c> listTourEvaluationLeader = new list <Tour_Evaluation_Leader__c>();
        Public void DeleteEvalLeaders(){
            listTourEvaluationLeader = [Select Id from Tour_Evaluation_Leader__c where CEO_Overall_Average__c = NULL Limit 9000];
            
                //Purge Tour Evaluation Leaders
                Delete listTourEvaluationLeader;
        }
}