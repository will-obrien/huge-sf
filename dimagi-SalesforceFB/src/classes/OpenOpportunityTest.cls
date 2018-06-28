/**************************************************
Class Name: OpenOpportunityTest
Class Description: Class for Open Opportunities Testing and Coverage
Author: Fernando Rodriguez (frodriguez@adooxen.com)
Modified By: Fernando Rodriguez
Update Date: 2013-03-04
Additional Comments: 
**************************************************/
@isTest
public class OpenOpportunityTest {

    public static final String TEST_EMAIL = 'frodriguez@adooxen.com'; 

    static testMethod void testEmailReportSuccess() {
    	
    	createOpportunity();
    	Test.startTest();
        OpenOpportunityReportUIController controller = new OpenOpportunityReportUIController();
        controller.getUsers();
        controller.reload();              
        for (String stageComment :controller.stagedComments.keySet()) {
        	controller.stagedComments.put(stageComment, 'Test Comment');
        }
        controller.initAction();
        controller.sendEmail();
        Test.stopTest();        
    }
    
    /*
    static testMethod void testEmailReportSuccessWithFields() {
        
        addCustomColumns();
        createOpportunity();
        Test.startTest();
        OpenOpportunityReportUIController controller = new OpenOpportunityReportUIController();
              
        for (String stageComment :controller.stagedComments.keySet()) {
            controller.stagedComments.put(stageComment, 'Test Comment');
        }
        controller.initAction();
        controller.sendEmail();
        Test.stopTest();        
    }
    */
    
    static testMethod void testEmailReportFailure() {
        
        createOpportunity();
        Test.startTest();
        OpenOpportunityReportUIController controller = new OpenOpportunityReportUIController();
        controller.recipients += 'this is not an address';
        controller.sendEmail();
        Test.stopTest();        
    }    
    
    static testMethod void testBatchEmailReport() {
        
        createOpportunity();           
        Test.startTest();           
        Database.executeBatch(new OpenOpportunitiesBatch()); 
        Test.stopTest();        
    }
    
    static testMethod void testBatchRedEmailReport() {
        
        createOpportunity();           
        Test.startTest();           
        Database.executeBatch(new OpenOpportunityNeedUpdateBatch()); 
        Test.stopTest();        
    }        
    
    static testMethod void testOpportunityStageDuration() {
        
        Test.startTest();        
        Id opportunityId = createOpportunity();                   
        Opportunity opp = [SELECT StageName FROM Opportunity WHERE Id = :opportunityId];
        opp.StageName = 'Stage 2 - Talking';
        update opp;         
        Test.stopTest();        
    }        
    
    private static void addCustomColumns() {
    	
    	Open_Opportunity_Fields__c column = new Open_Opportunity_Fields__c();
    	column.Name = 'CreatedDate';
    	column.Label__c = 'Created Date';
    	column.Type__c = 'DateTime';
    	column.Order__c = 1;
    	insert column;
    	
        column = new Open_Opportunity_Fields__c();
        column.Name = 'CloseDate';
        column.Label__c = 'Close Date';
        column.Type__c = 'Date';
        column.Order__c = 2;
        insert column;
    }
    
    
    private static Id createOpportunity() {

        Country__c country = new Country__c();
        country.Name = 'Test';
        insert country; 

        Account account = new Account();
        account.Name = 'Test Account';
        account.Office_Type__c = 'Country Office';
        account.Country__c = country.Id;    	
    	insert account;
    	
    	// Create 2 Opportunities for this user and account;
    	Id opportunityId = createOpportunity(account.Id);
    	createOpportunity(account.Id);
    	
    	return opportunityId;   		
    }
    
    private static Id createOpportunity(Id accountId) {
    	    	
        Opportunity opportunity = new Opportunity();
        opportunity.Name = 'Test Opportunity';
        opportunity.Amount = 5000;
        opportunity.Fogbugz_Assigned_To__c = 'Test Assignee';
        opportunity.Fogbugz_Ticket_Number__c = '12345';
        opportunity.Fogbugz_Last_Updated_Date__c = Date.today();
        opportunity.StageName = 'Stage 1 - Connect';
        opportunity.CloseDate = Date.today();
        opportunity.AccountId = accountId;                
        insert opportunity;
        
        return opportunity.Id;        	
    }    
    
    static testMethod void testDailyEmailReportNoSetting() {
        
        createOpportunity();           
        Test.startTest();           
        System.schedule('Test Biz Dev Daily Report Out', '0 0 * * * ?', new OpenOpportunitiesDailyScheduler()); 
        Test.stopTest();        
    }
    
    private static void setSetting(Id id) {
    	Opportunity opp = [select Owner.Email, OwnerId from Opportunity where id =: id];
        
        Open_Opportunity_Settings__c setting = Open_Opportunity_Settings__c.getOrgDefaults();
        setting.Biz_Dev_Daily_Report_Emails__c = opp.Owner.Email;
        setting.Default_Email_Recipient__c = opp.Owner.Email;
        setting.Days_Not_Updated_Limit_Early_Stages__c = -1;
        setting.Days_Not_Updated_Limit__c = -1;
        insert setting;
    }
    
    static testMethod void testDailyEmailReport() {
        
        setSetting(createOpportunity());
                   
        Test.startTest();           
        System.schedule('Test Biz Dev Daily Report Out', '0 0 * * * ?', new OpenOpportunitiesDailyScheduler()); 
        Test.stopTest();        
    
    }
    
    static testMethod void testDailyEmailReportCustomColumns() {
    	setSetting(createOpportunity());
    	addCustomColumns();
    	
    	Test.startTest();           
        System.schedule('Test Biz Dev Daily Report Out', '0 0 * * * ?', new OpenOpportunitiesDailyScheduler()); 
        Test.stopTest();    
    }
    
    static testMethod void testOpenOpportunityNeedUpdateDailySchedule() {
        setSetting(createOpportunity());
        addCustomColumns();
        
        Test.startTest();           
        System.schedule('Test Daily Open Opportunity Need Update', '0 0 * * * ?', new OpenOpportunityNeedUpdateDailySchedule()); 
        Test.stopTest();       
    }
    
    static testMethod void testOpenOpportunityNeedUpdateDailyScheduleLateStage() {
    	String id = createOpportunity();
        setSetting(id);
        
        Opportunity opp = [select Id, StageName from Opportunity where Id =: id];
        opp.StageName = 'Stage 4 - Proposal Development';
        update opp;
        
        addCustomColumns();
        
        Test.startTest();           
        System.schedule('Test Daily Open Opportunity Need Update', '0 0 * * * ?', new OpenOpportunityNeedUpdateDailySchedule()); 
        Test.stopTest();       
    }    
}