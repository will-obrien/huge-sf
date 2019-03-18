public with sharing class TravelBuilder {
	
	private Travel__c travel;
	private CompensationRate__c defaultStart = new CompensationRate__c(Name = 'DefaultLand',
                                                                       txt_CountryName__c = 'DefaultLand',
                                                                       txt_CityName__c = null,
                                                                       txt_CountryCode__c = 'DE',
                                                                       RecordTypeId = CompensationRateType.getLocationId(), 
                                                                       cur_FullDailyRate__c = 50, cur_PartialDailyRate__c = 25, 
                                                                       cur_OvernightStayRate__c = 70);
	private CompensationRate__c defaultDestination = new CompensationRate__c(Name = 'Defaultland2',
                                                                             txt_CountryName__c = 'DefaultLand2',
                                                                             txt_CityName__c = null,
                                                                             txt_CountryCode__c = 'DF',
                                                                             RecordTypeId = CompensationRateType.getLocationId(),
                                                                             cur_FullDailyRate__c = 60, 
                                                                             cur_PartialDailyRate__c = 35, 
                                                                             cur_OvernightStayRate__c =80);
	private CompensationRate__c breakfastType = new CompensationRate__c(Name='Breakfast', 
                                                                        RecordTypeId = CompensatioNRateType.getMealId(),
                                                                        pct_FullDayAllowanceRate__c = 20, 
                                                                        cur_HalfDayAllowanceRate__c = 1.63);
	private CompensationRate__c lunchType = new CompensationRate__c(Name='Lunch', 
                                                                    RecordTypeId = CompensatioNRateType.getMealId(),
                                                                    pct_FullDayAllowanceRate__c = 40, 
                                                                    cur_HalfDayAllowanceRate__c = 3);
	private CompensationRate__c dinnerType = new CompensationRate__c(Name='Dinner',
                                                                     RecordTypeId = CompensatioNRateType.getMealId(),
                                                                     pct_FullDayAllowanceRate__c = 40, 
                                                                     cur_HalfDayAllowanceRate__c = 3);
	private CompensationRate__c car = new CompensationRate__c(Name='Car',
                                                              RecordTypeId = CompensatioNRateType.getVehicleId(),
                                                              cur_MilageAllowance__c = 0.3);
	
		
	// CONSTRUCTOR
	
	public TravelBuilder(DateTime startTime, DateTime endTime) {
		insert defaultStart;
		insert defaultDestination;
		insert breakfastType;
		insert lunchType;
		insert dinnerType;
		insert car;
		
		travel = new Travel__c (Name = 'test travel', txt_Reason__c = 'testing', dtm_Start__c = startTime, dtm_End__c = endTime);
		
		insert travel;
	}
	
	
	// PUBLIC METHODS
	
	public TravelBuilder addDefaultFlight(DateTime departure, DateTime arrival) {			
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getFlightRecordTypeId();
		expense.dtm_DepartureTime__c = departure;
		expense.dtm_ArrivalTime__c = arrival;
		expense.cur_Amount__c = 500.00;
		
		setDefaultFromAndToForMovement(expense);
	
		insert expense;	
		
		return this;
	}
	
	
	public TravelBuilder addDefaultFlightWithoutLocation(DateTime departure, DateTime arrival) {			
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getFlightRecordTypeId();
		expense.cur_Amount__c = 500.00;
		expense.dtm_DepartureTime__c = departure;
		expense.dtm_ArrivalTime__c = arrival;
		expense.txt_From__c = 'Stuttgart, ';
		expense.txt_To__c = 'Berlin, ';
	
		insert expense;	
		
		return this;
	}
	
	
	public TravelBuilder addCustomFlightWithAmount(DateTime departure, DateTime arrival, Decimal amount) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getFlightRecordTypeId();
		expense.cur_Amount__c = amount;
		expense.dtm_DepartureTime__c = departure;
		expense.dtm_ArrivalTime__c = arrival;
		setDefaultFromAndToForMovement(expense);
		
		insert expense;
		
		return this;
	}
	
	
	public TravelBuilder addCustomFlightWithLocation(DateTime departure, DateTime arrival,CompensationRate__c start, CompensationRate__c destination) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getFlightRecordTypeId();
		expense.cur_Amount__c = 500.00;
		expense.dtm_DepartureTime__c = departure;
		expense.dtm_ArrivalTime__c = arrival;
		expense.txt_From__c = 'Stadt 1, '+start.Name;
		expense.txt_To__c = 'Stadt 2, '+destination.Name;
		expense.lkp_LocationFrom__c = start.Id;
		expense.lkp_Location__c = destination.Id;
		insert expense;
		
		return this;
	}
	
	
	public TravelBuilder addRoundFlight(DateTime departure, DateTime arrival, DateTime returnDeparture, DateTime returnArrival) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getFlightRecordTypeId();
		expense.chk_RoundTrip__c = true;
		expense.cur_Amount__c = 500.00;
		expense.dtm_DepartureTime__c = departure;
		expense.dtm_ArrivalTime__c = arrival;
		
		setDefaultFromAndToForMovement(expense);
		
		expense.dtm_ReturnDeparture__c = returnDeparture;
		expense.dtm_ReturnArrival__c = returnArrival;
		
		insert expense;	
		
		return this;
	}
	
	
	public TravelBuilder addCustomTrainRideWithLocation(DateTime departure, DateTime arrival,CompensationRate__c start, CompensationRate__c destination) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getTrainRideRecordTypeId();
		expense.cur_Amount__c = 100.00;
		expense.dtm_DepartureTime__c = departure;
		expense.dtm_ArrivalTime__c = arrival;
		expense.txt_From__c = 'Stuttgart, '+start.Name;
		expense.txt_To__c = 'Berlin, '+destination.Name;
		expense.lkp_LocationFrom__c = start.Id;
		expense.lkp_Location__c = destination.Id;
			
		insert expense;
		
		return this;
	}
	
	
	public TravelBuilder addDefaultPrivateVehicleRide(DateTime departure, DateTime arrival, Double distance) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getPrivateVehicleRecordTypeId();
		expense.dtm_DepartureTime__c = departure;
		expense.dtm_ArrivalTime__c = arrival;
		setDefaultFromAndToForMovement(expense);
		expense.num_Milage__c = distance;
		expense.lkp_VehicleType__c = car.Id;
		
		insert expense;
		
		return this;	
	}
	
	
	public TravelBuilder addDefaultCompanyVehicleRide(DateTime departure, DateTime arrival) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getCompanyVehicleRecordTypeId();
		expense.dtm_DepartureTime__c = departure;
		expense.dtm_ArrivalTime__c = arrival;
		setDefaultFromAndToForMovement(expense);
		expense.pkl_Reimbursement__c = null;
		
		insert expense;
		
		return this;
	}
	

	public TravelBuilder addDefaultAccommodation(Date checkIn, Date checkOut) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getAccommodationRecordTypeId();
		expense.cur_Amount__c = 80.00;
		expense.txt_LodgingAdress__c = 'Hotel Adlon, Berlin, '+ defaultStart.Name;
		expense.dat_CheckInDate__c = checkIn;
		expense.dat_CheckOutDate__c = checkOut;
		expense.lkp_LocationFrom__c = defaultStart.Id;
		expense.lkp_Location__c = defaultStart.Id;

		insert expense;
		
		return this;
	}
	
	
	public TravelBuilder addAccommodationWithBreakfastIncluded(Date checkIn, Date checkOut) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getAccommodationRecordTypeId();
		expense.cur_Amount__c = 80.00;
		expense.txt_LodgingAdress__c = 'Hotel Adlon, Berlin, '+ defaultStart.Name;
		expense.dat_CheckInDate__c = checkIn;
		expense.dat_CheckOutDate__c = checkOut;
		expense.lkp_LocationFrom__c = defaultStart.Id;
		expense.lkp_Location__c = defaultStart.Id;
		expense.chk_BreakfastIncluded__c = true;
		
		insert expense;
		
		return this;
	}
	
	
	public TravelBuilder addAccommodationWithoutLocation(Date checkIn, Date checkout) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getAccommodationRecordTypeId();
		expense.cur_Amount__c = 80.00;
		expense.txt_LodgingAdress__c = 'Hotel Adlon, Berlin, ';
		expense.dat_CheckInDate__c = checkIn;
		expense.dat_CheckOutDate__c = checkOut;

		insert expense;
		
		return this;
	}
	
	
	public TravelBuilder addCustomAccommodationWithLocation(Date checkIn, Date checkOut, CompensationRate__c location) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeid = ExpenseType.getAccommodationRecordTypeId();
		expense.cur_Amount__c = 80.00;
		expense.txt_LodgingAdress__c = 'Hotel Adlon, Berlin, Deutschland';
		expense.lkp_Location__c = location.Id;
		expense.lkp_LocationFrom__c = location.Id;
		expense.dat_CheckInDate__c = checkIn;
		expense.dat_CheckOutDate__c = checkOut;

		insert expense;
		
		return this;
	}
	
	
	public TravelBuilder addDefaultMiscellaneousExpense(Date expenseDate) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getMiscellaneousRecordTypeId();
		expense.cur_Amount__c = 80.00;
		expense.dat_ExpenseDate__c = expenseDate;
		expense.txt_Reason__c = 'testeingabe';
		
		insert expense;

		return this;
	}
	
	
	public TravelBuilder addDefaultEntertainment(Date day,Decimal bill, Decimal tip) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getEntertainmentRecordTypeId();
		expense.dat_ExpenseDate__c = day;
		expense.txt_PlaceOfEntertainment__c = 'Hotel Adlon, Berlin, '+defaultStart.Name;
		expense.lkp_Location__c = defaultStart.Id;
		expense.txt_Reason__c ='Essen';
		expense.txa_EntertainedPersons__c ='Max Mustermann';
		expense.cur_Bill__c = bill;
		expense.cur_Tip__c = tip;
		
		insert expense;
		
		return this;
	}
	
	
	public TravelBuilder addEntertainmentWithoutLocation(Date day) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getEntertainmentRecordTypeId();
		expense.dat_ExpenseDate__c = day;
		expense.txt_PlaceOfEntertainment__c = 'Hotel Adlon, Berlin, ';
		expense.txt_Reason__c ='Essen';
		expense.txa_EntertainedPersons__c ='Max Mustermann';
		expense.cur_Bill__c = 500;
		expense.cur_Tip__c = 20;
		
		insert expense;
		
		return this;
	}
	
	
	public TravelBuilder addDefaultRentalVehicle(Date pickUpDate, Date returnDate) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getRentalVehicleRecordTypeId();
		expense.cur_Amount__c = 80.00;
		expense.dat_PickUpDate__c = pickUpDate;
		expense.dat_ReturnDate__c = returnDate;
		
		insert expense;
		
		return this;
	}
	
	
	public TravelBuilder addRentalVehicleWithLongDistanceRide(Date pickUpDate, Date returnDate, DateTime start, DateTime stop) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getRentalVehicleRecordTypeId();
		expense.cur_Amount__c = 80.00;
		expense.dat_PickUpDate__c = pickUpDate;
		expense.dat_ReturnDate__c = returnDate;
		
		insert expense;
		
		insertLongDistanceRide(start,stop, expense.Id);
		
		return this;
	}
	
	
	public TravelBuilder addRentalVehicleWithRoundTripLongDistanceRide(Date pickUpDate, Date returnDate, DateTime start, DateTime stop, DateTime returnStart, DateTime returnStop) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getRentalVehicleRecordTypeId();
		expense.cur_Amount__c = 80.00;
		expense.dat_PickUpDate__c = pickUpDate;
		expense.dat_ReturnDate__c = returnDate;
		
		insert expense;
		
		insertRoundTripLongDistanceRide(start,stop,returnStart,returnStop,expense.Id);
		
		return this;
	}
	
	
	public TravelBuilder addRentalVehicleWithTwoLongDistanceRides(Date pickupDate, Date returnDate, DateTime start,DateTime stop,DateTime start2,DateTime stop2) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getRentalVehicleRecordTypeId();
		expense.cur_Amount__c = 80.00;
		expense.dat_PickUpDate__c = pickUpDate;
		expense.dat_ReturnDate__c = returnDate;
		
		insert expense;
		
		insertLongDistanceRide(start,stop, expense.Id);
		insertLongDistanceRide(start2,stop2, expense.Id);
		
		return this;
	}
	
	
	public TravelBuilder addRentalVehicleWithLongDistanceRideLocation(Date pickUpDate, Date returnDate, DateTime start, DateTime stop,CompensationRate__c startLocation,CompensationRate__c destination) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getRentalVehicleRecordTypeId();
		expense.cur_Amount__c = 80.00;
		expense.dat_PickUpDate__c = pickUpDate;
		expense.dat_ReturnDate__c = returnDate;
		
		insert expense;
		
		insertLongDistanceRideWithLocation(start,stop, expense.Id, startLocation,destination);
		
		return this;
	}
	
	
	public TravelBuilder addRentalVehicleWithLongDistanceRideWithoutLocation(Date pickUpDate, Date returnDate, DateTime start, DateTime stop) {
		Expense__c expense = createDefaultExpense();
		expense.RecordTypeId = ExpenseType.getRentalVehicleRecordTypeId();
		expense.cur_Amount__c = 80.00;
		expense.dat_PickUpDate__c = pickUpDate;
		expense.dat_ReturnDate__c = returnDate;
		
		insert expense;
		
		insertLongDistanceRideWithoutLocation(start,stop, expense.Id);
		
		return this;
	}
	
	
	// MEAL INVITATION
	public TravelBuilder addMealInvitation(Date day, Boolean breakfast, Boolean lunch, Boolean dinner) {
		MealInvitation__c meal = new MealInvitation__c();
		meal.dat_Day__c = day;
		meal.chk_Breakfast__c = breakfast;
		meal.chk_Lunch__c = lunch;
		meal.chk_Dinner__c = dinner;
		meal.mdr_Travel__c = travel.id;

		insert meal;

		return this;
	}
	
	
	public Travel__c create() {
		return travel;
	}
	
	
	// PRIVATE METHODS
	
	private Expense__c createDefaultExpense() {
		Expense__c result = new Expense__c();
		result.mdr_Travel__c = travel.Id;
		result.pkl_Reimbursement__c = 'I paid for this, please reimburse me.';
		
		return result;
	}
	
	
	private void setDefaultFromAndToForMovement(Expense__c expense) {
		expense.txt_From__c = 'Stuttgart, '+defaultStart.Name;
		expense.txt_To__c = 'Berlin, '+defaultDestination.Name;
		expense.lkp_LocationFrom__c = defaultStart.Id;
		expense.lkp_Location__c = defaultDestination.Id;
	}
	
	
	// LONG DISTANCE RIDES
	private void insertLongDistanceRide(DateTime start, DateTime stop,Id rentalVehicle) {
		LongDistanceRide__c ride = new LongDistanceRide__c();
		ride.dtm_DepartureTime__c = start;
		ride.dtm_ArrivalTime__c = stop;
		ride.txt_From__c = 'Stuttgart, '+defaultStart.Name;
		ride.txt_To__c = 'Berlin, '+defaultDestination.Name;
		ride.lkp_LocationFrom__c = defaultStart.Id;
		ride.lkp_LocationTo__c = defaultDestination.Id;
		ride.mdr_RentalVehicle__c = rentalVehicle;
		
		insert ride;
	}
	
	
	private void insertRoundTripLongDistanceRide(DateTime start, DateTime stop, DateTime returnStart, DateTime returnStop, Id rentalVehicle) {
		LongDistanceRide__c ride = new LongDistanceRide__c();
		ride.dtm_DepartureTime__c = start;
		ride.dtm_ArrivalTime__c = stop;
		ride.txt_From__c = 'Stuttgart, '+defaultStart.Name;
		ride.txt_To__c = 'Berlin, '+defaultDestination.Name;
		ride.lkp_LocationFrom__c = defaultStart.Id;
		ride.lkp_LocationTo__c = defaultDestination.Id;
		ride.chk_RoundTrip__c = true;
		ride.dtm_ReturnDeparture__c = returnStart;
		ride.dtm_ReturnArrival__c = returnStop;
		ride.mdr_RentalVehicle__c = rentalVehicle;
		
		insert ride;
	}
	
	
	private void insertLongDistanceRideWithLocation(DateTime start, DateTime stop,Id rentalVehicle,CompensationRate__c startLocation,CompensationRate__c destination) {
		LongDistanceRide__c ride = new LongDistanceRide__c();
		ride.dtm_DepartureTime__c = start;
		ride.dtm_ArrivalTime__c = stop;
		ride.txt_From__c = 'Stadt 1, '+startLocation.Name;
		ride.txt_To__c = 'Stadt 2, '+destination.Name;
		ride.lkp_LocationFrom__c = startLocation.Id;
		ride.lkp_LocationTo__c = destination.Id;
		ride.mdr_RentalVehicle__c = rentalVehicle;
		
		insert ride;
	}
	
	
	private void insertLongDistanceRideWithoutLocation(DateTime start, DateTime stop, Id rentalVehicle) {
				LongDistanceRide__c ride = new LongDistanceRide__c();
		ride.dtm_DepartureTime__c = start;
		ride.dtm_ArrivalTime__c = stop;
		ride.txt_From__c = 'Stadt 1, ';
		ride.txt_To__c = 'Stadt 2, ';
		ride.mdr_RentalVehicle__c = rentalVehicle;
		
		insert ride;
	}
}