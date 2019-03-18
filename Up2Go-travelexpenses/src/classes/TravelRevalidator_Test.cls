@isTest
private class TravelRevalidator_Test {
	
	private static final DateTime TRAVEL_START = dateTime(System.Today(), 12,00);
	private static final DateTime TRAVEL_END = dateTime(System.Today().addDays(2), 18,00);
	
    static {
        CustomSettings.addDefault();
    }
	
	
	@isTest
	private static void noExpenseDeletedIfPeriodEnhanced() {
		
		// Setup
		Exception unexpectedException;
		String errorMessage = '';
		
		Travel__c travel = createTravelWithExpensesOnFirstAndLastDay();
		
		
		// Exercise
		try {
			travelStartsEarlier(travel);
			travelEndsLater(travel);
		}
		catch(Exception e) {
			unexpectedException = e;
			errorMessage = e.getStackTraceString();
		}
		
		
		// Verify
		System.assertEquals(null, unexpectedException, errorMessage);
		System.assert(hasAllExpenses(travel));
	}
	
	
	@isTest
	private static void noInvitationDeletedIfPeriodEnhanced() {
		
		// Setup
		Exception unexpectedException;
		String errorMessage = '';
		
		Travel__c travel = createTravelWithInvitationsOnFirstAndLastDay();
		
		
		// Exercise
		try {
			travelStartsEarlier(travel);
			travelEndsLater(travel);
		}
		catch(Exception e) {
			unexpectedException = e;
			errorMessage = e.getStackTraceString();
		}
		
		
		// Verify
		System.assertEquals(null, unexpectedException, errorMessage);
		System.assert(hasAllInvitations(travel));
	}
	
	
	@isTest
	private static void noExpenseOutOfTravelPeriodIfPeriodReduced() {
		
		// Setup
		Exception unexpectedException;
		String errorMessage = '';
		
		Travel__c travel = createTravelWithExpensesOnFirstAndLastDay();
		
		
		// Exercise
		try {
			travelStartsLater(travel);
			travelEndsEarlier(travel);
		}
		catch(Exception e) {
			unexpectedException = e;
			errorMessage = e.getStackTraceString();
		}
		
		
		// Verify
		System.assertEquals(null, unexpectedException, errorMessage);
		System.assert(hasNoExpenses(travel));
	}
	
	
	@isTest
	private static void noMealInvitationOutOfTravelPeriodIfPeriodReduced() {
		
		// Setup
		Exception unexpectedException;
		String errorMessage = '';
		
		Travel__c travel = createTravelWithInvitationsOnFirstAndLastDay();
		
		
		// Exercise
		try {
			travelStartsLater(travel);
			travelEndsEarlier(travel);
		}
		catch(Exception e) {
			unexpectedException = e;
			errorMessage = e.getStackTraceString();
		}
		
		
		// Verify
		System.assertEquals(null, unexpectedException, errorMessage);
		System.assert(hasNoInvitations(travel));
	}
	
	
	@isTest
	private static void invitationsOfDeletedAccommodationsGetDeletedToo() {
			
		// Setup
		Exception unexpectedException;
		String errorMessage = '';
		
		Travel__c travel = createTravelWithAccommodationAndBreakfastIncluded();
		
		
		// Exercise
		try {
			travelEndsEarlier(travel);
		}
		catch(Exception e) {
			unexpectedException = e;
			errorMessage = e.getStackTraceString();
		}
		
		
		// Verify
		System.assertEquals(null, unexpectedException, errorMessage);
		System.assert(hasNoExpenses(travel));
		System.assert(hasNoInvitations(travel));
	}
	
	
	@isTest
	private static void expenseGetsDeletedIfRoundTripIsOutOfTravel() {
		
		// Setup
		Exception unexpectedException;
		String errorMessage = '';
		
		Travel__c travel = createTravelWithExpenseWithRoundTrip();
		
		
		// Exercise
		try {
			travelEndsEarlier(travel);
		}
		catch(Exception e) {
			unexpectedException = e;
			errorMessage = e.getStackTraceString();
		}
		
		
		// Verify
		System.assertEquals(null, unexpectedException, errorMessage);
		System.assert(hasNoExpenses(travel));
	}
	
	
	// TESTHELPER
	
	private static DateTime dateTime(Date day, Integer hour, Integer minute) {
		Time t = Time.newInstance(hour,minute,00,00);
		
		DateTime result = DateTime.newInstance(day,t);
		
		return result;
	}
	
	
	private static Travel__c createTravelWithExpensesOnFirstAndLastDay() {
		DateTime flightDeparture = TRAVEL_START;
		DateTime flightArrival = TRAVEL_START.addHours(2);
		Date accCheckIn = TRAVEL_START.date();
		Date accCheckOut = accCheckIn.addDays(1);
		Date rentalPickUp = TRAVEL_END.date();
		Date rentalReturn = TRAVEL_END.date();
		Date miscDate = TRAVEL_END.date();
		
		Travel__c result = new TravelBuilder(TRAVEL_START, TRAVEL_END)
							   .addDefaultFlight(flightDeparture, flightArrival)
							   .addDefaultAccommodation(accCheckIn, accCheckOut)
							   .addDefaultRentalVehicle(rentalPickUp, rentalReturn)
							   .addDefaultMiscellaneousExpense(miscDate)
							   .create();
		
		return result;
	}
	
	
	private static Travel__c createTravelWithInvitationsOnFirstAndLastDay() {
		Travel__c result = new TravelBuilder(TRAVEL_START, TRAVEL_END)
							   .addMealInvitation(TRAVEL_START.date(), true, true, true)
							   .addMealInvitation(TRAVEL_END.date(), true, true, true)
							   .create();
		
		return result;
	}
	
	
	private static Travel__c createTravelWithExpenseWithRoundTrip() {
		DateTime departure = TRAVEL_START;
		DateTime arrival = TRAVEL_START.addHours(2);
		DateTime returnDeparture = TRAVEL_END.addHours(-2);
		DateTime returnArrival = TRAVEL_END;
		
		Travel__c result = new TravelBuilder(TRAVEL_START, TRAVEL_END)
											.addRoundFlight(departure, arrival, returnDeparture, returnArrival)
											.create();
		
		return result;
	}
	
	
	private static Travel__c createTravelWithAccommodationAndBreakfastIncluded() {
		Date checkIn = TRAVEL_START.date();
		Date checkOut = TRAVEL_END.date();
		
		Travel__c result = new TravelBuilder(TRAVEL_START, TRAVEL_END)
											.addAccommodationWithBreakfastIncluded(checkIn, checkOut)
											.create();
		
		return result;
	}
	
	
	private static void travelStartsEarlier(Travel__c t) {
		t.dtm_Start__c = t.dtm_Start__c.addDays(-1);
		
		update t;
	}
	
	
	private static void travelEndsLater(Travel__c t) {
		t.dtm_End__c = t.dtm_End__c.addDays(1);
		
		update t;		
	}
	
	
	private static void travelStartsLater(Travel__c t) {
		t.dtm_Start__c = t.dtm_Start__c.addDays(1);
		
		update t;
	}
	
	
	private static void travelEndsEarlier(Travel__c t) {
		t.dtm_End__c = t.dtm_End__c.addDays(-1);
		
		update t;
	}
	
	
	private static Boolean hasAllExpenses(Travel__c t) {
		List<Expense__c> expenses = [SELECT Id
									 FROM Expense__c
									 WHERE mdr_Travel__c = :t.Id];
		
		Boolean result = (expenses.size() == 4);
		
		return result;
	}
	
	
	private static Boolean hasAllInvitations(Travel__c t) {
		List<MealInvitation__c> invitations = [SELECT Id
											   FROM MealInvitation__c
											   WHERE mdr_Travel__c = :t.Id];
									 
		Boolean result = (invitations.size() == 2);
		
		return result;
	}
	
	
	private static Boolean hasNoExpenses(Travel__c t) {
		List<Expense__c> expenses = [SELECT Id
									 FROM Expense__c
									 WHERE mdr_Travel__c = :t.Id];
									 
		Boolean result = expenses.isEmpty();
		
		return result;
	}
	
	
	private static Boolean hasNoInvitations(Travel__c t) {
		List<MealInvitation__c> invitations = [SELECT Id
											   FROM MealInvitation__c
											   WHERE mdr_Travel__c = :t.Id];
											   
		Boolean result = invitations.isEmpty();
		
		return result;
	}
}