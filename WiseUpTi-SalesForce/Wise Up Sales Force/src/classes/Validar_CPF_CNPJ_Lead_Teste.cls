/*
    Classe de testes para a classe: Validar_CPF_CNPJ_Lead
*/

@isTest
public class Validar_CPF_CNPJ_Lead_Teste{

    static testMethod void testeCPF(){
        Lead l = new Lead();
        l.FirstName = 'Lead';
        l.LastName = 'Teste';
        l.CPF__c = '813.322.030-00';
        l.Company = 'Empresa';
        insert l;
        
        List<Lead> leads = 
            [SELECT Id
            FROM Lead
            WHERE CPF__c = '813.322.030-00'];
            
        System.assertEquals(1, leads.size());
    }
    
    static testMethod void testeCNPJ(){
        Lead l = new Lead();
        l.FirstName = 'Lead';
        l.LastName = 'Teste';
        l.CNPJ__c = '23.027.250/0001-10';
        l.Company = 'Empresa';
        insert l;
        
        List<Lead> leads = 
            [SELECT Id
            FROM Lead
            WHERE CNPJ__c = '23.027.250/0001-10'];
            
        System.assertEquals(1, leads.size());
    }

}