global with sharing class ExpenseCtrlExt {
// Note: Class "global" due to former architecture in managed package. Change to "public" if possible. 
    
    public Expense__c expense {
        get;
        private set;
    }
 
 
    // CONSTRUCTOR
    
    public ExpenseCtrlExt(ApexPages.StandardController standardController) {
        expense = (Expense__c) standardController.getRecord();
    }
    

    //GLOBAL METHODS
    // Note: Deprecated Method. To be deleted if possible.
    @RemoteAction
    global static Id findLocation(String city, String country) {
        Id result;
        
        /*DEPRECATED*/
        
        return result;
    }
      
     
    // PUBLIC METHODS
    
    public String getRecordTypeName() {
        Id recordTypeId = expense.RecordTypeId;
        String result = ExpenseType.getRecordTypeName(recordTypeId);
        
        return result;
    }
    
    
    public String getUserLocale() {
        String result = UserInfo.getLocale();
        
        return result;
    
    }
    
    
    public Boolean getIsMovement() {
        Boolean result = ExpenseType.isMovement(expense);
        
        return result;
    }
    
    
    public List<CompensationRate__c> getVehicles() {
        List<CompensationRate__c> results = [SELECT Id, Name
                                             FROM CompensationRate__c
                                             WHERE RecordTypeId = :CompensationRateType.getVehicleId()];
                                             
        return results;
    }
    
    
    public Boolean getHasCostInfo() {
        Boolean result = !ExpenseType.isEntertainment(expense) && !ExpenseType.isPrivateVehicle(expense)
                         && !ExpenseType.IsPerDiem(expense) && !ExpenseType.isCompanyVehicle(expense);
        
        return result;
    }
    
    
    public String getMovementSubtitle() {
        String result;
        
        if(ExpenseType.isFlight(expense)) {
            result = 'Airfare';
        }
        else if(ExpenseType.isTrainRide(expense) || ExpenseType.isSeaTravel(expense)) {
            result = 'Ticket Price';
        }
        else if(ExpenseType.isMiscellaneous(expense) || ExpenseType.isAccommodation(expense)) {
            result = 'Overall Cost';
        }
        else if(ExpenseType.IsRentalVehicle(expense)) {
            result = 'Rental Cost';
        }
        
        return result;
    }
    
    
    public Boolean getHasMessages() {
        Boolean result;
        
        result = ApexPages.hasMessages();
        
        return result;
    }
    
    
    public Id getTravelId() {
        Id result = expense.mdr_Travel__c;
        
        return result;
    }
    
    
    public String getDate() {
        String result = expense.dat_ExpenseDate__c.format();
        
        return result;
    }
    
    
    public void doSaveExpense() {
        try {
            upsert expense;
        }
        catch(Exception ignored) {}
    }
    
    
    public PageReference doSaveAndRedirectToTravel() {
        PageReference result = null;
        
        try {
            upsert expense;
                
            result = new PageReference('/' + expense.mdr_Travel__c);
        }
        catch(Exception ignore) {}
                
        return result;
    }
   
    
    public PageReference doRedirectDesktopDevices() {
        PageReference result = null;
        
        if( !isMobileDevice() ) {
            String currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
            String parameters = currentRequestURL.split('expenseEditMobile', 2)[1];
            result = new PageReference('/apex/expenseEdit' + parameters);
            result.setRedirect(true);          
        }
        
        return result;
    }
    
    
    // PRIVATE METHODS
    
    private Boolean isMobileDevice() {
        Boolean result = false;
        
        if( ApexPages.currentPage().getParameters().get('sfdcIFrameHost') !=null 
            || ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin') !=null
            || ApexPages.currentPage().getParameters().get('isdtp') == 'p1'
            || ( ApexPages.currentPage().getParameters().get('retURL') != null && ApexPages.currentPage().getParameters().get('retURL').contains('projectone') ) ) {
            
            result = true;
        }
        
        return result;
    }
}