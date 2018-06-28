@isTest
public class Item_oportunidade_trigger_teste{
    public static testmethod void teste(){
        Teste_Util.createParams();
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Pessoa Física').getRecordTypeId();
        acc.FirstName = 'Teste';
        acc.LastName = 'Migueis';
        acc.CPF__pc = '019.781.981-83';
        acc.PersonBirthDate = System.Today().addYears(-25);
        acc.CPF_validado__c = true;
        insert acc;
        
        Opportunity opp = Teste_Util.newOpportunity(acc.Id);
        
        Product2 prod = Teste_Util.newProduct2();
        PricebookEntry pe = Teste_Util.newPriceBookEntry(prod.Id);
        OpportunityLineItem oli = Teste_Util.newOpportunityLineItem(opp.Id, pe.Id);
    }
}