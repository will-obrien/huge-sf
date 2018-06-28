trigger newLeadTask on Lead (after insert) {
    
    List<Task> taskList = new List<Task>();
    system.debug('List before the for loop'+ taskList);
    
    for(Lead l: Trigger.new){
        Task t = new Task (subject = 'Contact Lead', whoId = l.id, status = 'Not Started', ownerId = l.OwnerId  );
        if(l.LastName  <> 'Mario'){
            t.activityDate = Date.today()+7;
        }else{
            t.activityDate = Date.today()+1;
        }
        
        taskList.add(t);
    } 
    system.debug('List after the for loop'+ taskList);
    insert taskList;
    
	
}