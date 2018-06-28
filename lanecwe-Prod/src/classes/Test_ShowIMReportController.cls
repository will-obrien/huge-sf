/*********************************************************************
Name : Test_ShowIMReportController 
Created On : jan 04, 2012  
Created By : Lalit Bohra
Description : Test class for ShowIMReportController controller.
**********************************************************************/
@isTest
private class Test_ShowIMReportController {
	 public static testMethod void testShowIMReportController() {
	 	
	 	Lead objLead= new Lead();
        objLead.Company='Test Company2';
        objLead.LastName='Test Lead2';
        objLead.Status='Open';
        objLead.CurrencyIsoCode='USD';
        objLead.IM_USER_ID__c='TestUser Id11';
        ObjLead.Email='Testing@testsite.com';
        ObjLead.IM_AVGATTENDEES__c=1.0;  
        ObjLead.ChannelType__c = 'Reseller';   
        insert ObjLead; 
        
        Account acc= new Account();
        acc.Name='Test Acc';
        acc.ChannelType__c = 'Reseller'; 
        insert acc;
        
        
       
        Contact con= new Contact(); 
        con.LastName='Test con1';
        con.AccountId=acc.Id;
        con.Email='Testing@testsite.com'; 
        con.IM_USER_ID__c='TestUser1';    
        insert con;
            	
    	PageReference ShowIMReportPage = Page.ShowIMReport;
        Test.setCurrentPage(ShowIMReportPage);
        ApexPages.currentPage().getParameters().put('ReportType', 'Lead'); 
        ApexPages.currentPage().getParameters().put('ImUserId', 'TestUser Id11');
        ShowIMReportController objShowIMReportController= new ShowIMReportController();
        objShowIMReportController.ShowIMReport();
        ApexPages.currentPage().getParameters().put('ReportType', 'Contact'); 
        ApexPages.currentPage().getParameters().put('ImUserId', 'TestUser1');
        objShowIMReportController.ShowIMReport();
        ApexPages.currentPage().getParameters().put('ImUserId', '');
        objShowIMReportController.ShowIMReport();
    }
}