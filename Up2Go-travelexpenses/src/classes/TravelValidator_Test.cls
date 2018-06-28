@isTest
private class TravelValidator_Test {
	
	static {
		CustomSettings.addDefault();
	}
        
        
    @isTest
    private static void validTravelCanBeInserted() {
        
        // Setup
        
        Exception unexpectedException;
        String message = '';        
        
        
        // Exercise
        try {
            Travel__c travel = new TravelBuilder(System.now(), System.now().addDays(1))
                                        .create();
        }
        catch(Exception ex) { 
            unexpectedException = ex;
            message = unexpectedException.getStackTraceString();
        }
        
        
        // Verify
        System.assertEquals(null, unexpectedException, message);
    }
    
            
    @isTest
    private static void failsWhenTravelEndsBeforeItStarts() {
        
        // Setup
        Exception expectedException;

        
        // Exercise
        try {
            Travel__c travel = new TravelBuilder(System.now().addDays(1),System.now())
                                        .create();
        }
        catch(Exception e) { 
            expectedException = e;
        }
        
        
        // Verify
        System.assertNotEquals(null, expectedException);
        assertThrowsMessage(System.Label.TravelCannotEndBeforeStart);
    }
    
    
    @isTest
    private static void failsWhenTravelsOfSameUserOverlap() {
        
        // Setup
        Exception expectedException;
        
        Profile stand = [SELECT Id FROM Profile WHERE Name='Standard Platform User']; 
        User user = createNewUser(stand, 'traveller');
        
        Travel__c travel = createTravel('first Travel',System.now(), System.now().addDays(1));
        Travel__c secondTravel = createTravel('second Travel',System.now().addDays(2), System.now().addDays(4));
        Travel__c newTravel = createTravel('incoming Travel',System.now().addDays(1), System.now().addDays(3));	
        
        System.runAs(user) {
            insert travel;
	        insert secondTravel;
        }                            
                                            
        
        // Exercise
        try {
            System.runAs(user) {
		        insert newTravel;
            }
        }
        catch(Exception ex) { 
            expectedException = ex;
        }
        
        
        // Verify
        System.assertNotEquals(null, expectedException);
        assertThrowsMessage(String.format(System.Label.TravelsDontOverlap, new List<String> { secondTravel.Name }));
    }
    
    
    @isTest
    private static void overlappingTravelsOfDifferentUsersCanBeInserted() {
        
        // Setup
        Exception unexpectedException;
        
        String message = '';
        
        Profile sysAd = [SELECT Id FROM Profile WHERE Name='Standard Platform User']; 
        User user1 = createNewUser(sysAd, 'firstTraveller');
        
        Profile standPlatUs = [SELECT Id FROM Profile WHERE Name='Standard Platform User']; 
        User user2 = createNewUser(standPlatUs, 'secondTraveller');
        
        Travel__c travel = createTravel('first Travel',System.now(),System.now().addDays(1));
        Travel__c secondTravel = createTravel('second Travel',System.now(),System.now().addDays(1));
        
        System.runAs(user1) {
            insert travel;
        }

        
        // Exercise
        try {
            System.runAs(user2) {
                insert secondTravel;  
            }
        }
        catch(Exception ex) { 
            unexpectedException = ex;
            message = unexpectedException.getStackTraceString();
        }
        
        
        // Verify
        System.assertEquals(null, unexpectedException, message);
    }
    
    
    // TEST HELPER
    private static User createNewUser(Profile p, String name) {
        String userName = name+'@testorg.com';
        User result = new User(Alias = name.substring(0,2), Email=userName, EmailEncodingKey='UTF-8',
                               LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US',
                               ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName=userName);
        insert result;                     
        
        return result;
    }
    
    
    private static Travel__c createTravel(String name, DateTime start, DateTime stop) {
        Travel__c result = new Travel__c();
        result.txt_Reason__c = 'testing';
        result.Name = name;
        result.dtm_Start__c = start;
        result.dtm_End__c = stop;
        
        return result;
    }
    
    
    private static void assertThrowsMessage(String errorMessage) {
        Boolean result = false;
        
        for(ApexPages.Message m : ApexPages.getMessages()) {   
            if(m.getDetail().equals(errorMessage)) {
                result = true;
            }
        }
        
        System.assert(result);
    }   
}