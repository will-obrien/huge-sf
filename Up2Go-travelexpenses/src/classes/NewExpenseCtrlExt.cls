public with sharing class NewExpenseCtrlExt {

    private final Travel__c travel;
    public Expense__c expense {get; set;}
        
        
    // CONSTRUCTOR
        
    public NewExpenseCtrlExt(ApexPages.StandardController controller) {
        travel = (Travel__c)controller.getRecord();
        expense = new Expense__c();
        expense.mdr_Travel__c = travel.Id;
    }
    
    
    // PUBLIC METHODS
    
    public void doSaveExpense() {
        try {
            insert expense;
            expense = new Expense__c();
            expense.mdr_Travel__c = travel.Id;
        }
        catch(Exception ignored) {}
    }
    
    
    public String getUserLocale() {
        String result = UserInfo.getLocale().split('_')[0];
        
        return result;
    
    }
    
    
    public Boolean getHasMessages() {
        Boolean result;
        
        result = ApexPages.hasMessages();
        
        return result;
    }
    
    
    public List<CompensationRate__c> getVehicles() {
        List<CompensationRate__c> results = [SELECT Id, Name
                                             FROM CompensationRate__c
                                             WHERE RecordTypeId = :CompensationRateType.getVehicleId()];
                                                                                 
                return results;
    }
    
    
    public void createFlight() {
        expense.RecordTypeId = ExpenseType.getFlightRecordTypeId();
    }
    
    
    public void createTrainRide() {
        expense.RecordTypeId = ExpenseType.getTrainRideRecordTypeId();
    }
    
    
    public void createPrivateVehicleRide() {
        expense.RecordTypeId = ExpenseType.getPrivateVehicleRecordTypeId();
    }
    
    
    public void createCompanyVehicleRide() {
        expense.RecordTypeId = ExpenseType.getCompanyVehicleRecordTypeId();
    }
    
    
    public void createSeaTravel() {
        expense.RecordTypeId = ExpenseType.getSeaTravelRecordTypeId();
    }
    
    
    public void createAccommodation() {
        expense.RecordTypeId = ExpenseType.getAccommodationRecordTypeId();
    }
    
    
    public void createRentalVehicle() {
        expense.RecordTypeId = ExpenseType.getRentalVehicleRecordTypeId();
    }
    
    
    public void createMiscellaneous() {
        expense.RecordTypeId = ExpenseType.getMiscellaneousRecordTypeId();
    }
    
    
    public void createEntertainment() {
        expense.RecordTypeId = ExpenseType.getEntertainmentRecordTypeId();
    }
}