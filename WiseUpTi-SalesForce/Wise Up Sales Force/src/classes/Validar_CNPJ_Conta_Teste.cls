/*
    Classe de testes para a trigger: Validar_CNPJ_Conta
*/

@isTest
public class Validar_CNPJ_Conta_Teste{

    static testMethod void testeCNPJ(){
        Account conta = Teste_Util.newAccount();
        
        conta.CNPJ__c = '02.300.213/0001-62';
        
        try{
            update conta;
        }catch(Exception e){
            System.debug(LoggingLevel.ERROR, '___ [cls Validar_CNPJ_Conta_Teste - testeCNPJ()] - ERROR: '+ e.getMessage());
        }
    }
    
    static testMethod void testeCPF(){
        Account conta = Teste_Util.newAccount();
        conta.CPF__pc = '019.781.981-83';
        upsert conta;
        
        List<Account> contas = 
            [SELECT Id
            FROM Account
            WHERE CPF__pc = '019.781.981-83'];
            
        System.assertEquals(1, contas.size());
    }

}