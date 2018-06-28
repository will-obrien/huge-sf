//*********************************************************************************** 
// 
//  KPBatch_DocXtoolsTrainConsultCRU
//   
//  Description:
//  This class implements the Database.Batchable interface and is used to 
//  create Custom Rollup (CRU) records to support the calculation of the 
//  DocXtools training/consulting score component of the KP Health Check Rating.
//
//  This class was developed for Microsystems by InSitu Software LLC.
//   
//  History:
//  InSitu     01/11/2010    Original version
//
// ***********************************************************************************

global with sharing class KPBatch_DocXtoolsTrainConsultCRU implements Database.Batchable<sObject>
{
    ///////////////////////////////////////////////////
    //  Constants
    ///////////////////////////////////////////////////
    
    ///////////////////////////////////////////////////
    //  Member variables
    ///////////////////////////////////////////////////
	public Boolean bTest   {get; set;}	// Needed so that the unit tests can limit the query results to 200.
	
    ///////////////////////////////////////////////////
    //  Methods
    ///////////////////////////////////////////////////

    // Constructor

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
    	// Begin - the following section defines values used in the criteria to determine
        // the projects to be included in the calculation of the Private Training/Consulting hours 
        // component of the KP Health Check.
        
        // Project Product Type - to INCLUDE
        Set<String> setIncludeProjectProductType = new Set<String>();
        setIncludeProjectProductType.add('DocXTools');

        // Project Type - to INCLUDE
        Set<String> setIncludeProjectType = new Set<String>();
        setIncludeProjectType.add('Training');
        setIncludeProjectType.add('Consulting');
        
        // Project Status values - to EXCLUDE
        Set<String> setExcludeProjectStatus = new Set<String>();
        setExcludeProjectStatus.add('Cancelled');
        
        // Number of days
    	integer iMostRecentNumberOfDays = 365;
    	
    	// End -- KP Health Check Criteria values.
    	    

		// Create the query to find all Project Product records associated with Projects to be processed
		Date dateMR = Date.Today() - iMostRecentNumberOfDays;

		// The bTest variable is provided so that the query is limited to 200 records and is sorted such 
		// that the test records are guaranteed to be retrieved. 
		if (bTest != true)
		{
			return Database.getQueryLocator([SELECT project__c, project__r.ID, project_product_type__c
			                                          FROM Project_Product__c
			                                          WHERE project_product_type__c in :setIncludeProjectProductType AND
			                                                project__r.project_type__c in :setIncludeProjectType AND
			                                                project__r.project_status__c NOT in :setExcludeProjectStatus AND
			                                                project__r.project_start_date__c > :dateMR]);
		}
		else
		{
			system.debug('Running test query.');
			return Database.getQueryLocator([SELECT project__c, project__r.ID, project_product_type__c
			                                          FROM Project_Product__c
			                                          WHERE project_product_type__c in :setIncludeProjectProductType AND
			                                                project__r.project_type__c in :setIncludeProjectType AND
			                                                project__r.project_status__c NOT in :setExcludeProjectStatus AND
			                                                project__r.project_start_date__c > :dateMR
			                     // Next two lines are unique just for testing purposes.
			                     					  ORDER BY project__r.name DESC                           
			                                          LIMIT :200]);
		}
    }

	// --------------------------------------------------------
    //  execute
    //
    //  This method is called by the Batch Apex controller. Sets of records are
    //  sent in to be processed in 'batch'. Like a bulkified trigger, this method
    //  places items in collections for querying and updating to limit the number 
    //  of DML statements issued. Got to mind those governor limits! 
    // --------------------------------------------------------

    global void execute(Database.BatchableContext BC, sObject[] listProjProds)
    {
		// Iterate the collection of Project Product items - put all project ids into a set
		// in preparation for the project/account query.
        Set<ID> setProjectIds = new Set<ID>();
        for (integer i=0; i < listProjProds.size(); i++)
        {
            setProjectIds.add(((Project_Product__c)listProjProds[i]).project__r.ID);  
        }   
        
        //system.debug('Number of Project IDs in set = ' + setProjectIds.size());

        // Get all the project objects and associated account data.
        List<MS_Project__c> listProjects = new List<MS_Project__c>();
        listProjects = [SELECT Name, project_hours_logged_f__c, proj_hrs_logged_billable_not_chargeable__c,
                            project_start_date__c, project_status__c, project_type__c, account__r.ID
                        FROM MS_Project__c
                        WHERE ID in :setProjectIds];

        //system.debug('Number of Projects retrieved = ' + listProjects.size());
                        
        // Iterate the projects and create acct_proj_custom_rollup records for each project
        List<acct_proj_custom_rollup__c> listAcctProjCRU = new List<acct_proj_custom_rollup__c>();
        for (integer i=0; i < listProjects.size(); i++)
        {
            acct_proj_custom_rollup__c cruAcctProj = new acct_proj_custom_rollup__c(
	            account__c = listProjects[i].account__r.ID,
	            project__c = listProjects[i].ID,
	            project_type__c = listProjects[i].project_type__c,
	            project_status__c = listProjects[i].project_status__c,
	            project_start_date__c = listProjects[i].project_start_date__c,
	            project_hours_logged_f__c = listProjects[i].project_hours_logged_f__c,
	            proj_hrs_logged_billable_not_chargeable__c = listProjects[i].proj_hrs_logged_billable_not_chargeable__c);
            
            listAcctProjCRU.add(cruAcctProj);
        }   
        if (listAcctProjCRU.size() > 0)
        {
            system.debug('Inserting/Updating AcctProj CRU record count: ' + listAcctProjCRU.size());
            insert listAcctProjCRU;
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
		emailNotify.setSubject('KP Health Check Calculation: DocXTools Training/Consulting Time - Completed with Errors');
		emailNotify.setPlainTextBody(
			'The KP Health Check Calculation for the DocXTools Training/Consulting Time component completed, however the job reported ' + apexjobCRU.NumberOfErrors + 
			' errors. If the calculation continues to fail, contact your system administrator or InSitu Software support.');
			
		// if the job did not complete successfully, then send an email to the job's submitter letting them know that there was a problem.
		if (apexjobCRU.Status == 'Failed')
		{
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { emailNotify });
		}
    	
    }   
}