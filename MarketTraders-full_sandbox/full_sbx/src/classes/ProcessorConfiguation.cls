global with sharing class ProcessorConfiguation {
    
    /* Configure Processor Data Options */
    public boolean csv {get;set;}
    public boolean api {get;set;}
    public boolean manualWebinarSelection {get;set;}
    public boolean manualDateSelection {get;set;}

    /* Configure Processor Settings Options */
    public boolean skipSettings {get;set;}
    public boolean showPresenter {get;set;}
    public boolean showSecondaryPresenter {get;set;}
    public boolean showDiscount {get;set;}
    public boolean showDownPayment {get;set;}
    public boolean showActualStarttime {get;set;}
    public boolean showActualDuration {get;set;}
    public boolean showWebinarType {get;set;}
    public boolean showTimeAtClose {get;set;}
    public boolean showPeopleAtPrice {get;set;}
    public boolean showAttentiveRate {get;set;}
    public boolean showPromotion {get;set;}
    public boolean showPresentationDeck {get;set;}
    public boolean showProductPresented {get;set;}
    public boolean showPricePresented {get;set;}

    public String opportunityRecordTypeId {get;set;}
    public String opportunityRecordTypeName {get;set;}
    public String opportunityName {get;set;}
    public String opportunityStageName {get;set;}
    public String opportunitySubStage {get;set;}
    public String paymentPlan {get;set;}
    public String opportunityProduct {get;set;}
    public Date opportunityCloseDate {get;set;}
    
    public String taskRecordTypeId {get;set;}
    public String taskWebinarType {get;set;}
    public String taskActivityType {get;set;}
    
    public String leadRecordTypeId {get;set;}
    
    public map<String,String> opportunityOwnersMap = new map<String,String>();
    
    public list<String> opportunityOwnerIds = new list<String>();
    public integer numberOfOpportunityOwners;
    public integer currentOpportunityOwner;
    public boolean bypassOpportunityLogic {get;set;}
    public boolean bypassOpportunityCreate {get;set;}  
    public boolean updateSpecificOpportunity {get;set;}       
    public String  updateOpportunityRecType {get;set;}
    public String  webinarstamptype {get;set;}   //aac used for LMFS and BackEnd Processors stamp type webinars
    
    public ProcessorConfiguation(){
        this.bypassOpportunityLogic = false;
        this.bypassOpportunityCreate = false;
        this.updateSpecificOpportunity = false;
        this.showPresentationDeck = true;
    this.showProductPresented = true;
    this.showPricePresented = true;
        this.webinarstamptype = null;
    }
    
    public void setOpportunityOwnerAssignmentVariables(){
        opportunityOwnerIds.addAll(opportunityOwnersMap.keySet());
        numberOfOpportunityOwners = opportunityOwnerIds.size();
        currentOpportunityOwner = 0;
    }
    
    public String getOpportunityOwnerId(){
        String oppOwnerId = opportunityOwnerIds[currentOpportunityOwner];
        if(currentOpportunityOwner + 1 == numberOfOpportunityOwners){
            currentOpportunityOwner = 0;
        }else{
            currentOpportunityOwner++;
        }
        return oppOwnerId;
    }

}