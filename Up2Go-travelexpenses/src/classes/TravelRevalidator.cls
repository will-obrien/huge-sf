public with sharing class TravelRevalidator {
	
	private List<Travel__c> travels;
	private Map<Id, List<MealInvitation__c>> mealInvitationsByTravel;
	private Map<Id, List<Expense__c>> expensesByTravel;
	
	
	// CONSTRUCTOR
	
	public TravelRevalidator(List<Travel__c> travels) {
		this.travels = travels;
		mealInvitationsByTravel = queryAllAffectedMealInvitations();
		expensesByTravel = queryAllAffectedExpenses();
	}
	
	
	// PUBLIC METHODS
	
	public void revalidate() {
		for(Travel__c t : travels) {
			findAndDeleteInvalidInvitations(t);
			findAndDeleteInvalidExpenses(t);
		}
	}
	
	
	// PRIVATE METHODS
	
	private Map<Id, List<MealInvitation__c>> queryAllAffectedMealInvitations() {
		Map<Id, List<MealInvitation__c>> resultMap = new Map<Id, List<MealInvitation__c>>();
		
		for(Travel__c t : travels) {
			resultMap.put(t.Id, new List<MealInvitation__c>());
		}
		
		for(MealInvitation__c i : [SELECT Id, mdr_Travel__c, dat_Day__c
								   FROM MealInvitation__c
								   WHERE mdr_Travel__c IN :resultMap.keySet()]) {
								
			List<MealInvitation__c> invitations = resultMap.get(i.mdr_Travel__c);
			invitations.add(i);
		}
		
		return resultMap;
	}

	
	private Map<Id, List<Expense__c>> queryAllAffectedExpenses() {
		Map<Id, List<Expense__c>> resultMap = new Map<Id, List<Expense__c>>();
		
		for(Travel__c t : travels) {
			resultMap.put(t.Id, new List<Expense__c>());
		}
		
		for(Expense__c e : [SELECT Id, mdr_Travel__c, RecordTypeId,
								   dtm_DepartureTime__c, dtm_ArrivalTime__c, 
								   chk_RoundTrip__c, dtm_ReturnDeparture__c, dtm_ReturnArrival__c, 
								   dat_CheckInDate__c, dat_CheckOutDate__c, 
								   dat_PickUpDate__c, dat_ReturnDate__c, 
								   dat_ExpenseDate__c
							FROM Expense__c
							WHERE mdr_Travel__c IN :resultMap.keySet()
							AND RecordTypeId != :ExpenseType.getPerDiemRecordTypeId()]) {
								
			List<Expense__c> expenses = resultMap.get(e.mdr_Travel__c);
			expenses.add(e);
		}
		
		return resultMap;
	}
	
	
	private void findAndDeleteInvalidInvitations(Travel__c travel) {
		List<MealInvitation__c> invalidInvitations = findInvalidMealInvitations(travel);
		
		delete invalidInvitations;
	}
	
	
	private List<MealInvitation__c> findInvalidMealInvitations(Travel__c travel) {
		List<MealInvitation__c> results = new List<MealInvitation__c>();
		List<MealInvitation__c> invitations = mealInvitationsByTravel.get(travel.Id);
		
		for(MealInvitation__c i : invitations) {
			if(isOutOfTravel(travel, i)) {
				results.add(i);
			}
		}
		
		return results;
	}
	
	
	private Boolean isOutOfTravel(Travel__c t, MealInvitation__c i) {
		Date day = i.dat_Day__c;
		Date start = t.dtm_Start__c.date();
		Date stop = t.dtm_End__c.date();
		
		Boolean result = (day < start) || (day > stop);
		
		return result;
	}
	
	
	private void findAndDeleteInvalidExpenses(Travel__c travel) {
		List<Expense__c> invalidExpenses = findInvalidExpenses(travel);
		
		deleteInvitationsOfAccommodations(invalidExpenses);
		
		delete invalidExpenses;
	}
	
	
	private List<Expense__c> findInvalidExpenses(Travel__c travel) {
		List<Expense__c> results = new List<Expense__c>();
		List<Expense__c> expenses = expensesByTravel.get(travel.Id);
		
		for(Expense__c e : expenses) {
			if(isOutOfTravel(travel, e)) {
				results.add(e);
			}
		}
		
		return results;
	}
	
	
	private void deleteInvitationsOfAccommodations(List<Expense__c> expenses) {
		List<Expense__c> accommodations = findAccommodationsIn(expenses);
		
		if( !accommodations.isEmpty()) {
			BreakfastInclusionHandler handler = new BreakfastInclusionHandler(accommodations);
			handler.handleInclusion(false);
		}
	}
	
	
	private List<Expense__c> findAccommodationsIn(List<Expense__c> expenses) {
		List<Expense__c> results = new List<Expense__c>();
		
		for(Expense__c e : expenses) {
			if(ExpenseType.isAccommodation(e)) {
				results.add(e);
			}
		} 
		
		return results;
	}
	
	
	private Boolean isOutOfTravel(Travel__c t, Expense__c e) {
		Boolean result;
		
		if(ExpenseType.isMovement(e)) {
			result = movementOutOfTravel(t, e);
        }
        else if(ExpenseType.isAccommodation(e)) {
    		result = accommodationOutOfTravel(t, e);
    	}
		else if(ExpenseType.isRentalVehicle(e)) {
			result = rentalVehicleOutOfTravel(t, e);
		}
		else if((ExpenseType.isEntertainment(e) || ExpenseType.isMiscellaneous(e))){
			result = localExpenseOutOfTravel(t, e);
		}

		return result;
	}
	
	
	private Boolean movementOutOfTravel(Travel__c t, Expense__c e) {
		DateTime travelStart = t.dtm_Start__c;
		DateTime travelEnd = t.dtm_End__c;
		
		Boolean result = e.dtm_DepartureTime__c < travelStart 
						 || e.dtm_DepartureTime__c > travelEnd 
						 || e.dtm_ArrivalTime__c < travelStart 
						 || e.dtm_ArrivalTime__c > travelEnd;
						 
	 	if( !result && e.chk_RoundTrip__c) {
	 		result = e.dtm_ReturnDeparture__c < travelStart 
					 || e.dtm_ReturnDeparture__c > travelEnd 
					 || e.dtm_ReturnArrival__c < travelStart 
					 || e.dtm_ReturnArrival__c > travelEnd;
	 	}
		
		return result;
	}
	
	
	private Boolean accommodationOutOfTravel(Travel__c t, Expense__c e) {
		Date travelStart = t.dtm_Start__c.date();
		Date travelEnd = t.dtm_End__c.date();
		
		Boolean result = e.dat_CheckInDate__c < travelStart 
						 || e.dat_CheckInDate__c > travelEnd
						 || e.dat_CheckOutDate__c < travelStart 
						 || e.dat_CheckOutDate__c > travelEnd;
		
		return result;
	}
	
	
	private Boolean rentalVehicleOutOfTravel(Travel__c t, Expense__c e) {
		Date travelStart = t.dtm_Start__c.date();
		Date travelEnd = t.dtm_End__c.date();
		
		Boolean result = e.dat_PickUpDate__c < travelStart 
						 || e.dat_PickUpDate__c > travelEnd
						 || e.dat_ReturnDate__c < travelStart 
						 || e.dat_ReturnDate__c > travelEnd;
		
		return result;
	}
	
	
	private Boolean localExpenseOutOfTravel(Travel__c t, Expense__c e) {
		Date travelStart = t.dtm_Start__c.date();
		Date travelEnd = t.dtm_End__c.date();
		
		Boolean result = e.dat_ExpenseDate__c < travelStart 
						 || e.dat_ExpenseDate__c  > travelEnd;
		
		return result;		
	}
}