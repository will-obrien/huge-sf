/*
    Test class for class: Article_Component
*/

@isTest
public class Article_Component_Test{

    static testMethod void test(){
    
        PageReference pageRef = Page.contract;
        Test.setCurrentPage(pageRef);

        Account account = Teste_Util.newAccount();
        
        Opportunity opp = Teste_Util.newOpportunity(account.Id);
        
        ApexPages.currentPage().getParameters().put('idOpp', opp.Id);
        Article__c artcle = new Article__c();
        artcle.Name = 'Teste';
        insert artcle;
        Contract_Template__c cont = new Contract_Template__c();
        cont.Name = 'Teste';
        insert cont;
        Template_article__c article = new Template_article__c();
        article.Article__c = artcle.Id;
        article.Contract_Template__c = cont.Id;
        insert article;
        
        opp.Modelo_contrato__c = cont.Id;
        update opp;
        
        Article_Component classe = new Article_Component();
        
        classe.opp = opp;
        classe.idOpportunity = opp.Id;
        classe.getItems();
           
    }

}