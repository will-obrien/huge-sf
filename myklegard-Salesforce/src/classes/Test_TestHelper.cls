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
private class Test_TestHelper {
    Static Integer i = 0;
    @IsTest(OnInstall=false)
    public static void  testStandardUsert(){
        User stdUser  = TestHelper.getStandardUser(true);
        
    } 
        @IsTest(OnInstall=false)
    public static void  testCFS(){
        Contract_Funding_Sources__c cfsObj  = TestHelper.getCFS(true,i);
        
    } 
    
            @IsTest(OnInstall=false)
    public static void  testgetEstimate1(){
        Estimate_Planned__c estimate=TestHelper.getEstimate1(true,i);
        
    } 

}