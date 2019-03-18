@isTest
private class OpportunityLineItemTest {
    static final Integer num = Limits.getLimitQueries() + 1;


    static testMethod void PreventDeleteHandler() {
        final String dst = '123';
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
        List<OpportunityLineItem> olis = TestingUtils.createOpportunityLineItems(num, opp.Id, pbe.Id, false);
        for(OpportunityLineItem oli : olis) {
            oli.DST_ID__c = dst;
        }
        insert olis;

        Test.startTest();
            try {
                delete olis;
                system.assert(false, 'an error should have been added');
            }
            catch(DMLException e) {
                system.assert(e.getMessage().contains(Label.Prevent_Delete), 'the correct error message should have been added');
            }
        Test.stopTest();
    }
}