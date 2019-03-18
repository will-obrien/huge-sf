public with sharing class ExpensesDontOverlap implements ExpenseRule {

    
    // PUBLIC METHODS
    
    public void validate(List<SObject> records) {
    	List<Expense__c> newExpenses = (List<Expense__c>) records;
		
    	Map<Id,List<Expense__c>> expensesByTravels = queryRelevantExpensesByTravel(newExpenses);
    	
    	for(Expense__c expense : newExpenses) {
    		
	        if(ExpenseType.isMovement(expense)) {
	        	List<Expense__c> movementExpenses = expensesByTravels.get(expense.mdr_Travel__c);
	        	
		        if(hasRoundTrip(expense) && overlapsWithRoundTrip(expense)) {
					expense.addError(System.Label.OutwardTripOverlapsWithReturnTrip);
				}
		        if(isOverlapping(expense, movementExpenses)) {
					
					// TODO: Show overlapping movement to User
		        	expense.addError(System.Label.ExpensesDontOverlap);
		        }
	        }
    	}
    }
    
    
    // PRIVATE METHODS
    
    private Map<Id, List<Expense__c>> queryRelevantExpensesByTravel(List<Expense__c> expenses) {
    	Map<Id, List<Expense__c>> resultMap = new Map<Id, List<Expense__c>>();
		
		for(Expense__c incomingExpense : expenses) {
			Id travel = incomingExpense.mdr_Travel__c;
			
			if( !resultMap.containsKey(travel)) {
				resultMap.put(travel, new List<Expense__c>());
			}
		}
    	
    	Set<Id> movementRecordTypes = ExpenseType.getMovementRecordTypeIds();
		movementRecordTypes.add(ExpenseType.getRentalVehicleRecordTypeId());
		
		for(Expense__c expense : [SELECT Id, RecordTypeId, mdr_Travel__c, dtm_DepartureTime__c, dtm_ArrivalTime__c,
										 chk_RoundTrip__c, dtm_ReturnDeparture__c, dtm_ReturnArrival__c,
										 (SELECT dtm_DepartureTime__c, dtm_ArrivalTime__c,
										 		 chk_RoundTrip__c, dtm_ReturnDeparture__c, dtm_ReturnArrival__c
 		  	 						 	  FROM Long_Distance_Rides__r)
						    	  FROM Expense__c 
						    	  WHERE RecordTypeId IN :movementRecordTypes 
						    	  AND mdr_Travel__c IN :resultMap.keySet()]) {
			
			List<Expense__c> movementExpenses = resultMap.get(expense.mdr_Travel__c);
			
			if(ExpenseType.isRentalVehicle(expense)) {
				for(LongDistanceRide__c ride : expense.Long_Distance_Rides__r) {
					
					Expense__c falseExpense = new Expense__c();
		    		falseExpense.dtm_DepartureTime__c = ride.dtm_DepartureTime__c;
		    		falseExpense.dtm_ArrivalTime__c = ride.dtm_ArrivalTime__c;
		    		
		    		if(ride.chk_RoundTrip__c) {
		    			falseExpense.chk_RoundTrip__c = true;
		    			falseExpense.dtm_ReturnDeparture__c = ride.dtm_ReturnDeparture__c;
		    			falseExpense.dtm_ReturnArrival__c = ride.dtm_ReturnArrival__c;
		    		}
		    		
					movementExpenses.add(falseExpense);
				}
			}
			else {
				movementExpenses.add(expense);
			}	
		}
    	
    	return resultMap;
    }
    
    
    private Boolean overlapsWithRoundTrip(Expense__c e) {
		Boolean noOverlap = ( e.dtm_ReturnArrival__c < e.dtm_DepartureTime__c
	 					   || e.dtm_ReturnDeparture__c > e.dtm_ArrivalTime__c );
	 						   
		return !noOverlap;
    }
    
    
    private Boolean isOverlapping(Expense__c expense, List<Expense__c> expenses) {
    	Boolean result = false;
    	
    	for(Expense__c existing : expenses) {
    		if(doOverlap(expense, existing)) {
    			
    			if(existing.Id == null) {
	    			result = true;
	    					        		
	    			break;
    			}
    			else if((existing.Id != expense.Id)) {
    				result = true;
	    					        		
	    			break;
    			}
    		}
    	}
    	
    	return result;
    }
    
    
    private Boolean doOverlap( Expense__c expense, Expense__c existing) {
    	Boolean hasRoundTrip = hasRoundTrip(expense);
    	
        Boolean noOverlap = ( existing.dtm_ArrivalTime__c < expense.dtm_DepartureTime__c
        				 	  || existing.dtm_DepartureTime__c > expense.dtm_ArrivalTime__c );
        				 	
		if(noOverlap && hasRoundTrip) {
			noOverlap = ( existing.dtm_ArrivalTime__c < expense.dtm_ReturnDeparture__c
    				 	  || existing.dtm_DepartureTime__c > expense.dtm_ReturnArrival__c );
		}
		if(noOverlap && existing.chk_RoundTrip__c) {
			noOverlap = ( existing.dtm_ReturnArrival__c < expense.dtm_DepartureTime__c
    				 	  || existing.dtm_ReturnDeparture__c > expense.dtm_ArrivalTime__c );
		}
		if(noOverlap && hasRoundTrip && existing.chk_RoundTrip__c) {
			noOverlap = ( existing.dtm_ReturnArrival__c < expense.dtm_ReturnDeparture__c
    				 	  || existing.dtm_ReturnDeparture__c > expense.dtm_ReturnArrival__c );
		}
		
        return !noOverlap;
    }
    
    
    private Boolean hasRoundTrip(Expense__c e) {
    	Boolean result = e.chk_RoundTrip__c && e.dtm_ReturnDeparture__c != null && e.dtm_ReturnArrival__c != null;
    	
    	return result;
    }    
}