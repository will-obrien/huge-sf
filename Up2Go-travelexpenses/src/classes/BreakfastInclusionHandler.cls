public with sharing class BreakfastInclusionHandler {
    
    private final Id BREAKFAST = [SELECT Id
		                          FROM CompensationRate__c
		                          WHERE RecordTypeId = :CompensationRateType.getMealId()
		                          AND Name = 'Breakfast'].Id;
    private List<Expense__c> accommodations;
    private Map<Id, List<MealInvitation__c>> allInvitationsByTravel;


    // CONSTRUCTOR

    public BreakfastInclusionHandler(List<Expense__c> accommodations) {
    	this.accommodations = accommodations;
    	allInvitationsByTravel = queryAllInvitations();
    }
    
    
    // PUBLIC METHODS

    public void handleInclusion(Boolean breakfastIncluded) {
    	for(Expense__c a : accommodations) {
    		startInclusion(a, breakfastIncluded);
    	}
    }
    
    
    public void handleInclusionForUpdate() {
    	for(Expense__c a : accommodations) {
    		startInclusion(a, a.chk_BreakfastIncluded__c);
    	}
    }
    
    
    public void handleRedundantInvitations(List<Expense__c> oldAccommodations) {
    	for(Expense__c old : oldAccommodations) {
    		List<MealInvitation__c> invitations = getRedundantInvitations(old);
    	
	    	deselectBreakfast(invitations);
	    	invitations = deleteEmptyInvitations(invitations);
	    	
	    	update invitations;
    	}
    }
    
    

    // PRIVATE METHODS

    private Map<Id, List<MealInvitation__c>> queryAllInvitations() {
    	Map<Id, List<MealInvitation__c>> resultMap = new Map<Id, List<MealInvitation__c>>();
    	
    	for(Expense__c a : accommodations) {
    		resultMap.put(a.mdr_Travel__c, new List<MealInvitation__c>());
    	}
    	
    	for(MealInvitation__c m : [SELECT Id, dat_Day__c, chk_Breakfast__c, chk_Lunch__c, chk_Dinner__c, mdr_Travel__c
    							   FROM MealInvitation__c
    							   WHERE mdr_Travel__c IN :resultMap.keySet()]) {
	    	List<MealInvitation__c> invitations = resultMap.get(m.mdr_Travel__c);
	    	invitations.add(m);
	    }
	    
	    return resultMap;
    }
    
    
    private void startInclusion(Expense__c accommodation, Boolean breakfastIncluded) {
    	List<MealInvitation__c> invitations = composeInvitationList(accommodation);
        
        if(breakfastIncluded) {
	        selectBreakfast(invitations);
        }
        else {
        	deselectBreakfast(invitations);
        }
        
        invitations = deleteEmptyInvitations(invitations);
        
        upsert invitations;
    }
    
    
    private List<MealInvitation__c> composeInvitationList(Expense__c accommodation) {
        List<MealInvitation__c> results = new List<MealInvitation__c>();
        
        List<Date> affectedDays = calculateAffectedDays(accommodation);
        
        Id travel = accommodation.mdr_Travel__c;
		Map<Date, MealInvitation__c> invitationsByDates = getAffectedInvitations(travel);
        
        for(Date d : affectedDays) {
        	MealInvitation__c invitation;
        	
            if( !invitationsByDates.containsKey(d)) {
 	       		invitation = new MealInvitation__c(dat_Day__c = d, mdr_Travel__c = travel);
 	       	}
 	       	else {
 	       		invitation = invitationsByDates.get(d);
 	       	}
        	
            results.add(invitation);
        }
        
        return results;
    }

	
    private List<Date> calculateAffectedDays(Expense__c accommodation) {
        List<Date> results = new List<Date>();
        
        Date checkIn = accommodation.dat_CheckInDate__c;
        Date checkOut = accommodation.dat_CheckOutDate__c;
        
        for(Date d = checkIn.addDays(1) ; !d.isSameDay(checkOut.addDays(1)) ; d = d.addDays(1)) {
            results.add(d);
        }
        
        return results;
    }


    private Map<Date, MealInvitation__c> getAffectedInvitations(Id travel) {
        Map<Date, MealInvitation__c> resultMap = new Map<Date, MealInvitation__c>();

        List<MealInvitation__c> invitations = allInvitationsByTravel.get(travel);

        for(MealInvitation__c m : invitations) {
            resultMap.put(m.dat_Day__c, m);
        }

        return resultMap;
    }
    
    
    private void selectBreakfast(List<MealInvitation__c> invitations) {
        for(MealInvitation__c i : invitations) {
            i.chk_Breakfast__c = true;
            i.lkp_Breakfast__c = BREAKFAST;
        }
    }
    
        
    private void deselectBreakfast(List<MealInvitation__c> invitations) {
        for(MealInvitation__c i : invitations) {
        	i.chk_Breakfast__c = false;
        	i.lkp_Breakfast__c = null;
        }
    }
    
    
    private List<MealInvitation__c> deleteEmptyInvitations(List<MealInvitation__c> invitations) {
    	List<MealInvitation__c> results = new List<MealInvitation__c>();
    	
    	for(MealInvitation__c i : invitations) {
    		
    		if(hasMeal(i)) {
    			results.add(i);
    		}
    		else if(existsInDatabase(i)) {
    			delete i;
    		}
    	}
    	
    	return results;
    }
    
    
    private Boolean hasMeal(MealInvitation__c i) {
    	Boolean result = i.chk_Breakfast__c || i.chk_Lunch__c || i.chk_Dinner__c;
    	
    	return result;
    }
    
    
    private Boolean existsInDatabase(MealInvitation__c i) {
    	Boolean result = (i.Id != null);
    	
    	return result;
    }
    
    
    private List<MealInvitation__c> getRedundantInvitations(Expense__c old) {
    	List<MealInvitation__c> results = new List<MealInvitation__c>();
    	
    	Set<Date> redundantDays = getRedundantDays(old);
    	
    	List<MealInvitation__c> invitations = allInvitationsByTravel.get(old.mdr_Travel__c);
    	for(MealInvitation__c m : invitations) {
    		if(redundantDays.contains(m.dat_Day__c)) {
    			results.add(m);
    		}
    	}
    	
    	return results;
    }
    
    
    private Set<Date> getRedundantDays(Expense__c old) {
    	Set<Date> results = new Set<Date>();
    	
		results.addAll(examineStartOfStay(old));
    	results.addAll(examineEndOfStay(old));

    	return results;
    }
    
    
    private List<Date> examineStartOfStay(Expense__c old) {
    	List<Date> results = new List<Date>();
    	Expense__c accommodation = findUpdatedVersionOf(old);
    	
    	Date newCheckIn = accommodation.dat_CheckInDate__c;
    	Date oldCheckIn = old.dat_CheckInDate__c;
    	
    	if(newCheckIn > oldCheckIn) {
    		for(Date d = oldCheckIn ; !d.isSameDay(newCheckIn.addDays(1)) ; d = d.addDays(1)) {
    			results.add(d);
    		}
    	}
		
    	return results;
    }
    
    
    private List<Date> examineEndOfStay(Expense__c old) {
    	List<Date> results = new List<Date>();
    	Expense__c accommodation = findUpdatedVersionOf(old);
    	
    	Date newCheckOut = accommodation.dat_CheckOutDate__c;
    	Date oldCheckOut = old.dat_CheckOutDate__c;
    	
    	if(newCheckOut < oldCheckOut) {
    		for(Date d = oldCheckOut ; !d.isSameDay(newCheckOut) ; d = d.addDays(-1)) {
				results.add(d);
			}
    	}

    	return results;
    }
    
    
    private Expense__c findUpdatedVersionOf(Expense__c old) {
    	Expense__c result;
    	
    	for(Expense__c a : accommodations) {
    		if(a.Id == old.Id) {
    			result = a;
    			
    			break;
    		}
    	}
    	
    	return result;
    }
}