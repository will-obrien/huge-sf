public with sharing class TravelNeedsMovementOnFirstAndLastDay implements SubmitTravelRule {
	
	
	// PUBLIC METHODS
	
	public void validate(List<SObject> records) {
		List<Travel__c> travels = (List<Travel__c>) records;
		
		Map<Id, Set<Date>> movementExpensesByDate = queryAndGroupMovementExpenses(travels);
										
		for(Travel__c travel : travels) {
			Set<Date> movementExpenses = movementExpensesByDate.get(travel.Id);
			
			if( movementExpenses == null ) {
				travel.addError('Your travel needs at least a movement expense on the first and last day.');
			}
			else {
				Date firstDay = travel.dtm_Start__c.date();
				Date lastDay = travel.dtm_End__c.date();
			
				if( !movementExpenses.contains(firstDay)) {
					travel.addError('Your travel needs a movement expense on the first day.');
				}
				if( !movementExpenses.contains(lastDay)) {
					travel.addError('Your travel needs a movement expense on the last day.');
				}
			}
		}
	}
	
	
	// PRIVATE METHODS
	
	private Map<Id, Set<Date>> queryAndGroupMovementExpenses(List<Travel__c> travels) {
		Map<Id, Set<Date>> resultMap = new Map<Id, Set<Date>>();
		
		Set<Id> movementRecordTypeIds = ExpenseType.getMovementRecordTypeIds();
		movementRecordTypeIds.add(ExpenseType.getRentalVehicleRecordTypeId());
		
		for(Expense__c expense : [SELECT RecordTypeId, dtm_DepartureTime__c, dtm_ArrivalTime__c, mdr_Travel__c,
										 (SELECT dtm_DepartureTime__c, dtm_ArrivalTime__c FROM Long_Distance_Rides__r)
								  FROM Expense__c
								  WHERE RecordTypeId IN :movementRecordTypeIds
								  AND mdr_Travel__c IN :travels]) {
								  	
			Id travel = expense.mdr_Travel__c;
								  	
			if( !resultMap.containsKey(travel)) {
				resultMap.put(travel, new Set<Date>());
			}
			
			Set<Date> expenseDates = resultMap.get(travel);
			
			if(expense.RecordTypeId == ExpenseType.getRentalVehicleRecordTypeId()) {
				for(LongDistanceRide__c ride : expense.Long_Distance_Rides__r) {
					expenseDates.add(ride.dtm_DepartureTime__c.date());
					expenseDates.add(ride.dtm_ArrivalTime__c.date());
				}
			}
			else {
				expenseDates.add(expense.dtm_DepartureTime__c.date());
				expenseDates.add(expense.dtm_ArrivalTime__c.date());		
			}		  	
		}
		
		return resultMap;
	}
}