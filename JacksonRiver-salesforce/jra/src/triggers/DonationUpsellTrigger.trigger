/**
* @author Phillip Cave
* @date 1/2014
* @description Trigger event dispatcher for the Donation_Upsell__c object.
*/
trigger DonationUpsellTrigger on Donation_Upsell__c (before insert, after insert, before update, after update) {
    if (trigger.isBefore) {
        if (trigger.isInsert || trigger.isUpdate) {
            //Reserved for future logic.    
        }
    }
    else if (trigger.isAfter) {
        if (trigger.isInsert || trigger.isUpdate) {
            DonationUpsell.setOriginalDonationIds(trigger.new);
        }
    }
}