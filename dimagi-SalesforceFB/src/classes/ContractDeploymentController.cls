/**************************************************
Class Name: ContractDeploymentController
Class Description: Class for Deployment creating from an Contract
Author: Virginia Fernández (vfernandez@adooxen.com)
Update Date: 2013-04-09
Additional Comments: 
**************************************************/
public with sharing class ContractDeploymentController {
	private DContract__c c;
    
    public ContractDeploymentController(ApexPages.StandardController sc) {
        c = fetchContractById(sc.getId());
    }
    
    private DContract__c fetchContractById(Id contractId) {
        
        DContract__c[] contracts = [select Id,
                                          Name,
                                          Account__c,
                                          Funder_Account__c,
                                          Area__c,
                                          Sub_Area__c,
                                          (Select Product__c From Products__r)
                                    from DContract__c
                                    where Id = :contractId];
        
        return !contracts.isEmpty() ? contracts[0] : null;
    }
    
    public PageReference createDeployment() {
        Project__c deployment = new Project__c();
        deployment.Name = c.Name;
        deployment.Implementing_Account__c = c.Account__c;
        deployment.Funder_Account__c = c.Funder_Account__c;
        deployment.Area__c = c.Area__c;
        deployment.Sub_Area__c = c.Sub_Area__c;
        insert deployment;
        
        List<Project_Product__c> projectProducts = new List<Project_Product__c>();
        for (Contract_Product__c product: c.Products__r) {
        	Project_Product__c projectProduct = new Project_Product__c();
        	projectProduct.Product__c = product.Product__c;
        	projectProduct.Project__c = deployment.Id;
        	projectProducts.add(projectProduct);
        }
        
        insert projectProducts;
        
        Contract_Project__c contrDeploy = new Contract_Project__c();
        contrDeploy.Contract__c = c.Id;
        contrDeploy.Project__c = deployment.Id;
        insert contrDeploy;
        
        PageReference deployPage = new ApexPages.StandardController(deployment).view();
        deployPage.setRedirect(true);
       
        return deployPage;
        
    }

}