public with sharing class SubTDAListForUseOfFundsController{
        private final Contracts__c useOfFunds;  

    // The constructor passes in the standard controller defined
    // in the markup below
    public SubTDAListForUseOfFundsController(ApexPages.StandardController controller) {
        this.useOfFunds = (Contracts__c)controller.getRecord(); 
    }    
    
    public List<Sub_TDA__c> subTDAList{
        get {
            Contracts__c useOfFundsLocal = [SELECT Id, Project_Funding__c FROM Contracts__c WHERE Id = :useOfFunds.Id];
            return [SELECT Id, Name, Receiving_Station_Name__c, Receiving_Station_Name__r.Name, Contact__c, Contact__r.Name, TDA_Amount__c FROM Sub_TDA__c WHERE Funding_Request_c__c = :useOfFundsLocal.Project_Funding__c];
        }
        private set;
    }
}