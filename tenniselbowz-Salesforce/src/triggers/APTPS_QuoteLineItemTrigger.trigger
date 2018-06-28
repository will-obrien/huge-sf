/*
    Trigger : APTPS_QuoteLineItemTrigger
    Description : Trigger is supposed to implement utility methods from helper class.
*/
trigger APTPS_QuoteLineItemTrigger on Apttus_Proposal__Proposal_Line_Item__c(before insert,after Insert, after update, after delete) {
    
    if(trigger.isBefore) {
        if(trigger.isInsert) {
            APTPS_QuoteLineItemTriggerHandler.assignRecordTypeOnQuoteLineFromParentQuote(trigger.new);
        }
    }
    
    if(trigger.isAfter) {
        if(trigger.isInsert){
        	APTPS_QuoteLineItemTriggerHandler.setConfigFinalizedDateOnQuotes(trigger.new); 
        } else if(trigger.isUpdate) {
            APTPS_QuoteLineItemTriggerHandler.setConfigFinalizedDateOnQuotes(trigger.new);
        } else if(trigger.isdelete) {
            APTPS_QuoteLineItemTriggerHandler.setConfigFinalizedDateOnQuotes(trigger.old);
        }
        
    } 
    
}