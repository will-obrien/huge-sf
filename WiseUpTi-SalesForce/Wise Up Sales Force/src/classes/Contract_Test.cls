/*
    Test class for class: Contract_Handler
    Test class for trigger: Contract_Trigger
*/

@isTest
public class Contract_Test{

    static testMethod void test(){
        Account account = Teste_Util.newAccount();
        
        Article__c article = new Article__c();
        article.Name = 'Article Test';
        insert article;
        
        Contract_Template__c contractTemplate = new Contract_Template__c();
        contractTemplate.Name = 'Contract Template Test';
        insert contractTemplate;
        
        Template_Article__c templateArticle = new Template_Article__c();
        templateArticle.Article__c = article.Id;
        templateArticle.Contract_Template__c = contractTemplate.Id;
        insert templateArticle;
        
        Contract contract = new Contract();
        contract.AccountId = account.Id;
        contract.StartDate = System.today();
        contract.Contract_Template__c = contractTemplate.Id;
        insert contract;
        
        List<Contract_Article__c> articles = 
            [SELECT Id
            FROM Contract_Article__c
            WHERE Contract__c =: contract.Id];
            
        System.assertEquals(1, articles.size());
    }
    
}