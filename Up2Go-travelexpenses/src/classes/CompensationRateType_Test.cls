@isTest
private class CompensationRateType_Test {
	
	private static final Id LOCATION_ID = [SELECT Id FROM RecordType WHERE DeveloperName = 'Location'].Id;
	private static final Id VEHICLE_ID = [SELECT Id FROM RecordType WHERE DeveloperName = 'Vehicle'].Id;
	private static final Id MEAL_ID = [SELECT Id FROM RecordType WHERE DeveloperName = 'Meal'].Id;
	
	static {
		CustomSettings.addDefault();
	}
	
	
	@isTest
	private static void findsRecordTypeIdOfLocation() {
		
		//  Setup & Exercise
		Id foundId = CompensationRateType.getLocationId();
		
		
		// Verify
		System.assertEquals(LOCATION_ID, foundId);
	}
	
	
	@isTest
	private static void findsRecordTypeIdOfVehicle() {
		
		//  Setup & Exercise
		Id foundId = CompensationRateType.getVehicleId();
		
		
		// Verify
		System.assertEquals(VEHICLE_ID, foundId);
	}
	
	
	@isTest
	private static void findsRecordTypeIdOfMeal() {
		
		// Setup & Exercise
		Id foundId = CompensationRateType.getMealId();
		
		
		// Verify
		System.assertEquals(MEAL_ID, foundId);
	}
	
	
	@isTest
	private static void findsCompensationRateNameById() {
		
		// Setup & Exercise
		String location = CompensationRateType.getRecordTypeName(LOCATION_ID);
		String vehicle = CompensationRateType.getRecordTypeName(VEHICLE_ID);
		String meal = CompensationRateType.getRecordTypeName(MEAL_ID);
		String nothing = CompensationRateType.getRecordTypeName('012F0000001CV6VIAW');
		
		
		// Verify
		System.assertEquals('Location', location);
		System.assertEquals('Vehicle', vehicle);
		System.assertEquals('Meal', meal);
		System.assertEquals(null, nothing);
	}
}