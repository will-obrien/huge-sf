trigger GetUsableTaskDueDate on Task (before insert, before update) { 
Task[] checkTasks = Trigger.new; 
	for(Task t : checkTasks){ 
		t.UsableDueDate__c = t.ActivityDate;
	} 
}