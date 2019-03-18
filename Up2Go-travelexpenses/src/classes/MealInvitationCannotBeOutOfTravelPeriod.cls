public class MealInvitationCannotBeOutOfTravelPeriod implements MealInvitationRule {
	
	
	// PUBLIC METHODS
	
	public void validate(List<SObject> records) {
		List<MealInvitation__c> newInvitations = (List<MealInvitation__c>) records;

		Map<Id,Travel__c> travels = queryTravels(newInvitations);
		
		for( MealInvitation__c invitation :  newInvitations) {
			Travel__c travel = travels.get(invitation.mdr_Travel__c);
			
			if(isOutOfTravel(invitation.dat_Day__c,travel)) {
				invitation.dat_Day__c.addError(System.Label.MealInvitationCannotBeOutOfTravelPeriod);
			}
		}
	}
	
	
	// PRIVATE METHODS
	
	private Map<Id,Travel__c> queryTravels(List<MealInvitation__c> invitations) {
		Set<Id> relevantTravels = new Set<Id>();
		
		for(MealInvitation__c i : invitations) {
			relevantTravels.add(i.mdr_Travel__c);
		}
		
		Map<Id,Travel__c> resultMap = new Map<Id,Travel__c>([SELECT dtm_Start__c, dtm_End__c
										   					 FROM Travel__c
										   					 WHERE Id IN :relevantTravels]);
										   	
		return resultMap;
	}
	
	
	private Boolean isOutOfTravel(Date day, Travel__c travel) {
		Date start = travel.dtm_Start__c.date();
		Date stop = travel.dtm_End__c.date();
		
		Boolean result = (day < start) || (day > stop);
		
		return result;
	}
}