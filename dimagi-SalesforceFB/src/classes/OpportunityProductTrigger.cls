/**
 * Trigger for OpportunityProduct
 *
 * @author  Virginia Fernández
 * @date    04/12/2013
 */
public with sharing class OpportunityProductTrigger {

    private static final Set<String> PRODUCTS_AS_TAGS = new Set<String>{'CommCare',
                                                                        'CommConnect',
                                                                        'CommTrack'};

    // entry for Inserts
    public static void onUpdate(OpportunityLineItem[] newOppProduct, boolean isDelete) {
        Set<Id> oppIds = new Set<Id>();

        for (OpportunityLineItem oli : newOppProduct) {
            oppIds.add(oli.OpportunityId);
        }

        Map<Id, Opportunity> mapOpps = new Map<Id, Opportunity>();
        Set<Id> pricebookIds = new Set<Id>();

        List<Opportunity> opps = [SELECT Id, Product_Text__c,
                                         (SELECT PricebookEntryId FROM OpportunityLineItems)
                                  FROM Opportunity
                                  WHERE id in :oppIds];

        for (Opportunity opp : opps) {
            mapOpps.put(opp.Id, opp);

            for (OpportunityLineItem item : opp.OpportunityLineItems) {
                pricebookIds.add(item.PricebookEntryId);
            }
        }

        Map<Id, String> productNames = new Map<Id, String>();

        for (PricebookEntry pe: [select Id, Product2.Name, Product2Id from PricebookEntry where Id in :pricebookIds]) {
            productNames.put(pe.Id, pe.Product2.Name);
        }

        for (Opportunity opp : opps) {
            opp.Product_Text__c = '';

            for (OpportunityLineItem item : opp.OpportunityLineItems) {
                if ((opp.Product_Text__c != '') && (!opp.Product_Text__c.endsWith('; '))) {
                    opp.Product_Text__c += '; ';
                }
                opp.Product_Text__c += productNames.get(item.PricebookEntryId);
            }
        }

        update opps;
    }
}