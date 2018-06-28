/*
 * eightCloud (2014)
 * Controller for etcd8_LeadAssignmentConsole.page
 */
public with sharing class etcd8_LeadRecipientController {

	public etcd8_LeadRecipient__c leadRecipient{get; set;}
	public List<etcd8_LeadRecipient__c> lstLeadRecipient{get; set;}
	public static Boolean isNextUpSet = false;

	// Constructor
	public etcd8_LeadRecipientController() {
		leadRecipient = new etcd8_LeadRecipient__c();
		lstLeadRecipient = new List<etcd8_LeadRecipient__c>(); 
	}

	// Query leadRecipient records to populate the table
    public PageReference queryLeadRecipients() {		
		getLeadRecipients();
        return null;
    }

	// Execute on page *load*, call via action parameter of apex:page header
    public PageReference onLoad() {
      populateNextUp();  
      populateOpenLeadCount();
      return null;
    }
    
	// Save changes made to the table (update etcd8_LeadRecipient__c record(s) based on user input)
    public PageReference save() {
      try {
      	Boolean isNextUpMarked= true;
      	for(etcd8_LeadRecipient__c leadRecipient : lstLeadRecipient) {
      	  if(leadRecipient.nextUp__c && !leadRecipient.available__c) {
      	  	leadRecipient.nextUp__c = false;
      	    isNextUpMarked = false;
      	  }
      	  if(!isNextUpMarked && leadRecipient.available__c) {
      	    leadRecipient.nextUp__c = true;
      	    isNextUpMarked = true;
      	  }
      	}
		upsert lstLeadRecipient;
		populateNextUp();
		return NULL; 
	   } 
	   catch(System.DMLException e) {
		 ApexPages.addMessages(e); 
	   }  
      return null;
    }
    
	// Insert a new etcd8_LeadRecipient__c record based on the lookup field
    public PageReference add() {    
    		
		//if user lookup field is empty OR the particular user already exists as a LeadRecipient DON'T add new record
		if(leadRecipient.user__c == null || [SELECT Id, user__c FROM etcd8_LeadRecipient__c WHERE user__c =: leadRecipient.user__c].size() != 0) {
			return NULL;
		}
		
		//otherwise, add a new record
		else {
		  try {	
			List<User> lstUser = [Select UserRole.Name,Id FROM User WHERE Id = :leadRecipient.user__c];
			
			etcd8_LeadRecipient__c newRecipient = new etcd8_LeadRecipient__c(user__c = lstUser[0].Id,																			 
																			 available__c = true,
																			 nextUp__c = false);
				insert newRecipient;
				populateNextUp();
				return NULL;
			} catch(System.DMLException e) {
				ApexPages.addMessages(e); 
				return null;
			}
		}
	}

	// Helper function: DML query
    public List<etcd8_LeadRecipient__c> getLeadRecipients() {
        lstLeadRecipient = [SELECT c.openLeads__c, available__c, c.user__c, c.User_Role__c, c.nextUp__c
				FROM etcd8_LeadRecipient__c c 
				ORDER BY c.available__c DESC, c.user__r.lastname ASC LIMIT 5000];
		return lstLeadRecipient;
    } 

	// Helper function: ensure integrity of "Next Up" flag
	private void populateNextUp() {
		if(isNextUpSet) {
			return;
		}

		list<etcd8_LeadRecipient__c> lstRecipient = [Select Id from etcd8_LeadRecipient__c WHERE nextUp__c = TRUE];
		if(!lstRecipient.isEmpty()) {
			isNextUpSet = true;
			return;
		}
		lstRecipient = [Select lr.Id from etcd8_LeadRecipient__c lr Where lr.available__c = TRUE AND user__r.isActive = TRUE ORDER BY lr.user__r.lastname ASC];
		if(!lstRecipient.isEmpty()) {
			lstRecipient[0].nextUp__c = true;
			update lstRecipient[0];
		}
	}
    
    // Helper function: query Leads
    public void populateOpenLeadCount() {
      list<etcd8_LeadRecipient__c> lstLeadRecipient = [Select Id,openLeads__c,(Select Id from Leads__r WHERE IsConverted = false) FROM etcd8_LeadRecipient__c];
      for(etcd8_LeadRecipient__c leadRecipient : lstLeadRecipient) {
        leadRecipient.openLeads__c = leadRecipient.leads__r.size();
      }
      if(!lstLeadRecipient.isEmpty()) {
        update lstLeadRecipient;
      }
    }

}