public with sharing class Milestone1_GettingStartedController {

	public Boolean settingsReady {get;set;}
	public Boolean projectReady {get;set;}
	
	public String lastResult {get;set;}
	
	public Milestone1_GettingStartedController() {
		settingsReady = Milestone1_Settings__c.getOrgDefaults() != null;
		
	}
	
	public void setupStandardSettings() {
		List<Milestone1_Task__c> tasks = new List<Milestone1_Task__c>();
		List<Milestone1_Milestone__c> milestones = new List<Milestone1_Milestone__c>();
		Milestone1_Settings__c settings = Milestone1_Settings__c.getOrgDefaults();
		
		if (settings != null) {
			lastResult = 'Settings already exist.  No changes made.';		
		} else {
			settings = new Milestone1_Settings__c();
			
			List<Report> reports = [Select Id, Name from Report Where Name like '%(LPM1)'];
			
			Id blockedTasks;
			Id myTasks;
			Id overdueTasks;
			Id overallTaskStatus;
			Id openTaskStatus;
			Id projMilestones;
			Id reportMyTasksAllProjects;
			Id reportMyTasksByPriority;
			Id summaryBlockedTasks;
			Id summaryLateTasks;
			
			
			//these change from install to install so we have to update in settings
			for (Report current : reports) {
				System.debug(current.name);
				if (current.name.indexOf('Blocked Tasks by Project') > -1) {
					blockedTasks = current.Id;
				} else if (current.name.indexOf('Summary: My Blocked Tasks') > -1) {
					summaryBlockedTasks = current.Id;
				} else if (current.name.indexOf('Summary: My Late Tasks') > -1) {
					summaryLateTasks = current.Id;
				} else if (current.name.indexOf('My Incomplete Tasks, By Project') > -1) {
					reportMyTasksAllProjects = current.id;
				} else if (current.name.indexOf('My Incomplete Tasks, By Priority') > -1) {
					reportMyTasksByPriority = current.id;
				} else if (current.name.indexOf('My') > -1) {
					myTasks = current.Id;
				} else if (current.name.indexOf('Overdue') > -1) {
					overdueTasks = current.Id;
				} else if (current.name.indexOf('Milestones and Open Tasks') > -1) {
					projMilestones = current.id;
				} else if (current.name.indexOf('Open Tasks') > -1) {
					openTaskStatus = current.Id;
				} else if (current.name.indexOf('Tasks By Project') > -1) {
					overallTaskStatus = current.id;
				}
			}
			settings.Report_Id_Blocked_Tasks_by_Project__c = String.valueOf(blockedTasks).substring(0,15);
			settings.Report_Id_My_tasks_by_project__c = String.valueOf(myTasks).substring(0,15);
			settings.Report_Id_Overdue_Tasks_by_Project__c = String.valueOf(overdueTasks).substring(0,15);
			settings.Report_Id_Task_Status_By_Project__c = String.valueOf(overallTaskStatus).substring(0,15);
			settings.Report_Id_Open_Task_Status_by_Project__c = String.valueOf(openTaskStatus).substring(0,15);
			settings.Report_Id_Project_Milestone_Open_Task__c = String.valueOf(projMilestones).substring(0,15);
			settings.Report_Id_My_Tasks_By_Project_Milesto__c = String.valueOf(reportMyTasksAllProjects).substring(0,15);
			settings.Report_Id_My_Tasks_By_Priority_Project__c = String.valueOf(reportMyTasksByPriority).substring(0,15);
			settings.Report_Id_My_Blocked_Tasks__c = String.valueOf(summaryBlockedTasks).substring(0,15);
			settings.Report_Id_My_Late_Tasks__c = String.valueOf(summaryLateTasks).substring(0,15);
			
			
			insert settings;
			
			settingsReady = true;
			
			List<Document> docs = [Select d.Name, d.Id, d.Body From Document d Where d.Name = 'Starter Project (LPM1)'];
			
			System.debug('Doc Size ' + docs.size());
			
			if (docs.size() == 1) {
				Document startProject = docs.get(0);
				
				Milestone1_XML_Import_Utility util = new Milestone1_XML_Import_Utility();
				
				Milestone1_Project__c project = util.importProject(startProject.body.toString());
				
				
				//now we need to go through and  update the project with start date and deadlines.
				//Milestones
				List<Milestone1_Milestone__c> milestonesRetrieved = [Select m.Name, m.Kickoff__c, m.Id, m.Alias__c, m.Deadline__c, m.Project__c,
					(Select Id, Name, Blocked_Reason__c, Blocked__c, Complete__c, Due_Date__c, Priority__c, Start_Date__c 
					From Project_Tasks__r) From Milestone1_Milestone__c m WHERE m.Project__c = :project.id Order By m.Name];
					
				
				//start day = 3 days ago
				project.Kickoff__c = Date.today().addDays(-5);
				project.Deadline__c = Date.today().addDays(28);
				project.Status__c = 'Active';
				update project;
				
				Integer offset = -4;
				Date max_Deadline_Date = Date.today();
				//milestones
				for (Milestone1_Milestone__c current : milestonesRetrieved) {
					Date max_Due_Date = Date.today();
					current.Kickoff__c = Date.today().addDays(offset);
					for (Milestone1_Task__c task : current.Project_Tasks__r) {
						offset++;	
						task.Start_Date__c = Date.today().addDays(offset);
						task.Due_Date__c = Date.today().addDays(offset+1);
						
						if (current.Name.startsWith('1')) {
							task.Complete__c = true;
						}
						if (max_Due_Date < task.Due_Date__c){
							max_Due_Date = task.Due_Date__c;
						}
						tasks.add(task);
					}
					
					current.Deadline__c = max_Due_Date;
					if (current.Name.startsWith('1')) {
						current.Complete__c = true;
					}
					if (current.Deadline__c > max_Deadline_Date){
						max_Deadline_Date = current.Deadline__c;
					}
					current.Alias__c = 'GS' + current.Name.substring(0,1);
					milestones.add(current);
				}
				
				update tasks;
				update milestones;
				
			}
			
			
			
		}
		
	}
	
	public void setupStartProject() {
		
		
		
	}
}