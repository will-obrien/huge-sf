@isTest
// *********************************************************************************** 
// 
//  EmailRun_KP_HealthCheck_Maintenance_TEST
//  
//  Desciption:
//  Class for all of the unit tests associated with the 
//  EmailRun_KP_HealthCheck_Maintenance class.
//
//  Developed for Microsystems by InSitu Software LLC.
//
//  History:
//  RMN    01/10/2010    Original version
// ***********************************************************************************
private class EmailRun_KP_HealthCheck_Maintenance_TEST 
{
	// -------------------------------------------------
	// Test1 - just call the method
	// ------------------------------------------------
    static testMethod void Test1() 
    {
     	// Create a new email, envelope object and Attachment
   		Messaging.InboundEmail email = new Messaging.InboundEmail();
   		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

   		email.subject = 'Can be anything';
   		env.fromAddress = 'KPHealthCheckMaintenance@microsystems.com';

		// Creat a result object
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
   		// Call the class 
   		EmailRun_KP_HealthCheck_Maintenance kphcmTest = new EmailRun_KP_HealthCheck_Maintenance();
   		result = kphcmTest.handleInboundEmail(email, env );
   		
   		// Check the results
   		System.assertEquals(true, result.success);
   		System.assertEquals(null, result.message);	                         	  
    }
}