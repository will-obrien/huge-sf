public class assignmentEightController{
  public String fname{get;set;}
    
    public list<task_manager__c> task{get;set;}
    public assignmentEightController(){
        task = [select task_name__c,assign_to__c,status__c from task_manager__c];
    }
    public void save(){
    
       task_manager__c t =new  task_manager__c();
       t.task_name__c = fname;
        
    }
}