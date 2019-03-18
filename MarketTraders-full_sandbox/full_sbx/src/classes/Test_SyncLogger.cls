@IsTest
private class Test_SyncLogger {
	
	private static testMethod void testEnd2End() {
		SyncLogger logger = new SyncLogger('End to End Test');
		logger.log('Test Entry');
		logger.log(DateTime.now());
		logger.emailDebugResults('jh@adnubis.com',true);
	}

	private static testMethod void testLoggerConstructor() {
		SyncLogger logger = new SyncLogger('Test Logger');
		system.assertEquals('Test Logger',logger.subject);
	}
	
	private static testMethod void testLoggerString() {
		SyncLogger logger = new SyncLogger('Test Logger');
		logger.log('test');
		system.assertEquals('test',logger.log[0].values()[0]);
	}
	
	private static testMethod void testLoggerObject() {
		SyncLogger logger = new SyncLogger('Test Logger');
		logger.log(Date.today());
		system.assertEquals(1,logger.log[0].values().size());
	}
	
	private static testMethod void testEmailFailure() {
		SyncLogger logger = new SyncLogger('Test Failure');
		logger.log = null;
		logger.emailDebugResults('jh@adnubis.com',true);
	}

}