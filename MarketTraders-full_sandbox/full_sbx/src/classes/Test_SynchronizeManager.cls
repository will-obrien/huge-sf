@IsTest
private class Test_SynchronizeManager {
	
	private static testMethod void testSuccessfulSync() {
		SynchronizeManager manager = SynchronizeManager.getMockSynchronizeManager(false);
		manager.synchronize();
	}
	
	private static testMethod void testFailedSync() {
		SynchronizeManager manager = SynchronizeManager.getMockSynchronizeManager(true);
		manager.synchronize();
	}

}