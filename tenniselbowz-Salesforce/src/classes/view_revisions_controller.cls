public class view_revisions_controller {
	
	public List<SelectOption> versions{get;set;}
	public String selected_version{get;set;}
	public String task_data{set;get;}
	
	public String currently_selected_task{get;set;}
	public String new_start_date{get;set;}
	public String new_end_date{get;set;}
	public String changed_task{get;set;}
	
	public String project_id{get;set;}
	
	public view_revisions_controller(ApexPages.StandardController sc){
		project_id = ApexPages.currentPage().getParameters().get('id');
		selected_version = '';
		task_data = '';
		List<Revisions__c> list_revisions = [SELECT Id, Version__c, Revision_Name__c, SObject_Id__c, Gantt_Data__c
															FROM Revisions__c
															WHERE SObject_Id__c = :project_id
															ORDER BY Version__c];
		System.debug('LIST REVISIONS: ' + list_revisions);
		versions = new List<SelectOption>();
		for(Revisions__c revision : list_revisions){
			SelectOption option = new SelectOption(String.valueOf(revision.Id), String.valueOf(revision.Revision_Name__c));
			System.debug('OPTION: ' + option);
			versions.add(option);
		}
	}
	
	public PageReference refresh_data(){
		List<Revisions__c> selected_revisions = [SELECT Id, Version__c, Revision_Name__c, SObject_Id__c, Gantt_Data__c
															FROM Revisions__c
															WHERE Id = :selected_version
															ORDER BY Version__c
															LIMIT 1];
		if(selected_revisions.size() > 0){
			List<Attachment> list_attachment = [SELECT Id, Body, Name, ParentId FROM Attachment WHERE ParentId = :selected_revisions[0].Id];
			if(list_attachment.size() > 0){
				System.debug('FROM ATTACHEMENT: ' + list_attachment[0].Body.toString());
				task_data = list_attachment[0].Body.toString();
			}else{
				System.debug('FROM FIELD: ' + selected_revisions[0].Gantt_Data__c);
				task_data = selected_revisions[0].Gantt_Data__c;
			}
		}else{
			task_data = '';
		}
		
		System.debug('TASK DATA: ' + task_data);
		return null;
	}
	
	public PageReference back_project(){
		PageReference p = new PageReference('/' + project_id);
		p.setRedirect(true);
		
		return p;
	}

}