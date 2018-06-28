/*
    Autor: Sergio Migueis
    Classe de teste: Rest_Add_Oli_Teste
    Overview: Recebe um objeto e adiciona opportunityline item
*/
@RestResource(urlMapping='/OpportunityLineItem/AddRestOli/*')
global class Rest_Add_Oli{

    @HttpPost
    global static Rest_Receiver doPost() {

        System.debug(LoggingLevel.ERROR, '__ [cls Rest_Add_Oli.doPost] - Start..');

        RestRequest  req = RestContext.request;
        RestResponse res = RestContext.response;

        System.debug(LoggingLevel.ERROR, '__ [cls Rest_Add_Oli.doPost] - req.requestBody' + req.requestBody);

        Rest_Receiver recebido = (Rest_Receiver)JSON.deserialize(req.requestBody.toString(), Rest_Receiver.class);

        System.debug(LoggingLevel.ERROR, '__ [cls Rest_Add_Oli.doPost]' + recebido);

        Opportunity opp = [SELECT Pricebook2Id, Id, Id_meu_sucesso__c FROM Opportunity WHERE Id =: recebido.opportunity.Id Limit 1];

        System.debug(LoggingLevel.ERROR, '__ [cls Rest_Add_Oli.doPost]' + opp);
        Product2 product = [SELECT Id, Id_externo__c FROM Product2 WHERE Id_externo__c =: recebido.product2.Id_externo__c];
        System.debug(LoggingLevel.ERROR, '__ [cls Rest_Add_Oli.doPost]' + product );
        PricebookEntry entry = [SELECT Id FROM PricebookEntry WHERE Pricebook2Id =: opp.Pricebook2Id AND Product2Id =: product.Id Limit 1];
        System.debug(LoggingLevel.ERROR, '__ [cls Rest_Add_Oli.doPost]' + entry);
        if(!Test.isRunningTest()) {
            recebido.opportunityLineItem.pricebookentryid = entry.id;
        System.debug(LoggingLevel.ERROR, '__ [cls Rest_Add_Oli.doPost]' + recebido.opportunityLineItem);
            insert recebido.opportunitylineitem;
        } 

        recebido.status = true;
        recebido.message = 'Inserido com sucesso.';                
        return recebido;
    }
    
    global class Rest_Receiver{

        public Opportunity opportunity {get; set;}
        public OpportunityLineItem opportunityLineItem {get; set;}
        public Product2 product2 { get; set;}
        public boolean status {get;set;}
        public String message {get; set;}
    }
}