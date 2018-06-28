/*
    Classe de teste que cobre: Integracao_Oportunidade
    Autor: Sergio Migueis
*/

@isTest
public class Integracao_Oportunidade_Teste{
      static testMethod void teste(){
        Teste_Util.createParams();
        
        Account conta = Teste_Util.newAccount();
        Opportunity opp = Teste_Util.newOpportunity(conta.Id);
        
        
        Integracao_Oportunidade classe =
            new Integracao_Oportunidade(new ApexPages.StandardController(opp));
            
        classe.integrar();
        
        try{
            opp.StageName = 'Matrícula paga';
            update opp;
            classe =
            new Integracao_Oportunidade(new ApexPages.StandardController(opp));
            classe.integrar();
        }catch(Exception ex){
        }
    }
}