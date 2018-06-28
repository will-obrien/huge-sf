public with sharing class PreventDeleteHandler {
    public class PreventException extends Exception {}
    public static Boolean byPassTrigger = false;
    @TestVisible List<OpportunityLineItem> olisToPrevent;

    public PreventDeleteHandler(List<OpportunityLineItem> toBeDeleted) {
        if(byPassTrigger) { return; }
        filter(toBeDeleted);
    }

    public PreventDeleteHandler addError() {
        if(!byPassTrigger) {
            for(OpportunityLineItem oli : olisToPrevent) {
                oli.addError(new PreventException(Label.Prevent_Delete));
            }
        }
        return this;
    }

    void filter(List<OpportunityLineItem> toBeDeleted) {
        Map<String, List<OpportunityLineItem>> dstToOlis = GroupBy.strings(OpportunityLineItem.DST_ID__c, toBeDeleted);
        Set<String> dstWithProposals = Pluck.strings(
            Apttus_Proposal__Proposal_Line_Item__c.DST_ID__c,
                [Select DST_ID__c From Apttus_Proposal__Proposal_Line_Item__c
                Where DST_ID__c In :dstToOlis.keySet()]
        );

        olisToPrevent = new List<OpportunityLineItem>();
        for(String dst : dstToOlis.keySet()) {
            if(dstWithProposals.contains(dst)) {
                olisToPrevent.addAll(dstToOlis.get(dst));
            }
        }
    }
}