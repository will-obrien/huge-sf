@isTest
private class TaskUtilTest {
	
	@isTest static void testTaskPriority() {

		String pri = TaskUtil.getTaskPriority('NY');
		System.assertEquals('Normal',pri,'Expected Priority is Normal');
	
        pri = TaskUtil.getTaskPriority('CA');
        System.assertEquals('High',pri,'Expected Priority is High');
	
        pri = TaskUtil.getTaskPriority('');
        System.assertEquals(null,pri,'Expected NULL');
    }
}