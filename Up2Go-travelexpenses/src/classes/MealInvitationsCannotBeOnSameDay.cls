public class MealInvitationsCannotBeOnSameDay implements MealInvitationRule {

	
	// PUBLIC METHODS
	
	public void validate(List<SObject> records) {
		List<MealInvitation__c> toValidate = (List<MealInvitation__c>) records;
		
		Map<Id, List<MealInvitation__c>> invitationsByTravel = queryMealInvitationsByTravel(toValidate);
		
		for(MealInvitation__c current : toValidate) {
			List<MealInvitation__c> invitations = invitationsByTravel.get(current.mdr_Travel__c);
			
			if(hasDateConflict(current, invitations)) {
				current.dat_Day__c.addError(System.Label.MealInvitationsCannotBeOnSameDay);
			}
		}						   							 								   							 		
	}
	
	
	// PRIVATE METHODS
	
	private Map<Id, List<MealInvitation__c>> queryMealInvitationsByTravel(List<MealInvitation__c> invitations) {
		Map<Id, List<MealInvitation__c>> resultMap = new Map<Id, List<MealInvitation__c>>();
		
		for(MealInvitation__c mi : invitations) {
			Id travel = mi.mdr_Travel__c;
			
			if( !resultMap.containsKey(travel)) {
				resultMap.put(travel, new List<MealInvitation__c>());
			}
		}
		
		for(MealInvitation__c mi : [SELECT dat_Day__c, mdr_Travel__c
								    FROM MealInvitation__c
								    WHERE mdr_Travel__c IN :resultMap.keySet()]) {
								   	
			resultMap.get(mi.mdr_Travel__c).add(mi);
	    }
	    
	    return resultMap;
	}
	
	
	private Boolean hasDateConflict(MealInvitation__c invitation, List<MealInvitation__c> invitations) {
		Boolean result = false;
		
		for(MealInvitation__c m : invitations) {
			if(invitation.Id != m.Id && invitation.dat_Day__c.isSameDay(m.dat_Day__c)) {
				result = true;
				break;
			}
		}
		
		return result;
	}
}