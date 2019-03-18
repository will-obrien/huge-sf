public with sharing class RideCannotBeOutsideOfRental implements LongDistanceRideRule {


	// PUBLIC METHODS
	
	public void validate(List<SObject> records) {
		String errorMessage = System.Label.RideCannotBeOutsideOfRental;

		List<LongDistanceRide__c> newRides = (List<LongDistanceRide__c>) records;
		Map<Id,Expense__c> relevantRentalVehicles = queryRelevantRentalCarsById(newRides);
		
		for(LongDistanceRide__c ride : newRides) {
			Expense__c rentalVehicle = relevantRentalVehicles.get(ride.mdr_RentalVehicle__c);
			
			if(isOutsideOfRental(ride.dtm_DepartureTime__c, rentalVehicle)) {
				ride.dtm_DepartureTime__c.addError(errorMessage);
			}
			if(isOutsideOfRental(ride.dtm_ArrivalTime__c, rentalVehicle)) {
				ride.dtm_ArrivalTime__c.addError(errorMessage);
			}
			
			if(hasRoundTrip(ride)) {
				
				if(isOutsideOfRental(ride.dtm_ReturnDeparture__c, rentalVehicle)) {
					ride.dtm_ReturnDeparture__c.addError(errorMessage);
				}
				if(isOutsideOfRental(ride.dtm_ReturnArrival__c, rentalVehicle)) {
					ride.dtm_ReturnArrival__c.addError(errorMessage);
				}
			}
		}
	}
	
	
	// PRIVATE METHODS
	
	private Map<Id,Expense__c> queryRelevantRentalCarsById(List<LongDistanceRide__c> rides) {
		Set<Id> rentalVehicles = new Set<Id>();
		for(LongDistanceRide__c ride : rides){
			rentalVehicles.add(ride.mdr_RentalVehicle__c);
		}
		
		Map<Id,Expense__c> resultMap = new Map<Id,Expense__c>([SELECT dat_PickUpDate__c, dat_ReturnDate__c
															   FROM Expense__c
															   WHERE Id IN :rentalVehicles]);
															   
	   return resultMap;
	}
	
	
	private Boolean isOutsideOfRental(DateTime dtm, Expense__c e) {
		Boolean result = dtm.date() < e.dat_PickUpDate__c || dtm.date() > e.dat_ReturnDate__c;
		
    	return result;
    }
    
    
    private Boolean hasRoundTrip(LongDistanceRide__c ride) {
    	Boolean result = ride.chk_RoundTrip__c && ride.dtm_ReturnArrival__c != null && ride.dtm_ReturnDeparture__c != null;
    	
    	return result;
    }
}