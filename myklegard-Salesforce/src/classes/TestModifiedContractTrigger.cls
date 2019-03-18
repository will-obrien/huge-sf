/*
  This class provided test coverage for the Estimate Trigger
  **********************************************************
  Author: Shrawan Raina
  Audit History
  **********************************************************
  07/21/2014        Shrawan Raina       Created
  07/24/2014        Shrawan Raina       Modified
  **********************************************************  
*/ 
@isTest
private class TestModifiedContractTrigger {
    Static Integer i = 0;
    @IsTest(OnInstall=false)
    public static void  testModifiedContract(){
        User stdUser  = TestHelper.getStandardUser(true);
        Funding_Streams__c fundingStream = new Funding_Streams__c(Name = 'Test Funding Stream'+i);
        insert fundingStream;
        Project__c project = new Project__c(Name = 'Test Project'+i);
        insert project;
        Estimate_Planned__c estimate = new Estimate_Planned__c();
        Project_Funding_Sources__c pfsObj1 = new Project_Funding_Sources__c(Funding_Stream__c = fundingStream.Id, 
                                                Project__c = project.Id);     
        insert  pfsObj1;
        Contracts__c con=new Contracts__c(Project__c = project.Id);
        con.RecordTypeId =[SELECT Id FROM RecordType WHERE Name ='Contract' and SobjectType ='Contracts__c' limit 1].Id;        
        insert con;
        system.debug('***********'+con.Id);
        Modify_Contract__c modcontract = new Modify_Contract__c();
        modcontract.Use_of_Funds__c=con.Id;
         modcontract.Status__c='Approved';
      // modcontract.Project_Funding__c=pfsObj1.Id;
        modcontract.Amount__c=1000;
            insert modcontract;
    } 

}