public with sharing class MealInvitationsTriggerHandler extends AbstractTriggerHandler{
	
	private List<MealInvitation__c> newMealInvitations;
	private List<MealInvitation__c> oldMealInvitations;
	
	private RuleValidator validator;
	
	
	// CONSTRUCTOR
	
	public MealInvitationsTriggerHandler() {
		newMealInvitations = (List<MealInvitation__c>) Trigger.new;
		oldMealInvitations = (List<MealInvitation__c>) Trigger.old;
		
		validator = new RuleValidator(RuleType.MealInvitationRule);
	}
	
	
	// PUBLIC METHODS
	
	public override void onBeforeInsert() {
		validator.validate(newMealInvitations);
		
		populateLookupFields(newMealInvitations);
	}
	
	
	public override void onBeforeUpdate() {
		validator.validate(newMealInvitations);
		
		populateLookupFields(newMealInvitations);
	}
	
	
	public override void onAfterInsert() {
		calculatePerDiems(newMealInvitations);
	}
	
	
	public override void onAfterUpdate() {
		calculatePerDiems(newMealInvitations);
	}
	
	
	public override void onAfterDelete() {
		calculatePerDiems(oldMealInvitations);
	}
	
	
	// PRIVATE METHODS
	
	private void calculatePerDiems(List<MealInvitation__c> mealInvitations) {
		Set<Id> mealInvitationIds = new Set<Id>();
		for(MealInvitation__c mi : mealInvitations) {
			mealInvitationIds.add(mi.mdr_Travel__c);
		}
		
		for(Travel__c travel : [SELECT Id, Name, CurrencyIsoCode, txt_Reason__c, txa_Description__c, 
         							   dtm_Start__c, dtm_End__c, Owner.FirstName, Owner.LastName, 
         							   rsum_TotalExpenses__c, rsum_ReimbursableExpenses__c, rsum_PerDiems__c, 
         							   fcur_Reimbursement__c
							    FROM Travel__c 
							    WHERE Id IN :mealInvitationIds]) {
							    	
			PerDiemCalculator perDiemCalculator = new PerDiemCalculator(travel);
        	perDiemCalculator.calculate();
		}
	}
	
	
	private void populateLookupFields(List<MealInvitation__c> mealInvitations) {
		Map<String, Id> mealIdsByName = queryMealIdsByName();
        
        for(MealInvitation__c m : mealInvitations) {
			m.lkp_Breakfast__c = null;
			m.lkp_Lunch__c = null;
			m.lkp_Dinner__c = null;
			
			if(m.chk_Breakfast__c) {
				m.lkp_Breakfast__c = mealIdsByName.get('Breakfast');
			}
			if(m.chk_Lunch__c) {
				m.lkp_Lunch__c = mealIdsByName.get('Lunch');
			}
			if(m.chk_Dinner__c) {
				m.lkp_Dinner__c = mealIdsByName.get('Dinner');
			}
		}
	}
    
    
    private Map<String, Id> queryMealIdsByName() {
        Map<String, Id> results = new Map<String, Id>();
        
		for(CompensationRate__c rate : [SELECT Id, Name 
					 					FROM CompensationRate__c 
					 					WHERE RecordTypeId = :CompensationRateType.getMealId()]) {
 			results.put(rate.Name, rate.Id);
 		}
        
        return results;
    }
}