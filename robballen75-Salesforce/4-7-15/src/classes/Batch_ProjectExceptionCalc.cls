//*********************************************************************************** 
// 
//  Batch_ProjectExceptionCalc
//   
//  Description:
//  This class implements the Database.Batchable interface and is used to 
//  calculate the project exception status for active projects (those whose status is
//  not Closed or Cancelled). 
//
//  The project exception status is set to one of the three values if the associated condition is met:
//	1.	Overdue - If the Project End Date has been met or exceeded.
//	2.	Over Budget - If the Project Hours Logged - Billable plus Project Hours Logged - NonBillable is equal or greater than Project Hours.
//  3.	Stalled - if the project status is set to 'Hold' or 'Stalled'
//
//  This class was developed for Microsystems by InSitu Software LLC.
//   
//  History:
//  InSitu     01/13/2010    Original version
//
// ***********************************************************************************
global with sharing class Batch_ProjectExceptionCalc implements Database.Batchable<sObject>
{
    ///////////////////////////////////////////////////
    //  Constants
    ///////////////////////////////////////////////////
    
    public static final String EXCEPTION_STATUS_OVERDUE = 'Overdue';
    public static final String EXCEPTION_STATUS_OVERBUDGET = 'Over Budget';
    public static final String EXCEPTION_STATUS_STALLED = 'Stalled';    
    
    ///////////////////////////////////////////////////
    //  Member variables
    ///////////////////////////////////////////////////
	global Set<String> setIncludeProjectStatus = new Set<String>();
	global Set<String> setExcludeProjectStatus = new Set<String>();


    ///////////////////////////////////////////////////
    //  Methods
    ///////////////////////////////////////////////////

    // Constructor
    global Batch_ProjectExceptionCalc()
    {
    	// Begin - the following section defines values used in the criteria to determine
        // the projects for which the exception calculations should be run. 
        
        // Project Status - to INCLUDE
        setIncludeProjectStatus.add('Hold');
        setIncludeProjectStatus.add('Stalled');
        
        // Project Status values - to EXCLUDE
        setExcludeProjectStatus.add('Cancelled');
        setExcludeProjectStatus.add('Closed');
        
    	// End -- Project Exception Criteria values.
    }

    global Database.QueryLocator start(Database.BatchableContext BC)
    {

		// Create the query to find all Project records that meet at least one of three criteria
		// that places them in the possible 'exception' category.
		
		// Number of days
    	Date dateToday = Date.today();
				
		return Database.getQueryLocator([SELECT ID, name, project_status__c, project_end_date__c, project_exception_status__c,
										 project_hours__c, project_hours_logged_f__c, proj_hrs_logged_billable_not_chargeable__c
		                                 FROM ms_project__c
		                                 WHERE project_status__c NOT in :setExcludeProjectStatus AND (not name like '%microsystems%') and
		                                 	   (project_end_date__c < :dateToday OR
		                                        project_status__c in :setIncludeProjectStatus OR
		                                        project_hours_logged_f__c > 0 OR
		                                        proj_hrs_logged_billable_not_chargeable__c > 0)]);
    }

	// --------------------------------------------------------
    //  execute
    //
    //  This method is called by the Batch Apex controller. Sets of records are
    //  sent in to be processed in 'batch'. Like a bulkified trigger, this method
    //  processes and updates the items in collections to limit the number 
    //  of DML statements issued. Got to mind those governor limits! 
    // --------------------------------------------------------

    global void execute(Database.BatchableContext BC, sObject[] listProjects)
    {
        // Iterate the projects and determine which projects should have their exception status set.
        List<ms_project__c> listProjectsToUpdate = new List<ms_project__c>();
        for (sObject projObj : listProjects)
        {
            String sStatus = null;
            ms_project__c proj = (ms_project__c)projObj;

            if (proj.project_end_date__c < Date.today())
            {
            	// If project exception status is not already set to Overdue, set the status.
            	if (proj.project_exception_status__c != EXCEPTION_STATUS_OVERDUE)
            		sStatus = EXCEPTION_STATUS_OVERDUE;
            }
            else if (proj.project_hours_logged_f__c + proj.proj_hrs_logged_billable_not_chargeable__c > proj.project_hours__c)
            {
            	// If project exception status is not already set to Over budget, then set the status
            	if (proj.project_exception_status__c != EXCEPTION_STATUS_OVERBUDGET)
            		sStatus = EXCEPTION_STATUS_OVERBUDGET;
            }
            else if (setIncludeProjectStatus.contains(proj.project_status__c))
            {
            	// If project exception status is not already set to Stalled, then set the status
            	if (proj.project_exception_status__c != EXCEPTION_STATUS_STALLED)
	            		sStatus = EXCEPTION_STATUS_STALLED;
            }
 
            // Determine if the exception status needs to be set for the project
            if (sStatus != null)
            {
            	ms_project__c projUpdate = proj;
            	projUpdate.project_exception_status__c = sStatus;
            	projUpdate.project_exception_status_last_update__c = Date.today();
            	
            	listProjectsToUpdate.add(projUpdate);
            }
        }   
        if (listProjectsToUpdate.size() > 0)
        {
            system.debug('Updating Project record count: ' + listProjectsToUpdate.size());
            update listProjectsToUpdate;
        }
    }
    
	// --------------------------------------------------------
    //  finish
    //
    //  This method is called by the Batch Apex controller when an error is
    //  encountered during the execution of the Batch Apex Batch. If this should
    //  happen, a notification email is sent out. 
    // --------------------------------------------------------

    global void finish(Database.BatchableContext BC)
    {
    	// Get the ID of the AsyncApexJob representing this batch job from Database.BatchableContext.
		// Query the AsyncApexJob object to retrieve the current job's information.
		ID idJob = BC.getJobId();
		AsyncApexJob apexjobCRU =  [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
						  			FROM AsyncApexJob WHERE Id = :idJob];

		// Because of test coverage issues in this class, need to create the 'failure' email message and only
		// send if there is truly a failure.
		// I can't seem to find a way to fail the job from a test.
		Messaging.SingleEmailMessage emailNotify = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {apexjobCRU.CreatedBy.Email};
		emailNotify.setToAddresses(toAddresses);
		emailNotify.setSubject('Project Exception Status Calculation - Completed with Errors');
		emailNotify.setPlainTextBody(
			'The Project Exception Status Calculation completed, however the job reported ' + apexjobCRU.NumberOfErrors + 
			' errors. If the calculation continues to fail, contact your system administrator or InSitu Software support.');
			
		// if the job did not complete successfully, then send an email to the job's submitter letting them know that there was a problem.
		if (apexjobCRU.Status == 'Failed')
		{
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailNotify });
		}
    	
    }   
}