@isTest
private class TestTriggersExample {

	private static final Integer NumberOfOpportunities = 5;

    static testMethod void TestTaskCount() {
    	if(TestDiagnostics2.IsTestDisabled(1)) return;	// Used for deployment, not part of the sample
    	
    	List<Opportunity> ops = new List<Opportunity>();
    	
        for(Integer x=0; x<NumberOfOpportunities; x++)
		{
			ops.add(new Opportunity(CloseDate = Date.Today().addDays(5), Name = 'optest_' + String.valueOf(x), StageName = 'Prospecting' ));	
		}
		TestDiagnostics2.SetDefaultFields('Opportunity', ops);	// Used for deployment, not part of this example
		
		insert ops;
        
        for(Opportunity op: ops)
        {
        	op.StageName = 'Negotiation/Review';
        }
        Test.StartTest();
        update ops;
        Test.StopTest();
        
        Map<ID, Opportunity> opmap = new Map<ID, Opportunity>(ops);
        
        List<task> tasks = [Select ID, WhatID from Task where WhatID in :opmap.keyset() And Subject ='Opportunity stage update'];
        System.AssertEquals(NumberOfOpportunities, tasks.size());
    }
}