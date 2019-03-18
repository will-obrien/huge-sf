public with sharing class ExpenseNeedsReturnInformationIfRoundTrip  implements ExpenseRule {
 
 
    public void validate(List<SObject> records) {
    	String errorMessage = System.Label.YouMustEnterValue;

    	for(Expense__c expense : (List<Expense__c>)records) {
    		
	        if (expense.chk_RoundTrip__c) {
	        	if( expense.dtm_ReturnDeparture__c == null ) {
	        		expense.dtm_ReturnDeparture__c.addError(errorMessage);
	        	}
	        	if( expense.dtm_ReturnArrival__c == null ) {
	        		expense.dtm_ReturnArrival__c.addError(errorMessage);
	        	}
	        }
    	}
    }
}