/**
 *	This class implements the logic needed to keep ProjectLocations in sync
 *	with ProjectCountries. This allows Projects to be related to all
 *	Countries for those that have locations related to the Project.
 *
 *	@author: Gabriel Rilo - updated by Nick Nestle for Projects
 *	@date:	 3/25/2013
 */
public with sharing class ProjectTriggerSync {
	
	// Set of Closed stages.
	private static final Set<String> CLOSED_STAGES = new Set<String>{'Complete'};  
	
	
	// Entry point from @insert trigger event.
	public static void onInsert(Project_Location__c[] newLocations) {
		
		// Get each project and country pair that already exists
		Set<String> existentProjectCountries = getexistentProjectCountries(newLocations);
		// Get each locationID with its CountryID - <LocationId,CountryId>
		Map<Id,Id> locationCountry = getLocationWithCountries(newLocations); 	
		// Get each project with its Status name
		Map<Id,String> projectStages = getprojectStages(newLocations);
		// Create a placeholder for all the new ProjectCountries
		ProjectCountry__c[] projectCountries = new ProjectCountry__c[]{};
		
		// We loop all new locations and create a new ProjectCountry for each.
		for (Project_Location__c pl : newLocations) {
			
			// Get the Projct and the Location
			ProjectCountry__c pc = new ProjectCountry__c();
			pc.Country__c = locationCountry.get(pl.Location__c);
			pc.Project_Location__c = pl.Id;				
			
			
			if (!existentProjectCountries.contains(pl.Project__c + '' + locationCountry.get(pl.Location__c))) {
				pc.Project__c = pl.Project__c;
				
				if (CLOSED_STAGES.contains(projectStages.get(pl.Project__c))) {
					pc.Country_Closed__c = locationCountry.get(pl.Location__c);	
				}
				else {
					pc.Country_Open__c = locationCountry.get(pl.Location__c);
				}				
			}
			else {
				pc.ProjectId__c = pl.Project__c;
			}
			
			projectCountries.add(pc);
		}		
		
		if (!projectCountries.isEmpty()) {
			insert projectCountries;
		}
	}
	
	
	// Returns a Map of LocationsIds with their CountryIds
	private static Map<Id,Id> getLocationWithCountries(Project_Location__c[] newLocations) {
		Map<Id,Id> locationCountry = new Map<Id,Id>();
		
		for (Project_Location__c pl : newLocations) {
			locationCountry.put(pl.Location__c, null);
		} 
		
		for (Location__c l : [SELECT Country__c 
							  FROM Location__c
							  WHERE Id IN :locationCountry.keySet()]) {
			
			locationCountry.put(l.Id, l.Country__c);		
		}	
		
		return locationCountry;
	}
	
	
	// Returns a Set of ProjectIds for those Projects already related to Countries.
	private static Set<String> getexistentProjectCountries(Project_Location__c[] newLocations) {
		Set<Id> projectIds = new Set<Id>();
		Set<String> existentProjectCountries = new Set<String>();
		
		for (Project_Location__c pl : newLocations) {
			projectIds.add(pl.Project__c);
		}
		
		for (ProjectCountry__c pc : [SELECT Project__c,
												Country__c
										 FROM ProjectCountry__c
										 WHERE Project__c IN :projectIds]) {
			
			existentProjectCountries.add(pc.Project__c + '' + pc.Country__c);									 
		}
		
		return existentProjectCountries;
	}	
	
	
	// Returns a Map of ProjectIds with the corresponding Stages.
	private static Map<Id,String> getprojectStages(Project_Location__c[] newLocations) {
		Map<Id,String> projectStages = new Map<Id,String>();
		
		for (Project_Location__c pl : newLocations) {
			projectStages.put(pl.Project__c, null);
		}
		
		for (Project__c p : [SELECT Status__c FROM Project__c WHERE Id IN :projectStages.keySet()]) {
			projectStages.put(p.Id, p.Status__c);
		}
		
		return projectStages;
	}
	
	
	// Entry point from @delete trigger event.
	public static void onDelete(Project_Location__c[] oldLocations) {

		ProjectCountry__c[] projectCountryDelete = new ProjectCountry__c[]{};
		Map<Id,Set<Id>> oldProjectCountries = new Map<Id,Set<Id>>();
		Set<Id> oldLocationIds = new Set<Id>();
		

		for (Project_Location__c pl : oldLocations) {
			oldLocationIds.add(pl.Id);
		}
		
		for (ProjectCountry__c pc : [SELECT Project__c, 	
												Country__c 
										 FROM ProjectCountry__c 
										 WHERE Project_Location__c IN :oldLocationIds]) {
			projectCountryDelete.add(pc);
			
			if (pc.Project__c != NULL) {
				if (!oldProjectCountries.containsKey(pc.Project__c)) {
					oldProjectCountries.put(pc.Project__c, new Set<Id>());
				}
				oldProjectCountries.get(pc.Project__c).add(pc.Country__c);
			}
		}
		
		if (!projectCountryDelete.isEmpty()) {
			delete projectCountryDelete;
		}
		
		
		ProjectCountry__c[] projectCountries = new ProjectCountry__c[]{};
		Set<String> processedProjectCountry = new Set<String>();
		Map<Id,String> projectStages = getprojectStages(oldLocations);
		

		for (ProjectCountry__c pc : [SELECT ProjectId__c, 
												Country__c 
										 FROM ProjectCountry__c
										 WHERE ProjectId__c IN :oldProjectCountries.keySet()]) {
			
			if (oldProjectCountries.get(pc.ProjectId__c).contains(pc.Country__c) &&
				!processedProjectCountry.contains(pc.ProjectId__c + '' + pc.Country__c)) {
				
				processedProjectCountry.add(pc.ProjectId__c + '' + pc.Country__c);
				
				pc.Project__c = pc.ProjectId__c;
				pc.ProjectId__c = null;
				
				if (CLOSED_STAGES.contains(projectStages.get(pc.Project__c))) {
					pc.Country_Closed__c = pc.Country__c;	
					pc.Country_Open__c = null;
				}
				else {
					pc.Country_Open__c = pc.Country__c;
					pc.Country_Closed__c = null;	
				}
								
				projectCountries.add(pc);
			}											 
		}
		
		if (!projectCountries.isEmpty()) {
			update projectCountries;
		}
	}	
	
	
	// Entry point from Project Trigger, when Stage is updated.
	public static void onProjectTrigger(Project__c[] newProjects) {
		Map<Id,String> projectStages = new Map<Id,String>();
			
		for (Project__c p : newProjects) {
			projectStages.put(p.Id, p.Status__c);
		}
		
		ProjectCountry__c[] projectCountries = new ProjectCountry__c[]{};
		
		for (ProjectCountry__c pc : [SELECT Project__c, 
												Country__c 
										 FROM ProjectCountry__c
										 WHERE Project__c IN :projectStages.keySet()]) {
			
			if (CLOSED_STAGES.contains(projectStages.get(pc.Project__c))) {
				pc.Country_Closed__c = pc.Country__c;
				pc.Country_Open__c = NULL;
			}
			else {
				pc.Country_Open__c = pc.Country__c;	
				pc.Country_Closed__c = NULL;
			}		
			
			projectCountries.add(pc);				 
		}
		
		if (!projectCountries.isEmpty()) {
			TriggerContext.runTrigger = false;
			update projectCountries;
		}	
	}
	
	
	
	public static testmethod void unitTest() {
		
		Country__c cntry = new Country__c(Name='Test');
		insert cntry;
		
		Account acct = new Account(Name='Test Account', country__c=cntry.Id, office_type__c='HQ');
		insert acct;
		
		Project__c p = new Project__c();
		p.Name = 'Test';
		p.Project_Space_Name__c = 'Test';
		p.Status__c = 'Test';
		p.Implementing_Account__c = acct.Id;
		insert p;
		
		Country__c c = new Country__c();
		c.Name = 'United States';
		insert c; 
		 
		Location__c l = new Location__c();
		l.Country__c = c.Id;
		l.Name = 'Los Angeles';
		insert l;
		
		
		Project_Location__c pl = new Project_Location__c();
		pl.Project__c = p.Id;
		pl.Location__c = l.Id;
		insert pl;
		
		Project_Location__c pl2 = new Project_Location__c();
		pl2.Project__c = p.Id;
		pl2.Location__c = l.Id;
		insert pl2;		
		
		delete pl;
	}
}