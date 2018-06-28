/**
 *	This class implements the logic needed to keep OpporunityLocations in sync
 *	with OpportunityCountries. This allows Opportunities to be related to all
 *	Countries for those that have locations related to the Opportunity.
 *
 *	@author: Gabriel Rilo
 *	@date:	 3/25/2013
 */
public with sharing class OpportunityTriggerSync {
	
	//We don't need this list anymore. We will check this dynamically.
	//private static Set<String> CLOSED_STAGES = new Set<String>{'Closed', 'Closed - Won', 'Closed - Lost', 'Closed - No Go'};  
	
	
	// Entry point from @insert trigger event.
	public static void onInsert(Opportunity_Location__c[] newLocations) {
		
		Set<String> existentOpptyCountries = getExistentOpptyCountries(newLocations);
		Map<Id,Id> locationCountry = getLocationWithCountries(newLocations); 	
		Map<Id,String> opptyStages = getOpptyStages(newLocations);
		OpportunityCountry__c[] opptyCountries = new OpportunityCountry__c[]{};
		
		// We loop all new locations and create a new OpportunityCountry for each.
		for (Opportunity_Location__c ol : newLocations) {
			
			OpportunityCountry__c oc = new OpportunityCountry__c();
			oc.Country__c = locationCountry.get(ol.Location__c);
			oc.Opportunity_Location__c = ol.Id;				
			
			if (!existentOpptyCountries.contains(ol.Opportunity__c + '' + locationCountry.get(ol.Location__c))) {
				oc.Opportunity__c = ol.Opportunity__c;
				
				if (FogBugzUtils.closedStages.contains(opptyStages.get(ol.Opportunity__c))) {
					oc.Country_Closed__c = locationCountry.get(ol.Location__c);	
				}
				else {
					oc.Country_Open__c = locationCountry.get(ol.Location__c);
				}				
			}
			else {
				oc.OpportunityId__c = ol.Opportunity__c;
			}
			
			opptyCountries.add(oc);
		}		
		
		if (!opptyCountries.isEmpty()) {
			insert opptyCountries;
		}
	}
	
	
	// Returns a Map of LocationsIds with their CountryIds
	private static Map<Id,Id> getLocationWithCountries(Opportunity_Location__c[] newLocations) {
		Map<Id,Id> locationCountry = new Map<Id,Id>();
		
		for (Opportunity_Location__c ol : newLocations) {
			locationCountry.put(ol.Location__c, null);
		} 
		
		for (Location__c l : [SELECT Country__c 
							  FROM Location__c
							  WHERE Id IN :locationCountry.keySet()]) {
			
			locationCountry.put(l.Id, l.Country__c);		
		}	
		
		return locationCountry;
	}
	
	
	// Returns a Set of OpportunityIds for those Opportunities already related to Countries.
	private static Set<String> getExistentOpptyCountries(Opportunity_Location__c[] newLocations) {
		Set<Id> opptyIds = new Set<Id>();
		Set<String> existentOpptyCountries = new Set<String>();
		
		for (Opportunity_Location__c ol : newLocations) {
			opptyIds.add(ol.Opportunity__c);
		}
		
		for (OpportunityCountry__c oc : [SELECT Opportunity__c,
												Country__c
										 FROM OpportunityCountry__c
										 WHERE Opportunity__c IN :opptyIds]) {
			
			existentOpptyCountries.add(oc.Opportunity__c + '' + oc.Country__c);									 
		}
		
		return existentOpptyCountries;
	}	
	
	
	// Returns a Map of OpportunityIds with the corresponding Stages.
	private static Map<Id,String> getOpptyStages(Opportunity_Location__c[] newLocations) {
		Map<Id,String> opptyStages = new Map<Id,String>();
		
		for (Opportunity_Location__c ol : newLocations) {
			opptyStages.put(ol.Opportunity__c, null);
		}
		
		for (Opportunity o : [SELECT StageName FROM Opportunity WHERE Id IN :opptyStages.keySet()]) {
			opptyStages.put(o.Id, o.StageName);
		}
		
		return opptyStages;
	}
	
	
	// Entry point from @delete trigger event.
	public static void onDelete(Opportunity_Location__c[] oldLocations) {

		OpportunityCountry__c[] opptyCountryDelete = new OpportunityCountry__c[]{};
		Map<Id,Set<Id>> oldOpptyCountries = new Map<Id,Set<Id>>();
		Set<Id> oldLocationIds = new Set<Id>();
		

		for (Opportunity_Location__c ol : oldLocations) {
			oldLocationIds.add(ol.Id);
		}
		
		for (OpportunityCountry__c oc : [SELECT Opportunity__c, 	
												Country__c 
										 FROM OpportunityCountry__c 
										 WHERE Opportunity_Location__c IN :oldLocationIds]) {
			opptyCountryDelete.add(oc);
			
			if (oc.Opportunity__c != NULL) {
				if (!oldOpptyCountries.containsKey(oc.Opportunity__c)) {
					oldOpptyCountries.put(oc.Opportunity__c, new Set<Id>());
				}
				oldOpptyCountries.get(oc.Opportunity__c).add(oc.Country__c);
			}
		}
		
		if (!opptyCountryDelete.isEmpty()) {
			delete opptyCountryDelete;
		}
		
		
		OpportunityCountry__c[] opptyCountries = new OpportunityCountry__c[]{};
		Set<String> processedOpptyCountry = new Set<String>();
		Map<Id,String> opptyStages = getOpptyStages(oldLocations);
		

		for (OpportunityCountry__c oc : [SELECT OpportunityId__c, 
												Country__c 
										 FROM OpportunityCountry__c
										 WHERE OpportunityId__c IN :oldOpptyCountries.keySet()]) {
			
			if (oldOpptyCountries.get(oc.OpportunityId__c).contains(oc.Country__c) &&
				!processedOpptyCountry.contains(oc.OpportunityId__c + '' + oc.Country__c)) {
				
				processedOpptyCountry.add(oc.OpportunityId__c + '' + oc.Country__c);
				
				oc.Opportunity__c = oc.OpportunityId__c;
				oc.OpportunityId__c = null;
				
				if (FogBugzUtils.closedStages.contains(opptyStages.get(oc.Opportunity__c))) {
					oc.Country_Closed__c = oc.Country__c;	
					oc.Country_Open__c = null;
				}
				else {
					oc.Country_Open__c = oc.Country__c;
					oc.Country_Closed__c = null;	
				}
								
				opptyCountries.add(oc);
			}											 
		}
		
		if (!opptyCountries.isEmpty()) {
			update opptyCountries;
		}
	}	
	
	
	// Entry point from Opportunity Trigger, when Stage is updated.
	public static void onOpportunityTrigger(Opportunity[] newOppties) {
		Map<Id,String> opptyStages = new Map<Id,String>();
			
		for (Opportunity o : newOppties) {
			opptyStages.put(o.Id, o.StageName);
		}
		
		OpportunityCountry__c[] opptyCountries = new OpportunityCountry__c[]{};
		
		for (OpportunityCountry__c oc : [SELECT Opportunity__c, 
												Country__c 
										 FROM OpportunityCountry__c
										 WHERE Opportunity__c IN :opptyStages.keySet()]) {
			
			if (FogBugzUtils.closedStages.contains(opptyStages.get(oc.Opportunity__c))) {
				oc.Country_Closed__c = oc.Country__c;
				oc.Country_Open__c = NULL;
			}
			else {
				oc.Country_Open__c = oc.Country__c;	
				oc.Country_Closed__c = NULL;
			}		
			
			opptyCountries.add(oc);				 
		}
		
		if (!opptyCountries.isEmpty()) {
			TriggerContext.runTrigger = false;
			update opptyCountries;
		}	
	}
	
	
	
	public static testmethod void unitTest() {
		Opportunity o = new Opportunity();
		o.Name = 'Test';
		o.CloseDate = System.today();
		o.StageName = 'Test';
		insert o;
		
		Country__c c = new Country__c();
		c.Name = 'United States';
		insert c; 
		 
		Location__c l = new Location__c();
		l.Country__c = c.Id;
		l.Name = 'Los Angeles';
		insert l;
		
		
		Opportunity_Location__c ol = new Opportunity_Location__c();
		ol.Opportunity__c = o.Id;
		ol.Location__c = l.Id;
		insert ol;
		
		Opportunity_Location__c ol2 = new Opportunity_Location__c();
		ol2.Opportunity__c = o.Id;
		ol2.Location__c = l.Id;
		insert ol2;		
		
		delete ol;
	}
}