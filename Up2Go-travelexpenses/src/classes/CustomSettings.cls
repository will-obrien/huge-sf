public with sharing class CustomSettings {
	
	
	// PUBLIC METHODS
	
	public static void addDefault() {
		CustomSettings__c settings = new CustomSettings__c();
		
		settings.Name = 'Test Defaults';
		settings.txt_ExpenseRuleClasses__c = 'UP2GO_ITE.ExpenseCannotBeOutsideOfTravelPeriod, UP2GO_ITE.ExpenseCannotEndBeforeStart, UP2GO_ITE.ExpenseHasValidLocation, UP2GO_ITE.ExpenseNeedsReturnInformationIfRoundTrip, UP2GO_ITE.ExpensesDontOverlap, UP2GO_ITE.ExpenseAmountCannotBeNegative';
		settings.txt_LongDistanceRideRuleClasses__c = 'UP2GO_ITE.RideCannotBeOutsideOfRental, UP2GO_ITE.RideCannotEndBeforeStart, UP2GO_ITE.RideHasValidLocation, UP2GO_ITE.RidesDontOverlap, UP2GO_ITE.RidesCannotBeOutsideOfTravel, UP2GO_ITE.RideNeedsReturnInfoWhenRoundTripChecked';
		settings.txt_MealInvitationRuleClasses__c = 'UP2GO_ITE.MealInvitationCannotBeOutOfTravelPeriod, UP2GO_ITE.MealInvitationsCannotBeOnSameDay';
		settings.txt_SaveTravelRuleClasses__c = 'UP2GO_ITE.TravelCannotEndBeforeStart, UP2GO_ITE.TravelsDontOverlap';
		settings.txt_SubmitTravelRuleClasses__c ='UP2GO_ITE.TravelHasNoMovementGaps';
		
		insert settings;
	}
}