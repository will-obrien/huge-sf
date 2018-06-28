/**
 * Updates Deployment Product_Text__c field with the names of the Deployment Products
 *
 * @author  Virginia Fernández
 * @date    04/11/2013
 */
public with sharing class DeploymentProductTrigger {

    public void updateProductName(Project_Product__c[] projectProducts) {
        List<Id> projectIds = new List<Id>();
        
        for (Project_Product__c product : projectProducts) {
            projectIds.add(product.Project__c);
        }
        
        List<Project__c> projects = [select Id, Product_Text__c,
                                            (select Product__c from Project_Products__r)
                                        from Project__c 
                                        where id in :projectIds];
                                        
        List<Id> productsIds = new List<Id>();
        
        for (Project__c project : projects) {
            for (Project_Product__c projectProduct: project.Project_Products__r) {
                productsIds.add(projectProduct.Product__c);
            }
        }
        
        List<Product2> products = [select Id, Name from Product2 where id in :productsIds];
        
        Map<Id, String> productNameById = new Map<Id, String>();
        
        for (Product2 product : products) {
            productNameById.put(product.Id, product.Name);
        }
        
        for (Project__c project: projects) {
            List<Project_Product__c> proyProds = project.Project_Products__r;
            project.Product_Text__c = '';
            
            for (Project_Product__c proyProd : proyProds) {
                if (!project.Product_Text__c.equals('') && !project.Product_Text__c.endsWith('; ')) {
                    project.Product_Text__c += '; ';
                }
                project.Product_Text__c += productNameById.get(proyProd.Product__c);
            }
        }
        
        update projects;
        
    }
    
}