// this is the controller class for the RunAuditReminderBatch VF page. 
public class AuditReminderBatchController{

// var which holds the exception message
 public String errorText {get;set;}
 
 // method which executes the batch job
 public void startBatch()
  
  {
     errorText = ' ';
   
       Database.executeBatch(new AuditReminderBatch(),10);
   
   
 
  }
  
}