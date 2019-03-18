public with sharing class LongDistanceRidesTriggerHandler extends AbstractTriggerHandler {

	private List<LongDistanceRide__c> newLongDistanceRides;
	private List<LongDistanceRide__c> oldLongDistanceRides;
	
	private RuleValidator validator;


	// CONSTRUCTOR
	
	public LongDistanceRidesTriggerHandler() {
		newLongDistanceRides = (List<LongDistanceRide__c>) Trigger.new;
		oldLongDistanceRides = (List<LongDistanceRide__c>) Trigger.old;
		
		validator = new RuleValidator(RuleType.LongDistanceRideRule);
	}
	
	
	// PUBLIC METHODS
	
	public override void onBeforeInsert() {
		validator.validate(newLongDistanceRides);
	}
	
	
	public override void onBeforeUpdate() {
		validator.validate(newLongDistanceRides);
	}
	
	
	public override void onAfterInsert() {
		calculatePerDiems(newLongDistanceRides);
	}
	
	
	public override void onAfterUpdate() {
		calculatePerDiems(newLongDistanceRides);
	}
	
	
	public override void onAfterDelete() {
		calculatePerDiems(oldLongDistanceRides);
	}

	
	//PRIVATE METHODS
	
	private void calculatePerDiems(List<LongDistanceRide__c> longDistanceRides) {
		Set<Id> rentalVehicles = new Set<Id>();
		for(LongDistanceRide__c ldr : longDistanceRides) {
			rentalVehicles.add(ldr.mdr_RentalVehicle__c);
		}		

		for(Travel__c t : [SELECT Id, Name, CurrencyIsoCode, txt_Reason__c, txa_Description__c, 
     							  dtm_Start__c, dtm_End__c, Owner.FirstName, Owner.LastName, 
     							  rsum_TotalExpenses__c, rsum_ReimbursableExpenses__c, rsum_PerDiems__c, 
     							  fcur_Reimbursement__c
						   FROM Travel__c 
						   WHERE Id IN (SELECT mdr_Travel__c 
						  			    FROM Expense__c 
						  			    WHERE Id IN :rentalVehicles)]) {
						  			    	
			PerDiemCalculator perDiemCalculator = new PerDiemCalculator(t);
        	perDiemCalculator.calculate();
		}
	}
}