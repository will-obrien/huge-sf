@isTest
private class ExpenseValidator_Test {
	
	static {
		CustomSettings.addDefault();
	}
	
	private static final Date TRAVEL_BEGIN = System.today();
	
	private static final DateTime BEGIN_ONE_AM = dateTime(TRAVEL_BEGIN, Time.newInstance(01,00,00,00));
	private static final DateTime BEGIN_TWO_AM = dateTime(TRAVEL_BEGIN, Time.newInstance(02,00,00,00));
	private static final DateTime BEGIN_FIVE_AM = dateTime(TRAVEL_BEGIN, Time.newInstance(05,00,00,00));
	private static final DateTime BEGIN_SIX_AM = dateTime(TRAVEL_BEGIN, Time.newInstance(06,00,00,00));
	
	
	// TESTING: ExpenseCannotBeOutsideOFTravelPeriod
	
	@isTest
	private static void failsWhenFlightIsOutsideOfTravelPeriod() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addDefaultFlight(BEGIN_FIVE_AM.addDays(-1), BEGIN_SIX_AM.addDays(1));
		}	
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpenseCannotBeOutsideOFTravelPeriod);
	}

	
	@isTest
	private static void failsWhenMiscellaneousIsOutsideOfTravelPeriod() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
						
										 
		// Exercise
		try {
			builder.addDefaultMiscellaneousExpense(TRAVEL_BEGIN.addDays(1));
		}	
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpenseCannotBeOutsideOFTravelPeriod);
	}	

	
	@isTest
	private static void failsWhenAccommodationOutsideOfTravelPeriod() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addDefaultAccommodation(TRAVEL_BEGIN.addDays(-1), TRAVEL_BEGIN.addDays(1));
		}	
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpenseCannotBeOutsideOFTravelPeriod);
	}	

	
	@isTest
	private static void failsWhenRentalVehicleExpenseIsOutsideOfTravelPeriod() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addDefaultRentalVehicle(TRAVEL_BEGIN.addDays(-1), TRAVEL_BEGIN.addDays(1));
		}	
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpenseCannotBeOutsideOFTravelPeriod);
	}
	
	
	@isTest
	private static void failsWhenRoundTripIsOutsideOfTravelPeriod() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addRoundFlight(BEGIN_ONE_AM, BEGIN_SIX_AM, BEGIN_SIX_AM.addHours(1), BEGIN_SIX_AM.addHours(2));
		}	
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpenseCannotBeOutsideOFTravelPeriod);		
	}
	

	// TESTING: ExpenseCannotEndBeforeStart
	
	@isTest
	private static void failsWhenMovmentEndsBeforeItStarts() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM.addDays(-1), BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addDefaultFlight(BEGIN_SIX_AM, BEGIN_FIVE_AM);
		}
		catch(Exception ex) {
			expectedException = ex;
		}

		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpenseCannotEndBeforeStart);
	}
	
	
	@isTest
	private static void failsWhenAccommodationEndsBeforeItStarts() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM.addDays(-1), BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addDefaultAccommodation(TRAVEL_BEGIN, TRAVEL_BEGIN.addDays(-1));
		}
		catch(Exception ex) {
			expectedException = ex;
		}

		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpenseCannotEndBeforeStart);
	}
	
	
	@isTest
	private static void failsWhenRentalVehicleExpenseEndsBeforeItStarts() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM.addDays(-1), BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addDefaultRentalVehicle(TRAVEL_BEGIN, TRAVEL_BEGIN.addDays(-1));
		}
		catch(Exception ex) {
			expectedException = ex;
		}

		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpenseCannotEndBeforeStart);
	}
	
	
	@isTest
	private static void failsWhenRoundTripEndsBeforeItStarts() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addRoundFlight(BEGIN_ONE_AM, BEGIN_TWO_AM, BEGIN_SIX_AM, BEGIN_FIVE_AM);
		}	
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpenseCannotEndBeforeStart);		
	}	

	
	// TESTING ExpenseHasValidLocation
	
	@isTest
	private static void failsWhenMovementExpenseHasInvalidLocation() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addDefaultFlightWithoutLocation(BEGIN_FIVE_AM,BEGIN_SIX_AM);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.InvalidLocation);
	}

	
	@isTest
	private static void failsWhenAccommodationHasInvalidLocation() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM.addDays(1));
		
		
		// Exercise
		try {
			builder.addAccommodationWithoutLocation(TRAVEL_BEGIN,TRAVEL_BEGIN.addDays(1));
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.InvalidLocation);
	}	
	
	
	@isTest
	private static void failsWhenEntertainmentExpenseHasInvalidLocation() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM.addDays(1));
		
		
		// Exercise
		try {
			builder.addEntertainmentWithoutLocation(TRAVEL_BEGIN);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.InvalidLocation);
	}
	
	
	// TESTING ExpenseNeedsReturnInformationIfRoundTrip
	
	@isTest
	private static void failsWhenRoundTripInformationIsMissing() {

		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addRoundFlight(BEGIN_TWO_AM, BEGIN_FIVE_AM, null, null);
		}
		catch(Exception ex) {
			expectedException = ex;
		}						
			
									
		// Verify	
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.YouMustEnterValue);
	}				
	
	
	// TESTING ExpensesDontOverlap
	
	@isTest
	private static void failsWhenExpensesOverlapAtTheBeginning() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithLongDistanceRide(TRAVEL_BEGIN, TRAVEL_BEGIN, BEGIN_TWO_AM, BEGIN_SIX_AM);
			builder.addDefaultFlight(BEGIN_ONE_AM, BEGIN_FIVE_AM);										 
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpensesDontOverlap);
	}


	@isTest
	private static void failsWhenExpensesOverlapAtTheEnd() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithLongDistanceRide(TRAVEL_BEGIN,TRAVEL_BEGIN,BEGIN_ONE_AM,BEGIN_FIVE_AM);
			builder.addDefaultFlight(BEGIN_TWO_AM, BEGIN_SIX_AM);	
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpensesDontOverlap);
	}
	
	
	@isTest
	private static void failsWhenAnExpenseContainsAnotherExpense() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithLongDistanceRide(TRAVEL_BEGIN,TRAVEL_BEGIN,BEGIN_ONE_AM,BEGIN_SIX_AM);
  			builder.addDefaultFlight(BEGIN_TWO_AM, BEGIN_FIVE_AM);										 
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpensesDontOverlap);
	}

	
	@isTest
	private static void failsWhenAnExpenseIsContainedByAnotherExpense() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithLongDistanceRide(TRAVEL_BEGIN,TRAVEL_BEGIN,BEGIN_TWO_AM,BEGIN_FIVE_AM);
			builder.addDefaultFlight(BEGIN_ONE_AM, BEGIN_SIX_AM);									  
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpensesDontOverlap);
	}


	@isTest
	private static void failsWhenMovementOverlapsWithOwnRoundTrip() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addRoundFlight(BEGIN_ONE_AM, BEGIN_FIVE_AM, BEGIN_TWO_AM, BEGIN_SIX_AM);
		}	
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.OutwardTripOverlapsWithReturnTrip);
	}
	
	
	@isTest
	private static void failsWhenRoundTripOverlapsWithAnotherMovement() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addDefaultCompanyVehicleRide(BEGIN_TWO_AM.addHours(2), BEGIN_SIX_AM);
			builder.addRoundFlight(BEGIN_ONE_AM, BEGIN_TWO_AM, BEGIN_FIVE_AM, BEGIN_SIX_AM);
		}	
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpensesDontOverlap);
	}
	
	
	@isTest
	private static void failsWhenRoundTripOverlapsWithALongDistanceRide() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithLongDistanceRide(TRAVEL_BEGIN, TRAVEL_BEGIN, BEGIN_TWO_AM.addHours(2), BEGIN_SIX_AM);
			builder.addRoundFlight(BEGIN_ONE_AM, BEGIN_TWO_AM, BEGIN_FIVE_AM, BEGIN_SIX_AM);
		}	
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpensesDontOverlap);
	}
	
	
	@isTest
	private static void failsWhenRoundTripOverlapsWithAnotherRoundTrip() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithRoundTripLongDistanceRide(TRAVEL_BEGIN, TRAVEL_BEGIN, BEGIN_ONE_AM, BEGIN_TWO_AM, BEGIN_FIVE_AM, BEGIN_SIX_AM);
			builder.addRoundFlight(BEGIN_TWO_AM.addHours(1), BEGIN_TWO_AM.addHours(2), BEGIN_FIVE_AM, BEGIN_SIX_AM);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.ExpensesDontOverlap);
	}
	
	
	// TESTING: ExpenseAmountCannotBeNegative
		
	@isTest
	private static void failsWhenAmountIsNegative() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addCustomFlightWithAmount(BEGIN_ONE_AM,BEGIN_SIX_AM,-30);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null,expectedException);
		assertThrowsMessage(System.Label.ExpenseAmountCannotBeNegative);
	}
	
	
	@isTest
	private static void failsWhenAmountOfEntertainmentIsNegative() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(BEGIN_ONE_AM, BEGIN_SIX_AM);
		
		
		// Exercise
		try {
			builder.addDefaultEntertainment(TRAVEL_BEGIN,-50,-30);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null,expectedException);
		assertThrowsMessage(System.Label.ExpenseAmountCannotBeNegative);
	}
	
	
	//TEST HELPER
	private static DateTime dateTime(Date day, Time myTime) {
		DateTime result = DateTime.newInstance(day,myTime);
		
		return result;
	}
	
	
	private static void assertThrowsMessage(String errorMessage) {
		Boolean result = false;
		
		for(ApexPages.Message m : ApexPages.getMessages()) {
			if(m.getDetail().equals(errorMessage)) {
				result = true;
			}
		}
		
		System.assert(result);
	}
}