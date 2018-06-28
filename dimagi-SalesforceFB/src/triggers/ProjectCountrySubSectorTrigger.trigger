trigger ProjectCountrySubSectorTrigger on Project__c (after delete, after insert, after update) {
	

		Map<ID, Project__c> newProjectMap = Trigger.newMap;
		Map<ID, Project__c> oldProjectMap = Trigger.oldMap;
		Set<Country__c> countriesCompleted = new Set<Country__c>();
		Set<Id> updatedProjects = new Set<Id>();
		Set<Id> deletedProjects = new Set<Id>();
	
	if (Trigger.isUpdate) {
		
		// Get all the updated Projects
		for(Id projectId : newProjectMap.keySet()) {
			Project__c myNewProject = newProjectMap.get(projectId);
			Project__c myOldProject = oldProjectMap.get(projectId);
			
			if((myNewProject.Sub_Area__c <> myOldProject.Sub_Area__c) 
				| 
			   (myNewProject.Area__c <> myOldProject.Area__c)) {
				updatedProjects.add(myNewProject.Id);
			}
		}
		
		// Get all the Countries associated with the Projects
		Set<Country__c> countriesToUpdate = ProjectCountrySubSector.getCountries(updatedProjects);
				
		// Update each country's sub-sectors
		for (Country__c c : countriesToUpdate) {
					ProjectCountrySubSector.updateCountrySubSector(c);
		
		}
	}
		
	else if (Trigger.isDelete) {
		deletedProjects = oldProjectMap.keySet();
				
		// Get all the Countries associated with the Projects
		Set<Country__c> countriesToUpdate = ProjectCountrySubSector.getCountries(deletedProjects);
				
		// Update each country's sub-sectors
		for (Country__c c : countriesToUpdate) {
					ProjectCountrySubSector.updateCountrySubSector(c, deletedProjects);
		}
	}
}