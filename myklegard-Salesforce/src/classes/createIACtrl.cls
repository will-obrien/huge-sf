public with sharing class createIACtrl {
    private ID pfId;
    public createIACtrl(){
        pfId = ApexPages.currentPage().getParameters().get('id');
    }
    public PageReference insertInternalAllocation() {
        Project_Funding_Sources__c pfObj = [SELECT Id,Amount__c,Project__c,Target_Award_Date__c FROM Project_Funding_Sources__c WHERE Id = :pfId];
        Contracts__c cntrctObj = new Contracts__c(Project__c = pfObj.Project__c,Amount__c=pfobj.Amount__c, Target_award_date__c = pfObj.Target_Award_Date__c, Project_Funding__c = pfObj.Id);
        cntrctObj.RecordTypeId =[SELECT Id FROM RecordType WHERE Name ='Internal Allocation' and SobjectType ='Contracts__c' limit 1].Id;
        try{
            insert cntrctObj;
        }
        catch(DMLException e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        return new PageReference('/'+cntrctObj.Id+'/e?retURL=/'+pfId);
    }
}