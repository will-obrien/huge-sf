/*
    Test class for class: Order_Contract_Article
    
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

@isTest
public class Order_Contract_Artcile_Test{

    static testMethod void test(){
        String type = Article__c.Clause__c.getDescribe().getPickListValues().get(0).getValue();
        
        Account account = Teste_Util.newAccount();
        
        Contract contract = new Contract();
        contract.AccountId = account.Id;
        contract.StartDate = System.today();
        insert contract;
        
        Article__c article = new Article__c();
        article.Clause__c = type;
        article.Name = 'Article Test';
        insert article;
        
        Contract_Article__c contractArticle = new Contract_Article__c();
        contractArticle.Contract__c = contract.Id;
        contractArticle.Can_Be_Removed__c = true;
        contractArticle.Can_Be_Changed__c = true;
        contractArticle.Article__c = article.Id;
        insert contractArticle;
        
        PageReference pr = Page.order_contract_article;
        pr.getParameters().put('id', contract.Id);
        
        Test.setCurrentPage(pr);
        
        Order_Contract_Article classe = new Order_Contract_Article();
        
        classe.getTypes();
        
        classe.typeSelected = type;
        
        classe.search();
        
        System.assertEquals(classe.items.size(), 1);
        
        classe.variavel = contractArticle.Id;
        
        classe.saveOrder();
        
        contractArticle =
            [SELECT Order__c
            FROM Contract_Article__c
            WHERE Id =: contractArticle.Id];
    
        System.assertEquals('1.1', contractArticle.Order__c);
    }

}