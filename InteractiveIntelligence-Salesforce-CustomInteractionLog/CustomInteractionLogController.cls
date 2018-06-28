public class CustomInteractionLogController {
 
 	//Define disposition list here   
	public List<SelectOption> getDispositions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Requires Callback','Requires Callback'));
        options.add(new SelectOption('Issue Resolved','Issue Resolved'));
        options.add(new SelectOption('Problem Reported','Problem Reported'));
        return options;
    }
	
    @RemoteAction
    public static Task saveTask(String taskId, String disposition, String subject, String notes, String whoId, String whatId){
		//We Expect the CTI to have already created a Task for this call
        Task  existingTask = [Select Id From Task Where Id = :taskId];
        existingTask.CallDisposition = disposition;
        existingTask.Subject = subject;
        existingTask.Description = notes;
        existingTask.WhoId = whoId;
        existingTask.WhatId = whatId;
        
        update existingTask;
        
        taskId = existingTask.id;
        
        return null;
    }
    
    @RemoteAction
    public static Task getTaskInformation(String interactionId){
        Task  existingTask = [Select Id, CallDisposition, Subject,Description,WhoId, WhatId From Task Where CallObject = :interactionId and OwnerId = :UserInfo.getUserid() LIMIT 1];
        
        return existingTask;
    }
}
