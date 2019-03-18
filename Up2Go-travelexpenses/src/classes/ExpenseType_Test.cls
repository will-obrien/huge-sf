@isTest
private class ExpenseType_Test {
	
	private static final Id FLIGHT_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'Flight'].Id;
	private static final Id TRAIN_RIDE_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'TrainRide'].Id;
	private static final Id SEA_TRAVEL_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'SeaTravel'].Id;
	private static final Id PRIVATE_VEHICLE_RIDE_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'PrivateVehicleRide'].Id;
	private static final Id COMPANY_VEHICLE_RIDE_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'CompanyVehicleRide'].Id;
	
	private static final Id RENTAL_VEHICLE_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'RentalVehicle'].Id;
	private static final Id ACCOMMODATION_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'Accommodation'].Id;
	private static final Id ENTERTAINMENT_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'Entertainment'].Id;
	private static final Id MISCELLANEOUS_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'Miscellaneous'].Id;
	
	private static final Id PER_DIEM_ID = [SELECT DeveloperName FROM RecordType WHERE DeveloperName = 'perDiem'].Id;

	static {
		CustomSettings.addDefault();
	}


	@isTest
	private static void findsRecordTypeIdsOfMovements() {
		
		//Setup
		Set<Id> movementSet = new Set<Id>();
		movementSet.add(FLIGHT_ID);
		movementSet.add(TRAIN_RIDE_ID);
		movementSet.add(SEA_TRAVEL_ID);
		movementSet.add(PRIVATE_VEHICLE_RIDE_ID);
		movementSet.add(COMPANY_VEHICLE_RIDE_ID);
		
		Expense__c flight = new Expense__c(RecordTypeId = FLIGHT_ID);
		Expense__c accommodation = new Expense__c(RecordTypeId = ACCOMMODATION_ID);
		
		
		//Excercise
		Set<Id> result = ExpenseType.getMovementRecordTypeIds();
		
		Boolean isMovement = ExpenseType.isMovement(flight);
		Boolean isNoMovement = ExpenseType.isMovement(accommodation);
		
		
		//Verify
		System.assertEquals(movementSet, result);
		System.assertEquals(true, isMovement);
		System.assertEquals(false, isNoMovement);
	}
	
	
	@isTest
	private static void findsRecordTypeIdOfFlight() {
		
		// Setup
		Expense__c flight = new Expense__c( RecordTypeId = FLIGHT_ID);
		
		
		// Exercise		
		Id returnedId = ExpenseType.getFlightRecordTypeId();
		Boolean isFlight = ExpenseType.isFlight(flight);
		
		
		// Verify 
		System.assertEquals(FLIGHT_ID, returnedId);
		System.assertEquals(true,isFlight);
	}
	
	
	@isTest
	private static void findsRecordTypeIdOfPrivateVehicleRide() {
		
		// Setup
		Expense__c privateVehicleRide = new Expense__c( RecordTypeId = PRIVATE_VEHICLE_RIDE_ID);
		
		
		// Exercise		
		Id returnedId = ExpenseType.getPrivateVehicleRecordTypeId();
		Boolean isPrivateVehicle = ExpenseType.isPrivateVehicle(privateVehicleRide);
		
		
		// Verify 
		System.assertEquals(PRIVATE_VEHICLE_RIDE_ID, returnedId);
		System.assertEquals(true,isPrivateVehicle);
	}
	
	
	@isTest
	private static void findsRecordTypeIdOfCompanyVehicleRide() {
			
		// Setup
		Expense__c companyVehicleRide = new Expense__c( RecordTypeId = COMPANY_VEHICLE_RIDE_ID);
		
			
		// Exercise		
		Id returnedId = ExpenseType.getCompanyVehicleRecordTypeId();
		Boolean isCompanyVehicle = ExpenseType.isCompanyVehicle(companyVehicleRide);
		
		
		// Verify 
		System.assertEquals(COMPANY_VEHICLE_RIDE_ID, returnedId);
		System.assertEquals(true,isCompanyVehicle);
	}
	
	
	@isTest
	private static void findsRecordTypeIdOfTrainRide() {
		
		// Setup
		Expense__c trainRide = new Expense__c( RecordTypeId = TRAIN_RIDE_ID);
		
				
		// Exercise		
		Id returnedId = ExpenseType.getTrainRideRecordTypeId();
		Boolean isTrainRide = ExpenseType.isTrainRide(trainRide);
		
		
		// Verify 
		System.assertEquals(TRAIN_RIDE_ID, returnedId);
		System.assertEquals(true,isTrainRide);
	}
	
	
	@isTest
	private static void findsRecordTypeIdOfRentalVehicle() {
				
		// Setup
		Expense__c rentalVehicle = new Expense__c( RecordTypeId = RENTAL_VEHICLE_ID);
		
		
		// Exercise		
		Id returnedId = ExpenseType.getRentalVehicleRecordTypeId();
		Boolean isRentalVehicle = ExpenseType.isRentalVehicle(rentalVehicle);
		
		
		// Verify 
		System.assertEquals(RENTAL_VEHICLE_ID, returnedId);
		System.assertEquals(true,isRentalVehicle);
	}
	
	
	@isTest
	private static void findsRecordTypeIdOfAccommodation() {
		
		// Setup
		Expense__c accommodation = new Expense__c( RecordTypeId = ACCOMMODATION_ID);
		
				
		// Exercise		
		Id returnedId = ExpenseType.getAccommodationRecordTypeId();
		Boolean isAccommodation = ExpenseType.isAccommodation(accommodation);
		
		
		// Verify 
		System.assertEquals(ACCOMMODATION_ID, returnedId);
		System.assertEquals(true,isAccommodation);
	}
	
	
	@isTest
	private static void findsRecordTypeIdOfEntertainment() {
		
		// Setup
		Expense__c entertainment = new Expense__c( RecordTypeId = ENTERTAINMENT_ID);
		
				
		// Exercise		
		Id returnedId = ExpenseType.getEntertainmentRecordTypeId();
		Boolean isEntertainment = ExpenseType.isEntertainment(entertainment);
		
		
		// Verify 
		System.assertEquals(ENTERTAINMENT_ID, returnedId);
		System.assertEquals(true,isEntertainment);
	}
	
	
	@isTest
	private static void findsRecordTypeIdOfMiscellaneous() {
		
		// Setup
		Expense__c miscellaneous = new Expense__c( RecordTypeId = MISCELLANEOUS_ID);
		
				
		// Exercise		
		Id returnedId = ExpenseType.getMiscellaneousRecordTypeId();
		Boolean isMiscellaneous = ExpenseType.isMiscellaneous(miscellaneous);
		
		
		// Verify 
		System.assertEquals(MISCELLANEOUS_ID, returnedId);
		System.assertEquals(true,isMiscellaneous);
	}
	
	
	@isTest
	private static void findsRecordTypeIdOfSeaTravel() {
		
		// Setup
		Expense__c seaTravel = new Expense__c( RecordTypeId = SEA_TRAVEL_ID);
		
				
		// Exercise		
		Id returnedId = ExpenseType.getSeaTravelRecordTypeId();
		Boolean isSeaTravel = ExpenseType.isSeaTravel(seaTravel);
		
		
		// Verify 
		System.assertEquals(SEA_TRAVEL_ID, returnedId);
		System.assertEquals(true,isSeaTravel);
	}
	
	
	@isTest
	private static void findsRecordTypeIdOfPerDiem() {
		
		// Setup
		Expense__c perDiem = new Expense__c( RecordTypeId = PER_DIEM_ID);		

		
		// Exercise		
		Id returnedId = ExpenseType.getPerDiemRecordTypeId();
		Boolean isPerDiem = ExpenseType.isPerDiem(perDiem);
		
		
		// Verify 
		System.assertEquals(PER_DIEM_ID, returnedId);
		System.assertEquals(true,isPerDiem);
	}
	
	
	@isTest
	private static void findsRecordTypeNamesById() {
		
		// Exercise
		String flight = ExpenseType.getRecordTypeName(FLIGHT_ID);
		String trainRide = ExpenseType.getRecordTypeName(TRAIN_RIDE_ID);
		String privateVehicleRide = ExpenseType.getRecordTypeName(PRIVATE_VEHICLE_RIDE_ID);
		String companyVehicleRide = ExpenseType.getRecordTypeName(COMPANY_VEHICLE_RIDE_ID);
		String seaTravel = ExpenseType.getRecordTypeName(SEA_TRAVEL_ID);
		
		String accommodation = ExpenseType.getRecordTypeName(ACCOMMODATION_ID);
		String rentalVehicle = ExpenseType.getRecordTypeName(RENTAL_VEHICLE_ID);
		String miscellaneous = ExpenseType.getRecordTypeName(MISCELLANEOUS_ID);
		String entertainment = ExpenseType.getRecordTypeName(ENTERTAINMENT_ID);
		
		String perDiem = ExpenseType.getRecordTypeName(PER_DIEM_ID);
		
		
		// Verify
		System.assertEquals('Flight', flight);
		System.assertEquals('TrainRide',trainRide);
		System.assertEquals('PrivateVehicleRide',privateVehicleRide);
		System.assertEquals('CompanyVehicleRide',companyVehicleRide);
		System.assertEquals('SeaTravel',seaTravel);
		
		System.assertEquals('Accommodation',accommodation);
		System.assertEquals('RentalVehicle',rentalVehicle);
		System.assertEquals('Miscellaneous',miscellaneous);
		System.assertEquals('Entertainment',entertainment);
		
		System.assertEquals('perDiem',perDiem);
	}
}