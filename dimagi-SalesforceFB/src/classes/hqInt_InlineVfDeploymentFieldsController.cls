public with sharing class hqInt_InlineVfDeploymentFieldsController {

    public Domain__c domain { get; set; }

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public hqInt_InlineVfDeploymentFieldsController(ApexPages.StandardController stdController)  {
        this.domain = (Domain__c)stdController.getRecord();
        domain = [SELECT Id, Deployment_Countries__c, Deployment_description__c, Internal_Properties__r.notes__c FROM Domain__c WHERE Id = :domain.Id LIMIT 1];
    }
}