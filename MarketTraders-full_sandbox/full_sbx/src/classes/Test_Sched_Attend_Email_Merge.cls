@IsTest
private class Test_Sched_Attend_Email_Merge {
    
    private static testmethod void testSchedule3CLogic() {
       Test.startTest();
        String jobId = System.schedule('testSchedAttendEmail','0 0 0 3 9 ? 2022',new Sched_Attend_Email_Merge());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals('0 0 0 3 9 ? 2022',ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-09-03 00:00:00',String.valueOf(ct.NextFireTime));
       Test.stopTest();
    }

}