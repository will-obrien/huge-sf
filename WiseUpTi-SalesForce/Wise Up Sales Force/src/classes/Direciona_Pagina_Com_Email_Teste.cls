/*
    Classe de testes para a classe: Direciona_Pagina_Com_Email
    
    Criado por: Jonathan Valoto
    Data: 05/08/2016
*/

@isTest
public class Direciona_Pagina_Com_Email_Teste{

    static testMethod void teste(){
        Account unidade = new Account();
        unidade.CNPJ__c = '27.085.672/0001-01';
        unidade.Name = 'Unidade teste';
        unidade.RecordTypeId = Account.SObjectType.getDescribe().getRecordTypeInfosByName().get('Franquias').getRecordTypeId();
        unidade.Bandeira__c = 'Wise Up';
        insert unidade;
        
        Account conta = Teste_Util.newAccount();
        
        Opportunity oportunidade = Teste_Util.newOpportunity(conta.Id);
        oportunidade.Data_inicio_curso__c = System.today();
        oportunidade.Unidade_matriculadora__c = unidade.Id;
        update oportunidade;

        afinance__Banking_account__c banco = new afinance__Banking_account__c();
        banco.Name = 'Banco teste';
        insert banco;
        
        afinance__Transaction__c trans = new afinance__Transaction__c();
        trans.afinance__Opportunity__c = oportunidade.Id;
        trans.afinance__Payment_date__c = System.today();
        trans.afinance__Billed_To_Received_From__c = conta.Id;
        trans.afinance__Due_date__c = System.today();
        trans.afinance__Gross_Amount__c = 100;
        trans.afinance__Banking_Account__c = banco.Id;        
        insert trans;
                
        PageReference pr = ApexPages.currentPage();
        pr.getParameters().put('idOpp', oportunidade.Id);
        
        Test.setCurrentPage(pr);
        
        Direciona_Pagina_Com_Email classe = new Direciona_Pagina_Com_Email();
        
        System.debug(LoggingLevel.ERROR, '___ [cls Direciona_Pagina_Com_Email_Teste - teste()] - inicioCurso: '+ classe.inicioCurso);
        
        pr.getParameters().put('idTR', trans.Id);
        
        Test.setCurrentPage(pr);
        
        classe = new Direciona_Pagina_Com_Email(null);
        
        classe.redirect();
        
//        outra unidade
        unidade.Bandeira__c = 'You Move';
        update unidade;
        
        
        pr = ApexPages.currentPage();
        pr.getParameters().put('idOpp', oportunidade.Id);
        pr.getParameters().put('idTR', trans.Id);
                
        Test.setCurrentPage(pr);
        
        classe = new Direciona_Pagina_Com_Email(null);
        
        classe.redirect();
    }

}