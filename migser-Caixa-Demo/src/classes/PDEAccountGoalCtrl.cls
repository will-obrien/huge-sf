public class PDEAccountGoalCtrl {
	@AuraEnabled
    public static List<AccountGoal__c> getGoals(String parentId){
        return [Select Id, Name, TargetValue__c, ActualValue__c, TargetDate__c, Progress__c, Description__c, status__c
                from AccountGoal__c where Account__c = :parentId ORDER BY TargetDate__c ASC];
    }
    
}