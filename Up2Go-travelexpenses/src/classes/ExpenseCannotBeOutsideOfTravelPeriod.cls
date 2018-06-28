public with sharing class ExpenseCannotBeOutsideOfTravelPeriod implements ExpenseRule{     
     
     private String errorMessage = System.Label.ExpenseCannotBeOutsideOfTravelPeriod;
     private Travel__c travel;
     
     
	// PUBLIC METHODS
     
    public void validate(List<SObject> records) {
    	List<Expense__c> expenses = (List<Expense__c>) records;

    	Map<Id,Travel__c> relevantTravels = queryRelevantTravels(expenses);
    	
		for(Expense__c expense : expenses) {
			travel = relevantTravels.get(expense.mdr_Travel__c);
			
	        if(ExpenseType.isMovement(expense)) {
	        	checkMovementExpense(expense);
	        }
	        else if(ExpenseType.isAccommodation(expense)) {
	    		checkAccommodationExpense(expense);
        	}
			else if(ExpenseType.isRentalVehicle(expense)) {
				checkRentalVehicleExpense(expense);
			}
			else if((ExpenseType.isEntertainment(expense) || ExpenseType.isMiscellaneous(expense))){
				checkLocalExpense(expense);
			}
		}
    }
    
    
    // PRIVATE METHODS
    
    private Map<Id,Travel__c> queryRelevantTravels(List<Expense__c> expenses) {
    	Set<Id> travels = new Set<Id>();
    	for(Expense__c e : expenses) {
    		travels.add(e.mdr_Travel__c);
    	}
    	
    	Map<Id,Travel__c> resultMap = new Map<Id,Travel__c>([SELECT Id, dtm_Start__c, dtm_End__c 
    														  FROM Travel__c
    														  WHERE Id IN :travels]);
    	
    	return resultMap;
    }
    
    
    private void checkMovementExpense(Expense__c expense) {
    	if(isOutsideOfTravel(expense.dtm_DepartureTime__c)) {
            expense.dtm_DepartureTime__c.addError(errorMessage);            
    	}
    	if(isOutsideOfTravel(expense.dtm_ArrivalTime__c)) {
    		expense.dtm_ArrivalTime__c.addError(errorMessage);
    	}
    	
    	if(hasRoundTrip(expense)) {
    		
    		if(isOutsideOfTravel(expense.dtm_ReturnDeparture__c)) {
    			expense.dtm_ReturnDeparture__c.addError(errorMessage);
    		}
    		if(isOutsideOfTravel(expense.dtm_ReturnArrival__c)) {
    			expense.dtm_ReturnArrival__c.addError(errorMessage);
    		}
    	}
    }
    
    
    private void checkAccommodationExpense(Expense__c expense) {
    	if(isOutsideOfTravel(expense.dat_CheckInDate__c)) {
    		expense.dat_CheckInDate__c.addError(errorMessage);     
		}
		if(isOutsideOfTravel(expense.dat_CheckOutDate__c)) {
			expense.dat_CheckOutDate__c.addError(errorMessage);
		}
    }
    
    
    private void checkRentalVehicleExpense(Expense__c expense) {
    	if(isOutsideOfTravel(expense.dat_PickUpDate__c)) {
			expense.dat_PickUpDate__c.addError(errorMessage);
		}
		if(isOutsideOfTravel(expense.dat_ReturnDate__c)) {
			expense.dat_ReturnDate__c.addError(errorMessage);
		}				
    }
    
    
    private void checkLocalExpense(Expense__c expense) {
    	if(IsOutsideOfTravel(expense.dat_ExpenseDate__c)) {
			expense.dat_ExpenseDate__c.addError(errorMessage);
    	}
    }
    
    
    private Boolean isOutsideOfTravel(Date day) {
    	Boolean result = day < travel.dtm_Start__c.date() || day > travel.dtm_End__c.date();
        				  
        return result;
    }
    
    
    private Boolean isOutsideOfTravel(DateTime dtm) {
    	Boolean result = dtm < travel.dtm_Start__c || dtm > travel.dtm_End__c;

    	return result;
    }
    
    
    private Boolean hasRoundTrip(Expense__c e) {
    	Boolean result = e.chk_RoundTrip__c && e.dtm_ReturnDeparture__c != null && e.dtm_ReturnArrival__c != null;
    	
    	return result;
    }
}