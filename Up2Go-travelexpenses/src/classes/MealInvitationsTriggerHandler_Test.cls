@isTest
private class MealInvitationsTriggerHandler_Test {
	
	private static final Date DAY_TODAY = System.today();
	private static final Date DAY_TOMORROW = DAY_TODAY.addDays(1);
	private static final DateTime TODAY_NOW = System.now();
	private static final DateTime TOMORROW_NOW = TODAY_NOW.addDays(1);
	
	static {
		CustomSettings.addDefault();
	}

	
	@isTest
	private static void populateLookupFields() {
		
		// Setup
		Exception unexpectedException;
		
		String message = '';
		
		Travel__c travel;
		
		
		// Exercise
		try {
			travel = new TravelBuilder(TODAY_NOW, TOMORROW_NOW)
										.addMealInvitation(DAY_TODAY, true, true, true)
										.addMealInvitation(DAY_TOMORROW, false, false, false)
										.create();
		}
		catch(DMLException e) {
			unexpectedException = e;
			message = unexpectedException.getStackTraceString();
		}
									
		
		// Verify
		System.assertEquals(null, unexpectedException, message);
		assertAllFieldsHaveLookups(travel, DAY_TODAY);
		assertNoFieldsHaveLookups(travel, DAY_TOMORROW);
	}
	
	
	// TEST HELPER
	
	private static void assertAllFieldsHaveLookups(Travel__c travel, Date day) {
		MealInvitation__c meal = [SELECT Id, lkp_Breakfast__c, lkp_Lunch__c, lkp_Dinner__c, dat_Day__c, mdr_Travel__c
								  FROM MealInvitation__c
								  WHERE mdr_Travel__c = :travel.Id
								  AND dat_Day__c = :day];
		
		System.assertNotEquals(null, meal.lkp_Breakfast__c);
		System.assertNotEquals(null, meal.lkp_Lunch__c);
		System.assertNotEquals(null, meal.lkp_Dinner__c);
	}
	
	
	private static void assertNoFieldsHaveLookups(Travel__c travel, Date day) {
		MealInvitation__c meal = [SELECT Id,lkp_Breakfast__c,lkp_Lunch__c,lkp_Dinner__c,dat_Day__c,mdr_Travel__c
								  FROM MealInvitation__c
								  WHERE mdr_Travel__c = :travel.Id
								  AND dat_Day__c = :day];
		
		System.assertEquals(null, meal.lkp_Breakfast__c);
		System.assertEquals(null, meal.lkp_Lunch__c);
		System.assertEquals(null, meal.lkp_Dinner__c);
	}
}