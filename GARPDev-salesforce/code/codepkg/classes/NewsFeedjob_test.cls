@isTest
public class NewsFeedjob_test {

    static testMethod void unitTest_1(){
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        string CRON_EXP = '0 0 0 15 3 ? 2022';
        System.schedule('ScheduleApexClassTest',
                        CRON_EXP, 
                        new NewsFeedJob());
        test.stopTest();
    }
}