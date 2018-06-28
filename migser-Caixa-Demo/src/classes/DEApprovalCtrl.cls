public class DEApprovalCtrl {
	public DEApprovalCtrl() {
		
	}

	@AuraEnabled
	public static List<ProcessInstanceWorkItem> getPendingApprovals(){        
		List<ProcessInstanceWorkItem> piws = [Select Id, ProcessInstanceId, ProcessInstance.Status, 
		ProcessInstance.TargetObjectId, ActorId, OriginalActorId, ProcessInstance.TargetObject.Name,
		CreatedById, CreatedDate, ProcessInstance.ProcessDefinition.Name, ProcessInstance.ProcessDefinition.Description 
		from ProcessInstanceWorkitem where ActorId = :UserInfo.getUserId()
		and ProcessInstance.Status = 'Pending']; 
        return piws;
	}
    
    @AuraEnabled
    public static String setProcess(String ProcessInstanceWorkItemId, String decision, String comment){
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments(''+comment);
        if(decision == 'Approved'){
            req.setAction('Approve');   
        }
        else{
            req.setAction('Reject'); 
        }
        req.setWorkitemId(ProcessInstanceWorkItemId);
        Approval.ProcessResult result =  Approval.process(req); 

        return 'Sucess';   
    }
}