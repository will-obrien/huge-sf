public class PDEGoalCardCtrl {

    @AuraEnabled
    public static void deleteGoal (String goalId){
         AccountGoal__c[] AG = [Select Id
                from AccountGoal__c where Id = :goalId];
       	try {
            delete AG;
        } catch (DmlException e) {
            // Process exception here
        }
        
        return;
    }
    
}