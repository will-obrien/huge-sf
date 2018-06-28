//******************************************************************************************
// 
//  EmailRun_KP_HealthCheck_Maintenance
//
//  This class initiates the various KP Health Check routines which
//  must be run on a regular basis.  These maintenance routines consist mainly
//  of processing associated with properly maintaining the records in custom
//  rollup summary objects.
//
//  This class is implemented as a Salesforce InboundEmail handler.  Currently
//  the content of the message does not matter as any valid message will 
//  initiate each of the maintenance tasks.  If granularity of task was needed
//  this class could be changed to initiate individual maintenance tasks based
//  on the contents of the email subject (email.Subject).
// 
//  NOTE: This class is a temporary solution to be used until SFDC releases
//        their Spring 2010 version.  That version is schedule to include
//        support for schedulable Apex.  Once available, the KP Health
//        Check maintenance tasks should be call as a scheduled class.    
//
//  This class was developed for Microsystems by InSitu Software LLC.
//   
//  History:
//  InSitu    01/11/2010    Original version
// ******************************************************************************************
global class EmailRun_KP_HealthCheck_Maintenance implements Messaging.InboundEmailHandler 
{

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) 
    {
        // Creat a result object
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
		// Run the maintenance routine 
		try
		{
			// Call the Account-Case Purge routine	
			KP_HealthCheck_Util.runKPHealthCheckMaintenance();
		}
		catch (Exception e)
		{
			result.success = false;
			result.message = e.getMessage();	
		}

		// Return success
		result.success = true;
        return result;
    }
}