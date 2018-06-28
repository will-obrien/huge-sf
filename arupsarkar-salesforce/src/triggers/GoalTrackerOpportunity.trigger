trigger GoalTrackerOpportunity on Opportunity (after insert, after update) {
    //GoalTracker.goalTracker(Trigger.new, Trigger.Old);
    KVGoalManagementEngine.KVGoalEngine(Trigger.new, Trigger.Old);
}