/*
    Test class for class: Order_Contract_Template
*/

@isTest
public class Order_Contract_Template_Test{

    static testMethod void test(){
        String type = Article__c.Clause__c.getDescribe().getPickListValues().get(0).getValue();
        
        Article__c article = new Article__c();
        article.Name = 'Clause Test';
        article.Clause__c = type;
        insert article;
        
        Contract_Template__c contractTemplate = new Contract_Template__c();
        contractTemplate.Name = 'Contract Template Test';
        insert contractTemplate;
        
        Template_Article__c templateArticle = new Template_Article__c();
        templateArticle.Contract_Template__c = contractTemplate.Id;
        templateArticle.Article__c = article.Id;
        insert templateArticle;
        
        PageReference pr = Page.order_contract_template;
        pr.getParameters().put('id', contractTemplate.Id);
        
        Test.setCurrentPage(pr);
        
        Order_Contract_Template classe = new Order_Contract_Template();
        
        classe.getTypes();
        
        classe.typeSelected = type;
        
        classe.search();
        
        System.assertEquals(1, classe.items.size());
        
        classe.variavel = templateArticle.Id;
        
        classe.saveOrder();
        
        templateArticle = 
            [SELECT Order__c
            FROM Template_Article__c
            WHERE Id =: templateArticle.Id];
            
        System.assertEquals('1.1', templateArticle.Order__c);
    }

}