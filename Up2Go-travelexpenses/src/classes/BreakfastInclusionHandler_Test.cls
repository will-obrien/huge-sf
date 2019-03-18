@isTest
private class BreakfastInclusionHandler_Test {
    
    private static final DateTime TRAVEL_START = dateTime(System.today(), 12,00);
    private static final DateTime TRAVEL_END = dateTime(System.today().addDays(2), 18,00);
    
    static {
        CustomSettings.addDefault();
    }
    
    
    @isTest
    private static void newInvitationsAreInserted() {

        // Setup
        Exception unexpectedException;
        String message = '';
        
        Date checkIn = TRAVEL_START.date();
        Date checkOut = TRAVEL_END.date();
        Travel__c t;


        // Exercise
        try{
            t = new TravelBuilder(TRAVEL_START,TRAVEL_END).
                                  addAccommodationWithBreakfastIncluded(checkIn, checkOut).
                                  create();
        }
        catch(Exception e) {
            unexpectedException = e;
            message = e.getStackTraceString();
        }
        

        // Verify
        System.assertEquals(null,unexpectedException,message);
        
        List<MealInvitation__c> invitations = findInvitations(t, checkIn, checkOut);
        
        assertCorrectNumberOfInvitations(invitations,checkIn,checkOut);
        System.assert(haveBreakfast(invitations));
    }


    @isTest
    private static void noInvitationForCheckInDay() {

        // Setup
        Exception unexpectedException;
        String message = '';
        
        Date checkIn = TRAVEL_START.date();
        Date checkOut = TRAVEL_END.date();
        Travel__c t;
        
        
        // Exercise
        try{
            t = new TravelBuilder(TRAVEL_START,TRAVEL_END).
                                  addAccommodationWithBreakfastIncluded(checkIn,checkOut).
                                  create();
        }
        catch(Exception e) {
            unexpectedException = e;
            message = e.getStackTraceString();
        }


        // Verify
        System.assertEquals(null, unexpectedException,message);

        MealInvitation__c invitation = findInvitation(t, checkIn);
        
        System.assertEquals(null,invitation);
    }


    @isTest
    private static void noDuplicateInvitations() {

        // Setup
        Exception unexpectedException;
        String message = '';
        
        Date checkIn = TRAVEL_START.date();
        Date checkOut = TRAVEL_END.date();
        Travel__c t;


        // Exercise
        try {
            t = new TravelBuilder(TRAVEL_START,TRAVEL_END).
                                  addMealInvitation(checkOut,true,false,false).
                                  addAccommodationWithBreakfastIncluded(checkIn,checkOut).
                                  create();
        }
        catch(Exception e) {
            unexpectedException = e;
            message = e.getStackTraceString();
        }


        // Verify
        System.assertEquals(null,unexpectedException,message);
        
        List<MealInvitation__c> invitations = findInvitations(t, checkIn, checkOut);
        
        assertCorrectNumberOfInvitations(invitations,checkIn,checkOut);
    }

   
   @isTest 
    private static void existingInvitationsNotChangedWhenNormalAccommodationInserted() {
    	
    	// Setup
    	Exception unexpectedException;
        String message = '';
        
        Date checkIn = TRAVEL_START.date();
        Date checkOut = TRAVEL_END.date();
        Travel__c t;
        
        
        // Exercise
        try {
            t = new TravelBuilder(TRAVEL_START,TRAVEL_END).
                                  addMealInvitation(checkOut,false,true,false).
                                  addDefaultAccommodation(checkIn,checkOut).
                                  create();
        }
        catch(Exception e) {
            unexpectedException = e;
            message = e.getStackTraceString();
        }
        
        
        // Verify
        System.assertEquals(null,unexpectedException,message);
        
        MealInvitation__c invitation = findInvitation(t, checkOut);
        
        System.assert( !hasBreakfast(invitation));
    } 
    
    
    @isTest
    private static void existingInvitationIsUpdatedWhenAccommodationInserted() {
        // Setup
        Exception unexpectedException;
        String message = '';
        
        Date checkIn = TRAVEL_START.date();
        Date checkOut = TRAVEL_END.date();
        Travel__c t;
        
        
        // Exercise
        try {
            t = new TravelBuilder(TRAVEL_START,TRAVEL_END).
                                  addMealInvitation(checkOut,false,false,false).
                                  addAccommodationWithBreakfastIncluded(checkIn,checkOut).
                                  create();
        }
        catch(Exception e) {
            unexpectedException = e;
            message = e.getStackTraceString();
        }
        
        
        // Verify
        System.assertEquals(null,unexpectedException,message);
        
        MealInvitation__c invitation = findInvitation(t, checkOut);
        
        System.assert(hasBreakfast(invitation));
    }


    @isTest
    private static void existingInvitationIsUpdatedWhenAccommodationUpdated() {
        
        // Setup
        Exception unexpectedException;
        String message = '';
        
        Date checkIn = TRAVEL_START.date();
        Date checkOut = TRAVEL_END.date();
        
        Travel__c t = new TravelBuilder(TRAVEL_START,TRAVEL_END).
                                        addMealInvitation(checkIn.addDays(1),false,true,false).
                                        addAccommodationWithBreakfastIncluded(checkIn,checkOut).
                                        create();
        
        
        // Exercise
        try{
            setAccommodationToNoBreakfastIncluded(t);
        }
        catch(Exception e) {
            unexpectedException = e;
            message = e.getStackTraceString();
        }
        
        
        // Verify
        System.assertEquals(null,unexpectedException, message);
        
        MealInvitation__c invitation = findInvitation(t,checkIn.addDays(1));
        
        System.assert( !hasBreakfast(invitation));
    }

    
    @isTest
    private static void existingInvitationIsUpdatedWhenAccommodationDeleted() {
        
        // Setup
        Exception unexpectedException;
        String message = '';
        
        Date checkIn = TRAVEL_START.date();
        Date checkOut = TRAVEL_END.date();
        
        Travel__c t = new TravelBuilder(TRAVEL_START,TRAVEL_END).
                                        addMealInvitation(checkIn.addDays(1),false,true,false).
                                        addAccommodationWithBreakfastIncluded(checkIn,checkOut).
                                        create();
                                        
        
        // Exercise
        try{
            deleteAccommodation(t);
        }
        catch(Exception e) {
            unexpectedException = e;
            message = e.getStackTraceString();
        }
        
        
        // Verify
        System.assertEquals(null,unexpectedException, message);
        
        MealInvitation__c invitation = findInvitation(t,checkIn.addDays(1));
        
        System.assert( !hasBreakfast(invitation));
    }

    
    @isTest
    private static void emptyInvitationIsDeletedWhenAccommodationUpdated() {
        
        // Setup
        Exception unexpectedException;
        String message = '';
        
        Date checkIn = TRAVEL_START.date();
        Date checkOut = TRAVEL_END.date();
        
        Travel__c t = new TravelBuilder(TRAVEL_START,TRAVEL_END).
                                        addAccommodationWithBreakfastIncluded(checkIn,checkOut).
                                        create();
                                        
        
        // Exercise
        try{
            setAccommodationToNoBreakfastIncluded(t);
        }
        catch(Exception e) {
            unexpectedException = e;
            message = e.getStackTraceString();
        }
        
        
        // Verify
        System.assertEquals(null,unexpectedException, message);
        
        List<MealInvitation__c> invitations = findInvitations(t,checkIn,checkOut);
        
        System.assertEquals(0, invitations.size());
    }

    
    @isTest
    private static void emptyInvitationIsDeletedWhenAccommodationDeleted() {
    	
    	// Setup
        Exception unexpectedException;
        String message = '';
        
        Date checkIn = TRAVEL_START.date();
        Date checkOut = TRAVEL_END.date();
        
        Travel__c t = new TravelBuilder(TRAVEL_START,TRAVEL_END).
                                        addAccommodationWithBreakfastIncluded(checkIn,checkOut).
                                        create();
                                        
        
        // Exercise
        try{
            deleteAccommodation(t);
        }
        catch(Exception e) {
            unexpectedException = e;
            message = e.getStackTraceString();
        }
        
        
        // Verify
        System.assertEquals(null,unexpectedException, message);
        
        List<MealInvitation__c> invitations = findInvitations(t,checkIn,checkOut);
        
        System.assertEquals(0, invitations.size());
    }


	@isTest
	private static void invitationsAreCorrectIfStayIsExtended() {
		
		// Setup
        Exception unexpectedException;
        String message = '';
        
        Date checkIn = TRAVEL_START.date();
        Date checkOut = checkIn.addDays(1);
        
        Travel__c t = new TravelBuilder(TRAVEL_START,TRAVEL_END).
                                        addAccommodationWithBreakfastIncluded(checkIn,checkOut).
                                        create();
        Date newCheckOut = checkOut.addDays(1);                                
        
        
        // Exercise
        try {
        	changeCheckOutDay(t, newCheckOut);
        }
        catch(Exception e) {
        	unexpectedException = e;
        	message = e.getStackTraceString();
        }
        
        
        // Verify
        System.assertEquals(null,unexpectedException, message);
        
        List<MealInvitation__c> invitations = findInvitations(t, checkIn, newCheckOut);
        
        assertCorrectNumberOfInvitations(invitations,checkIn, newCheckOut);
        System.assert(haveBreakfast(invitations));
	}
	
	
	@isTest
	private static void invitationsAreCorrectIfAccommodationStopsEarlier() {
		
		// Setup
        Exception unexpectedException;
        String message = '';
        
        Date checkIn = TRAVEL_START.date();
        Date checkOut = TRAVEL_END.date();
        
        Travel__c t = new TravelBuilder(TRAVEL_START,TRAVEL_END).
                                        addAccommodationWithBreakfastIncluded(checkIn,checkOut).
                                        create();
        Date newCheckOut = checkOut.addDays(-1);
        
        
        // Exercise
        try {
        	changeCheckOutDay(t, newCheckOut);
        }
        catch(Exception e) {
        	unexpectedException = e;
        	message = e.getStackTraceString();
        }
        
        
        // Verify
        System.assertEquals(null,unexpectedException, message);
        
        List<MealInvitation__c> invitations = findInvitations(t, checkIn, checkOut);
        
        assertCorrectNumberOfInvitations(invitations,checkIn, newCheckOut);
        System.assert(haveBreakfast(invitations));
	}
	
	
	@isTest
	private static void invitationsAreCorrectIfAccommodationBeginsLater() {
		
		// Setup
        Exception unexpectedException;
        String message = '';
        
        Date checkIn = TRAVEL_START.date();
        Date checkOut = TRAVEL_END.date();
        
        Travel__c t = new TravelBuilder(TRAVEL_START,TRAVEL_END).
                                        addAccommodationWithBreakfastIncluded(checkIn,checkOut).
                                        create();
        Date newCheckIn = checkIn.addDays(1);
        
        
        // Exercise
        try {
        	changeCheckInDay(t, newCheckIn);
        }
        catch(Exception e) {
        	unexpectedException = e;
        	message = e.getStackTraceString();
        }
        
        
        // Verify
        System.assertEquals(null,unexpectedException, message);
        
        List<MealInvitation__c> invitations = findInvitations(t, checkIn, checkOut);

        assertCorrectNumberOfInvitations(invitations,newCheckIn, checkOut);
        System.assert(haveBreakfast(invitations));
	}
	
	
    // TESTHELPER
    private static DateTime dateTime(Date day, Integer hour, Integer minute) {
        Time t = Time.newInstance(hour, minute, 0, 0);
        DateTime result = DateTime.newInstance(day, t);
        
        return result;
    }
    
    
    private static MealInvitation__c findInvitation(Travel__c t, Date day) {
        List<MealInvitation__c> result = [SELECT Id, chk_Breakfast__c
                                          FROM MealInvitation__c
                                          WHERE mdr_Travel__c = :t.Id
                                          AND dat_Day__c = :day
                                          LIMIT 1];

        return result.isEmpty() ? null : result[0];
    }


    private static List<MealInvitation__c> findInvitations(Travel__c t, Date start, Date stop) {
        List<Date> days = countDays(start,stop);

        List<MealInvitation__c> results = [SELECT Id, chk_Breakfast__c
                                           FROM MealInvitation__c
                                           WHERE mdr_Travel__c = :t.Id
                                           AND dat_Day__c IN :days];

       return results;
    }


    private static List<Date> countDays(Date start, Date stop) {
        List<Date> results = new List<Date>();
        
        for(Date d = start ; !d.isSameDay(stop.addDays(1)) ; d = d.addDays(1)) {
        	results.add(d);
        }

        return results;
    }
    
    
    private static void assertCorrectNumberOfInvitations(List<MealInvitation__c> invitations, Date checkIn, Date checkOut) {
        List<Date> days = countDays(checkIn.addDays(1), checkOut);
        Integer expectedInvitations = days.size();

        System.assertEquals(expectedInvitations, invitations.size());
    }


    private static Boolean hasBreakfast(MealInvitation__c invitation) {
        Boolean result = invitation.chk_Breakfast__c;
        
        return result;
    }
    
    
    private static Boolean haveBreakfast(List<MealInvitation__c> invitations) {
        Boolean result = true;

        for(MealInvitation__c m : invitations) {
            if( !m.chk_Breakfast__c) {
                result = false;

                break;
            }
        }

        return result;
    }
    
    
    private static void setAccommodationToNoBreakfastIncluded(Travel__c t) {
        Expense__c accommodation = findAccommodation(t.Id);
                                    
        accommodation.chk_BreakfastIncluded__c = false;
        
        update accommodation;
    }
    
    
    private static void deleteAccommodation(Travel__c t) {
    	Expense__c accommodation = findAccommodation(t.Id);
                                    
        delete accommodation;
    }
    
    
    private static void changeCheckOutDay(Travel__c t, Date newCheckOut) {
    	Expense__c accommodation = findAccommodation(t.Id);
    	
    	accommodation.dat_CheckOutDate__c = newCheckOut;
    	
    	update accommodation;
    }
    
    
    private static void changeCheckInDay(Travel__c t, Date newCheckIn) {
    	Expense__c accommodation = findAccommodation(t.Id);
    	
    	accommodation.dat_CheckInDate__c = newCheckIn;
    	
    	update accommodation;
    }
    
    
    private static Expense__c findAccommodation(Id travel) {
    	Expense__c result = [SELECT Id, dat_CheckOutDate__c
                             FROM Expense__c
                             WHERE mdr_Travel__c = :travel
                             AND RecordTypeId = :ExpenseType.getAccommodationRecordTypeId()];
                             
     	return result;
    }
}