public with sharing class ExpensesTriggerHandler extends AbstractTriggerHandler{
	
	private List<Expense__c> newExpenses;
	private List<Expense__c> oldExpenses;
	private Map<Id, Expense__c> oldExpensesById;
	
	private RuleValidator validator;
		
	
	//CONSTRUCTOR
	
	public ExpensesTriggerHandler() {
		newExpenses = filterOutPerDiems(Trigger.new);
		oldExpenses = filterOutPerDiems(Trigger.old);
		oldExpensesById = filterOutPerDiems(Trigger.oldMap);
		
		validator = new RuleValidator(RuleType.ExpenseRule);
	}
	
	
	// PUBLIC METHODS
	
	public override void onBeforeInsert() {
		validator.validate(newExpenses);	
			
		populateFields(newExpenses);
		manageBreakfastInclusionForInsert(newExpenses);
	}
	
	
	public override void onBeforeUpdate() {
		validator.validate(newExpenses);		
		
		populateFields(newExpenses);
		manageBreakfastInclusionForUpdate(newExpenses);
	}
	
	
	public override void onBeforeDelete() {
		manageBreakfastInclusionForDelete(oldExpenses);
	}
	
	
	public override void onAfterInsert() {
		calculatePerDiems(newExpenses);
	}
	
	
	public override void onAfterUpdate() {
		calculatePerDiems(newExpenses);
	}
	
	
	public override void onAfterDelete() {
		calculatePerDiems(oldExpenses);
	}
			
	
	// PRIVATE METHODS
	
	private List<Expense__c> filterOutPerDiems(List<SObject> expenses) {
		List<Expense__c> results = new List<Expense__c>();
		
		if(expenses != null && !expenses.isEmpty()) {
			for(Expense__c e : (List<Expense__c>) expenses) {
				if(!ExpenseType.isPerDiem(e)) {
					results.add(e);
				}
			}
		}
		
		return results;
	}
	
	
	private Map<Id, Expense__c> filterOutPerDiems(Map<Id,SObject> oldExpenses) {
		Map<Id, Expense__c> resultMap = new Map<Id, Expense__c>();
		
		if( oldExpenses != null && !oldExpenses.isEmpty()) {
			for(Expense__c e : (List<Expense__c>)oldExpenses.values()) {
				resultMap.put(e.Id, e);
			}
		}
		
		return resultMap;
	}
	
	
	private void calculatePerDiems(List<Expense__c> expenses) {
		Set<Id> travels = new Set<Id>();
		for(Expense__c e : expenses) {
			travels.add(e.mdr_Travel__c);
		}
		
		for(Travel__c t : [SELECT Id, Name, CurrencyIsoCode, txt_Reason__c, txa_Description__c, 
     							  dtm_Start__c, dtm_End__c, Owner.FirstName, Owner.LastName, 
     							  rsum_TotalExpenses__c, rsum_ReimbursableExpenses__c, rsum_PerDiems__c, 
     							  fcur_Reimbursement__c
						   FROM Travel__c 
						   WHERE Id IN :travels]) {
						   	
			PerDiemCalculator perDiemCalculator = new PerDiemCalculator(t);
        	perDiemCalculator.calculate();
		}
	}
	
	
	private void populateFields(List<Expense__c> expenses) {
		for(Expense__c expense : expenses) {
			populateExpenseDate(expense);
			populateAmount(expense);
			populateReimbursement(expense);
			clearRoundTripFields(expense);
		}		
	}
	
	
	private void clearRoundTripFields(Expense__c expense) {
		if(expense.chk_RoundTrip__c == false) {
			expense.dtm_ReturnDeparture__c = null;
			expense.dtm_ReturnArrival__c = null;
		}
	}


	private void populateExpenseDate(Expense__c expense) {
		if(ExpenseType.isMovement(expense)) {
			expense.dat_ExpenseDate__c = expense.dtm_DepartureTime__c.date();
		}
		else if(ExpenseType.isAccommodation(expense)) {
			expense.dat_ExpenseDate__c = expense.dat_CheckOutDate__c;
		}
		else if(ExpenseType.isRentalVehicle(expense)) {
			expense.dat_ExpenseDate__c = expense.dat_ReturnDate__c;
		}
	}
	
	
	private void populateAmount(Expense__c expense) {
		if(ExpenseType.isPrivateVehicle(expense)) {			
			expense.cur_Amount__c = expense.fcur_MilageCosts__c;
		}
		else if(ExpenseType.isEntertainment(expense)) {
			expense.cur_Amount__c = expense.cur_Bill__c + expense.cur_Tip__c;
		}
	}
	
	
	private void populateReimbursement(Expense__c expense) {
		if(ExpenseType.isPrivateVehicle(expense)) {			
			expense.pkl_Reimbursement__c = 'I paid for this, please reimburse me.';
		}
		else if(ExpenseType.isCompanyVehicle(expense)) {			
			expense.pkl_Reimbursement__c = 'The company paid for this.';
		}
	}
	
	
	private void manageBreakfastInclusionForInsert(List<Expense__c> expenses) {
		List<Expense__c> accommodations = findAccommodationsWithBreakfastIncluded(expenses);
		Boolean includeBreakfast = true;
		
		if( !accommodations.isEmpty()) {
			BreakfastInclusionHandler handler = new BreakfastInclusionHandler(accommodations);
			handler.handleInclusion(includeBreakfast);
		}
	}
	
	
	private void manageBreakfastInclusionForUpdate(List<Expense__c> expenses) {
		List<Expense__c> accommodations = findAccommodationsWhichNeedHandler(expenses);
		List<Expense__c> oldAccommodations = findAccommodationsWithRedundantInvitations(accommodations);
		
		if( !accommodations.isEmpty()) {
			BreakfastInclusionHandler handler = new BreakfastInclusionHandler(accommodations);
			handler.handleRedundantInvitations(oldAccommodations);
			handler.handleInclusionForUpdate();
		}
	}
	
	
	private void manageBreakfastInclusionForDelete(List<Expense__c> expenses) {
		List<Expense__c> accommodations = findAccommodationsWithBreakfastIncluded(expenses);
		Boolean includeBreakfast = false;
		
		if( !accommodations.isEmpty()) {
			BreakfastInclusionHandler handler = new BreakfastInclusionHandler(accommodations);
			handler.handleInclusion(includeBreakfast);
		}
	}
	
	
	private List<Expense__c> findAccommodationsWithBreakfastIncluded(List<Expense__c> expenses) {
		List<Expense__c> results = new List<Expense__c>();
		
		for(Expense__c a : onlyAccommodationsIn(expenses)) {
			if(a.chk_BreakfastIncluded__c) {
				results.add(a);
			}
		}
		
		return results;
	}
	
	
	private List<Expense__c> onlyAccommodationsIn(List<Expense__c> expenses) {
		List<Expense__c> results = new List<Expense__c>();
		
		for(Expense__c e : expenses) {
			if(ExpenseType.isAccommodation(e)) {
				results.add(e);
			}
		}
		
		return results;
	}
	
	
	private List<Expense__c> findAccommodationsWhichNeedHandler(List<Expense__c> expenses) {
		List<Expense__c> results = new List<Expense__c>();
		
		for(Expense__c updated : onlyAccommodationsIn(expenses)) {
			Expense__c old = oldExpensesById.get(updated.Id);
			
			if(needsBreakfastInclusion(updated, old)) {
				results.add(updated);
			}
		}
		
		return results;
	}
	
	
	private Boolean needsBreakfastInclusion(Expense__c updated, Expense__c old) {
		Boolean result = (updated.chk_BreakfastIncluded__c && timePeriodChanged(updated, old))
						 || breakfastIncludedChanged(updated, old);
		
		return result;
	}
	
	
	private Boolean timePeriodChanged(Expense__c updated, Expense__c old) {
		Boolean result = (updated.dat_CheckInDate__c != old.dat_CheckInDate__c) 
						 || (updated.dat_CheckOutDate__c != old.dat_CheckOutDate__c);
		
		return result;
	}
	
	
	private Boolean breakfastIncludedChanged(Expense__c updated, Expense__c old) {
		Boolean result = (updated.chk_BreakfastIncluded__c != old.chk_BreakfastIncluded__c);
		
		return result;
	}
	
	
	private List<Expense__c> findAccommodationsWithRedundantInvitations(List<Expense__c> accommodations) {
		List<Expense__c> results = new List<Expense__c>();
		
		for(Expense__c updated : accommodations) {
			Expense__c old = oldExpensesById.get(updated.Id);
			
			if(timePeriodHasBeenReduced(updated, old)) {
				results.add(old);
			}
		}
		
		return results;
	}
	
	
	private Boolean timePeriodHasBeenReduced(Expense__c updated, Expense__c old) {
		Boolean result = (updated.dat_CheckInDate__c > old.dat_CheckInDate__c)
						 || (updated.dat_CheckOutDate__c < old.dat_CheckOutDate__c);
		
		return result;
	}
}