public with sharing class TravelsDontOverlap implements SaveTravelRule {
	
	
	// PUBLIC METHODS
	    
    public void validate(List<SObject> records) {
    	List<Travel__c> newTravels = (List<Travel__c>) records;

    	Map<Id, List<Travel__c>> travelsByUser = queryAndGroupTravelsByUsers(newTravels);

		for(Travel__c travel : newTravels) {
			List<Travel__c> existingTravelsOfSameUser = travelsByUser.get(travel.OwnerId);
			
	        for(Travel__c existing : existingTravelsOfSameUser) {
				
	            if( (travel.Id != existing.Id) && doOverlap(travel, existing)) {
	                travel.addError(String.format(System.Label.TravelsDontOverlap, new List<String> { existing.Name }));
	            }
	        }
		}
    }
    
    
    // PRIVATE METHODS
    
    private Map<Id, List<Travel__c>> queryAndGroupTravelsByUsers(List<Travel__c> travels) {
    	Map<Id, List<Travel__c>> resultMap = new Map<Id, List<Travel__c>>();
    	
    	for(Travel__c t : travels) {
    		Id user = t.OwnerId;

    		if( !resultMap.containsKey(user)) {
    			resultMap.put(user, new List<Travel__c>());
    		}
    		
    	}
    	
    	for(Travel__c travel : [SELECT Name, dtm_Start__c, dtm_End__c, OwnerId 
							    FROM Travel__c
							    WHERE OwnerId IN :resultMap.keySet()]) {
							    	
			resultMap.get(travel.OwnerId).add(travel);
		}
		
		return resultMap;
    }
    
    
    private Boolean doOverlap(Travel__c travel, Travel__c existing) {
        Boolean noOverlap = (existing.dtm_End__c < travel.dtm_Start__c || existing.dtm_Start__c > travel.dtm_End__c);

        return !noOverlap;
    }
}