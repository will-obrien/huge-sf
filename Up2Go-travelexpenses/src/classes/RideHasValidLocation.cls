public with sharing class RideHasValidLocation implements LongDistanceRideRule {
	
	
	public void validate(List<SObject> records) {
		String errorMessage = System.Label.InvalidLocation;
		
    	for(LongDistanceRide__c ride : (List<LongDistanceRide__c>) records) {
    		
			if(ride.lkp_LocationFrom__c == null) {
				ride.txt_From__c.addError(errorMessage);
			}
			if(ride.lkp_LocationTo__c == null) {
				ride.txt_To__c.addError(errorMessage);
			}
    	}
    }
}