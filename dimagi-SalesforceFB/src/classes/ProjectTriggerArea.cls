/* Created by Nick to try to store Area multi select in a text field */

public with sharing class ProjectTriggerArea {
	
	// Entry point from update event
	public static void onUpdate(Project__c[] newProjects) {
		
		for (Project__c p : newProjects) {
			
			p.Area_Text__c = p.Area__c;
			p.Sub_Area_Text__c = p.Sub_Area__c;

		}

	}
	
	//Test Cases
	public static testmethod void unitTest() {
		
		Country__c cntry = new Country__c(Name='Test');
		insert cntry;
		
		Account acct = new Account(Name='Test Account', country__c=cntry.Id, office_type__c='HQ');
		insert acct;
				
		Project__c p = new Project__c();
		p.Name = 'Test';
		p.Project_Space_Name__c = 'Test';
		p.Status__c = 'Test';
		p.Implementing_Account__c = acct.Id;
		insert p;
		
	}
	
}