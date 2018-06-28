/*
    Teste para: Rest_Add_Oli
*/

@isTest
public class Rest_Add_Oli_Teste{

    static testMethod void Rest_Add_Oli_Teste1(){

        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        Account account = Teste_Util.newAccount();

        Opportunity opp = new Opportunity();
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Assinatura meusucesso.com').getRecordTypeId();
        opp.Name = 'Oportunidade Teste';
        opp.AccountId = account.Id;
        opp.CloseDate = System.today();
        opp.StageName = 'Trabalhando';
        opp.Id_meu_sucesso__c = '123456';

        insert opp;

        Product2 produto = Teste_Util.newProduct2();
        PricebookEntry pbe = Teste_Util.newPricebookEntry(produto.Id);
        opp.Pricebook2Id = pbe.Pricebook2Id;
        update opp;

        OpportunityLineItem oppLi = Teste_Util.newOpportunityLineItem(opp.Id, pbe.Id);
        
        Rest_Add_Oli.Rest_Receiver parametro = new Rest_Add_Oli.Rest_Receiver();
        parametro.opportunity = opp;
        parametro.opportunityLineItem = oppLi;
        parametro.product2 = produto;
        parametro.status = true;
        parametro.message = 'xxx';
        
        String parametroJSON = JSON.serialize(parametro);

        System.debug(LoggingLevel.ERROR, '__ [cls Rest_Add_Oli.doPost] - parametroJSON: ' + parametroJSON);

        req.requestURI = '/OpportunityLineItem/AddRestOli/'+parametroJSON;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(parametroJSON);
        RestContext.request = req;
        RestContext.response = res;

        Rest_Add_Oli.Rest_Receiver recebido = new Rest_Add_Oli.Rest_Receiver();
        recebido = Rest_Add_Oli.doPost();

    }
}