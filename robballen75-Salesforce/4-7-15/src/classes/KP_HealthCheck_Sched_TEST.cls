@isTest
// *********************************************************************************** 
//
//  KP_HealthCheck_Sched_TEST
//    
//  Desciption:
//  Class to test the schedulable nature of the KP Healthcheck Maintenance processing.
//   
//  This class was developed for Microsystems by InSitu Software LLC.
//   
//  History:
//  InSitu  04/06/2010  Original version
// *************************************************************************************
class KP_HealthCheck_Sched_TEST 
{
	//--------------------------------------------------------------------------------
	//  testScheduledCalc()
	// 
	//  History:
	//  TSH    04/06/2010    Original version
	// -------------------------------------------------------------------------------
	public static testMethod void testScheduledCalc() 
	{
		Test.startTest();

		// Run the scheduled job at midnight Sept. 3rd. 2022  
		String CRON_EXP = '0 0 0 3 9 ? 2022';
		String jobId = System.schedule('testScheduledKPHealthcheck', CRON_EXP, new KP_HealthCheck_Sched());
		
		// Get the information from the CronTrigger API object  
		CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

		// Verify the expressions are the same  
		System.assertEquals(CRON_EXP, ct.CronExpression);

		// Verify the job has not run  
		System.assertEquals(0, ct.TimesTriggered);

		// Verify the next time the job will run  
		System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
		Test.stopTest();
	}
}