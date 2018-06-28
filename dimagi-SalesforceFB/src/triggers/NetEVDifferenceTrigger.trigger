/**
 * Trigger for Pipeline_Snapshot__c custom objects, it's creates NetEVDiff records.
 */
trigger NetEVDifferenceTrigger on Pipeline_Snapshot__c (after insert) {
    // Create NetEVDiff records for new snapshots
    NetEVDifferenceTriggerGateway netDiffHelper = new NetEVDifferenceTriggerGateway();
    netDiffHelper.processLastMonthSnapshots(trigger.new);
}