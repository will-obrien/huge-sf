trigger casesRollup on Case (after delete, after insert, after update) {
 
	Set<id> projectIds = new Set<id>();
	List<Project__c> projectToUpdate = new List<Project__c>();
 
 	if (Trigger.isInsert)
 	{
		for (Case cases : Trigger.new)
			projectIds.add(cases.Project__c);
 	}
 
	if (Trigger.isUpdate || Trigger.isDelete) {
		for (Case cases : Trigger.old)
			projectIds.add(cases.Project__c);
	}
 
	// get a map of the project with the number of cases
	Map<id,Project__c> projectMap = new Map<id,Project__c>([select id, Number_of_Cases__c from Project__c where id IN :projectIds]);
 
	// query the projects and the related cases and add the quantity of the cases to the projects's Number_of_Cases__c
	for (Project__c project : [SELECT Id, Name, Number_of_Cases__c,(select id from Cases__r) from Project__c where Id IN :projectIds]) {
		projectMap.get(project.Id).Number_of_Cases__c = project.Cases__r.size();
		// add the case value in the map to a list so we can update it
		projectToUpdate.add(projectMap.get(project.Id));
	}
 
	update projectToUpdate;
 
}