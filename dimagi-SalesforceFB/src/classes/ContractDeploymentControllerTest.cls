/**************************************************
Class Name: ContractDeploymentControllerTest
Class Description: Class for Deployment creating from an Contract testing
Author: Virginia Fernández (vfernandez@adooxen.com)
Update Date: 2013-04-09
Additional Comments: 
**************************************************/
@isTest
private class ContractDeploymentControllerTest {

    static testMethod void testCreateDeployment() {
    	Account account = new Account();
    	account.Name = 'Test';
    	insert account;
    	
    	DContract__c contract = new DContract__c();
    	contract.Name = 'Test';
    	contract.Account__c = account.Id;
    	contract.Implementing_Account__c = account.Id;
    	contract.Area__c = 'Health';
    	contract.Sub_Area__c = 'Food Security';
    	insert contract;
    	
    	Product2 product = new Product2();
    	product.Name = 'Product';
        insert product;
        
        Contract_Product__c contractProduct = new Contract_Product__c();
        contractProduct.Product__c = product.Id;
        contractProduct.Contract__c = contract.Id;
        insert contractProduct;
        
    	ApexPages.StandardController sc = new ApexPages.standardController(contract);
        PageReference contrPage = sc.view();
        Test.setCurrentPageReference(contrPage);
        
        ContractDeploymentController contractDeployment = new ContractDeploymentController(sc);
        Test.startTest();
        
        PageReference deployPage = contractDeployment.createDeployment();
        String deployId = deployPage.getUrl().substring(1);
        
        Project__c deployment = [select Name, 
                                        Funder_Account__c, 
                                        Implementing_Account__c, 
                                        Area__c, 
                                        Sub_Area__c,
                                        (select Product__c from Project_Products__r),
                                        (select Contract__c from Contract_Projects__r)
                                 from Project__c
                                 where Id =: deployId
                                 limit 1];
                                 
        System.assertEquals(deployment.Name, contract.Name);
        System.assertEquals(deployment.Funder_Account__c, contract.Funder_Account__c);        
        System.assertEquals(deployment.Implementing_Account__c, contract.Account__c);
        System.assertEquals(deployment.Area__c, contract.Area__c);
        System.assertEquals(deployment.Sub_Area__c, contract.Sub_Area__c);
        System.assertEquals(deployment.Project_Products__r.size(), 1);
        System.assertEquals(deployment.Project_Products__r[0].Product__c, product.Id);
        System.assertEquals(deployment.Contract_Projects__r.size(), 1);
        System.assertEquals(deployment.Contract_Projects__r[0].Contract__c, contract.Id);
        
        Test.stopTest();
    }
}