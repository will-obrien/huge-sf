public with sharing class ExpenseCannotEndBeforeStart implements ExpenseRule {
    
 
    public void validate(List<SObject> records) {
    	String errorMessage = System.Label.ExpenseCannotEndBeforeStart;

    	for(Expense__c expense : (List<Expense__c>)records) {
    		
	        if (ExpenseType.isMovement(expense)) {
	        	if(expense.dtm_ArrivalTime__c <= expense.dtm_DepartureTime__c) {
		        	expense.dtm_ArrivalTime__c.addError(errorMessage);
	        	}
	        	
	        	if(hasRoundTrip(expense) && expense.dtm_ReturnArrival__c <= expense.dtm_ReturnDeparture__c) {
	        		expense.dtm_ReturnArrival__c.addError(errorMessage);
	        	}
	        }
	        else if(ExpenseType.isAccommodation(expense) && expense.dat_CheckOutDate__c <= expense.dat_CheckInDate__c) {
		    	expense.dat_CheckOutDate__c.addError(errorMessage);
	        }
	        else if (ExpenseType.isRentalVehicle(expense) && expense.dat_ReturnDate__c < expense.dat_PickUpDate__c) {
	        	expense.dat_ReturnDate__c.addError(errorMessage);
	        }
    	}
    }
    
    
    // PRIVATE METHODS
    
    private Boolean hasRoundTrip(Expense__c e) {
    	Boolean result = e.chk_RoundTrip__c && e.dtm_ReturnDeparture__c != null && e.dtm_ReturnArrival__c != null;
    	
    	return result;
    }
}