@IsTest
private class Test_ScheduleSync3CLogic {

    private static testmethod void testSchedule3CLogic() {
        Test.startTest();
        String jobId = System.schedule('test3CLogic', '0 0 0 3 9 ? 2022', new ScheduleSynchronize3CLogic());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals('0 0 0 3 9 ? 2022', ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
}