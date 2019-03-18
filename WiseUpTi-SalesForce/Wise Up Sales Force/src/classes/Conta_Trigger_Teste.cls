/*
    Classe de testes para a trigger: Conta_Trigger_Teste
    
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

@isTest
public class Conta_Trigger_Teste{

    public static testmethod void teste(){
        Teste_Util.createParams();
        
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Pessoa Física').getRecordTypeId();
        acc.FirstName = 'Teste';
        acc.LastName = 'Migueis';
        acc.CPF__pc = '019.781.981-83';
        acc.PersonBirthDate = System.Today().addYears(-25);
        insert acc;
        
        acc.LastName = 'Teste 2';
        acc.CPF__pc = '381.432.685-78';
        update acc;
    }
}