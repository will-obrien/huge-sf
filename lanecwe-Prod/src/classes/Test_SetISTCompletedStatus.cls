/*********************************************************************
Name : Test_SetISTCompletedStatus
Created On : jan 09, 2013  
Created By : JP
Description : Test class on  Trigger on Opportunity SetISTCompletedStatus
**********************************************************************/
@isTest
private class Test_SetISTCompletedStatus{
	@istest (SeeAllData=true)
 	static void TestSetISTCompletedStatus() {
 		Test.startTest();
        Opportunity opp = PGITestUtilities.getOpportunityDetails();
        insert opp;  
        Implementation_Services__c imp = PGITestUtilities.getImplementationServices(opp.Id);
        imp.CheckboxForWFRule__c = false;
		insert imp;
        
        opp.Opp_Stage__c = 'Closed Lost';
        opp.Competitor_s__c = 'test';
        opp.Incumbent__c = 'test';
        opp.Lost_Reason__c = 'test';
        update opp;
        
        Implementation_Services__c retImpServices=[SELECT CheckboxForWFRule__c FROM Implementation_Services__c WHERE Id =: imp.Id];
        System.assertEquals(retImpServices.CheckboxForWFRule__c, true);
        Test.stopTest();
    }
}