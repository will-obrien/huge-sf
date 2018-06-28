trigger EventTrigger on Event (after insert) {
    EventTriggerHelper.createEventOnOpportunity(Trigger.new);
}