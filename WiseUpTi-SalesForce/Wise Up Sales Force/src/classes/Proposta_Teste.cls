/*
    Classe de testes para a classe: Proposta
    
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

@isTest
public class Proposta_Teste{

    public static testmethod void teste(){
        Account acc = Teste_Util.newAccount();
            
        Opportunity opp = Teste_Util.newOpportunity(acc.Id);
        
        Teste_Util.newOpportunityLineItem(opp.Id, Teste_Util.newPricebookEntry(Teste_Util.newProduct2('1').Id).Id);
        Teste_Util.newOpportunityLineItem(opp.Id, Teste_Util.newPricebookEntry(Teste_Util.newProduct2('2').Id).Id);
        
        Proposta classe = new Proposta(new ApexPages.StandardController(opp));
        
        Opportunity oportunidadeAux = classe.getOpp();
        
        System.assertEquals(oportunidadeAux.Id, opp.Id);
        
        classe.getItensToPage();
        
        classe = new Proposta();
        classe.oppty = opp;
        classe.teste = opp.Id;
        classe.qtdItem = true;
    }
    
}