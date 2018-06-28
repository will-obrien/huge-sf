trigger GoalTrackerAccount on Account (after insert, after update) {
    //GoalTracker.goalTracker(Trigger.new, Trigger.Old);
    //TriggerFactory.createHandler(Account.sObjectType);
    KVGoalManagementEngine.KVGoalEngine(Trigger.new, Trigger.Old);
}