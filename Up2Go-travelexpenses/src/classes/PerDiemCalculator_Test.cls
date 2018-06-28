@isTest
private class PerDiemCalculator_Test {
	
	private static final Date DAY_TODAY = System.today();
	private static final Date DAY_TOMORROW = DAY_TODAY.addDays(1);
	private static final Date DAY_AFTER_TOMORROW = DAY_TODAY.addDays(2);
	private static final Date ONE_WEEK_FROM_TODAY = DAY_TODAY.addDays(7);
	
	private static final DateTime TODAY_START = dateTime(DAY_TODAY, Time.newInstance(00,00,00,00));
	private static final DateTime TODAY_SEVEN_AM = dateTime(DAY_TODAY, Time.newInstance(07,00,00,00));
	private static final DateTime TODAY_TEN_AM = dateTime(DAY_TODAY, Time.newInstance(10,00,00,00));
	private static final DateTime TODAY_TWELVE_AM = dateTime(DAY_TODAY,Time.newInstance(12,00,00,00));
	private static final DateTime TODAY_FOUR_PM = dateTime(DAY_TODAY, Time.newInstance(16,00,00,00));
	private static final DateTime TODAY_EIGHT_PM = dateTime(DAY_TODAY, Time.newInstance(20,00,00,00));
	private static final DateTime TODAY_END = dateTime(DAY_TODAY, Time.newInstance(23,59,59,00));

	private static final DateTime TOMORROW_START = dateTime(DAY_TOMORROW, Time.newInstance(00,00,00,00));
	private static final DateTime TOMORROW_THREE_AM = dateTime(DAY_TOMORROW, Time.newInstance(03,00,00,00));
	private static final DateTime TOMORROW_SEVEN_AM = dateTime(DAY_TOMORROW, Time.newInstance(07,00,00,00));
	private static final DateTime TOMORROW_TWELVE_AM = dateTime(DAY_TOMORROW, Time.newInstance(12,00,00,00));
	private static final DateTime TOMORROW_FOUR_PM = dateTime(DAY_TOMORROW, Time.newInstance(16,00,00,00));
	private static final DateTime TOMORROW_SIX_PM = dateTime(DAY_TOMORROW, Time.newInstance(18,00,00,00));
	private static final DateTime TOMORROW_EIGHT_PM = dateTime(DAY_TOMORROW, Time.newInstance(20,00,00,00));
	private static final DateTime TOMORROW_END = dateTime(DAY_TOMORROW, Time.newInstance(23,59,59,00));
	
	private static final DateTime DAY_AFTER_TOMORROW_START = dateTime(DAY_AFTER_TOMORROW, Time.newInstance(00,00,00,00));
	private static final DateTime DAY_AFTER_TOMORROW_TWELVE_AM = dateTime(DAY_AFTER_TOMORROW, Time.newInstance(12,00,00,00));
	private static final DateTime DAY_AFTER_TOMORROW_SIX_PM = dateTime(DAY_AFTER_TOMORROW, Time.newInstance(18,00,00,00));
	
	private static final DateTime ONE_WEEK_FROM_TODAY_TWELVE_AM = dateTime(ONE_WEEK_FROM_TODAY, Time.newInstance(12,00,00,00));
	private static final DateTime ONE_WEEK_FROM_TODAY_FOUR_PM = dateTime(ONE_WEEK_FROM_TODAY, Time.newInstance(16,00,00,00));
	
	private static Map<Date, Expense__c> expectedPerDiems; 
	private static Map<Date, Expense__c> actualPerDiems;
	
	static {
		CustomSettings.addDefault();
	}
		

	@isTest
	private static void calcualtesNoReimbursementForLessThanEightHourTravel() {
		
		// Setup & Exercise
		CompensationRate__c start = insertCustomLocation('Startland', 'Startland', null, 'sl', 50, 25, 60);
		CompensationRate__c destination = insertDefaultLocation();
		
		Travel__c travel = new TravelBuilder(TODAY_SEVEN_AM,TODAY_TWELVE_AM)
									.addCustomFlightWithLocation(TODAY_SEVEN_AM,TODAY_TEN_AM,start,destination)
									.addCustomFlightWithLocation(TODAY_TEN_AM.addHours(1),TODAY_TWELVE_AM,destination,start)
									.create();
					
		
		// Verify
		Decimal expectedAmount = 0.00;
		
		Expense__c expectedPerDiem = perDiemExpense(TODAY_SEVEN_AM, TODAY_TWELVE_AM, destination, expectedAmount);
		
		actualPerDiems = getActualPerDiems(travel);
		
		System.assertEquals(1, actualPerDiems.size());
		assertHaveEqualValues(expectedPerDiem, actualPerDiems.get(DAY_TODAY));
	}

	
	@isTest
	private static void calculatesNoReimbursementForOvernightTravelShorterThanEightHours() {
		
		// Setup & Exercise 
		CompensationRate__c start = insertCustomLocation('Startland', 'Startland', null, 'SL', 50, 25, 60);
		CompensationRate__c destination = insertDefaultLocation();
		
		Travel__c travel = new TravelBuilder(TODAY_EIGHT_PM, TOMORROW_THREE_AM)
									.addCustomFlightWithLocation(TODAY_EIGHT_PM,TODAY_END,start,destination)
									.addCustomFlightWithLocation(TOMORROW_START,TOMORROW_THREE_AM,destination,start)
									.create();
									
									
		// Verify
		Decimal expectedAmount = 0.00;
		
		Expense__c expectedPerDiem = perDiemExpense(TODAY_EIGHT_PM,TOMORROW_THREE_AM,destination,expectedAmount);
		
		actualPerDiems = getActualPerDiems(travel);
		
		System.assertEquals(1, actualPerDiems.size());
		assertHaveEqualValues(expectedPerDiem, actualPerDiems.get(DAY_TODAY));			
	}
	
	
	@isTest
	private static void calculatesJustOnePerDiemForOvernightTravel() {
		
		// Setup & Exercise
		CompensationRate__c start = insertCustomLocation('Startland', 'Startland', null, 'SL', 50, 25, 60);
		CompensationRate__c destination = insertDefaultLocation();
		
		Travel__c travel = new TravelBuilder(TODAY_TWELVE_AM, TOMORROW_TWELVE_AM)
									.addCustomFlightWithLocation(TODAY_TWELVE_AM,TODAY_EIGHT_PM,start,destination)
									.addCustomTrainRideWithLocation(TOMORROW_SEVEN_AM,TOMORROW_TWELVE_AM,destination,start)
									.create();
									
									
		// Verify
		Decimal expectedAmount = destination.cur_PartialDailyRate__c;
		Expense__c expectedPerDiem = perDiemExpense(TODAY_TWELVE_AM, TOMORROW_TWELVE_AM, destination, expectedAmount);
		
		actualPerDiems = getActualPerDiems(travel);
		
		System.assertEquals(1 , actualPerDiems.size());
		assertHaveEqualValues(expectedPerDiem, actualPerDiems.get(DAY_TODAY));
	}
	
	
	@isTest
	private static void calculatesPerDiemsForTwoDayTravelWithLocationChange() {
		
		// Setup & Exercise
		CompensationRate__c start = insertCustomLocation('Startland', 'Startland', null, 'SL', 50, 25, 60);
		CompensationRate__c firstDestination = insertDefaultLocation();
		CompensationRate__c secondDestination = insertCustomLocation('Land 2', 'Land 2', null, 'L2', 50, 25, 90);
		CompensationRate__c thirdDestination = insertCustomLocation('Land 3', 'Land 3', null, 'L3',  60,30,100);
		CompensationRate__c fourthDestination = insertCustomLocation('Land 4', 'Land 4', null, 'L4',  70,35,110);
		
		Travel__c travel = new TravelBuilder(TODAY_SEVEN_AM,TOMORROW_END)
									.addCustomFlightWithLocation(TODAY_SEVEN_AM,TODAY_TWELVE_AM,start,firstDestination)
									.addCustomTrainRideWithLocation(TODAY_FOUR_PM,TODAY_EIGHT_PM,firstDestination,secondDestination)
									.addCustomAccommodationWithLocation(DAY_TODAY,DAY_TOMORROW,secondDestination)
									.addCustomTrainRideWithLocation(TOMORROW_TWELVE_AM,TOMORROW_SIX_PM,secondDestination,thirdDestination)
									.addCustomFlightWithLocation(TOMORROW_EIGHT_PM,TOMORROW_END,thirdDestination,fourthDestination)
									.create();
									
									
		//Verify
		Decimal expectedAmount = secondDestination.cur_PartialDailyRate__c;
		
		expectedPerDiems = new Map<Date, Expense__c>();
		expectedPerDiems.put(DAY_TODAY, perDiemExpense(TODAY_SEVEN_AM, TODAY_END,secondDestination,expectedAmount));
		expectedPerDiems.put(DAY_TOMORROW, perDiemExpense(TOMORROW_START,TOMORROW_END,secondDestination,expectedAmount));
			
		actualPerDiems = getActualPerDiems(travel);
		
		System.assertEquals(2, actualPerDiems.size());
		assertHaveEqualValues(expectedPerDiems.get(DAY_TODAY), actualPerDiems.get(DAY_TODAY));
		assertHaveEqualValues(expectedPerDiems.get(DAY_TOMORROW), actualPerDiems.get(DAY_TOMORROW));							
	}
	
	
	@isTest
	private static void calculatesPerDiemsForThreeDayTravelWithLocationChange() {
		
		// Setup & Exercise
		CompensationRate__c start = insertCustomLocation('Startland', 'Startland', null, 'SL', 50, 25, 60);
		CompensationRate__c firstDestination = insertDefaultLocation();
		CompensationRate__c secondDestination = insertCustomLocation('Land 2', 'Land 2', null, 'L2', 70, 35, 90);
			
		Travel__c travel = new TravelBuilder(TODAY_FOUR_PM,DAY_AFTER_TOMORROW_SIX_PM)
									.addCustomFlightWithLocation(TODAY_FOUR_PM,TODAY_EIGHT_PM,start,firstDestination)
									.addCustomFlightWithLocation(TOMORROW_SEVEN_AM,TOMORROW_TWELVE_AM,firstDestination,secondDestination)
									.addCustomTrainRideWithLocation(DAY_AFTER_TOMORROW_TWELVE_AM,DAY_AFTER_TOMORROW_SIX_PM,secondDestination,start)
									.create();
									
									
		// Verify		
		Decimal firstPartial = firstDestination.cur_PartialDailyRate__c;
		Decimal secondFull = secondDestination.cur_FullDailyRate__c;
		Decimal secondPartial = secondDestination.cur_PartialDailyRate__c;
		
		expectedPerDiems = expectedPerDiems = new Map<Date, Expense__c>();
		expectedPerDiems.put(DAY_TODAY, perDiemExpense(TODAY_FOUR_PM, TODAY_END, firstDestination, firstPartial));		
		expectedPerDiems.put(DAY_TOMORROW, perDiemExpense(TOMORROW_START,TOMORROW_END,secondDestination,secondFull));		
		expectedPerDiems.put(DAY_AFTER_TOMORROW, perDiemExpense(DAY_AFTER_TOMORROW_START,DAY_AFTER_TOMORROW_SIX_PM,secondDestination,secondPartial));
		
		actualPerDiems = getActualPerDiems(travel);
		
		System.assertEquals(3, actualPerDiems.size());
		assertHaveEqualValues(expectedPerDiems.get(DAY_TODAY), actualPerDiems.get(DAY_TODAY));
		assertHaveEqualValues(expectedPerDiems.get(DAY_TOMORROW), actualPerDiems.get(DAY_TOMORROW));
		assertHaveEqualValues(expectedPerDiems.get(DAY_AFTER_TOMORROW), actualPerDiems.get(DAY_AFTER_TOMORROW));
	}
	
	
	@isTest
	private static void calculatesPerDiemsWithMealInvitationDeduction() {
		
		// Setup & Exercise
		CompensationRate__c location = insertCustomLocation('Land1', 'Land1', null, 'L1', 50, 25, 60);
		
		Travel__c travel = new TravelBuilder(TODAY_TWELVE_AM,DAY_AFTER_TOMORROW_SIX_PM)
									.addMealInvitation(DAY_TODAY,false,false,true)
									.addMealInvitation(DAY_TOMORROW,true,true,true)
									.addMealInvitation(DAY_AFTER_TOMORROW,true,true,false)
									.addCustomFlightWithLocation(TODAY_TWELVE_AM, TODAY_FOUR_PM,location,location)
									.addCustomTrainRideWithLocation(DAY_AFTER_TOMORROW_TWELVE_AM,DAY_AFTER_TOMORROW_SIX_PM,location,location)
									.create();
									
		
		// Verify
		actualPerDiems = getActualPerDiems(travel);
		
		System.assertEquals(5, actualPerDiems.get(DAY_TODAY).cur_Amount__c);
		System.assertEquals(0, actualPerDiems.get(DAY_TOMORROW).cur_Amount__c);
		System.assertEquals(0, actualPerDiems.get(DAY_AFTER_TOMORROW).cur_Amount__c);
	}
	
	
	@isTest
	private static void calculatesEightPerDiemsForOneWeekTravel() {
		
		// Setup & Exercise	
		CompensationRate__c start = insertCustomLocation('Startland', 'Startland', null, 'SL', 50, 25, 60);
		CompensationRate__c location1 = insertDefaultLocation();
			
		Travel__c travel = new TravelBuilder(TODAY_TWELVE_AM, ONE_WEEK_FROM_TODAY_FOUR_PM)
									.addCustomFlightWithLocation(TODAY_TWELVE_AM, TODAY_FOUR_PM,start,location1)
									.addCustomAccommodationWithLocation(DAY_TODAY, ONE_WEEK_FROM_TODAY, location1)
									.addCustomTrainRideWithLocation(ONE_WEEK_FROM_TODAY_TWELVE_AM, ONE_WEEK_FROM_TODAY_FOUR_PM,location1,start)
									.create();	
	
		
		// Verify
		actualPerDiems = getActualPerDiems(travel);
		
		System.assertEquals(8, actualPerDiems.size());
		System.assertEquals(actualPerDiems.get(DAY_TODAY).lkp_Location__r.Name, 'Land');
		
		System.assertEquals(20.00, actualPerDiems.get(DAY_TODAY).cur_Amount__c);
		System.assertEquals(40.00, actualPerDiems.get(DAY_AFTER_TOMORROW).cur_Amount__c);
		System.assertEquals(20.00, actualPerDiems.get(ONE_WEEK_FROM_TODAY).cur_Amount__c);			
	}
	
	
	@isTest
	private static void calculatesPerDiemForOneDayTravelLongerEightHours() {
		
		// Setup & Exercise
		CompensationRate__c start = insertCustomLocation('Startland','Startland',null,'sl',50,25,60);
		CompensationRate__c destination = insertDefaultLocation();
		
		Travel__c travel = new TravelBuilder(TODAY_SEVEN_AM,TODAY_EIGHT_PM)
									.addCustomFlightWithLocation(TODAY_SEVEN_AM,TODAY_TEN_AM,start,destination)
									.addCustomFlightWithLocation(TODAY_FOUR_PM,TODAY_EIGHT_PM,destination,start)
									.create();
					
		
		// Verify
		Decimal expectedAmount = destination.cur_PartialDailyRate__c;
		
		Expense__c expectedPerDiem = perDiemExpense(TODAY_SEVEN_AM, TODAY_EIGHT_PM, destination, expectedAmount);
		
		actualPerDiems = getActualPerDiems(travel);
		
		System.assertEquals(1, actualPerDiems.size());
		assertHaveEqualValues(expectedPerDiem, actualPerDiems.get(DAY_TODAY));
	}
	
	
	@isTest
	private static void failsWhenAmountIsNegative() {
		
		// Setup & Exercise 
		CompensationRate__c start = insertCustomLocation('Startland', 'Startland', null, 'SL', 50, 25, 60);
		CompensationRate__c destination = insertDefaultLocation();
		
		Travel__c travel = new TravelBuilder(TODAY_FOUR_PM, TOMORROW_SIX_PM)
									.addCustomFlightWithLocation(TODAY_FOUR_PM, TODAY_END, start,destination)
									.addCustomFlightWithLocation(TOMORROW_START, TOMORROW_SIX_PM, destination,start)
									.addMealInvitation(DAY_TODAY, false, true, true)
									.addMealInvitation(DAY_TOMORROW, true, true, false)
									.create();
									
									
		// Verify
		Decimal expectedAmount = 0.00;
		
		Expense__c expectedPerDiem = perDiemExpense(TODAY_FOUR_PM, TOMORROW_SIX_PM, destination, expectedAmount);
		
		actualPerDiems = getActualPerDiems(travel);
		
		System.assertEquals(1, actualPerDiems.size());
		assertHaveEqualValues(expectedPerDiem, actualPerDiems.get(DAY_TODAY));
	}
	
	
	// TEST HELPER
	private static void assertHaveEqualValues(Expense__c expected, Expense__c generated) {
		Boolean isEqual = false;
		
		if( (generated.dtm_Begin__c == expected.dtm_Begin__c)
			&& (generated.dtm_End__c == expected.dtm_End__c )
			&& (generated.cur_Amount__c == expected.cur_Amount__c)
			&& (generated.lkp_Location__c == expected.lkp_Location__c)) {
			isEqual = true;
		}
		
		System.assert(isEqual);
	}
	
	
	private static Map<Date, Expense__c> getActualPerDiems(Travel__c selectedTravel) {
		Map<Date,Expense__c> result = new Map<Date,Expense__c>();
		for(Expense__c e : [SELECT id,
								   dtm_Begin__c,
								   dtm_End__c, 
								   lkp_Location__c, 
								   cur_Amount__c, 
								   lkp_Location__r.Name,
								   dat_ExpenseDate__c
							FROM Expense__c 
							WHERE mdr_Travel__c = :selectedTravel.id 
							AND RecordType.DeveloperName = 'perDiem']) {
			result.put(e.dtm_Begin__c.date(), e);
		}	
			
		return result;
	}
	
	
	private static DateTime dateTime(Date day, Time myTime) {
		DateTime result = DateTime.newInstance(day, myTime);
		
		return result;
	}
	
	
	private static Expense__c perDiemExpense(DateTime start, DateTime stop, CompensationRate__c location, Decimal amount) {
		Expense__c expense = new Expense__c ();
		expense.RecordTypeId =ExpenseType.getPerDiemRecordTypeId();
		expense.dtm_Begin__c = start;
		expense.dtm_End__c = stop;
		expense.lkp_Location__c = location.id;
		expense.cur_Amount__c = amount;
		expense.pkl_Reimbursement__c = 'I paid for this, please reimburse me';
		
		return expense;
	}
	
	
	private static CompensationRate__c insertDefaultLocation() {
		CompensationRate__c result = new CompensationRate__c(Name = 'Land',
                                                             txt_CountryName__c = 'Land',
                                                             txt_CountryCode__c = 'DE',
                                                             RecordTypeId = CompensationRateType.getLocationId(),
															 cur_FullDailyRate__c =40,
															 cur_PartialDailyRate__c =20,
															 cur_OvernightStayRate__c =60);
		insert result;	
	
		return result;
	}
	
	
	private static CompensationRate__c insertCustomLocation(String name, String country, String city,  String countryCode, Decimal full, Decimal partial, Decimal overnight) {
		CompensationRate__c result = new CompensationRate__c(Name = name,
                                                             txt_CountryName__c = country,
                                                             txt_CountryCode__c = countryCode,
                                                             RecordTypeId = CompensationRateType.getLocationId(),
											 				 cur_FullDailyRate__c = full, 
											 				 cur_PartialDailyRate__c = partial, 
											 				 cur_OvernightStayRate__c = overnight);
		insert result;
		
		return result;
	}
	
	
	private static CompensationRate__c insertCustomMeal(String mealName, Double full, Decimal half) {
		CompensationRate__c result = new CompensationRate__c(txt_CountryName__c = mealName, 
											 				 RecordTypeId = CompensationRateType.getMealId(),
											 				 pct_FullDayAllowanceRate__c = full, 
											 				 cur_HalfDayAllowanceRate__c = half);
		insert result;
		
		return result;
	}
}