/**
 * Tests the updates of Deployment Product_Text__c field with the names of the Deployment Products
 *
 * @author  Virginia Fernández
 * @date    04/11/2013
 */
@isTest
private class DeploymentProductTriggerTest {

    static testMethod void insertDeploymentProductTest() {
        Country__c country = new Country__c();
        country.Name = 'Country';
        insert country;
        
        Account account = new Account();
        account.Name = 'Account';
        account.Country__c = country.Id;
        insert account;
        
        Project__c project = new Project__c();
        project.Name = 'Test';
        project.Implementing_Account__c = account.Id;
        insert project;
        
        Product2 product = new Product2();
        product.Name = 'Product1';
        insert product;
        
        Product2 product2 = new Product2();
        product2.Name = 'Product2';
        insert product2;
        
        List<Project_Product__c> projectProducts = new List<Project_Product__c>();
        Project_Product__c projProduct1 = new Project_Product__c();
        projProduct1.Project__c = project.Id;
        projProduct1.Product__c = product.Id;
        projectProducts.add(projProduct1);
        
        Project_Product__c projProduct2 = new Project_Product__c();
        projProduct2.Project__c = project.Id;
        projProduct2.Product__c = product2.Id;
        projectProducts.add(projProduct2);
        
        Test.startTest();
        
        insert projectProducts;
        
        project = [select Id, Product_Text__c from Project__c where id =: project.Id];
        
        System.assert(project.Product_Text__c != null &&
                      project.Product_Text__c.indexOf('Product2') != -1 &&
                      project.Product_Text__c.indexOf('Product1') != -1);
        
        Test.stopTest();   
    }
    
    static testMethod void updateDeploymentProductTest() {
        
        Country__c country = new Country__c();
        country.Name = 'Country';
        insert country;
        
        Account account = new Account();
        account.Name = 'Account';
        account.Country__c = country.Id;
        insert account;
        
        Project__c project = new Project__c();
        project.Name = 'Test';
        project.Implementing_Account__c = account.Id;
        insert project;
        
        Product2 product = new Product2();
        product.Name = 'Product1';
        insert product;
        
        Product2 product2 = new Product2();
        product2.Name = 'Product2';
        insert product2;
        
        Project_Product__c projProduct1 = new Project_Product__c();
        projProduct1.Project__c = project.Id;
        projProduct1.Product__c = product.Id;
        insert projProduct1;
        
        Test.startTest();
        
        project = [select Id, Product_Text__c from Project__c where id =: project.Id];
        System.assertEquals(project.Product_Text__c, 'Product1');
        
        projProduct1.Product__c = product2.Id;
        update projProduct1;
        
        project = [select Id, Product_Text__c from Project__c where id =: project.Id];
        System.assertEquals(project.Product_Text__c, 'Product2');
        
        Test.stopTest();   
    }
    
    static testMethod void deleteDeploymentProductTest() {
        
        Country__c country = new Country__c();
        country.Name = 'Country';
        insert country;
        
        Account account = new Account();
        account.Name = 'Account';
        account.Country__c = country.Id;
        insert account;
        
        Project__c project = new Project__c();
        project.Name = 'Test';
        project.Implementing_Account__c = account.Id;
        insert project;
        
        Product2 product = new Product2();
        product.Name = 'Product1';
        insert product;
        
        Product2 product2 = new Product2();
        product2.Name = 'Product2';
        insert product2;
        
        Project_Product__c projProduct1 = new Project_Product__c();
        projProduct1.Project__c = project.Id;
        projProduct1.Product__c = product.Id;
        insert projProduct1;
        
        Project_Product__c projProduct2 = new Project_Product__c();
        projProduct2.Project__c = project.Id;
        projProduct2.Product__c = product2.Id;
        insert projProduct2;
        
        Test.startTest();
        
        project = [select Id, Product_Text__c from Project__c where id =: project.Id];
        System.assert(project.Product_Text__c != null &&
                      project.Product_Text__c.indexOf('Product2') != -1 &&
                      project.Product_Text__c.indexOf('Product1') != -1);
        
        delete projProduct2;
        
        project = [select Id, Product_Text__c from Project__c where id =: project.Id];
        System.assertEquals(project.Product_Text__c, 'Product1');
        
        Test.stopTest();   
    }
}