public with sharing class NewLongDistanceRideCtrlExt {
	
	private final Expense__c rentalVehicle;
	public LongDistanceRide__c ride{get; set;}
	
	
	// CONSTRUCTOR
	
    public NewLongDistanceRideCtrlExt(ApexPages.StandardController controller) {
        rentalVehicle = (Expense__c)controller.getRecord();
        
        ride = new LongDistanceRide__c();
        ride.mdr_RentalVehicle__c = rentalVehicle.Id;
    }

	
	// PUBLIC METHODS
	
    public Boolean getHasMessages() {
        Boolean result;
        
        result = ApexPages.hasMessages();
        
        return result;
    }
    
    
    public String getUserLocale() {
        String result = UserInfo.getLocale();
        
        return result;
    
    }
    
    
    public void doSaveExpense() {
        try {
            insert ride;
        }
        catch(Exception ignored) {}
    }
}