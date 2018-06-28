@isTest(seeAllData=true)
private class PDEAccountGoalCtrlTest {
    
        static testMethod void myTestMethod() {
            
            Account acc = new Account(name='Test Account');
            insert acc;
            
            AccountGoal__c AG = new AccountGoal__c(name='Test Account', account__c=acc.Id);
            insert AG;
            
            PDEAccountGoalCtrl.getGoals(acc.Id);
            
            PDEGoalCardCtrl.deleteGoal(AG.Id);
            
        }

}