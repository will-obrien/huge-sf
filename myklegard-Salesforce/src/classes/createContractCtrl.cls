public with sharing class createContractCtrl {
    private ID pfId;
    public createContractCtrl(){
        pfId = ApexPages.currentPage().getParameters().get('id');
    }
    public PageReference insertContract() {
        Project_Funding_Sources__c pfObj = [SELECT Id,Project__c,Amount__c,COR__c, X2237__c, Contract_Officer__c, Contract_Specialist__c, Contract_Type__c FROM Project_Funding_Sources__c WHERE Id = :pfId];
        Contracts__c cntrctObj = new Contracts__c(Project__c = pfObj.Project__c,Amount__c=pfobj.Amount__c, COR_Contact__c = pfobj.COR__c,X2237__c=pfobj.X2237__c, Contracting_officer__c=pfobj.Contract_Officer__c, Contract_Specialist__c=pfobj.Contract_Specialist__c, Contract_Type__c=pfobj.Contract_Type__c, Project_Funding__c = pfObj.Id);
        cntrctObj.RecordTypeId =[SELECT Id FROM RecordType WHERE Name ='Contract' and SobjectType ='Contracts__c' limit 1].Id;
        try{
            insert cntrctObj;
        }
        catch(DMLException e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return new PageReference('/'+cntrctObj.Id+'/e?retURL=/'+pfId);
    }
}