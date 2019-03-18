public class MyTaskListCompController {
    @AuraEnabled
    public static List<TaskWraper> getTasks() {
        List<Task> tasks =  [SELECT Status, Description, What.Name, WhatId, Who.Name, WhoId, Id, Subject, Priority, Owner.Name, ActivityDate 
                            FROM Task
                            WHERE Status != 'Completed' and OwnerId =: UserInfo.getUserId()
                            ORDER BY ActivityDate ASC, Priority];
        
        
        
        List<TaskWraper> tWrapps = new List<TaskWraper>();
        
        for(Task t : tasks){
            TaskWraper tw = new TaskWraper();
            tw.t = t;
            
            if(t.ActivityDate < Date.today())
                tw.overdue = true; 
            tWrapps.add(tw);
        }
        
        return tWrapps;
    }
    
    public class TaskWraper{
        @AuraEnabled
        public Task t { get; set; }
        
        @AuraEnabled
        public Boolean overdue { get; set; }
    }
}