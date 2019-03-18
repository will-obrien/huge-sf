/*
    Test class for class: Order_Template_Article
*/

@isTest
public class Order_Template_Article_Test{

    static testMethod void test(){
        String type = Article__c.Clause__c.getDescribe().getPickListValues().get(0).getLabel();
        
        Article__c article = new Article__c();
        article.Name = 'Clause Test';
        article.Clause__c = type;
        insert article;
        
        Contract_Template__c contractTemplate = new Contract_Template__c();
        contractTemplate.Name = 'Contract Template Test';
        insert contractTemplate;
        
        Template_Article__c templateArticle = new Template_Article__c();
        templateArticle.Article__c = article.Id;
        templateArticle.Contract_Template__c = contractTemplate.Id;
        templateArticle.Order__c = '1.1';
        insert templateArticle;
        
        Template_Article__c templateArticle2 = new Template_Article__c();
        templateArticle2.Article__c = article.Id;
        templateArticle2.Contract_Template__c = contractTemplate.Id;
        templateArticle2.Parent_Article__c = templateArticle.Id;
        insert templateArticle2;
        
        PageReference pr = Page.order_template_article;
        pr.getParameters().put('id', templateArticle.Id);
        
        Test.setCurrentPage(pr);
        
        Order_Template_Article classe = new Order_Template_Article();
        
        System.assertEquals(1, classe.getItems().size());
        
        classe.variavel = templateArticle2.Id;
        
        classe.saveOrder();
        
        templateArticle2 = 
            [SELECT Order__c
            FROM Template_Article__c
            WHERE Id =: templateArticle2.Id];
            
        System.assertEquals('1.1.1', templateArticle2.Order__c);
    }

}