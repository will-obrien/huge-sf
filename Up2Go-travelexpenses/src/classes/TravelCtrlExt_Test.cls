@isTest
private class TravelCtrlExt_Test {
	
	static {
		CustomSettings.addDefault();
	}
    
    private static final Date DAY_TODAY = System.today();
    private static final Date DAY_TOMORROW = DAY_TODAY.addDays(1);
    private static final Date DAY_AFTER_TOMORROW = DAY_TODAY.addDays(2);
    private static final Date ONE_WEEK_FROM_TODAY = DAY_TODAY.addDays(7);
    
    private static final Time START_OF_DAY = Time.newInstance(00,00,00,00);
    private static final Time MORNING = Time.newInstance(08,00,00,00);
    private static final Time NOON = Time.newInstance(12,00,00,00);
    private static final Time AFTERNOON = Time.newInstance(16,00,00,00);
    private static final Time EVENING = Time.newInstance(20,00,00,00);
    private static final Time END_OF_DAY = Time.newInstance(23,59,59,00);
    
    private static final DateTime TRAVEL_BEGIN = dateTime(System.today(), Time.newInstance(05,00,00,00));
    private static final DateTime TRAVEL_END = dateTime(ONE_WEEK_FROM_TODAY, Time.newInstance(20,00,00,00));
    
    
    @isTest
    private static void identifyTheApprovalStatusOfTheTravel() {
        
        // Setup
        DateTime departure = dateTime(DAY_TODAY, MORNING);
        DateTime arrival = dateTime(DAY_TODAY, AFTERNOON);
        
        Profile standPlatUs = [SELECT Id FROM Profile WHERE Name='Standard Platform User']; 
        User user = createNewUser(standPlatUs, 'traveller');
        
        Travel__c travel;
        
        System.runAs(user) {
            travel = new TravelBuilder(TRAVEL_BEGIN, TRAVEL_END)
                                          .addDefaultFlight(departure.addDays(7), arrival.addDays(7))
                                          .addDefaultFlight(departure.addDays(1), arrival.addDays(1))
                                          .addDefaultFlight(departure.addDays(4), arrival.addDays(4))
                                          .addDefaultFlight(departure.addDays(6), arrival.addDays(6))
                                          .addDefaultFlight(departure, arrival)
                                          .addDefaultFlight(departure.addDays(3), arrival.addDays(3))
                                          .create();
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(travel.Id);
            Approval.ProcessResult result = Approval.process(req);
        }
        
                
        // Exercise
        String recordStatus = TravelCtrlExt.getRecordStatus(travel.Id);
        
        
        // Verify
        System.assertEquals('Pending', recordStatus);
    }

    
    @isTest
    private static void sortExpenses() {
        
        // Setup 
        DateTime departure = dateTime(DAY_TODAY, MORNING);
        DateTime arrival = dateTime(DAY_TODAY, AFTERNOON);
        
        Travel__c travel = new TravelBuilder(TRAVEL_BEGIN, TRAVEL_END)
                                      .addDefaultFlight(departure.addDays(7), arrival.addDays(7))
                                      .addDefaultFlight(departure.addDays(1), arrival.addDays(1))
                                      .addDefaultFlight(departure.addDays(4), arrival.addDays(4))
                                      .addDefaultFlight(departure.addDays(6), arrival.addDays(6))
                                      .addDefaultFlight(departure, arrival)
                                      .addDefaultFlight(departure.addDays(3), arrival.addDays(3))
                                      .create();        
        
        
         // Exercise
        TravelCtrlExt ctrlExt = new TravelCtrlExt(new ApexPages.StandardController(travel));
        ctrlExt.doInitializeLists();
        List<Expense__c> expenses = ctrlExt.getSortedExpenses();
             
                            
        // Verify
        System.assertEquals(DAY_TODAY, expenses.get(0).dat_ExpenseDate__c);
                
        Integer LAST = expenses.size() - 1;
        System.assertEquals(ONE_WEEK_FROM_TODAY, expenses.get(LAST).dat_ExpenseDate__c);
    }
    
    
    @isTest
    private static void calculatingDailyExpenses() {
        // Setup    
        DateTime departure = dateTime(DAY_TODAY, MORNING);
        DateTime arrival = dateTime(DAY_TODAY, AFTERNOON);
    	
        Travel__c travel = new TravelBuilder(TRAVEL_BEGIN, TRAVEL_END)
                                    .addCustomFlightWithAmount(departure, arrival, 500.00)
                                    .addCustomFlightWithAmount(departure.addDays(1), arrival.addDays(1), 400.00)
                                    .addCustomFlightWithAmount(departure.addDays(7), arrival.addDays(7), 300.00)
                                    .addCustomFlightWithAmount(arrival.addDays(7).addHours(2), arrival.addDays(7).addHours(4), 200.00)
                                    .create();          
    
        
        // Exercise
        TravelCtrlExt ctrlExt = new TravelCtrlExt(new ApexPages.StandardController(travel));
        ctrlExt.doInitializeLists();
        List<Expense__c> dailyExpenses = ctrlExt.getDailyExpenses();
        
        
        // Verify
        System.assertEquals(DAY_TOMORROW, dailyExpenses.get(1).dat_ExpenseDate__c);
        System.assertEquals(460.00, dailyExpenses.get(1).cur_Amount__c);
            
        Integer lastDay = dailyExpenses.size() - 1;
        System.assertEquals(ONE_WEEK_FROM_TODAY, dailyExpenses.get(lastDay).dat_ExpenseDate__c);
        System.assertEquals(525.00, dailyExpenses.get(lastDay).cur_Amount__c);
    }
    
    
    //@isTest
    private static void emptyTravelCannotBeSubmitted() {
        
        // Setup
        Travel__c travel = new TravelBuilder(System.now(), System.now().addDays(2)).create();
                                    
        TravelCtrlExt ctrlExt = new TravelCtrlExt(new ApexPages.StandardController(travel));
                                    
        
        // Exercise
        PageReference validationResult = ctrlExt.doValidateOnSubmit();
        
        
        // Verify
        System.assertEquals(null,validationResult);
        assertThrowsMessage(System.Label.TravelNeedsMovementOnFirstDay);
        assertThrowsMessage(System.Label.TravelNeedsMovementOnLastDay);
    }
   

    @isTest
    private static void travelWithLocationGapsCannotBeSubmitted() {
        
        // Setup
        CompensationRate__c germany = insertLocation('Deutschland', 'Deutschland', null, 'DE', 50, 50, 50);
        CompensationRate__c spain = insertLocation('Spanien', 'Spanien', null, 'ES', 20, 20, 20);

        Travel__c travel = new TravelBuilder(System.now(), System.now().addDays(2))
                                    .addCustomFlightWithLocation(System.now(), System.now().addHours(3), germany, germany)
                                    .addRentalVehicleWithLongDistanceRideLocation(DAY_TODAY,DAY_AFTER_TOMORROW,
                                                                                  System.now().addDays(1),System.now().addDays(1).addHours(3),
                                                                                  spain, spain)     
                                    .create();
                                    
        TravelCtrlExt ctrlExt = new TravelCtrlExt(new ApexPages.StandardController(travel));
        
        
        // Exercise
        PageReference validationResult = ctrlExt.doValidateOnSubmit();
        
        
        // Verify
        System.assertEquals(null,validationResult); 
        assertThrowsMessage(String.format(System.Label.TravelHasNoMovementGaps, new List<String> {'Stadt 2, Deutschland', 'Stadt 1, Spanien'}));              
    }
   
    
    //@isTest
    private static void travelWithNoMovementsOnFirstAndLastDayCannotBeSubmitted() {
        
        // Setup
        DateTime start = dateTime(DAY_TODAY,START_OF_DAY);
        DateTime stop = dateTime(DAY_AFTER_TOMORROW,END_OF_DAY);
        DateTime mark = dateTime(DAY_TOMORROW,START_OF_DAY);
        
        Travel__c travel = new TravelBuilder(start, stop)
                                     .addDefaultFlight(mark, mark.addHours(3))
                                     .addRentalVehicleWithRoundTripLongDistanceRide(DAY_TODAY,DAY_AFTER_TOMORROW,
                                     												mark.addHours(5),mark.addHours(6),
                                     												mark.addHours(8),mark.addHours(10))
                                     .create();
                                     
        TravelCtrlExt ctrlExt = new TravelCtrlExt(new ApexPages.StandardController(travel));
        
        
        // Exercise
        PageReference validationResult = ctrlExt.doValidateOnSubmit();
        
        
        // Verify   
        System.assertEquals(null,validationResult); 
        assertThrowsMessage(System.Label.TravelNeedsMovementOnFirstDay);
        assertThrowsMessage(System.Label.TravelNeedsMovementOnLastDay);
    }
    
    
    @isTest
    private static void validTravelCanBeSubmitted() {
        
        // Setup
        Travel__c travel = new TravelBuilder(System.now(), System.now().addDays(2))
                                     .addRoundFlight(System.now(), System.now().addHours(3),
                                                     System.now().addDays(2).addHours(-3), System.now().addDays(2).addHours(-1))
                                     .create();
                                     
        
        
        // Exercise
        TravelCtrlExt ctrlExt = new TravelCtrlExt(new ApexPages.StandardController(travel));
        PageReference validationResult = ctrlExt.doValidateOnSubmit();
        
        
        // Verify
        System.assert( !ApexPages.hasMessages(ApexPages.Severity.ERROR) );
    }
	
	
	@isTest
	private static void generatesDailySummaries() {
		
		// Setup
        Travel__c travel = new TravelBuilder(System.now(), System.now().addDays(2))
                                     .addRoundFlight(System.now(), 
                                     				 System.now().addHours(3),
                                                     System.now().addDays(2).addHours(-3), 
                                                     System.now().addDays(2).addHours(-1))
                                     .create();


        // Exercise
        TravelCtrlExt ctrlExt = new TravelCtrlExt(new ApexPages.StandardController(travel));
        ctrlExt.doGeneratePerDiemsAndLists();
        
        
        // Verify
        System.assertEquals(535.00, ctrlExt.getDailySummaries()[0].amount);
	}

    
    // TEST HELPER
    
    private static DateTime dateTime(Date day, Time myTime) {
        DateTime result = DateTime.newInstance(day, myTime);
        
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
    
    
    private static CompensationRate__c insertLocation(String name, String country, String city,  String countryCode, Decimal full, Decimal partial, Decimal overnight) {
        CompensationRate__c location = new CompensationRate__c(Name = name,
                                                               txt_CountryName__c = country,
                                                               txt_CityName__c = city,
                                                               txt_CountryCode__c = countryCode,
                                                               cur_FullDailyRate__c = full,
                                                               cur_PartialDailyRate__c = partial,
                                                               cur_OvernightStayRate__c = overnight);
                                                               
        insert location;
        
        CompensationRate__c result;
        for(CompensationRate__c r : [SELECT Id,Name FROM CompensationRate__c WHERE Id = :location.Id]) {
            result = r; 
        }   
        return result;                                                 
    }
    
    
    private static User createNewUser(Profile p, String name) {
        String userName = name+'@testorg.com';
        
        User manager = new User(Alias = 'man', Email='manager@testorg.com', EmailEncodingKey='UTF-8',
                               LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US',
                               ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='manager@testorg.com');
        insert manager;
        
        User user = new User(Alias = name.substring(0,2), Email=userName, EmailEncodingKey='UTF-8',
                               LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US',
                               ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName=userName,
                               ManagerId = manager.Id);
        insert user;    
                           
        return user;
    }
}