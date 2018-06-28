@IsTest
private class Test_SynchronizeResult {
	
	private static testMethod void testSyncResult() {
		SynchronizeResult result = new SynchronizeResult();
		Account testAccount = new Account();
		testAccount.Name = 'test';
		Database.insert(testAccount); 
		result.addResultId(testAccount.Id);
		system.assertEquals(1,result.getResultIds().size());
	}

}