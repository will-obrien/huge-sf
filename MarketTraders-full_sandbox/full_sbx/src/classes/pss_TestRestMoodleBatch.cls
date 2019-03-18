@isTest(SeeAllData=true)
private class pss_TestRestMoodleBatch {

    /*
    private HttpResponse resp;
    
    public pss_TestRestMoodleBatch(String testBody,Integer StatusCode) {
        resp = new HttpResponse();
        resp.setBody(testBody);
        resp.setStatusCode(StatusCode);
    }
    
    public HTTPResponse respond(HTTPRequest req) {
        return resp;
    }
    */
    static testMethod void VerifyUserScheduleJob() {
        
        
        Account testAcc = new Account();
        testAcc.FirstName='test'; 
        testAcc.LastName='test';
        testAcc.PersonEmail='test@abc.com';        
        testAcc.LMS_Password__c='test#123'; 
        testAcc.LMS_Insert__c=true;               
        testAcc.PB_Client_Target_Trading_Course__c=true;   
        insert testAcc;    
        Test.StartTest();
        
        
        Datetime sysTime = System.now();
        sysTime = sysTime.addSeconds(150);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        system.debug(chron_exp);
        pss_REST_Moodle_BatchScheduler moodleScheduler = new pss_REST_Moodle_BatchScheduler();
        String jobId = System.schedule('Moodle User Sync SchedulerTest' + System.now(),chron_exp, moodleScheduler);
        
        CronTrigger ct = fetchCronTrigger(jobId);
        
        System.assertEquals(chron_exp, ct.CronExpression, 'Did not get the same Cron Expression back');
        System.assertEquals(0, ct.TimesTriggered, 'The job has been run and should not have');
        
        Test.StopTest();
    }
    public static CronTrigger fetchCronTrigger(String jobId) {
        return [
            select CronExpression,
                TimesTriggered,
                NextFireTime
            from CronTrigger
            where Id = :jobId
        ];
    }
}