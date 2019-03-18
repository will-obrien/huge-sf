public class PDEProjectsListCtrl {

   
	@AuraEnabled
    public static List<AccountProject__c> getProjects(String parentId){
        return [Select Id, Name, Start_Date__c, Stop_Date__c, Project_manager__c, ProgressF__c,
                Next_step__c, Issue__c, Issue_message__c
                from AccountProject__c where Account__c = :parentId];
    }
    
    @AuraEnabled
    public static void deleteProject (String projectId){
         AccountProject__c[] P = [Select Id
                from AccountProject__c where Id = :projectId];
       	try {
            delete P;
        } catch (DmlException e) {
            // Process exception here
        }
        
        return;
    }    
    
}