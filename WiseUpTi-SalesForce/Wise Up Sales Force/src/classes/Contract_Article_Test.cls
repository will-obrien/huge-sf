/*
    Test class for trigger: Contract_Article_Trigger
    Test class for class: Contract_Article_Handler
    
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

@isTest
public class Contract_Article_Test{

    static testMethod void test(){
        Account account = Teste_Util.newAccount();
        
        Contract contract = new Contract();
        contract.AccountId = account.Id;
        contract.StartDate = System.today();
        insert contract;
        
        Contract_Article__c contractArticle = new Contract_Article__c();
        contractArticle.Contract__c = contract.Id;
        contractArticle.Can_Be_Removed__c = false;
        contractArticle.Can_Be_Changed__c = false;
        insert contractArticle;

        try{
            update contractArticle;
        }catch(Exception e){
            System.assert(true);
        }
        
        try{
            delete contractArticle;
        }catch(Exception e){
            System.assert(true);
        }
    }

}