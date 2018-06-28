/*
  This class is invoked to create a Project  Funding from an Estimate object
  ***********************************************************************
  Audit History
  ***********************************************************************
  07/21/2014        Shrawan Raina       Created
  ***********************************************************************  
*/ 
public with sharing class createPFCtrl {
    private ID estId;
    public createPFCtrl(){
        estId = ApexPages.currentPage().getParameters().get('id');
    }
    public PageReference insertProjectFunding() {
        Estimate_Planned__c estObj = [SELECT Id,Project__c,Funding_Stream__c,Project_Portfolio_Manager__c,Contract_Type__c,Status__c,Target_Award_Date__c,Funding_Direction__c,
                                      Cost_Estimate__c,Funding_Use__c,Funding_Requirement__c,Funding_Amount_Desc__c,Administration__c FROM Estimate_Planned__c WHERE Id = :estId];
        Project_Funding_Sources__c pfObj = new Project_Funding_Sources__c(Project__c = estObj.Project__c, Funding_Stream__c = estObj.Funding_Stream__c, Contract_Type__c = estObj.Contract_Type__c,
                                                                        Amount__c = estObj.Cost_Estimate__c, Target_Award_Date__c = estObj.Target_Award_Date__c, 
                                                                        Project_Portfolio_Manager__c = estObj.Project_Portfolio_Manager__c, Status__c = 'Draft',Funding_Type__c = estObj.Funding_Direction__c,
                                                                        Funding_Amount_Description__c=estObj.Funding_Amount_Desc__c,Requirement_for_Funding__c=estObj.Funding_Requirement__c,Funding_Use__c=estObj.Funding_Use__c);
                                                                        
        if(estObj.Administration__c =='OIT')
        {
          pfObj.RecordTypeId='01260000000M1lTAAS';
        }
        else if(estObj.Administration__c =='VHA')
        {
          pfObj.RecordTypeId='01260000000M1lYAAS';
        }
        else if(estObj.Administration__c == 'VBA')
        {
          pfObj.RecordTypeId='01260000000M2OzAAK';
        }                                                               
        try{
            insert pfObj;        
            estObj.Status__c = 'Locked';
            estObj.Project_Funding__c=pfObj.Id;
            update estObj;
            
        }
        catch(DMLException e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));  
        }
        return new PageReference('/'+pfObj.Id);
    }

}