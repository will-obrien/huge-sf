global with sharing class LongDistanceRideCtrlExt {
// Note: Class "global" due to former architecture in managed package. Change to "public" if possible.  
   
    private LongDistanceRide__c ride;
    private ApexPages.StandardController stdCtrl;
    
    
    // CONSTRUCTOR
    
    public LongDistanceRideCtrlExt(ApexPages.StandardController standardController) {
        stdCtrl = standardController;
        ride = (LongDistanceRide__c) stdCtrl.getRecord();
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
    
    public Boolean getHasMessages() {
        Boolean result;
        
        result = ApexPages.hasMessages();
        
        return result;
    }
    
    
    public String getUserLocale() {
        String result = UserInfo.getLocale();
        
        return result;
    
    }
    
    
    public void doSaveRide() {
        try {
            upsert ride;
        }
        catch(Exception ignored) {}
    }
    
    
    public PageReference doSave() {
        try {  
            upsert ride;
            return ApexPages.currentPage();
        } 
        catch(Exception e) {  
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getCause().getMessage()));  
            return null;
        }
    }
       
    
    public PageReference doRedirectDesktopDevices() {
        PageReference result = null;
        
        if( !isMobileDevice() ) {
            String currentRequestURL = URL.getCurrentRequestUrl().toExternalForm();
            String parameters = currentRequestURL.split('longDistanceRideEditMobile', 2)[1];
            result = new PageReference('/apex/longDistanceRideEdit' + parameters);
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