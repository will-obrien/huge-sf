@isTest(seeAllData=true)
private class PDEProjectsListCtrlTest {
    
            static testMethod void myTestMethod() {
            
            Account acc = new Account(name='Test Account');
            insert acc;
            
            AccountProject__c AP = new AccountProject__c(name='Test Account', account__c=acc.Id);
            insert AP;
                
            PDEProjectsListCtrl.getProjects(acc.Id);
                
            PDEProjectsListCtrl.deleteProject(AP.Id);
            
            
        }

}