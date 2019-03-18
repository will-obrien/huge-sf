@isTest
private class ExpensesTriggerHandler_Test {

	private static final DateTime TRAVEL_END = dateTime(System.today().addDays(3), Time.newInstance(20,00,00,00));
	private static final DateTime TRAVEL_BEGIN = dateTime(System.today(), Time.newInstance(12,00,00,00));
	
	static {
		CustomSettings.addDefault();
	}
	
	
	@isTest
	private static void populatesExpenseDateField() {
		
		// Setup
		Travel__c travel = new TravelBuilder(TRAVEL_BEGIN, TRAVEL_END)
		
		
		// Exercise
									.addDefaultFlight(TRAVEL_BEGIN,TRAVEL_BEGIN.addHours(3))
									.addDefaultAccommodation(TRAVEL_BEGIN.date(), TRAVEL_BEGIN.date().addDays(1))
									.addDefaultRentalVehicle(TRAVEL_BEGIN.date().addDays(1),TRAVEL_END.date())
									.create();
							
									
		// Verify
		Date flightExpenseDate = findFlightExpense(travel.Id).dat_ExpenseDate__c;
		Date accommodationExpenseDate = findAccommodationExpense(travel.Id).dat_ExpenseDate__c;
		Date rentalVehicleExpenseDate = findRentalVehicleExpense(travel.Id).dat_ExpenseDate__c;
		
		System.assertEquals(TRAVEL_BEGIN.date(), flightExpenseDate);
		System.assertEquals(TRAVEL_BEGIN.date().addDays(1), accommodationExpenseDate);
		System.assertEquals(TRAVEL_END.date(), rentalVehicleExpenseDate);
	}
	
	
	@isTest
	private static void populatesAmountField() {
		
		// Setup
		Travel__c travel = new TravelBuilder(TRAVEL_BEGIN, TRAVEL_END)
		
		
		// Exercise
									.addDefaultPrivateVehicleRide(TRAVEL_BEGIN, TRAVEL_BEGIN.addHours(5),100)
									.addDefaultEntertainment(TRAVEL_END.date(), 50, 20)
									.create();
									
									
		// Verify
		Decimal privateVehicleRideAmount = findPrivateVehicleRideExpense(travel.Id).cur_Amount__c;
		Decimal entertainmentAmount = findEntertainmentExpense(travel.Id).cur_Amount__c;
		
		System.assertEquals(30, privateVehicleRideAmount);
		System.assertEquals(70, entertainmentAmount);
	}
	
	
	@isTest
	private static void populatesReimbursementField() {
		
		// Setup
		Travel__c travel = new TravelBuilder(TRAVEL_BEGIN, TRAVEL_END)
		
		
		// Exercise
									 .addDefaultPrivateVehicleRide(TRAVEL_BEGIN, TRAVEL_BEGIN.addHours(5),100)
									 .addDefaultCompanyVehicleRide(TRAVEL_END.addHours(-2), TRAVEL_END)
									 .create();
									 
									 
		// Verify
		String privateVehicleReimbursement = findPrivateVehicleRideExpense(travel.Id).pkl_Reimbursement__c;
		String companyVehicleReimbursement = findCompanyVehicleRideExpense(travel.Id).pkl_Reimbursement__c;
		
		System.assertEquals('I paid for this, please reimburse me.', privateVehicleReimbursement);
		System.assertEquals('The company paid for this.', companyVehicleReimbursement);
	}
	
	
	// TEST HELPER
	
	private static DateTime dateTime(Date day, Time myTime) {
		DateTime result = DateTime.newInstance(day, myTime);
		
		return result;
	}
	
	
	private static Expense__c findFlightExpense(Id travelId) {
		Expense__c result = searchExpense(travelId, ExpenseType.getFlightRecordTypeId())[0];
		
		return result;
	}
	
	
	private static Expense__c findAccommodationExpense(Id travelId) {
		Expense__c result = searchExpense(travelId, ExpenseType.getAccommodationRecordTypeId())[0];
		
		return result;
	}
	
	
	private static Expense__c findRentalVehicleExpense(Id travelId) {
		Expense__c result = searchExpense(travelId, ExpenseType.getRentalVehicleRecordTypeId())[0];
		
		return result;
	}
	
	
	private static Expense__c findPrivateVehicleRideExpense(Id travelId) {
		Expense__c result = searchExpense(travelId, ExpenseType.getPrivateVehicleRecordTypeId())[0];
		
		return result;
	}
	
	
	private static Expense__c findEntertainmentExpense(Id travelId) {
		Expense__c result = searchExpense(travelId, ExpenseType.getEntertainmentRecordTypeId())[0];
		
		return result;
	}


	private static Expense__c findCompanyVehicleRideExpense(Id travelId) {
		Expense__c result = searchExpense(travelId, ExpenseType.getCompanyVehicleRecordTypeId())[0];
		
		return result;
	}
	
	
	private static List<Expense__c> searchExpense(Id travelId, Id recordTypeId) {
		List<Expense__c> results = [SELECT Id,RecordTypeId,dat_ExpenseDate__c,dtm_DepartureTime__c,dtm_ArrivalTime__c,
										   cur_Amount__c,lkp_ReturnTrip__c,chk_RoundTrip__c, pkl_Reimbursement__c
							 		FROM Expense__c
							 		WHERE RecordTypeId = :recordTypeId
							 		AND mdr_Travel__c = :travelId LIMIT 1];
		
		return results;
	}
}