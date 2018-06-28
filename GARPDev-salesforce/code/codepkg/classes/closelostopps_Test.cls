@isTest
Public class closelostopps_Test
{
    public static String CRON_EXP = '0 0 0 15 6 ? 2050';

    Public static testMethod void MyUnitTest()
    {
        test.starttest();
        closelostopps s12= new closelostopps();
        string jobId = system.schedule('Test closelostopps',CRON_EXP,s12);
        CronTrigger ct = [SELECT Id, CronExpression,TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP,ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2050-06-15 00:00:00',String.valueOf(ct.NextFireTime));
        test.stopTest();
        
    } 
 }