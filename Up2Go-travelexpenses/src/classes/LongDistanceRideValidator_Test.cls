@isTest
private class LongDistanceRideValidator_Test {
	
	private static final Date TODAY = System.Today();
	private static final Date TOMORROW = System.Today().addDays(1);
	private static final Date DAY_AFTER_TOMORROW = System.Today().addDays(2);
	
	private static final DateTime TODAY_TEN_AM = dateTime(TODAY, 10,00);
	private static final DateTime TODAY_ONE_PM = dateTime(TODAY, 13,00);
	private static final DateTime TODAY_THREE_PM = dateTime(TODAY, 15,00);
	private static final DateTime TODAY_FIVE_PM = dateTime(TODAY, 17,00);
	private static final DateTime TOMORROW_ELEVEN_AM = dateTime(TOMORROW, 11,00);
	private static final DateTime TOMORROW_FOUR_PM = dateTime(TOMORROW, 16,00);
	private static final DateTime DAY_AFTER_TOMORROW_NINE_AM = dateTime(DAY_AFTER_TOMORROW, 09,00);
	private static final DateTime DAY_AFTER_TOMORROW_EIGHT_PM = dateTime(DAY_AFTER_TOMORROW, 20,00);
	
	static {
		CustomSettings.addDefault();
	}
	
	
	// TESTING: LongDistanceRideCannotEndBeforeStart
	
	@isTest
	private static void failsWhenLongDistanceRideEndsBeforeItStarts() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_TEN_AM,TOMORROW_FOUR_PM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithLongDistanceRide(TODAY, TOMORROW, 
														 TODAY_ONE_PM, TODAY_TEN_AM);
		}
		catch(Exception ex) {
			expectedException = ex;
		}

		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.RideCannotEndBeforeStart);
	}
	
	
	@isTest
	private static void failsWhenRoundTripEndsBeforeItStarts() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_TEN_AM,TOMORROW_FOUR_PM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithRoundTripLongDistanceRide(TODAY, TOMORROW, 
																  TODAY_TEN_AM, TODAY_ONE_PM, 
																  TOMORROW_FOUR_PM, TOMORROW_ELEVEN_AM);
		}
		catch(Exception ex) {
			expectedException = ex;
		}

		
		// Verify
		System.assertNotEquals(null,expectedException);
		assertThrowsMessage(System.Label.RideCannotEndBeforeStart);
	}
	
	
	// TESTING: LongDistanceRideCannotBeOutOfRental
	
	@isTest
	private static void failsWhenLongDistanceRideIsOutsideOfRentalPeriod() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_TEN_AM, DAY_AFTER_TOMORROW_EIGHT_PM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithLongDistanceRide(TODAY, TOMORROW, 
														 TODAY_ONE_PM, DAY_AFTER_TOMORROW_NINE_AM);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.RideCannotBeOutsideOfRental);
	}
	
	
	@isTest
	private static void failsWhenRoundTripIsOutsideOfRentalPeriod() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_TEN_AM, DAY_AFTER_TOMORROW_EIGHT_PM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithRoundTripLongDistanceRide(TODAY, TOMORROW, 
																  TODAY_TEN_AM, TODAY_ONE_PM, 
																  TOMORROW_FOUR_PM, DAY_AFTER_TOMORROW_NINE_AM);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.RideCannotBeOutsideOfRental);
	}
	
	
	// TESTING: LongDistanceRidesDontOverlap
	
	@isTest
	private static void failsWhenLongDistanceRideOverlapsWithAnotherMovement() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_TEN_AM, TOMORROW_FOUR_PM);
		
		
		// Exercise
		try {
			builder.addDefaultFlight(TODAY_TEN_AM, TODAY_ONE_PM);										 
			builder.addRentalVehicleWithLongDistanceRide(TODAY, TOMORROW, 
														 TODAY_TEN_AM, TOMORROW_ELEVEN_AM);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null,expectedException);
		assertThrowsMessage(System.Label.RidesDontOverlap);
	}
	
	
	@isTest
	private static void failsWhenLongDistanceRideOverlapsWithAnotherOne() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_TEN_AM, TOMORROW_FOUR_PM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithTwoLongDistanceRides(TODAY, TOMORROW, 
															 TODAY_TEN_AM,TOMORROW_ELEVEN_AM, 
															 TODAY_ONE_PM, TOMORROW_FOUR_PM);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.RidesDontOverlap);
	}
	
	
	@isTest
	private static void failsWhenLongDistanceRideOverlapsWithOwnRoundTrip() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_TEN_AM, TOMORROW_FOUR_PM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithRoundTripLongDistanceRide(TODAY, TOMORROW, 
																  TODAY_TEN_AM, TOMORROW_ELEVEN_AM, 
																  TODAY_ONE_PM, TOMORROW_FOUR_PM);
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
		
		TravelBuilder builder = new TravelBuilder(TODAY_TEN_AM, TOMORROW_FOUR_PM);
		
		
		// Exercise
		try {
			builder.addDefaultFlight(TOMORROW_ELEVEN_AM, TOMORROW_FOUR_PM);										 
			builder.addRentalVehicleWithRoundTripLongDistanceRide(TODAY, TOMORROW, 
																  TODAY_TEN_AM, TODAY_ONE_PM, 
																  TOMORROW_ELEVEN_AM, TOMORROW_FOUR_PM);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.RidesDontOverlap);
	}
	
	
	@isTest
	private static void failsWhenRoundTripOverlapsWithAnotherLongDistanceRide() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_TEN_AM, TOMORROW_FOUR_PM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithLongDistanceRide(TOMORROW, TOMORROW, 
														 TOMORROW_ELEVEN_AM, TOMORROW_FOUR_PM);										 
			builder.addRentalVehicleWithRoundTripLongDistanceRide(TODAY, TOMORROW, 
																  TODAY_TEN_AM, TODAY_ONE_PM, 
																  TOMORROW_ELEVEN_AM, TOMORROW_FOUR_PM);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.RidesDontOverlap);
	}
	
	
	@isTest
	private static void failsWhenRoundTripOverlapsWithAnotherRoundTrip() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_TEN_AM, TOMORROW_FOUR_PM);
		
		
		// Exercise
		try {
			builder.addRoundFlight(TODAY_TEN_AM, TODAY_ONE_PM, 
								   TOMORROW_ELEVEN_AM, TOMORROW_FOUR_PM);
			builder.addRentalVehicleWithRoundTripLongDistanceRide(TODAY, TOMORROW, 
																  TODAY_THREE_PM, TODAY_FIVE_PM, 
																  TOMORROW_ELEVEN_AM, TOMORROW_FOUR_PM);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.RidesDontOverlap);
	}
	
	
	// TESTING: LongDistanceRideHasValidLocation
	
	@isTest
	private static void failsWhenLongDistanceRideHasInvalidLocation() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_TEN_AM, TOMORROW_FOUR_PM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithLongDistanceRideWithoutLocation(TODAY, TOMORROW, 
																		TODAY_TEN_AM, TOMORROW_FOUR_PM);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.InvalidLocation);
	}


	// TESTING: LongDistanceRideCannotBeOutsideOfTravel
	
	@isTest
	private static void failsWhenLongDistanceRideIsOutsideOfTravelPeriod() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_TEN_AM, TOMORROW_ELEVEN_AM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithLongDistanceRide(TODAY, TOMORROW, 
														 TODAY_TEN_AM, TOMORROW_FOUR_PM);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.RidesCannotBeOutsideOfTravel);
	}
	
	
	@isTest
	private static void failsWhenRoundTripIsOutsideOfTravelPeriod() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_TEN_AM, TOMORROW_FOUR_PM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithRoundTripLongDistanceRide(TODAY, TOMORROW, 
																  TODAY_TEN_AM, TODAY_ONE_PM, 
																  TOMORROW_ELEVEN_AM, DAY_AFTER_TOMORROW_NINE_AM);
		}
		catch(Exception ex) {
			expectedException = ex;
		}
		
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.RidesCannotBeOutsideOfTravel);
	}
	
	
	// TESTING: LongDistanceRideNeedsReturnInfoWhenRT
	
	@isTest
	private static void failsWhenRoundTripInformationIsMissing() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_TEN_AM, TOMORROW_FOUR_PM);
		
		
		// Exercise
		try {
			builder.addRentalVehicleWithRoundTripLongDistanceRide(TODAY, TOMORROW, 
																  TODAY_TEN_AM, TODAY_ONE_PM, 
																  null, null);
		}
		catch(Exception ex) {
			expectedException = ex;
		}						
			
									
		// Verify	
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.YouMustEnterValue);
	}
	
	
	// TEST HELPER
	
	private static DateTime dateTime(Date day, Integer hour, Integer minute) {
		Time t = Time.newInstance(hour, minute, 0,0);
		DateTime result = DateTime.newInstance(day, t);
		
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