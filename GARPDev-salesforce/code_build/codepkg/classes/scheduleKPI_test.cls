@isTest
public class scheduleKPI_test {
    static testMethod void unitTest_1(){
        test.startTest();
        scheduleKPI schedule = new scheduleKPI();
        String cronExp = '0 0 23 * * ?';
        system.schedule('test', cronExp, schedule);
        test.stopTest();
    }

}