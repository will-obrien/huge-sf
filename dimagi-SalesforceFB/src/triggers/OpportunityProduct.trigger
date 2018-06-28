/**
 * Trigger for OpportunityProduct
 *
 * @author  Virginia Fernández
 * @date    04/12/2013
 */
trigger OpportunityProduct on OpportunityLineItem (after delete, after insert, after update) {
	
    if (Trigger.isDelete) {
        OpportunityProductTrigger.onUpdate(Trigger.old, true);
    }
    else { 
        OpportunityProductTrigger.onUpdate(Trigger.new, false);
    }

}