@isTest
// *********************************************************************************** 
// 
//  Batch_ProjectExceptionCalc_TEST
//    
//  Desciption:
//  Class for all of the unit tests associated with the Batch_ProjectExceptionCalc.
//   
//  History:
//  This class was developed for Microsystems by InSitu Software LLC.
//   
//  History:
//  InSitu     01/17/2010    Original version
//
// ***********************************************************************************
private class Batch_ProjectExceptionCalc_TEST 
{
   //--------------------------------------------------------------------------------
    //  testBatch_ProjectExceptionCalc()
    // 
    //  Tests to make sure project exception calc works properly.
    //
    //  History:
    //  InSitu    01/17/2010    Original version
    // -------------------------------------------------------------------------------

    public static testMethod void testBatch_ProjectExceptionCalc() 
    {
        //--------------------------------------------------------------------
        // Set up test data 
        //--------------------------------------------------------------------
        
        // Create projects:
        // 1. Overdue
        // 2. Over Budget
        // 3. Stalled
        // 4. Overdue, Over budget, Stalled
        // 5. Overdue, Over budget
        // 6. Overdue, Stalled
  
		//---------------------------
        // 1. Overdue
		//---------------------------
  		ms_project__c projOverdue = new ms_project__c(name = 'InSitu Unit Test1 - Overdue',
  													  project_status__c = 'Open',
  													  project_start_date__c = Date.today() - 10, 
  													  project_end_date__c = Date.today() - 1,
  													  project_hours__c = 10);
		insert projOverdue;
    
		//---------------------------
        // 2. Over Budget
		//---------------------------
  		ms_project__c projOverBudget = new ms_project__c(name = 'InSitu Unit Test2 - OverBudget',
  													  project_status__c = 'Open',
  													  project_start_date__c = Date.today(), 
  													  project_end_date__c = Date.today() + 10,
  													  project_hours__c = 11);
		insert projOverBudget;
		
			// Create an assignment record.
			MS_Assignment__c assignOverBudget = new MS_Assignment__c(Project__c = projOverBudget.Id,
																	 Hours_Assigned__c = 11,
																	 Assignment_Due_Date__c = Date.today() + 10,
																	 Area_of_Effort__c = 'Train');
			insert assignOverBudget;
			
			// Record hours against the project.
   			MS_Time_Entry__c teHours2 = new MS_Time_Entry__c(Time_Entry_Hours__c = 10,
   															Time_Entry_Hours_NON_BILLABLE__c = 5, 
   															Time_Entry_Date__c = Date.today(), 
   															Project__c = projOverBudget.Id,
   															Assignment__c = assignOverBudget.Id);
    		insert teHours2;
    
		//---------------------------
        // 3. Stalled
		//---------------------------
  		ms_project__c projStalled = new ms_project__c(name = 'InSitu Unit Test3 - Stalled',
  													  project_status__c = 'Stalled',
  													  project_start_date__c = Date.today() - 10, 
  													  project_end_date__c = Date.today() + 10,
  													  project_hours__c = 12);
		insert projStalled;

		//---------------------------
        // 4. Overdue, Over Budget, Stalled
		//---------------------------
  		ms_project__c projOverDueBudgetStalled = new ms_project__c(name = 'InSitu Unit Test4 - OverDue, Over Budget, Stalled',
		  													  		project_status__c = 'Stalled',
		  													  		project_start_date__c = Date.today()- 20, 
		  													  		project_end_date__c = Date.today() - 10,
		  													  		project_hours__c = 14);
		insert projOverDueBudgetStalled;
		
			// Create an assignment record.
			MS_Assignment__c assignOverDueBudgetStalled = new MS_Assignment__c(Project__c = projOverDueBudgetStalled.Id,
																			    Hours_Assigned__c = 15,
																			    Assignment_Due_Date__c = Date.today() + 10,
																			    Area_of_Effort__c = 'Train');
			insert assignOverDueBudgetStalled;
			
			// Record hours against the project.
   			MS_Time_Entry__c teHours4 = new MS_Time_Entry__c(Time_Entry_Hours__c = 10,
   															 Time_Entry_Hours_NON_BILLABLE__c = 15, 
   															 Time_Entry_Date__c = Date.today(), 
   															 Project__c = projOverDueBudgetStalled.Id,
   															 Assignment__c = assignOverDueBudgetStalled.Id);
    		insert teHours4;

		//---------------------------
        // 5. Overdue, Over Budget
		//---------------------------
  		ms_project__c projOverDueBudget = new ms_project__c(name = 'InSitu Unit Test5 - OverDue, Over Budget',
  													  		project_status__c = 'Open',
  													  		project_start_date__c = Date.today()- 20, 
  													  		project_end_date__c = Date.today() - 10,
  													  		project_hours__c = 15);
		insert projOverDueBudget;
		
			// Create an assignment record.
			MS_Assignment__c assignOverDueBudget = new MS_Assignment__c(Project__c = projOverDueBudget.Id,
																	    Hours_Assigned__c = 15,
																	    Assignment_Due_Date__c = Date.today() + 10,
																	    Area_of_Effort__c = 'Train');
			insert assignOverDueBudget;
			
			// Record hours against the project.
   			MS_Time_Entry__c teHours5 = new MS_Time_Entry__c(Time_Entry_Hours__c = 10,
   															 Time_Entry_Hours_NON_BILLABLE__c = 15, 
   															 Time_Entry_Date__c = Date.today(), 
   															 Project__c = projOverDueBudget.Id,
   															 Assignment__c = assignOverDueBudget.Id);
    		insert teHours5;


		//---------------------------
        // 6. Overdue, Stalled
		//---------------------------
  		ms_project__c projOverdueStalled = new ms_project__c(name = 'InSitu Unit Test6 - OverdueStalled',
  													  project_status__c = 'Stalled',
  													  project_start_date__c = Date.today() - 10, 
  													  project_end_date__c = Date.today() - 1,
  													  project_hours__c = 16);
		insert projOverdueStalled;

        Test.StartTest();

		// The calculation is going to be done in batch. Create an instance of the Apex Batch class and
		// initiate the batch processing.
		Batch_ProjectExceptionCalc batchProjectExceptionCalc = new Batch_ProjectExceptionCalc();
	 	Id idJob = database.executeBatch(batchProjectExceptionCalc, 200);
        
		// Execute a second time - make sure status doesn't change.
	//	Batch_ProjectExceptionCalc batchProjectExceptionCalc2 = new Batch_ProjectExceptionCalc();
	 //	idJob = database.executeBatch(batchProjectExceptionCalc2, 200);

        Test.StopTest();
        
        List<ms_project__c> listUnitTestProjs = [SELECT ID, Name,  project_exception_status__c FROM ms_project__c
        										 WHERE Name LIKE 'InSitu Unit Test%' 
        										 ORDER BY Name];
        
        System.assertEquals(6, listUnitTestProjs.size());
        system.debug('RobbLog1-Project=' + listUnitTestProjs[0].name + 'Status=' + listUnitTestProjs[0].project_exception_status__c);
       // System.assertEquals(Batch_ProjectExceptionCalc.EXCEPTION_STATUS_OVERDUE, listUnitTestProjs[0].project_exception_status__c);
       // System.assertEquals(Batch_ProjectExceptionCalc.EXCEPTION_STATUS_OVERBUDGET, listUnitTestProjs[1].project_exception_status__c);
        //System.assertEquals(Batch_ProjectExceptionCalc.EXCEPTION_STATUS_STALLED, listUnitTestProjs[2].project_exception_status__c);
        //System.assertEquals(Batch_ProjectExceptionCalc.EXCEPTION_STATUS_OVERDUE, listUnitTestProjs[3].project_exception_status__c);
        //System.assertEquals(Batch_ProjectExceptionCalc.EXCEPTION_STATUS_OVERDUE, listUnitTestProjs[4].project_exception_status__c);
        //System.assertEquals(Batch_ProjectExceptionCalc.EXCEPTION_STATUS_OVERDUE, listUnitTestProjs[5].project_exception_status__c);
        
    }
    
}