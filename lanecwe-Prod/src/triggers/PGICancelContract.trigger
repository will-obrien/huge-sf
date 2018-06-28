trigger PGICancelContract on Quote (before update) {
    PGIQuoteTriggerUtilities.quoteCancelContract(trigger.new);
}