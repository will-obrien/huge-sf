/*
Testes para
    trigger: Composicao_Criacao_ItemOportunidade
    trigger: Composicao_Alteracao_ItemOportunidade
    trigger: Composicao_Exclusao_ItemOportunidade
    
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

@isTest
public class ComposicaoOportunidade_Teste{

    static testMethod void teste(){
        Account conta = Teste_Util.newAccount();
                
        Product2 p = Teste_Util.newProduct2();

        PriceBookEntry pbe = Teste_Util.newPricebookEntry(p.Id);
        
        Opportunity opp = Teste_Util.newOpportunity(conta.Id);
        
        OpportunityLineItem item = Teste_Util.newOpportunityLineItem(opp.Id, pbe.Id);
        
        item.Funcao__c = 'Nova função';
        item.UnitPrice = 200;
        
        try{
            update item;
        }catch(Exception e){
            System.debug(LoggingLevel.ERROR, '___ [cls ComposicaoOportunidade_Teste - teste()] - ERROR: '+ e.getMessage());
        }
        
        item = 
            [SELECT Id
                , Funcao__c
                , UnitPrice
            FROM OpportunityLineItem
            WHERE Id =: item.Id];
            
        System.assertEquals(100, item.UnitPrice);
    }
}