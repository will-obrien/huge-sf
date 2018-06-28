/*
    Classe de testes para a trigger: Validar_CPF_Contato
    
    Atualizado por: Jonathan Valoto
    Data: 05/08/2016
*/

@isTest
public class Validar_CPF_Contato_Teste{

    static testMethod void testeCPF(){
        Contact contato = new Contact();
        contato.AccountId = Teste_Util.newAccountPJ().Id;
        contato.FirstName = 'Contato';
        contato.LastName = 'Teste';
        contato.CPF__c = '268.405.180-19';
        insert contato;
        
        List<Contact> contatos = 
            [SELECT Id
            FROM Contact
            WHERE CPF__c = '268.405.180-19'];
            
        System.assertEquals(1, contatos.size());
    }

}