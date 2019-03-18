@isTest
public class DETestClassApproval {
    static testMethod void myTest() {
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        // Create an approval request for the account
        Approval.ProcessSubmitRequest req1 = 
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(acc.id);
    
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
        // Verify the result
        System.assert(result.isSuccess());
        
        List<ProcessInstanceWorkItem> pwis = DEApprovalCtrl.getPendingApprovals();
        //System.assertEquals(pwis.size(), 1);
        
        String pwis2 = DEApprovalCtrl.setProcess(newWorkItemIds.get(0), 'Approved', 'Test Comment');
        //System.assertEquals(pwis2.size(), 0);
        
        // Submit the approval request for the account
        Approval.ProcessResult result2 = Approval.process(req1);
        List<Id> newWorkItemIds2 = result2.getNewWorkitemIds();
        
        String pwis3 = DEApprovalCtrl.setProcess(newWorkItemIds2.get(0), 'Reject', 'Test Comment');
    }
}