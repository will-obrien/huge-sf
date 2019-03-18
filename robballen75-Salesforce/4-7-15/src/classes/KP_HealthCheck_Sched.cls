//*********************************************************************************** 
// 
//  KP_HealthCheck_Sched
//   
//  Description:
//  This class implements the Schedulable interface and is provided so that
//  the KP Healthcheck Maintenance processing can be scheduled to run on a regular basis. 
//
//  This class was developed for Microsystems by InSitu Software LLC.
//   
//  History:
//  InSitu  04/06/2010  Original version
// ***********************************************************************************

global with sharing class KP_HealthCheck_Sched implements Schedulable
{
	global void execute(SchedulableContext SC) 
	{
		// Call the HealthCheck Maintenance routine.	
		KP_HealthCheck_Util.runKPHealthCheckMaintenance();
	}
}