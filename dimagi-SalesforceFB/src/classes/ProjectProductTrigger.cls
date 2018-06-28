public with sharing class ProjectProductTrigger {
	
	// entry for Inserts
	public static void onUpdate(Project_Product__c[] newProjProds) {
		
		for (Project_Product__c pp : newProjProds) {
			
			Set<String> productNames = new Set<String>();
			String productNamesString;
			Project__c updatedProject = new Project__c();
			
			// Select the project
			updatedProject.Id = pp.Project__c;
					
			// Get all the Product Names associated with this project
			for (Project_Product__c p : [SELECT Product__c,
												Product__r.Name
										 FROM Project_Product__c
										 WHERE Project__r.Id = :pp.Project__c]) {
			
				productNames.add(p.Product__r.Name);									 
			}
			
			//Turn the products into a string
			if (!productNames.isEmpty()) {
				for (String s : productNames) {
						productNamesString = productNamesString + '; ' + s;
				}
				
			
				// Put the string in the project field
				updatedProject.Product_Text__c = productNamesString.replace('null;',''); // the replace is bad code but couldn't get it to initialize wihout a null
				update updatedProject;			
			}
			else {
				updatedProject.Product_Text__c = '';
				update updatedProject;
			}

}
	}

	public static testmethod void unitTest() {
		
		Country__c cntry = new Country__c(Name='Test');
		insert cntry;
		
		Account acct = new Account(Name='Test Account', country__c=cntry.Id, office_type__c='HQ');
		insert acct;
		
		Project__c proj = new Project__c();
		proj.Name = 'Test';
		proj.Implementing_Account__c = acct.Id;
		insert proj;
		
		Product2 prod = new Product2();
		prod.Name = 'Test Product';
		insert prod;
		
		Project_Product__c pp = new Project_Product__c();
		pp.Project__c = proj.Id;
		pp.Product__c = prod.Id;
		insert pp;
		
		
		delete pp;
	}

}