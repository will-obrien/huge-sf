//*********************************************************************************** 
// 
//  KP_HealthCheck_Util
//   
//  Description:
//  This class contains utility methods used to perform calculation and record updates
//  for the Knowledge Partnership Healthcheck scoring system.
//
//  This class was developed for Microsystems by InSitu Software LLC.
//   
//  History:
//  InSitu  01/10/2010  Original version
// ***********************************************************************************

public with sharing class KP_HealthCheck_Util 
{
    // -----------------------------------------------------
    //  Custom KP Healthcheck Exception class
    // -----------------------------------------------------
    public class KPHC_Exception extends Exception {}

    ///////////////////////////////////////////////////
    //  Constants
    ///////////////////////////////////////////////////
    
    ///////////////////////////////////////////////////
    //  Member variables
    ///////////////////////////////////////////////////


    ///////////////////////////////////////////////////
    //  Methods
    ///////////////////////////////////////////////////


	// --------------------------------------------------------
    //  runKPHealthCheckMaintenance
    //
    //  Performs the following KP Health Check Maintenance routines: 
    //  1.	Creates custom rollup records to support the DocXTools Training/Consulting time calculation.
    //  2.	Purges outdated Account-Case custom rollup records. 
    //  3.	Purges outdated Account-Campaign custom rollup records. 
    // --------------------------------------------------------
    public static void runKPHealthCheckMaintenance() 
    {
        try
        {
            // Purge outdated Account-Case custom rollup records.
            purgeAccountCase();

            // Purge outdated Account-Campaign custom rollup records.
            purgeAccountCampaign();

            // Run the routine to create custom rollup records to support the DocXTools Training /Consulting time calculation.
            runDocXToolsTrainConsultTimeCRU();

            // Run the routine to calculate project exception status.
            runProjectExceptionCalc();
        }
        catch (Exception e) 
        {
            // Something happened with the query or processing the query results.   
            throw new KPHC_Exception('The following error occurred while executing the KP Health Check Maintenance routine - ' + e.getMessage());
        }       
    }

	// -----------------------------------------------------------
	// Purge the Account-Case Rollup Summary records
	// -----------------------------------------------------------
	public static void purgeAccountCase()
	{
	    try
		{
		    // Fill a collection of Account-Case records that need to be purged
		    for (acct_case_custom_rollup__c[] listAcctCaseToPurge : [SELECT Id FROM acct_case_custom_rollup__c WHERE Purge_Date__c < :System.Today()])
		    {
			    // Delete all records that matched the criteria. 
		        delete listAcctCaseToPurge;
		    }
	    }
        catch(Exception e)  
        {
            // Something happened with the query or processing the query results.   
            throw new KPHC_Exception('Account-Case Custom Rollup Purge: ' + e.getMessage());
        } 
	}

	// -----------------------------------------------------------
	// Purge the Account-Campaign Rollup Summary records
	// -----------------------------------------------------------
	public static void purgeAccountCampaign()
	{
	    try
		{
		    // Fill a collection of Account-Campaign records that need to be purged
		    for (acct_campaign_custom_rollup__c[] listAcctCampaignToPurge : [SELECT Id FROM acct_campaign_custom_rollup__c WHERE Purge_Date__c < :System.Today()])
		    {
			    // Delete all records that matched the criteria. 
		        delete listAcctCampaignToPurge;
		    }
	    }
        catch(Exception e)  
        {
            // Something happened with the query or processing the query results.   
            throw new KPHC_Exception('Account-Campaign Custom Rollup Purge: ' + e.getMessage());
        }
	}


	// -----------------------------------------------------------
    // Create custom rollup records to support the DocXTools Training/Consulting time calculation. 
	// -----------------------------------------------------------
    public static void runDocXToolsTrainConsultTimeCRU() 
    {
		try
		{
	    	// Delete all existing acct_proj_custom_rollup__c records.
			for (acct_proj_custom_rollup__c[] listAcctProjCRU : [SELECT ID from acct_proj_custom_rollup__c])
			{
				delete listAcctProjCRU;
			}

			// The calculation is going to be done in batch. Create an instance of the Apex Batch class and
			// initiate the batch processing.
			KPBatch_DocXtoolsTrainConsultCRU batchDocXtoolsCRU = new KPBatch_DocXtoolsTrainConsultCRU();
		 	Id idJob = database.executeBatch(batchDocXtoolsCRU, 200);
	
        }
        catch(Exception e)  
        {
            // Something happened with the query or processing the query results.   
            throw new KPHC_Exception('DocXtools Training/Consulting Total Project Time: ' + e.getMessage());
        }
    }

	// -----------------------------------------------------------
    // Processes Project records to determine which ones are in an 'exception' state - meaning
    // that something is potentially not going as expected. For those found in the exception state,
    // a project exception status is set. On a regularly scheduled basis, reports are generated using this
    // information to alert key personnel of the situation. 
	// -----------------------------------------------------------
    public static void runProjectExceptionCalc() 
    {
		try
		{
			// The calculation is going to be done in batch. Create an instance of the Apex Batch class and
			// initiate the batch processing.
			Batch_ProjectExceptionCalc batchProjectExceptionCalc = new Batch_ProjectExceptionCalc();
		 	Id idJob = database.executeBatch(batchProjectExceptionCalc, 200);
	
        }
        catch(Exception e)  
        {
            // Something happened with the query or processing the query results.   
            throw new KPHC_Exception('Project Exception Status Calc: ' + e.getMessage());
        }
    }


    
}