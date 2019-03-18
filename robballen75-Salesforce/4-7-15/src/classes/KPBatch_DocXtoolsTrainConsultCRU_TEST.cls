@isTest
// *********************************************************************************** 
// 
//  KPBatch_DocXtoolsTrainConsultCRU_TEST
//    
//  Desciption:
//  Class for all of the unit tests associated with the KPBatch_DocXtoolsTrainConsultCRU.
//   
//  History:
//  This class was developed for Microsystems by InSitu Software LLC.
//   
//  History:
//  InSitu     01/17/2010    Original version
//
// ***********************************************************************************
private class KPBatch_DocXtoolsTrainConsultCRU_TEST 
{
   //--------------------------------------------------------------------------------
    //  testKPBatch_DocXtoolsTrainConsultCRU()
    // 
    //  Tests to make sure DocXtoolsTrainConsultCRU calc works properly.
    //
    //  History:
    //  InSitu    01/17/2010    Original version
    // -------------------------------------------------------------------------------

    public static testMethod void testKPBatch_DocXtoolsTrainConsultCRU() 
    {
        //--------------------------------------------------------------------
        // Set up test data 
        //--------------------------------------------------------------------
	
	   	// Delete all existing acct_proj_custom_rollup__c records - this is what is always done before the
	   	// batch processing is executed.
		for (acct_proj_custom_rollup__c[] listAcctProjCRU : [SELECT ID from acct_proj_custom_rollup__c])
		{
			delete listAcctProjCRU;
		}
		
		// Create a regular account  - the KP Account attribute is not checked in the batch
		// process that creates the CRU records.
		Account acctTest = new Account (Name = 'Unit Test - Account 1');
     	insert acctTest;
		
		// Create a bunch of projects with various attributes.
		
		//---------------------------
        // 1. Project Product = DocXTools
        //    Type = Training
		//---------------------------
		ms_project__c projDocXTrain = new ms_project__c(name = 'ZZZUnit Test1 - Training, DocXtools',
  													  account__c = acctTest.Id,
  													  project_status__c = 'Open',
  													  project_start_date__c = Date.today(), 
  													  project_end_date__c = Date.today() + 10,
  													  project_hours__c = 11,
  													  project_type__c = 'Training');
		insert projDocXTrain;

		Project_Product__c projprodDocX1 = new Project_Product__c(Project__c = projDocXTrain.Id,
																  Project_Product_Type__c = 'DocXTools');
		insert projprodDocX1;

		//---------------------------
        // 2. Project Product = DocXTools
        //    Type = Consulting
		//---------------------------
		ms_project__c projDocXConsult = new ms_project__c(name = 'ZZZUnit Test2 - Consulting, DocXtools',
  													  account__c = acctTest.Id,
  													  project_status__c = 'Open',
  													  project_start_date__c = Date.today(), 
  													  project_end_date__c = Date.today() + 10,
  													  project_hours__c = 11,
  													  project_type__c = 'Consulting');
		insert projDocXConsult;

		Project_Product__c projprodDocX2 = new Project_Product__c(Project__c = projDocXConsult.Id,
																  Project_Product_Type__c = 'DocXTools');
		insert projprodDocX2;


		//---------------------------
        // 3. Project Product = DocXTools
        //    Type = None
		//---------------------------
		ms_project__c projDocXNone = new ms_project__c(name = 'ZZZUnit Test3 - None, DocXtools',
  													  account__c = acctTest.Id,
  													  project_status__c = 'Open',
  													  project_start_date__c = Date.today(), 
  													  project_end_date__c = Date.today() + 10,
  													  project_hours__c = 11);
		insert projDocXNone;
		
		//---------------------------
        // 4. Project Product = DocXTools
        //    Status = Cancelled
		//---------------------------
		ms_project__c projDocXCancelled = new ms_project__c(name = 'ZZZUnit Test4 - Cancelled, DocXtools',
  													  account__c = acctTest.Id,
  													  project_status__c = 'Cancelled',
  													  project_start_date__c = Date.today(), 
  													  project_end_date__c = Date.today() + 10,
  													  project_hours__c = 11,
											  		  project_type__c = 'Consulting');
		insert projDocXCancelled;
		
		Project_Product__c projprodDocX4 = new Project_Product__c(Project__c = projDocXCancelled.Id,
																  Project_Product_Type__c = 'DocXTools');
		insert projprodDocX4;

		//---------------------------
        // 5. Project Product = D3
        //    Type = Training
		//---------------------------
		ms_project__c projD3Train = new ms_project__c(name = 'ZZZUnit Test5 - Training, D3',
  													  account__c = acctTest.Id,
  													  project_status__c = 'Open',
  													  project_start_date__c = Date.today(), 
  													  project_end_date__c = Date.today() + 10,
  													  project_hours__c = 11,
  													  project_type__c = 'Training');
		insert projD3Train;

		Project_Product__c projprodD3 = new Project_Product__c(Project__c = projD3Train.Id,
															   Project_Product_Type__c = 'D3');
		insert projprodD3;

        Test.StartTest();

		// The calculation is going to be done in batch. Create an instance of the Apex Batch class and
		// initiate the batch processing.
		
		KPBatch_DocXtoolsTrainConsultCRU batchClass = new KPBatch_DocXtoolsTrainConsultCRU();
		batchClass.bTest = true;
		
		// Call execute to process one batch.
		Database.executeBatch(batchClass);
		
		Test.StopTest();
	
		// Now test the results.      
		
		//  Get all CRU records for test account
 		List<acct_proj_custom_rollup__c> listAcctProjCRU  = [SELECT ID, project_type__c FROM acct_proj_custom_rollup__c
 															 WHERE account__r.ID = :acctTest.Id
 															 ORDER BY project__r.Name ASC];
 															 
		System.assertEquals(2, listAcctProjCRU.size());
		System.assertEquals('Training', listAcctProjCRU[0].project_type__c);
		System.assertEquals('Consulting', listAcctProjCRU[1].project_type__c);
    }
    
}