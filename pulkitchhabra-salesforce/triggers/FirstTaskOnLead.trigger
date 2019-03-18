trigger FirstTaskOnLead on Task(after insert){
	Map<Id, Lead> exLeads = new Map<Id, Lead>([Select Id, Name from Lead]);
	for(Task t:trigger.new){
		if(exLeads.containsKey(t.WhoId)){
			if(t.WhoCount > 0){
				Task tsk = [Select Id, CreatedDate from Task where WhoId =:t.WhoId Order By CreatedDate ASC LIMIT 1];
				Lead l = [Select Id, Name, CreatedDate from Lead where Id =: t.WhoId];
				l.Task_Lead__c = NoOfDays.main(l.CreatedDate, tsk.CreatedDate);
                update l;
			}
		}
	}
}