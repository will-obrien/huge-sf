public with sharing class RidesCannotBeOutsideOfTravel implements LongDistanceRideRule {
    
    
    // PUBLIC METHODS
    
    public void validate(List<SObject> records) {
        List<LongDistanceRide__c> newRides = (List<LongDistanceRide__c>) records;
        
        String errorMessage = System.Label.RidesCannotBeOutsideOfTravel;
        
        Map<Id,Travel__c> relevantTravels = queryRelevantTravelsByRentalVehicle(newRides);
                                                                   
        for(LongDistanceRide__c ride : newRides) {
            Id travelId = ride.mdr_RentalVehicle__c;
            Travel__c travel = relevantTravels.get(travelId);

            if(isOutsideOfTravel(ride.dtm_DepartureTime__c, travel)) {
                ride.dtm_DepartureTime__c.addError(errorMessage);
            }
            if(isOutsideOfTravel(ride.dtm_ArrivalTime__c, travel)) {
                ride.dtm_ArrivalTime__c.addError(errorMessage);
            }
            
            if(hasRoundTrip(ride)) {
                if(isOutsideOfTravel(ride.dtm_ReturnDeparture__c, travel)) {
                	ride.dtm_ReturnDeparture__c.addError(errorMessage);
                }
                if(isOutsideOfTravel(ride.dtm_ReturnArrival__c, travel)) {
                    ride.dtm_ReturnArrival__c.addError(errorMessage);
                }
            }
        }                                                          
    }
    
    
    // PRIVATE METHODS
    
    private Map<Id,Travel__c> queryRelevantTravelsByRentalVehicle(List<LongDistanceRide__c> rides) {
        Map<Id,Travel__c> resultMap = new Map<Id,Travel__c>();
        
        for(LongDistanceRide__c r : rides) {
            resultMap.put(r.mdr_RentalVehicle__c,null);
        }
        
        for(Travel__c t : [SELECT Id,dtm_Start__c, dtm_End__c,
        						  (SELECT Id
        						   FROM Expenses__r
        						   WHERE RecordTypeId = :ExpenseType.getRentalVehicleRecordTypeId())
                           FROM Travel__c
                           WHERE Id IN (SELECT mdr_Travel__c
                           				FROM Expense__c
                           				WHERE Id IN :resultMap.keySet())]) {
			for(Expense__c e : t.Expenses__r) {
				resultMap.put(e.Id,t);
			}
   		}
        
        return resultMap;
    }
    
    
    private Boolean isOutsideOfTravel(DateTime dtm, Travel__c travel) {
	    Boolean result = (dtm < travel.dtm_Start__c || dtm > travel.dtm_End__c);
        
        return result;
    }
    
    
    private Boolean hasRoundTrip(LongDistanceRide__c ride) {
    	Boolean result = ride.chk_RoundTrip__c && ride.dtm_ReturnArrival__c != null && ride.dtm_ReturnDeparture__c != null;
    	
    	return result;
    }
}