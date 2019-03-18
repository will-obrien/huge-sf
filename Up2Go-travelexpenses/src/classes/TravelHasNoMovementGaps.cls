public with sharing class TravelHasNoMovementGaps implements SubmitTravelRule {
	
	
	// PUBLIC METHODS

	public void validate(List<SObject> records) {
		List<Travel__c> newTravels = (List<Travel__c>) records;
		
		Map<Id,List<Expense__c>> movementExpensesByTravel = queryAndGroupMovementExpenses(newTravels);
					   			   					  
		for(Travel__c travel : newTravels) {
			List<Expense__c> movementExpenses = movementExpensesByTravel.get(travel.Id);
			
			if (movementExpenses != null) {
				movementExpenses = createReturnTripsAndSortExpenses(movementExpenses);
				
				for(Integer i=0; i<(movementExpenses.size()-1); i++) {
					Expense__c expense1 = movementExpenses[i];
					Expense__c expense2 = movementExpenses[i+1];
					
					if(isGap(expense1, expense2)) {
						travel.addError(String.format(System.Label.TravelHasNoMovementGaps, new List<String> {expense1.txt_To__c, expense2.txt_From__c}));
					}
				}
			}
		}
	}
	
	
	// PRIVATE METHODS
	
	private Map<Id,List<Expense__c>> queryAndGroupMovementExpenses(List<Travel__c> travels) {
		Map<Id,List<Expense__c>> resultMap = new Map<Id,List<Expense__c>>();
		
		Set<Id> movementRecordTypeIds = ExpenseType.getMovementRecordTypeIds();
		movementRecordTypeIds.add(ExpenseType.getRentalVehicleRecordTypeId());
		
		for(Expense__c expense : [SELECT RecordTypeId, mdr_Travel__c,
										 dtm_ArrivalTime__c,dtm_DepartureTime__c,
										 lkp_LocationFrom__c, lkp_Location__c,
										 txt_From__c, txt_To__c,
										 chk_Roundtrip__c, dtm_ReturnDeparture__c, dtm_ReturnArrival__c,
										 (SELECT dtm_DepartureTime__c, dtm_ArrivalTime__c,
										 		 lkp_LocationFrom__c, lkp_LocationTo__c,
										 		 txt_From__c, txt_To__c,
										 		 chk_Roundtrip__c, dtm_ReturnDeparture__c, dtm_ReturnArrival__c
										  FROM Long_Distance_Rides__r)
								  FROM Expense__c
								  WHERE RecordTypeId IN :movementRecordTypeIds
								  AND mdr_Travel__c IN :travels]) {
								  	
			Id travel = expense.mdr_Travel__c;
								  	
			if( !resultMap.containsKey(travel)) {
				resultMap.put(travel, new List<Expense__c>());
			}
			
			List<Expense__c> expenses = resultMap.get(travel);
			
			if(ExpenseType.isRentalVehicle(expense)) {
				for(LongDistanceRide__c ride : expense.Long_Distance_Rides__r) {
					Expense__c falseExpense = createFalseExpense(ride);
		    		
					expenses.add(falseExpense);		    		
				}
			}
			else {
				expenses.add(expense);
			}			
		}
		
		return resultMap;
	}
	
	
	private Expense__c createFalseExpense(LongDistanceRide__c ride) {
		Expense__c result = new Expense__c();
		
		result.dtm_DepartureTime__c = ride.dtm_DepartureTime__c;
		result.dtm_ArrivalTime__c = ride.dtm_ArrivalTime__c;
		result.lkp_LocationFrom__c = ride.lkp_LocationFrom__c;
		result.lkp_Location__c = ride.lkp_LocationTo__c;
		result.txt_From__c = ride.txt_From__c;
		result.txt_To__c = ride.txt_To__c;
		result.chk_RoundTrip__c = ride.chk_RoundTrip__c;
		result.dtm_ReturnDeparture__c = ride.dtm_ReturnDeparture__c;
		result.dtm_ReturnArrival__c = ride.dtm_ReturnArrival__c;
		
		return result;
	}
	
	
	private List<Expense__c> createReturnTripsAndSortExpenses(List<Expense__c> expenses) {
		List<Expense__c> results = new List<Expense__c>();
		
		for(Expense__c e : expenses) {
			results.add(e);
			
			if(e.chk_RoundTrip__c) {
				Expense__c returnTrip = new Expense__c();
				returnTrip.dtm_DepartureTime__c = e.dtm_ReturnDeparture__c;
	    		returnTrip.dtm_ArrivalTime__c = e.dtm_ReturnArrival__c;
	    		returnTrip.lkp_LocationFrom__c = e.lkp_Location__c;
	    		returnTrip.lkp_Location__c = e.lkp_LocationFrom__c;
	    		returnTrip.txt_From__c = e.txt_To__c;
	    		returnTrip.txt_To__c = e.txt_From__c;
				
				results.add(returnTrip);
			}
		}
		
		results = sortExpenses(results);
		
		return results;
	}
	
	
	private List<Expense__c> sortExpenses(List<Expense__c> expenses) {
		Map<DateTime,Expense__c> expensesByDateTime = new Map<DateTime,Expense__c>();
		
		for(Expense__c e : expenses) {
			expensesByDateTime.put(e.dtm_DepartureTime__c, e);
		}
		
		List<DateTime> keys = new List<DateTime>(expensesByDateTime.keySet());
		keys.sort();
		
		List<Expense__c> results = new List<Expense__c>();
		
		for(DateTime dt : keys) {
			results.add(expensesByDateTime.get(dt));
		}
		
		return results;
	}
	
	
	private Boolean isGap(Expense__c firstExpense, Expense__c secondExpense) {
		Boolean result = (firstExpense.lkp_Location__c != secondExpense.lkp_LocationFrom__c);
		
		return result;
	}
}