public with sharing class ExpenseAmountCannotBeNegative implements ExpenseRule {
 	
    public void validate(List<SObject> records) {
    	String errorMessage = System.Label.ExpenseAmountCannotBeNegative;

    	for(Expense__c expense : (List<Expense__c>)records) {
    		
	        if(ExpenseType.isEntertainment(expense)) {
                if( (expense.cur_Bill__c + expense.cur_Tip__c) < 0 ) {
                    expense.cur_Bill__c.addError(errorMessage);
                	expense.cur_Tip__c.addError(errorMessage);
                } 	
	        }
	        else if(expense.cur_Amount__c < 0){
		    	expense.cur_Amount__c.addError(errorMessage);
	        }
    	}
    }
}