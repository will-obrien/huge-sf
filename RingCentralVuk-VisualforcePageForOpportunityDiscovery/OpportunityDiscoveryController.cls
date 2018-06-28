public with sharing class OpportunityDiscoveryController {
    Transient List<Lead_Qualification__c> allLeadQualList{get;set;}
    public Lead_Qualification__c leadQualificationObj{get;set;}
    public Opportunity opp{get;set;}
    public string viewMode{get;set;}
    public String redirectUrl{get;set;}
    public OpportunityDiscoveryController(ApexPages.StandardController controller){
        //property to hold parent view url to solve cross domain issue
        redirectUrl = controller.view().getUrl();
        opp = (Opportunity)controller.getRecord();
        if(opp != null && !String.isBlank(opp.Id)){
            allLeadQualList = new List<Lead_Qualification__c>(); 
            leadQualificationObj = new Lead_Qualification__c();
            allLeadQualList = [select Id,Discovery_notes__c from Lead_Qualification__c where Opportunity__c = : opp.ID  ORDER BY LastModifiedDate DESC LIMIT 1];
            if(allLeadQualList.size() >0){
                leadQualificationObj = allLeadQualList.get(0);
                viewMode = 'read';
            }else{
                viewMode = 'edit';
            }
        }
        else{
            viewMode = 'edit';
        }
    }
    //-------------------methdos to controll read or write mode of page
    public void showEdit(){
        viewMode = 'edit';
    }
    
    public void hideEdit(){
        viewMode = 'read';
    }
    
    //------------------Override method save----------------------
    public void save(){
        //-----------updating current opportunity record
        update opp;
        //-----------updating or creating leadQualification record
        leadQualificationObj.Opportunity__c = opp.Id;
        upsert leadQualificationObj;
        viewMode = 'read';
    }
    
    

}
