// Note - the concurrency tests here are purely for code coverage
// The actual examples from the book must be performed in an
// anonymous Apex window
@isTest(seealldata=true)
private class TestConcurrency {

    static testMethod void GetCodeCoverage() {
    	List<OpportunityStage> stages = [Select MasterLabel from OpportunityStage where IsActive = true Order By SortOrder Desc Limit 1 ];
        Opportunity op = new Opportunity(Name = 'Concurrency1', CloseDate = Date.Today(), StageName = stages[0].MasterLabel);
        insert op;
        Concurrency1.IncrementOptimistic(1, 1, 1, 1);
        Concurrency1.IncrementPessimistic(1, 1, 1, 1);
        Concurrency1.IncrementPessimisticB(1, 1, 1, 1);
        Concurrency1.IncrementPessimistic2B(1, 1, 1, 1);
    }

    static testMethod void TestRecovery() {
    	List<OpportunityStage> stages = [Select MasterLabel from OpportunityStage where IsActive = true Order By SortOrder Desc Limit 1 ];
		List<Opportunity> existingops = [Select ID from Opportunity where Name = 'Concurrency1'];
		if(existingops.size()>0) delete existingops;	// SeeAllData is true, so delete any existing Concurrency1 ops
		// Creat our own
        Opportunity op = new Opportunity(Name = 'Concurrency1', CloseDate = Date.Today(), StageName = stages[0].MasterLabel, Amount=0);
        insert op;
        // Get a lock on it
        Test.StartTest();
        Concurrency1.IncrementOptimisticWithCapture(0, 0, 0, 0);	// Leave amount at zero
        op.Amount = 10;	// Now fake an error
        Concurrency1.RecordRecoveryInformation(new List<Opportunity>{op}, 10);
        GoingAsync2.StartBatch();	// Make sure the batch runs
        Test.StopTest();
        // Was a request processed?
        List<AsyncRequest__c> ars = [select ID, TargetOpportunity__c from AsyncRequest__c where TargetOpportunity__c = :op.id];
        System.AssertEquals(0, ars.size());
        Opportunity opresult = [Select ID, Amount from Opportunity where ID = :op.id];
        // The actual amount result will depend on which concurrency approach to take
        // but as shipped, will result in 10
        system.debug(opresult);
        System.Assert(opresult.Amount == 10);
    }


}