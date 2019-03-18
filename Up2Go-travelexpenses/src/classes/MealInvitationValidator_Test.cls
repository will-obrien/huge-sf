@isTest
private class MealInvitationValidator_Test {
	
	private static final Date DAY_TODAY = System.today();
	private static final Date DAY_TOMORROW = DAY_TODAY.addDays(1);
	private static final DateTime TODAY_NOW = System.now();
	private static final DateTime TOMORROW_NOW = TODAY_NOW.addDays(1);
	
	static {
		CustomSettings.addDefault();
	}

	
	@isTest
	private static void insertValidMealInvitations() {
		
		// Setup
		Exception unexpectedException;
		String message = '';
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW, TOMORROW_NOW);
		
		
		// Exercise
		try {
			builder.addMealInvitation(DAY_TODAY, true, true, true);
			builder.addMealInvitation(DAY_TOMORROW, false, false, false);
		}
		catch(DMLException ex) {
			unexpectedException = ex;
			message = unexpectedException.getStackTraceString();
		}
									
		
		// Verify
		System.assertEquals(null, unexpectedException, message);
	}
	
	
	@isTest
	private static void failsWhenMealInvitationIsOutsideOfTravelPeriod() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW,TOMORROW_NOW);
				
		
		// Exercise
		try {
			builder.addMealInvitation(DAY_TODAY.addDays(-1), false, false, true);
			builder.addMealInvitation(DAY_TOMORROW.addDays(1), true, true, false);
		}
		catch(DMLException ex) {
			expectedException = ex;
		}
									
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.MealInvitationCannotBeOutOfTravelPeriod);
	}
	
	
	@isTest
	private static void failsWhenThereIsAnotherMealInvitationOnSameDate() {
		
		// Setup
		Exception expectedException;
		
		TravelBuilder builder = new TravelBuilder(TODAY_NOW,TOMORROW_NOW);
		
		
		// Exercise
		try {
			builder.addMealInvitation(DAY_TODAY, false, false, true);
			builder.addMealInvitation(DAY_TODAY, true, true, false);
		}
		catch(DMLException ex) {
			expectedException = ex;
		}
									
		
		// Verify
		System.assertNotEquals(null, expectedException);
		assertThrowsMessage(System.Label.MealInvitationsCannotBeOnSameDay);
	}
	
	
	// TEST HELPER
	
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