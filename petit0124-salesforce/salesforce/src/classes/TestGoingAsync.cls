@isTest
private class TestGoingAsync {

	private static Integer BulkTestSize = 10;

    static testMethod void TestSolutionsInsert() {
 		
 		List<Solution> sols = new List<Solution>();
 		
 		for(Integer x = 0; x<BulkTestSize; x++)
    	{
    		sols.add(new Solution(SolutionName='solution_' + String.valueOf(x), Status = 'Draft', SolutionNote = 'This is solution # ' + String.ValueOf(x) ));
    	}
    	DiagnosticsInstrumentation.Debug('Starting test');
    	Test.StartTest();
		insert sols;
		Test.StopTest();
 
 		Map<ID, Solution> solsmap = new Map<ID, Solution>(sols);
 		
 		List<Solution> results = [Select ID, SolutionNote, SolutionSpanish__c from Solution where ID in :solsmap.keyset()];
 		for(Solution sol: results) System.AssertEquals(sol.SolutionNote + ' in Spanish', sol.SolutionSpanish__c);
 
    }
    
    static testMethod void TestSolutionsInsert2() {
 		
 		Integer bulktestize = Limits.getLimitCallouts();
 		
 		List<Solution> sols = new List<Solution>();

		GoingAsync.ThirdAttemptAsyncSupport(); 
 		
 		for(Integer x = 0; x<bulktestsize; x++)
    	{
    		sols.add(new Solution(SolutionName='solution_' + String.valueOf(x), Status = 'Draft', SolutionNote = 'This is solution # ' + String.ValueOf(x) ));
    	}
    	DiagnosticsInstrumentation.Debug('Starting test');
    	Test.StartTest();
		insert sols;
		Test.StopTest();
 
 		Map<ID, Solution> solsmap = new Map<ID, Solution>(sols);
 		
 		List<Solution> results = [Select ID, SolutionNote, SolutionSpanish__c from Solution where ID in :solsmap.keyset()];
 		for(Solution sol: results) System.AssertEquals(sol.SolutionNote + ' in Spanish', sol.SolutionSpanish__c);
 
    }
    
}