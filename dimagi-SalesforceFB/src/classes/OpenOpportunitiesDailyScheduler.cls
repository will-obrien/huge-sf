/**
 *
 * @author  Virginia Fernández (vfernandez@adooxen.com)
 * @date    04/23/2013
 *
 */
global class OpenOpportunitiesDailyScheduler implements Schedulable {
	
	public OpenOpportunitiesDailyScheduler() {}
    
    global void execute(SchedulableContext sc) {                                      
        
        Open_Opportunity_Settings__c settings = Open_Opportunity_Settings__c.getOrgDefaults();
        if (settings.Biz_Dev_Daily_Report_Emails__c != null) {
            
            List<String> mails = settings.Biz_Dev_Daily_Report_Emails__c.split(',');
            List<User> users = [select Id, Name, Email from User where Email in :mails];
                        	
            if (!users.isEmpty()) {           
            
                Map<String, Opportunity[]> stagedOpportunities = OpenOpportunityReportController.getInstance().getOpenOpportunitiesAllUsersOrderByStage();
                
                OpenOpportunityMailer.sendOpenOpportunitiesDailyReport(users, stagedOpportunities);
                                
            }
        
        }  
    }
	
}