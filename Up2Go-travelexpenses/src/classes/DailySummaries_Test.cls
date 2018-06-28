@isTest
public with sharing class DailySummaries_Test {
	
	private static final Date FIRST_DAY = System.Today();
	private static final Date SECOND_DAY = FIRST_DAY.addDays(1);
	private static final Date THIRD_DAY = FIRST_DAY.addDays(2);
	
	private static final DateTime TRAVEL_START = dateTime(FIRST_DAY, 8);
	private static final DateTime TRAVEL_STOP = dateTime(THIRD_DAY, 20);
	
	static {
		CustomSettings.addDefault();
	}
	
	
	@isTest
	private static void generatesNoRowsForEmptyTravel() {
		
		// Setup
		Exception unexpectedException;
		String message = '';
		
		List<Expense__c> sortedExpenses = new List<Expense__c>();
		
		List<DailySummaries.Row> generatedRows;
		
		
		// Exercise
		try {
			generatedRows = new DailySummaries(sortedExpenses).getRows();
		}
		catch(Exception e) {
			unexpectedException = e;
			message = e.getStackTraceString();
		}
		
		
		// Verify
		System.assertEquals(null,unexpectedException, message);
		System.assertEquals(0, generatedRows.size());
	}
	
	
	@isTest
	private static void generateNoAdditionalElementsForTravelWithoutDeduction() {
		
		// Setup
		Exception unexpectedException;
		String message = '';
		
		Travel__c travel = createTravelWithoutDeduction();
		List<Expense__c> sortedExpenses = getTravel(travel.Id).Expenses__r;
		
		List<DailySummaries.Row> generatedRows;
		
		
		// Exercise
		try {
			generatedRows = new DailySummaries(sortedExpenses).getRows();
		}
		catch(Exception e) {
			unexpectedException = e;
			message = e.getStackTraceString();
		}
		
		
		// Verify
		Integer expectedElements = sortedExpenses.size();		
		Integer generatedElements = countRowElements(generatedRows);
		
		System.assertEquals(null,unexpectedException, message);
		System.assertEquals(expectedElements,generatedElements);
	}
	
	
	@isTest
	private static void generatesInfoElementsForEachMealInvitation() {
		
		// Setup
		Exception unexpectedException;
		String message = '';
		
		Travel__c travel = createTravelWithDeduction();
		List<Expense__c> sortedExpenses = getTravel(travel.Id).Expenses__r;
		
		List<DailySummaries.Row> generatedRows;
		
		
		// Exercise
		try {
			generatedRows = new DailySummaries(sortedExpenses).getRows();
		}
		catch(Exception e) {
			unexpectedException = e;
			message = e.getStackTraceString();
		}
		
		
		// Verify
		Integer expectedElements = 9 + sortedExpenses.size();		
		Integer generatedElements = countRowElements(generatedRows);
		
		System.assertEquals(null,unexpectedException, message);
		System.assertEquals(expectedElements,generatedElements);
	}
	
	
	// TESTHELPER
	
	private static Travel__c createTravelWithoutDeduction() {
		DateTime departure = dateTime(FIRST_DAY,8);
		DateTime arrival = dateTime(FIRST_DAY, 16);
		DateTime returnDeparture = dateTime(THIRD_DAY, 12);
		DateTime returnArrival = dateTime(THIRD_DAY, 20);
		
		Travel__c result = new TravelBuilder(TRAVEL_START,TRAVEL_STOP)
							   .addRoundFlight(departure, arrival, returnDeparture, returnArrival)
							   .addDefaultAccommodation(FIRST_DAY, THIRD_DAY)
							   .create();
							   
		return result;
	}
	
	
	private static Travel__c createTravelWithDeduction() {
		DateTime departure = dateTime(FIRST_DAY,8);
		DateTime arrival = dateTime(FIRST_DAY, 16);
		DateTime returnDeparture = dateTime(THIRD_DAY, 12);
		DateTime returnArrival = dateTime(THIRD_DAY, 20);
		
		Travel__c result = new TravelBuilder(TRAVEL_START,TRAVEL_STOP)
							   .addRoundFlight(departure, arrival, returnDeparture, returnArrival)
							   .addDefaultAccommodation(FIRST_DAY, THIRD_DAY)
							   .addMealInvitation(FIRST_DAY, false, false, true)
							   .addMealInvitation(SECOND_DAY,true,true,true)
							   .addMealInvitation(THIRD_DAY,true,true,false)
							   .create();
							   
		return result;
	}
	
	
	private static Travel__c getTravel(Id travel) {
		Travel__c result = [SELECT Id, dtm_Start__c, dtm_End__c,
	   							  (SELECT Id, Name, RecordType.Name, cur_Amount__c, dtm_DepartureTime__c, 
				                          dtm_ArrivalTime__c, dat_CheckInDate__c, dat_CheckOutDate__c, 
				                          lkp_Location__c, CurrencyIsoCode, dat_ExpenseDate__c, mdr_Travel__c, 
				                          pkl_Reimbursement__c,cur_OriginalAmount__c,
				                          lkp_Location__r.cur_FullDailyRate__c,
				                          lkp_MealInvitation__r.lkp_Breakfast__c, lkp_MealInvitation__r.lkp_Breakfast__r.pct_FullDayAllowanceRate__c,
				                          lkp_MealInvitation__r.lkp_Lunch__c, lkp_MealInvitation__r.lkp_Lunch__r.pct_FullDayAllowanceRate__c,
				                 		  lkp_MealInvitation__r.lkp_Dinner__c, lkp_MealInvitation__r.lkp_Dinner__r.pct_FullDayAllowanceRate__c
                   				   FROM Expenses__r
                   				   ORDER BY dat_ExpenseDate__c ASC, dtm_DepartureTime__c ASC, RecordType.Name ASC)
	   					   FROM Travel__c
	   					   WHERE Id = :travel];
   					   
   		return result;
	}	
	
	private static Integer countRowElements(List<DailySummaries.Row> generatedRows) {
		Integer result = 0;
		
		for(DailySummaries.Row r : generatedRows) {
			result += r.expenses.size();
		}
		
		return result;
	}
	
	
	private static DateTime dateTime(Date day, Integer hour) {
		Time t = Time.newInstance(hour,00,00,00);
		
		DateTime result = DateTime.newInstance(day,t);
		
		return result;
	}
}