trigger ClosedOpportunityTrigger on Opportunity (before insert,before update) {
    
    List<task> tList = new List<task>();
    for(Opportunity o:Trigger.New) {
		task t = new task();
        if(o.StageName=='Closed Won') {
         //   insert t;
            t.OwnerId = o.OwnerId;
			t.Subject = 'Follow Up Test Task';
            t.WhatId = o.id;
            t.Status = 'Not Started';
            t.Priority = 'Normal';
            t.ActivityDate = Date.Today()+14;
            System.debug('date: '+t.ActivityDate);
        }
        tList.add(t);
    }
    insert tList;
}