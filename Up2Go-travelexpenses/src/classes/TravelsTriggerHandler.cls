public with sharing class TravelsTriggerHandler extends AbstractTriggerHandler {
	
	private List<Travel__c> newTravels;
	private List<Travel__c> oldTravels;
	
	private RuleValidator validator;
	
	
	//CONSTRUCTOR
	
	public TravelsTriggerHandler() {
		newTravels = (List<Travel__c>) Trigger.new;
		oldTravels = (List<Travel__c>) Trigger.old;
		
		validator = new RuleValidator(RuleType.SaveTravelRule);
	}
	
	
	// PUBLIC METHODS
	
	public override void onBeforeInsert() {
		validator.validate(newTravels);
		
		setCurrencyToEUR(newTravels);
	}
	
	
	public override void onBeforeUpdate() {
		validator.validate(newTravels);
		
		setCurrencyToEUR(newTravels);
	}
	
	
	public override void onAfterInsert() {
		calculatePerDiems(newTravels);
	}
	
	
	public override void onAfterUpdate() {
		revalidateExistingExpensesAndInvitations(newTravels);
		
		calculatePerDiems(newTravels);
	}
	
	
	// PRIVATE METHODS
	
	private void setCurrencyToEUR(List<Travel__c> travels) {
		for(Travel__c travel : travels) {
			travel.CurrencyIsoCode = 'EUR';
		}
	}
	
	
	private void calculatePerDiems(List<Travel__c> travels) {
		for(Travel__c travel : travels) {
			PerDiemCalculator perDiemCalculator = new PerDiemCalculator(travel);
        	perDiemCalculator.calculate();
		}
	}
	
	
	private void revalidateExistingExpensesAndInvitations(List<Travel__c> travels) {
		Map<Id, Travel__c> oldTravels = (Map<Id, Travel__c>)Trigger.oldMap;
		List<Travel__c> travelsToBeRevalidated = new List<Travel__c>();
		
		for(Travel__c t : travels) {
			Travel__c oldVersion = oldTravels.get(t.Id);
			
			if(timePeriodHasBeenReduced(t, oldVersion)) {
				travelsToBeRevalidated.add(t);
			}
		}
		
		TravelRevalidator revalidator = new TravelRevalidator(travelsToBeRevalidated);
		revalidator.revalidate();
	}
	
	
	private Boolean timePeriodHasBeenReduced(Travel__c updated, Travel__c old) {
		Boolean result = (updated.dtm_Start__c > old.dtm_Start__c) || (updated.dtm_End__c < old.dtm_End__c);
		
		return result;
	}
}