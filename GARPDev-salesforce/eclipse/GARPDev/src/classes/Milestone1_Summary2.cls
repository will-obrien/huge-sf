public with sharing class Milestone1_Summary2 {

	public ID targetProject {get; set;}
	
	public Milestone1_Settings__c settings = Milestone1_Settings__c.getInstance();
	
	public List<Milestone1_Project__c> getProjects() {
		
		List<Milestone1_Project__c> activeProjects = [Select m.Status_TasksOpenComplete__c, m.Status_TasksOpenBlockedLate__c, 
		m.Status_BudgetMiletoneEstimate__c, m.Status_BudgetExpenseSummary__c, m.Name, m.Id, m.Deadline__c, m.Kickoff__c, 
		m.Duration__c, m.GoogleGanntUrl__c
		From Milestone1_Project__c m where m.status__c = 'Active'];


		return activeProjects;
	}
	
	public Pagereference view() {

		return new Pagereference('/' + targetProject);
	}
	
	public Pagereference viewMyTasks() {
		return new Pagereference('/' + settings.Report_Id_My_tasks_by_project__c + '?pv0=' + String.valueOf(targetProject).substring(0,15) + '&pv1=' + UserInfo.getFirstName() + ' ' + UserInfo.getLastName());
	}

	public Pagereference viewBlockedTasks() {
		return new Pagereference('/' + settings.Report_Id_Blocked_Tasks_by_Project__c + '?pv0=' + String.valueOf(targetProject).substring(0,15) );
	}

	public Pagereference viewOverdueTasks() {
		return new Pagereference('/' + settings.Report_Id_Overdue_Tasks_by_Project__c + '?pv0=' + String.valueOf(targetProject).substring(0,15) );
	}

	public Pagereference viewOpenTasks() {
		return new Pagereference('/' + settings.Report_Id_Open_Task_Status_by_Project__c + '?pv0=' + String.valueOf(targetProject).substring(0,15) );
	}

	public Pagereference viewMilestoneOpenTasks() {
		return new Pagereference('/' + settings.Report_Id_Project_Milestone_Open_Task__c + '?pv0=' + String.valueOf(targetProject).substring(0,15) );
	}

	public Pagereference incompleteTasksByProject() {
		return new Pagereference('/' + settings.Report_Id_My_Tasks_By_Project_Milesto__c + '?pv0=' + Encodingutil.urlEncode(''+UserInfo.getName(), 'UTF-8' ));
	}

	public Pagereference incompleteTasksByPriority() {
		return new Pagereference('/' + settings.Report_Id_My_Tasks_By_Priority_Project__c + '?pv0=' + Encodingutil.urlEncode(''+UserInfo.getName(), 'UTF-8' ) );
	}

	public Pagereference summaryMyLateTasks() {
		return new Pagereference('/' + settings.Report_Id_My_Late_Tasks__c + '?pv0=' + Encodingutil.urlEncode(''+UserInfo.getName(), 'UTF-8' ) );
	}
	
	public Pagereference summaryMyBlockedTasks() {
		return new Pagereference('/' + settings.Report_Id_My_Blocked_Tasks__c + '?pv0=' + Encodingutil.urlEncode(''+UserInfo.getName(), 'UTF-8' ) );
	}
	
	static TestMethod void testController() {
		
		//make sure it shows active projects
		Milestone1_Summary2 summary2 = new Milestone1_Summary2();
		
		//important for new installs
		if (summary2.settings == null) {
			summary2.settings = new Milestone1_Settings__c();
		}
		
		if (summary2.settings.Report_Id_Blocked_Tasks_by_Project__c == null) {
			summary2.settings.Report_Id_Blocked_Tasks_by_Project__c = 'a';
			summary2.settings.Report_Id_My_tasks_by_project__c = 'b';
			summary2.settings.Report_Id_Overdue_Tasks_by_Project__c = 'c';
		}
		
		Integer i = summary2.getProjects().size();
		
		Milestone1_Project__c p1 = Milestone1_Test_Utility.sampleProjectActive('Controller Test');
		insert p1;
		Integer i2 = summary2.getProjects().size();
		
		System.assert(i2 == i+1);
		
		//make sure we get page references back
		summary2.targetProject = p1.id;
		
		System.assert(summary2.view() != null);
		System.assert(summary2.viewMyTasks() != null);
		System.assert(summary2.viewBlockedTasks() != null);
		System.assert(summary2.viewOverdueTasks() != null);
	}

}