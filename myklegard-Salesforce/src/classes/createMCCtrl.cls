public with sharing class createMCCtrl {
  private ID pfId;
  public createMCCtrl(){
    pfId = ApexPages.currentPage().getParameters().get('id');
  }
    public PageReference modifyContracts() {
        Project_Funding_Sources__c pfObj = [SELECT Id,name,Amount__c,Project__c,Target_Award_Date__c FROM Project_Funding_Sources__c WHERE Id = :pfId];
        Modify_Contract__c modcntrctObj = new Modify_Contract__c();
       // modcntrctObj.Project_Funding_ID__c=pfId;
        //cntrctObj.RecordTypeId =[SELECT Id FROM RecordType WHERE Name ='Internal Allocation' and SobjectType ='Contracts__c' limit 1].Id;
        try{
          insert modcntrctObj;
        }
        catch(DMLException e){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
       // return new PageReference('/a09/e?CF00N11000000vkFf='+pfObj.name+'&CF00N11000000vkFf_lkid=a03110000026QIz&retURL=%2Fa09%2Fo');
       //return new PageReference('/a09/e?CF00N11000000vkFf='+pfObj.name+'&retURL=%2Fa03110000026QNLAA2');
       return new PageReference('/a09/e?CF00N60000002s0ka='+pfObj.name+'&retURL=%2Fa03110000026QNLAA2');
       
    }
}