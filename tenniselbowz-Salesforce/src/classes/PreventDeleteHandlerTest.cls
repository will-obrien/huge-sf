@isTest
private class PreventDeleteHandlerTest {
    static final String dst = '123';
    static List<OpportunityLineItem> olis;

    static void setup() {
        Account acc = TestingUtils.createAccounts(1, 'name', true)[0];
        Product2 prod = TestingUtils.createProduct('prod', new Map<String,Object>(), true);
        Pricebookentry pbe = TestingUtils.createPriceBookEntry(prod.Id, 1, new Map<String, Object>(), true);
        Opportunity opp = TestingUtils.createOpportunities(1, acc.Id, false)[0];
        opp.Pricebook2Id = Test.getStandardPricebookId();
        insert opp;
        Apttus_Proposal__Proposal__c quote = new Apttus_Proposal__Proposal__c(
            Apttus_Proposal__Opportunity__c = opp.Id
        );
        insert quote;
        Apttus_Proposal__Proposal_Line_Item__c qli = new Apttus_Proposal__Proposal_Line_Item__c(
            Apttus_Proposal__Proposal__c = quote.Id,
            DST_ID__c = dst
        );
        insert qli;
        olis = TestingUtils.createOpportunityLineItems(2, opp.Id, pbe.Id, false);
        olis[0].DST_ID__c = dst;
        olis[1].DST_ID__c = 'no associated proposal';
        insert olis;
    }

    static testMethod void filter() {
        setup();

        Test.startTest();
            PreventDeleteHandler handler = new PreventDeleteHandler(olis);
        Test.stopTest();

        system.assertEquals(new Set<Id>{ olis[0].Id }, Pluck.ids(handler.olisToPrevent), 'the correct oli should have been added to the list');
    }
}