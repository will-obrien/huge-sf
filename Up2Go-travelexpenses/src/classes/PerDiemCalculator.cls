public with sharing class PerDiemCalculator {
    
    private Travel__c travel;
    private CompensationRate__c currentLocation; 
    
    private List<Expense__c> movementExpenses;
    private List<Expense__c> oldPerDiems;
    
    private Map<Id,CompensationRate__c> locations;
    private Map<Date,MealInvitation__c> mealInvitations;
    
    private Boolean hasNoAccommodations;
    
    
    // CONSTRUCTOR
    
    public PerDiemCalculator(Travel__c travel) {
    	this.travel = travel;
    	
 		initExpenses();
 		initLocations();
 		initMealInvitations();
    }
    
    
    // PUBLIC METHODS
    
    public void calculate() {
        delete oldPerDiems;
        
    	List<Expense__c> newPerDiems = new List<Expense__c>();
        
        try {
	    	if(isShorterOrEqualEightHours()) {
	    		newPerDiems.add(generateShortTravelPerDiem());
	    	}
	    	else {
	    		if(isOvernightTravel()) {
					newPerDiems.add(generateOverNightPerDiem());
	    		}
	    		else {
	    			newPerDiems.addAll(generatePerDiems());
	    		}
	    	}
	    	
	    	insert newPerDiems;
    	}
    	catch(Exception ignore) {
    		// Note: If error occurs no calculation of Per Diems.
    	}
    }
    
    
	// PRIVATE METHODS
	
	private void initExpenses() {
		movementExpenses = new List<Expense__c>();
		oldPerDiems = new List<Expense__c>();
		
    	hasNoAccommodations = true;
    			
		Set<Id> recordTypes = new Set<Id>();
		recordTypes.add(ExpenseType.getEntertainmentRecordTypeId());
		recordTypes.add(ExpenseType.getMiscellaneousRecordTypeId());
		
		for(Expense__c expense : [SELECT RecordTypeId, dtm_ArrivalTime__c, dtm_DepartureTime__c,lkp_Location__c, lkp_LocationFrom__c,
										 chk_RoundTrip__c, dtm_ReturnDeparture__c, dtm_ReturnArrival__c,
    					   				 (SELECT dtm_DepartureTime__c, dtm_ArrivalTime__c,lkp_LocationFrom__c,lkp_LocationTo__c,
    					   				 		 chk_RoundTrip__c, dtm_ReturnDeparture__c, dtm_ReturnArrival__c
    					   			   	  FROM Long_Distance_Rides__r)	
    							  FROM Expense__c 
    							  WHERE mdr_travel__c = :travel.id
    							  AND RecordTypeId NOT IN :recordTypes]) {
    		
    		if(ExpenseType.isMovement(expense)) {
    			movementExpenses.add(expense);
    		}					  	
			else if(ExpenseType.isPerDiem(expense)) {
				oldPerDiems.add(expense);
			}
			else if(ExpenseType.isRentalVehicle(expense)) {
				for(LongDistanceRide__c ldr : expense.Long_Distance_Rides__r) {
					Expense__c falseExpense = createFalseExpense(ldr);
		    		
		    		movementExpenses.add(falseExpense);
				}
			}
			else if(ExpenseType.isAccommodation(expense)) {
				hasNoAccommodations = false;
			}
		}
		
		movementExpenses.addAll(createReturnTrips(movementExpenses));
	}
	
	
	private void initLocations() {
		locations = new Map<Id,CompensationRate__c>([SELECT Id, CurrencyIsoCode,cur_FullDailyRate__c, cur_PartialDailyRate__c
												     FROM CompensationRate__c
												     WHERE RecordTypeId = :CompensationRateType.getLocationId()]);
	}
	
	
	private void initMealInvitations() {
    	mealInvitations = new Map<Date,MealInvitation__c>();
    	
    	for(MealInvitation__c invitation : [SELECT Id, dat_Day__c, lkp_Breakfast__c, 
    											   lkp_Breakfast__r.pct_FullDayAllowanceRate__c,
    									   		   lkp_Lunch__c, lkp_Lunch__r.pct_FullDayAllowanceRate__c,
    									   		   lkp_Dinner__c, lkp_Dinner__r.pct_FullDayAllowanceRate__c
    										FROM MealInvitation__c
    										WHERE mdr_Travel__c = :travel.Id]) {
    		mealInvitations.put(invitation.dat_Day__c,invitation);
    	}
	}
    
    
    // CHECKING METHODS
    
    private Boolean isShorterOrEqualEightHours() {
    	Long dt1 = travel.dtm_End__c.getTime();  
   		Long dt2 = travel.dtm_Start__c.getTime();
   		
   		Double difference = dt1 - dt2;
   		difference = difference/ 1000 / 60 / 60;
    	
    	Boolean result = (difference <= 8);
    	
    	return result;
    }
    
        
    private Boolean isOvernightTravel() {
    	Integer travelDuration = travel.dtm_End__c.day() - travel.dtm_Start__c.day();
    	
    	Boolean result = (travelDuration == 1) && hasNoAccommodations;
    	
    	return result;
    }
    
    
    private Boolean isOneDayTravel() {
    	Boolean result = travel.dtm_Start__c.isSameDay(travel.dtm_End__c);
    	
    	return result;
    }
    
    
    // PER DIEM GENERATING METHODS
    
    private Expense__c generateShortTravelPerDiem() {
    	Date firstDay = travel.dtm_Start__c.date();
    	Date lastDay = travel.dtm_End__c.date();
    	
    	determineLocationOfTheDay(firstDay,lastDay);
		
		Expense__c result = createDefaultPerDiem(firstDay);
		result.cur_Amount__c = 0.00;
		result.cur_OriginalAmount__c = 0.00;
		result.cur_Deduction__c = calculateMealDeduction(firstDay, true);
		result.lkp_MealInvitation__c = findMealInvitation(firstDay, true);	
    	    	
    	return result;
    }
    
    
    private Expense__c generateOverNightPerDiem() {
    	Date firstDay = travel.dtm_Start__c.date();
    	Date lastDay = travel.dtm_End__c.date();
    	
   		determineLocationOfTheDay(firstDay,lastDay);
		Decimal original = currentLocation.cur_PartialDailyRate__c;
		Decimal deduction = calculateMealDeduction(firstDay, true);
   		
    	Expense__c result = createDefaultPerDiem(firstDay);
		result.lkp_MealInvitation__c = findMealInvitation(firstDay,true);
		result.cur_OriginalAmount__c = original;
		result.cur_Deduction__c = deduction;
		result.cur_Amount__c = calculateAmount(original,deduction);
   		 
   		return result;    			
    }
    	
    
    private List<Expense__c> generatePerDiems() {
    	Date firstDay = travel.dtm_Start__c.date();
    	Date lastDay = travel.dtm_End__c.date();
    	
    	List<Expense__c> results = new List<Expense__c>();

		for( Date day = firstDay ; day <= lastDay ; day = day.addDays(1)) {
        	determineLocationOfTheDay(firstDay,lastDay,day);
            
            Expense__c perDiem = createDefaultPerDiem(day);

			Decimal originalAmount;
		    Decimal deduction = calculateMealDeduction(day,false);

			if(isOneDayTravel()) {
		    	originalAmount= currentLocation.cur_PartialDailyRate__c;
		    }            	
		    else if (day.isSameDay(firstDay)) {
		        originalAmount = currentLocation.cur_PartialDailyRate__c;
		        perDiem.dtm_End__c = DateTime.newInstance(day,Time.newInstance(23,59,59,00));
		    }
		    else if(day.isSameDay(lastDay)) {
		        originalAmount = currentLocation.cur_PartialDailyRate__c;
		        perDiem.dtm_Begin__c = DateTime.newInstance(day,Time.newInstance(00,00,00,00));
		    }
		    else {
		        originalAmount = currentLocation.cur_FullDailyRate__c;
		        perDiem.dtm_Begin__c = DateTime.newInstance(day,Time.newInstance(00,00,00,00));
		        perDiem.dtm_End__c = DateTime.newInstance(day,Time.newInstance(23,59,59,00));
		    }
		
		    perDiem.cur_OriginalAmount__c = originalAmount;
		    perDiem.cur_Deduction__c = deduction;
		    perDiem.lkp_MealInvitation__c = findMealInvitation(day,false);
			perDiem.cur_Amount__c = calculateAmount(originalAmount,deduction);
            
            results.add(perDiem);
        }
        
        return results;
    }
	
	
	// CALCULATING AND DETERMINING METHODS
	
	private Expense__c createFalseExpense(LongDistanceRide__c ldr) {
		Expense__c result = new Expense__c();
		
		result.dtm_DepartureTime__c = ldr.dtm_DepartureTime__c;
		result.dtm_ArrivalTime__c = ldr.dtm_ArrivalTime__c;
		result.lkp_LocationFrom__c = ldr.lkp_LocationFrom__c;
		result.lkp_Location__c = ldr.lkp_LocationTo__c;
		result.chk_RoundTrip__c = ldr.chk_RoundTrip__c;
		result.dtm_ReturnDeparture__c = ldr.dtm_ReturnDeparture__c;
		result.dtm_ReturnArrival__c = ldr.dtm_ReturnArrival__c;
		
		return result;
	}
	
	
	private List<Expense__c> createReturnTrips(List<Expense__c> expenses) {
		List<Expense__c> results = new List<Expense__c>();
		
		for(Expense__c e : expenses) {
			if(e.chk_RoundTrip__c) {
				Expense__c returnTrip = new Expense__c();
				returnTrip.dtm_DepartureTime__c = e.dtm_ReturnDeparture__c;
				returnTrip.dtm_ArrivalTime__c = e.dtm_ReturnArrival__c;
				returnTrip.lkp_LocationFrom__c = e.lkp_Location__c;
				returnTrip.lkp_Location__c = e.lkp_LocationFrom__c;
				returnTrip.chk_RoundTrip__c = false;
				
				results.add(returnTrip);
			}
		}
		
		return results;	
	}
	
	
	private Expense__c createDefaultPerDiem(Date day) {
		Expense__c result = new Expense__c();
		
		result.mdr_Travel__c = travel.Id;
		result.RecordTypeId = ExpenseType.getPerDiemRecordTypeId();
		result.pkl_Reimbursement__c = 'I paid for this, please reimburse me.';
		result.dat_ExpenseDate__c = day;
		result.dtm_Begin__c = travel.dtm_Start__c;
		result.dtm_End__c = travel.dtm_End__c;
		result.lkp_Location__c = currentLocation.Id;
		result.CurrencyIsoCode = currentLocation.CurrencyIsoCode;
	
		
		return result;
	}
		
	
	private Id findMealInvitation(Date day, Boolean checkOnTwoDays) {
		Id result;
		Date lastDay = travel.dtm_End__c.date();

		MealInvitation__c invitation = mealInvitations.get(day);
		if(checkOnTwoDays && invitation == null) {
			invitation = mealInvitations.get(lastDay);
		}

		if(invitation != null) {
			result = invitation.Id;
		}

		return result;
	}
	
	
	private void determineLocationOfTheDay(Date firstDay,Date lastDay) {
		Expense__c movementOfTheDay;
		
		if(isOneDayTravel()) {
			movementOfTheDay = determineLastExpensePerDay(firstDay);
		}
		else if(isOvernightTravel()) {
			movementOfTheDay = determineLastExpensePerDay(lastDay);
			
			if(movementOfTheDay == null) {
				movementOfTheDay = determineLastExpensePerDay(firstDay);
			}
		}
		
		if(movementOfTheDay != null) {
			currentLocation = locations.get(movementOfTheDay.lkp_LocationFrom__c);
		}
	}
		
	
	private void determineLocationOfTheDay(Date firstDay,Date lastDay, Date day) {
		Expense__c movementOfTheDay;
		
		if(isOneDayTravel()) {
			movementOfTheDay = determineLastExpensePerDay(day);
		
			if(movementOfTheDay != null) {
				currentLocation = locations.get(movementOfTheDay.lkp_LocationFrom__c);
			}
		}
		else {
			if(day.isSameDay(lastDay)) {
				movementOfTheDay = determineFirstExpensePerDay(day);
				
				if(movementOfTheDay != null) {
					currentLocation = locations.get(movementOfTheDay.lkp_LocationFrom__c);
				}
			}
			else {
				movementOfTheDay = determineLastExpensePerDay(day);
				
				if(day.IsSameDay(firstDay) && movementOfTheDay == null) {
					movementOfTheDay = determineFirstExpensePerDay(day);
				}
				
				if(movementOfTheDay != null) {
					currentLocation = locations.get(movementOfTheDay.lkp_Location__c);
				}
			}
		}
	} 
	
	
	private Expense__c determineFirstExpensePerDay(Date day) {
		Expense__c result;
		DateTime compareTime = DateTime.newInstance(day,Time.newInstance(23,59,59,00));
		
		 for(Expense__c expense : movementExpenses) {
		 	DateTime departureTime = expense.dtm_DepartureTime__c;
		 	
		 	if( (departureTime.date() == day) && (departureTime < compareTime) ) {
	        	compareTime = departureTime;
	            result = expense;
		 	}
		 }
		 
		 return result;
	}


	private Expense__c determineLastExpensePerDay(Date day) {
		Expense__c result;
		DateTime compareTime = DateTime.newInstance(day,Time.newInstance(00,00,00,00));
		
		 for(Expense__c expense : movementExpenses) {
		 	DateTime arrivalTime = expense.dtm_ArrivalTime__c;
		 	
	 		if( (arrivalTime.date() == day) && (arrivalTime > compareTime) ) {
	        	compareTime = arrivalTime;
	            result = expense;
	    	}
		 }
		 
		 return result;
	}
	
	
	private Decimal calculateAmount(Decimal original, Decimal deduction) {
		Decimal result = original - deduction;

		if(result < 0) {
			result = 0;
		}

		return result;
	}
	
	
	private Decimal calculateMealDeduction(Date day,Boolean overnight) {
		Double allowanceRate;
		
		if(overnight) {
			allowanceRate = calculateAllowanceRate(day) + calculateAllowanceRate(day.addDays(1));
		}
		else {
			allowanceRate = calculateAllowanceRate(day);
		}
		
		if(allowanceRate > 1) {
				allowanceRate = 1;
		}
		
		Decimal result = locations.get(currentLocation.Id).cur_FullDailyRate__c * allowanceRate;
				
		return result;
	}
	
	
	private Double calculateAllowanceRate(Date day) {
		Double result = 0.00;
		MealInvitation__c invitation = mealInvitations.get(day);
		
		if(invitation != null) {
			
			if(invitation.lkp_Breakfast__c != null) {
				result = result+ invitation.lkp_Breakfast__r.pct_FullDayAllowanceRate__c;
			}
			if(invitation.lkp_Lunch__c != null) {
				result = result+ invitation.lkp_Lunch__r.pct_FullDayAllowanceRate__c;
			}
			if(invitation.lkp_Dinner__c != null) {
				result = result+ invitation.lkp_Dinner__r.pct_FullDayAllowanceRate__c;
			}
		}
		
		return result/100;
	}
}