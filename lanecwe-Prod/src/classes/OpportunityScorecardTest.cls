@isTest
private class OpportunityScorecardTest {
	static testMethod void testOpportunityScorecardEvents() {
		Test.startTest();
		Opportunity testOpp = PGITestUtilities.getOpportunityDetails();
    	insert testOpp;
    	GCS_Acq_Opportunity_Scorecard__c testOppScorecard = PGITestUtilities.getOpportunityScorecardDetails(testOpp);
    	insert testOppScorecard;
    	
    	try{
	    	GCS_Acq_Opportunity_Scorecard__c testOppScorecardDuplicate = PGITestUtilities.getOpportunityScorecardDetails(testOpp);
	    	insert testOppScorecardDuplicate;
	    	system.assert(false);
    	}
    	catch(Exception ex){
    		system.assert(true);
    	}
    	
    	GCS_Acq_Opportunity_Scorecard__c result = [SELECT Total_Score__c, Completion__c FROM GCS_Acq_Opportunity_Scorecard__c WHERE Id =: testOppScorecard.Id];
    	system.assert(result.Total_Score__c > 0);
    	system.assert(result.Completion__c > 0);
    	
    	testOppScorecard.Q1__c = '2';
    	testOppScorecard.Q4__c = '2';
    	update testOppScorecard;
    	GCS_Acq_Opportunity_Scorecard__c result2 = [SELECT Total_Score__c, Completion__c FROM GCS_Acq_Opportunity_Scorecard__c WHERE Id =: testOppScorecard.Id];
    	system.assert(result2.Total_Score__c > result.Total_Score__c); 	
    	 	
		Test.stopTest();
	}
}