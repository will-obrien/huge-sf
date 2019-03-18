/**
 * This trigger copies the expriation date of the QLIs of the quote to the expiration date copy field
 * if service commencement date is being changed on the quote.
 *
 * @author Amit M.
 * @version 1.0
 */
trigger PGI_Quote_CopyExpirationDate on Quote (after update) {
    QuoteHistoryHandler.trackChanges(trigger.new, Trigger.oldMap);
    /* Instacne of trigger handler class. */
    PGICopyExpirationDateHandler triggerHandler = new PGICopyExpirationDateHandler();
    
    // collect the quotes from the trigger for which service commencement date has been changed.
    triggerHandler.collectQuotes(Trigger.new, Trigger.oldMap);
}