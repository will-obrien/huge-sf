public with sharing class RideNeedsReturnInfoWhenRoundTripChecked implements LongDistanceRideRule{
    
    
    public void validate(List<SObject> records) {
    	String errorMessage = System.Label.YouMustEnterValue;
    	
        for(LongDistanceRide__c ride : (List<LongDistanceRide__c>)records) {
        	
            if (ride.chk_RoundTrip__c) {
                if(ride.dtm_ReturnDeparture__c == null) {
                    ride.dtm_ReturnDeparture__c.addError(errorMessage);
                }
                if(ride.dtm_ReturnArrival__c == null) {
                    ride.dtm_ReturnArrival__c.addError(errorMessage);
                }
            }
        }
    }
}