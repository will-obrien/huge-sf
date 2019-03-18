/*
    Classe de testes para a trigger: Oportunidade_Trigger
    
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

@isTest
public class Oportunidade_Trigger_Teste{

    public static testmethod void teste(){
        Teste_Util.createParams();
        
        Account acc = Teste_Util.newAccount();
        
        Opportunity opp = Teste_Util.newOpportunity(acc.Id);
        
        Teste_Util.newOpportunityLineItem(opp.Id, Teste_Util.newPricebookEntry(Teste_Util.newProduct2('1').Id).Id);
        Teste_Util.newOpportunityLineItem(opp.Id, Teste_Util.newPricebookEntry(Teste_Util.newProduct2('2').Id).Id);
        
        opp.StageName = 'Matrícula paga';
        update opp;
    }
}