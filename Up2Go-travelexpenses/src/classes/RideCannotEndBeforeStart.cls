public with sharing class RideCannotEndBeforeStart implements LongDistanceRideRule {
	
	
	// PUBLIC METHODS
	 
    public void validate(List<SObject> records) {
    	String errorMessage = System.Label.RideCannotEndBeforeStart;
    	
    	for(LongDistanceRide__c ride : (List<LongDistanceRide__c>) records) {
    		DateTime start = ride.dtm_DepartureTime__c;
    		DateTime stop = ride.dtm_ArrivalTime__c;
    		
	        if (stop <= start) {
	        	ride.dtm_ArrivalTime__c.addError(errorMessage);
	        }
	        
	        if(hasRoundTrip(ride)) {
	        	start = ride.dtm_ReturnDeparture__c;
	        	stop = ride.dtm_ReturnArrival__c;
	        	
	        	if(stop <= start) {
	        		ride.dtm_ReturnArrival__c.addError(errorMessage);
	        	}
	        }
    	}
    }
    
    
    // PRIVATE METHODS

    private Boolean hasRoundTrip(LongDistanceRide__c ride) {
    	Boolean result = ride.chk_RoundTrip__c && ride.dtm_ReturnArrival__c != null && ride.dtm_ReturnDeparture__c != null;
    	
    	return result;
    }
}