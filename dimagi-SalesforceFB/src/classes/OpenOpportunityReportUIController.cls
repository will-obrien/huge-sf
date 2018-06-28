/**
 *
 * @author  Fernando Rodriguez (frodriguez@adooxen.com)
 * @date    01/11/2012
 *
 */
public class OpenOpportunityReportUIController {

    public String[] selectedUsers {get;set;}
    public OpenOpportunityListData[] stagedListData {get; set;}
    public Map<String, String> stagedComments {get;set;}
    public String recipients {get;set;}
    public Id userId {get;set;}

    private static final String DEFAULT_EMAIL = Open_Opportunity_Settings__c.getOrgDefaults() != null
                                                    ? Open_Opportunity_Settings__c.getOrgDefaults().Default_Email_Recipient__c
                                                    : 'bizdev@dimagi.com';

    public OpenOpportunityReportUIController() {

        userId = (Apexpages.currentPage().getParameters().containsKey('uid')) 
                    ? Apexpages.currentPage().getParameters().get('uid') 
                    : Userinfo.getUserId();

        selectedUsers = new String[] {userId};
    	stagedComments = new Map<String, String>();
    	stagedListData = new OpenOpportunityListData[] {};
    	Map<String, Opportunity[]> stagedOpportunities = OpenOpportunityReportController.getInstance().getOpenOpportunitiesOrderByStage(userId);
    	recipients = DEFAULT_EMAIL;
    	
    	if (!stagedOpportunities.isEmpty()) {
    		
    		String[] stageList = new String[] {};
    		stageList.addAll(stagedOpportunities.keySet());
    		stageList.sort();
    		
    		for (String stageName :stageList) {    			
    			stagedComments.put(stageName, '');
    			stagedListData.add(new OpenOpportunityListData(stageName, stagedOpportunities.get(stageName)));
    		}
    	}
    }

    public void reload() {
        try {
            Id[] usersId = selectedUsers;

            if (usersId != null && !usersId.isEmpty()) {
                stagedComments = new Map<String, String>();	    	    	    	
		    	Map<String, Opportunity[]> stagedOpportunities = OpenOpportunityReportController.getInstance().getOpenOpportunitiesOrderByStage(usersId);
		    	stagedListData = new OpenOpportunityListData[] {};
		    	
		    	OpenOpportunityReportController.getInstance().updateStageDate(usersId);
		    	
		        if (!stagedOpportunities.isEmpty()) {
		        	stagedListData = new OpenOpportunityListData[] {};
		        	
		            String[] stageList = new String[] {};
		            stageList.addAll(stagedOpportunities.keySet());
		            stageList.sort();		        	        	
		            
		            for (String stageName :stageList) {
		            	stagedComments.put(stageName, '');
		                stagedListData.add(new OpenOpportunityListData(stageName, stagedOpportunities.get(stageName)));
		            }
		        }        
	        }
    	}
    	catch (Exception e) {
    		
    		Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.FATAL, 'An error ocurred. Please refresh the Report'));
    	}
    }

    public void initAction() {
    	
        Id userId = (Apexpages.currentPage().getParameters().containsKey('uid')) 
                    ? Apexpages.currentPage().getParameters().get('uid') 
                    : Userinfo.getUserId();    	
    	
    	OpenOpportunityReportController.getInstance().updateStageDate(new Id[] {userId});
    } 

    public void sendEmail() {
         
        try {        
        	Id[] usersId = selectedUsers;	
        	User[] users = [SELECT Id, Email, Name FROM User WHERE Id IN :usersId];
        	
        	if (!users.isEmpty()) {        	
	        	String[] mails = (recipients != null && recipients.trim().length() > 0) ? recipients.split(',') : new String[] {};
	        	OpenOpportunityMailer.sendOpenOpportunitiesSingleReport(users, mails, stagedComments);
	        	Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.CONFIRM, 'Mail Sent Success'));
        	}
        	else {
        		Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.FATAL, 'Cannot Send Mail. Please select one or more users'));
        	}
        }
        catch (Exception e) {        	
        	Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.FATAL, 'Cannot Send Mail. Please check message fields'));
        }                    
    }
    
    public Selectoption[] getUsers() {
    
        User[] users = [SELECT Id, Name FROM User WHERE isActive = true ORDER BY Name];
        Business_Unit__c[] bus = [SELECT Id, Name FROM Business_Unit__c ORDER BY Name];
        
        Selectoption[] result = new Selectoption[] {};
       
    	for (Business_Unit__c bu :bus) {
    		result.add(new Selectoption(bu.Id, '--- ' + bu.Name + ' ---'));
    	}
        
        for (User user :users) {        	
            result.add(new Selectoption(user.Id, user.Name));	
        }
        
        return result;    
    }
    
}