/*
    Classe de testes para a classe: PreAplication
    
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

@isTest
public class PreAplication_teste{

    public static testmethod void teste(){
        Account acc = Teste_Util.newAccount();
        acc.PersonBirthDate = Date.newInstance(1988, 1, 10);
        acc.Phone = '+55 00 0000 0000';
        acc.CPF__pc = '330.508.028-04';
        update acc;
        
        Opportunity opp = Teste_Util.newOpportunity(acc.Id);
        
        Teste_Util.newOpportunityLineItem(opp.Id, Teste_Util.newPricebookEntry(Teste_Util.newProduct2('1').Id).Id);
        Teste_Util.newOpportunityLineItem(opp.Id, Teste_Util.newPricebookEntry(Teste_Util.newProduct2('2').Id).Id);
        
        opp.StageName = 'Matrícula paga';
        opp.Data_inicio_curso__c = System.Today();     
        update opp;
        
        try{            
            PreAplication.futureIntegrateOpp(new List<Id> {opp.Id});
        }catch(Exception ex){
            System.debug(LoggingLevel.ERROR, '___ [cls PreAplication_teste - teste()] - ERROR: '+ ex.getMessage());
        }
    }
    
}