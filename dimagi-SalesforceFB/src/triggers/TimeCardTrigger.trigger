trigger TimeCardTrigger on Time_Card__c (after insert, after update) {
    if (Trigger.isInsert) {
        Database.executeBatch(new BatchRecalculateTimeCardCost(Trigger.newMap.keySet()), 200);
    } else {
        Set<Id> timeCardsIds = new Set<Id>();
        for (Time_Card__c updatedTC : Trigger.new) {
            // If time or number of hours was updated we should recalculate total cost for that time card, we must check that because we are updating time cards
            // in batch job (job updates only total cost) so it will cause a recurrsive trigger.
            if (updatedTC.Total__c != Trigger.oldMap.get(updatedTC.Id).Total__c ||updatedTC.Date__c != Trigger.oldMap.get(updatedTC.Id).Date__c) {
                timeCardsIds.add(updatedTC.Id);
            }
        }
        if (timeCardsIds.size() > 0) {
            Database.executeBatch(new BatchRecalculateTimeCardCost(timeCardsIds), 200);
        }
    }
}