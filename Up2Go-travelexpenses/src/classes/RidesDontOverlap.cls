public with sharing class RidesDontOverlap implements LongDistanceRideRule {

	
	// PUBLIC METHODS
	
	public void validate(List<SObject> records) {
		List<LongDistanceRide__c> newRides = (List<LongDistanceRide__c>) records;
		
		Map<Id,Id> travelsByRentalVehicle = queryRelevantTravelsByRentalVehicles(newRides);
        Map<Id,List<LongDistanceRide__c>> movementsByTravel = queryMovementsByTravel(travelsByRentalVehicle.values());
        
		for(LongDistanceRide__c ride : newRides) {
			Id travel = travelsByRentalVehicle.get(ride.mdr_RentalVehicle__c);
			List<LongDistanceRide__c> movements = movementsByTravel.get(travel);
			
			if(hasRoundTrip(ride) && overlapsWithRoundTrip(ride)) {
				ride.addError(System.Label.OutwardTripOverlapsWithReturnTrip);
			}
			if(isOverlapping(ride, movements)) {
				
				// TODO: Show overlapping movement to User
				ride.addError(System.Label.RidesDontOverlap);
			}
		}   
    }

    
    // PRIVATE METHODS
    
    private Map<Id,Id> queryRelevantTravelsByRentalVehicles(List<LongDistanceRide__c> rides) {
    	Map<Id,Id> resultMap = new Map<Id,Id>();

    	for(LongDistanceRide__c ride : rides) {
    		resultMap.put(ride.mdr_RentalVehicle__c,null);
    	}
    	
    	for(Expense__c expense : [SELECT mdr_Travel__c
    							  FROM Expense__c
    							  WHERE Id IN :resultMap.keySet()]) {
	  		resultMap.put(expense.Id, expense.mdr_Travel__c);
		}
		
		return resultMap;
    }

    
    private Map<Id,List<LongDistanceRide__c>> queryMovementsByTravel(List<Id> travels) {
    	Map<Id,List<LongDistanceRide__c>> resultMap = new Map<Id,List<LongDistanceRide__c>>();
    	
		Set<Id> movementRecordTypes = ExpenseType.getMovementRecordTypeIds();
		movementRecordTypes.add(ExpenseType.getRentalVehicleRecordTypeId());
		
		for(Expense__c expense : [SELECT RecordTypeId, mdr_Travel__c, dtm_DepartureTime__c, dtm_ArrivalTime__c,
										 chk_RoundTrip__c, dtm_ReturnDeparture__c, dtm_ReturnArrival__c,
										 (SELECT Id, dtm_DepartureTime__c, dtm_ArrivalTime__c,
										 		 chk_RoundTrip__c, dtm_ReturnDeparture__c, dtm_ReturnArrival__c  
 		  	 						 	  FROM Long_Distance_Rides__r)
						    	  FROM Expense__c 
						    	  WHERE RecordTypeId IN :movementRecordTypes 
						    	  AND mdr_Travel__c IN :travels]) {
						    	  	
			Id travel = expense.mdr_Travel__c;
			
			if( !resultMap.containsKey(travel)) {
				resultMap.put(travel, new List<LongDistanceRide__c>());
			}
			List<LongDistanceRide__c> movements = resultMap.get(travel);
			
			if(ExpenseType.isRentalVehicle(expense)) {
				for(LongDistanceRide__c ride : expense.Long_Distance_Rides__r) {
					movements.add(ride);
				}
			}
			else {
				LongDistanceRide__c falseLongDistanceRide = new LongDistanceRide__c();
				falseLongDistanceRide.dtm_DepartureTime__c = expense.dtm_DepartureTime__c;
				falseLongDistanceRide.dtm_ArrivalTime__c = expense.dtm_ArrivalTime__c;
				falseLongDistanceRide.chk_RoundTrip__c = expense.chk_RoundTrip__c;
				falseLongDistanceRide.dtm_ReturnDeparture__c = expense.dtm_ReturnDeparture__c;
				falseLongDistanceRide.dtm_ReturnArrival__c = expense.dtm_ReturnArrival__c;
				
				movements.add(falseLongDistanceRide);
			}	
		}
    	
    	return resultMap;
    }
    
    
    private Boolean overlapsWithRoundTrip(LongDistanceRide__c ride) {
    	Boolean noOverlap = true;
    	
    	if(ride.dtm_ReturnArrival__c != null && ride.dtm_ReturnDeparture__c != null) {
			noOverlap = ( ride.dtm_ReturnArrival__c < ride.dtm_DepartureTime__c
	 			   	   || ride.dtm_ReturnDeparture__c > ride.dtm_ArrivalTime__c );
    	}
	 						   
		return !noOverlap;
    }
    
    
    private Boolean isOverlapping(LongDistanceRide__c ride, List<LongDistanceRide__c> rides) {
    	Boolean result = false;
    	
    	for(LongDistanceRide__c ldr : rides) {
			if(doOverlap(ride,ldr)) {
				if(ldr.Id == null) {
					result = true;
					
					break;
				}
				else if(ldr.Id != ride.Id) {
					result = true;
					
					break;
				}
			}
		}
    	
    	return result;
    }
    
    
    private Boolean doOverlap( LongDistanceRide__c ride, LongDistanceRide__c existing) {
    	Boolean hasRoundTrip = hasRoundTrip(ride);
    	
        Boolean noOverlap = ( existing.dtm_ArrivalTime__c < ride.dtm_DepartureTime__c
        				 	|| existing.dtm_DepartureTime__c > ride.dtm_ArrivalTime__c );
        				 	
		if(noOverlap && hasRoundTrip) {
			noOverlap = ( existing.dtm_ArrivalTime__c < ride.dtm_ReturnDeparture__c
        				 	|| existing.dtm_DepartureTime__c > ride.dtm_ReturnArrival__c );
		}
		if(noOverlap && existing.chk_RoundTrip__c) {
			noOverlap = ( existing.dtm_ReturnArrival__c < ride.dtm_DepartureTime__c
        				 	|| existing.dtm_ReturnDeparture__c > ride.dtm_ArrivalTime__c );
		}
		if(noOverlap && hasRoundTrip && existing.chk_RoundTrip__c) {
			noOverlap = ( existing.dtm_ReturnArrival__c < ride.dtm_ReturnDeparture__c
        				 	|| existing.dtm_ReturnDeparture__c > ride.dtm_ReturnArrival__c );
		}

        return !noOverlap;
    }
    
    
    private Boolean hasRoundTrip(LongDistanceRide__c ride) {
    	Boolean result = ride.chk_RoundTrip__c && ride.dtm_ReturnArrival__c != null && ride.dtm_ReturnDeparture__c != null;
    	
    	return result;
    }    
}