@isTest
private class TestProjectFunding_Project_Trigger {
    Static Integer i = 1;
    
    @IsTest(OnInstall=false)
    public static void  insertProjectFundingSource(){
        User stdUser  = TestHelper.getStandardUser(true);
        Funding_Streams__c fundingStream = new Funding_Streams__c(Name = 'Test Funding Stream'+i);
        insert fundingStream;
        Project__c project = new Project__c(Name = 'Test Project'+i);
        insert project;
        Estimate_Planned__c estimate = new Estimate_Planned__c();
        estimate .Funding_Stream__c = fundingStream.Id ;
        estimate.Project__c = project.Id ;
        estimate.Funding_Direction__c='Request';
        estimate.Status__c='Approved';
        estimate.Cost_Estimate__c=5000;
        Project_Funding_Sources__c pfsObj1 = new Project_Funding_Sources__c(Funding_Stream__c = fundingStream.Id, 
                                                Project__c = project.Id, Contract_Funding_Source_Total_Amount__c = 10+i); 
        pfsObj1.Funding_Type__c='Request';  
        pfsObj1.Status__c='Approved';
        pfsObj1.Amount__c=1000; 
        insert estimate;    
        insert  pfsObj1;    
    }
    
        public static void  insertProjectFundingSourceReturn(){
        User stdUser  = TestHelper.getStandardUser(true);
        Funding_Streams__c fundingStream = new Funding_Streams__c(Name = 'Test Funding Stream'+i);
        insert fundingStream;
        Project__c project = new Project__c(Name = 'Test Project'+i);
        insert project;
        Estimate_Planned__c estimate = new Estimate_Planned__c();
        estimate .Funding_Stream__c = fundingStream.Id ;
        estimate.Project__c = project.Id ;
        estimate.Funding_Direction__c='Return';
        estimate.Status__c='Approved';
        estimate.Cost_Estimate__c=5000;
        Project_Funding_Sources__c pfsObj1 = new Project_Funding_Sources__c(Funding_Stream__c = fundingStream.Id, 
                                                Project__c = project.Id, Contract_Funding_Source_Total_Amount__c = 10+i); 
        pfsObj1.Funding_Type__c='Return';  
        pfsObj1.Status__c='Approved';
        pfsObj1.Amount__c=1000; 
        insert estimate;    
        insert  pfsObj1;    
    }

}