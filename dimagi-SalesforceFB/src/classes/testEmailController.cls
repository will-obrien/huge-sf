public with sharing class testEmailController {

    private PageReference cancelPage = null;
    private Opportunity o;
    
    public testEmailController(ApexPages.StandardSetController controller) {
    	cancelPage = controller.cancel();
    }
    
    public testEmailController(ApexPages.StandardController sc) {
    	cancelPage = sc.cancel();
    }
    
    public void testEmail() {
    	
         Open_Opportunity_Settings__c settings = Open_Opportunity_Settings__c.getOrgDefaults();
        if (settings.Biz_Dev_Daily_Report_Emails__c != null) {
            
            List<String> mails = settings.Biz_Dev_Daily_Report_Emails__c.split(',');
            
            List<User> users = [select Id, Name, Email from User where Email in :mails];
                            
            if (!users.isEmpty()) {           
            
                Map<String, Opportunity[]> stagedOpportunities = OpenOpportunityReportController.getInstance().getOpenOpportunitiesAllUsersOrderByStage();
                
                OpenOpportunityMailer.sendRedOpenOpportunitiesUsers(users, stagedOpportunities, 'global');
                                
            }
        
        }
    	
    }
    
    public PageReference goBack() {
    	return cancelPage;
    }
}