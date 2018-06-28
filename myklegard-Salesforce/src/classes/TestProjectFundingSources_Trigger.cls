/*
  This class provided test coverage for the Project Funding Source Trigger
  **********************************************************
  Author: Shrawan Raina
  Audit History
  **********************************************************
  07/02/2014        Shrawan Raina       Created
  07/24/2014        Shrawan Raina       Modified
  **********************************************************  
*/ 
@isTest
private class TestProjectFundingSources_Trigger {
    Static Integer i = 1;
    
    @IsTest(OnInstall=false)
    public static void  insertProjectFundingSource(){
        User stdUser  = TestHelper.getStandardUser(true);
        Project_Funding_Sources__c pfsObj1 = new Project_Funding_Sources__c(Funding_Stream__c = TestHelper.getFundingStream(true,i).Id, 
                                                Project__c = TestHelper.getProject(true,i).Id, Contract_Funding_Source_Total_Amount__c = 10+i);
        Project_Funding_Sources__c pfsObj2 = new Project_Funding_Sources__c(Funding_Stream__c = pfsObj1.Funding_Stream__c, Project__c = pfsObj1.Project__c, 
                                                Contract_Funding_Source_Total_Amount__c = 20+i);                
            Test.startTest();
            insert pfsObj1;
            insert pfsObj2;
            Test.stopTest();    
        List<AggregateResult> pfsAmount = new List<AggregateResult>([SELECT SUM(Contract_Funding_Source_Total_Amount__c)TotalAmount FROM Project_Funding_Sources__c 
                                                WHERE Funding_Stream__c = :pfsObj1.Funding_Stream__c]);
        Funding_Streams__c fsAmount = [SELECT Funds_Obligated__c FROM Funding_Streams__c WHERE Id = :pfsObj2.Funding_Stream__c];
        //System.assertEquals(pfsAmount[0].get('TotalAmount'),fsAmount.Funds_Obligated__c);
    }
    
   /* @IsTest(OnInstall=false)
    public static void  insertBulkProjectFundingSource(){
        List<Project_Funding_Sources__c> pfsList = new List<Project_Funding_Sources__c>();
        User stdUser  = TestHelper.getStandardUser(true);
        Project__c project = TestHelper.getProject(true, i);
        Funding_Streams__c fundingStream1 = TestHelper.getFundingStream(true, 1);
        Funding_Streams__c fundingStream2 = TestHelper.getFundingStream(true, 1);
        System.runAs(stdUser){
            for(Integer j=0; j<50; ++j){
                Project_Funding_Sources__c pfsObj1 = new Project_Funding_Sources__c(Funding_Stream__c = fundingStream1.Id, 
                                                Project__c = project.Id, Contract_Funding_Source_Total_Amount__c = 10+j);
                pfsList.add(pfsObj1);
                Project_Funding_Sources__c pfsObj2 = new Project_Funding_Sources__c(Funding_Stream__c = fundingStream2.Id, 
                                                Project__c = project.Id, Contract_Funding_Source_Total_Amount__c = 20+j);
                pfsList.add(pfsObj2);
            }
            Test.startTest();
            insert pfsList;
            Test.stopTest();
        }
        List<AggregateResult> pfsAmount1 = new List<AggregateResult>([SELECT SUM(Contract_Funding_Source_Total_Amount__c)TotalAmount FROM Project_Funding_Sources__c 
                                                WHERE Funding_Stream__c = :fundingStream1.Id]);
        List<AggregateResult> pfsAmount2 = new List<AggregateResult>([SELECT SUM(Contract_Funding_Source_Total_Amount__c)TotalAmount FROM Project_Funding_Sources__c 
                                                WHERE Funding_Stream__c = :fundingStream2.Id]);
        Funding_Streams__c fsAmount1 = [SELECT Funds_Obligated__c FROM Funding_Streams__c WHERE Id = :fundingStream1.Id];
        Funding_Streams__c fsAmount2 = [SELECT Funds_Obligated__c FROM Funding_Streams__c WHERE Id = :fundingStream2.Id];
        //System.assertEquals(pfsAmount1[0].get('TotalAmount'),fsAmount1.Funds_Obligated__c);
        //System.assertEquals(pfsAmount2[0].get('TotalAmount'),fsAmount2.Funds_Obligated__c);
    } */
}