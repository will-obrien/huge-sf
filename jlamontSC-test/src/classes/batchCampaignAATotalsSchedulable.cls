// **************************************************************************
// batchCampaignAATotalsSchedulable						(c) 2015 Sierra Club
//
//	Recalculates the Advocacy Action totals for marked Campaigns
//			When an Advocacy Action is inserted or updated, it is marked 
//		to e recalculated.  This class is called nightly to recalcuate 
//		the Advocacy_Action_Count__c value on the Campaign.
//
//	2015/09/14		VB		Original ()
//	2015/09/08		VB		Code to calculate Advocacy Action counts
//	2015/09/08		VB		Added 'after' clauses on update & delete, 
//								so totals could be calculated correctly.
//
// **************************************************************************
global class batchCampaignAATotalsSchedulable implements Schedulable{
		
    global void execute(SchedulableContext sc){
    	
		// VB: 8/20/15 - Delete All Contact Addresses created by BatchUpload user.
						//'WHERE CreatedById = \'005i00000066uf9AAA\' ' +
 						// 'OR CreatedById = \'00519000000X3tf\'' // Full Sandbox User

		//
		// VB: Not sure if this query should be pulling the Campaigns, and attempting to build
		//		the counts by issuing additional queries, of if I should be doing the mass
		//		update here and attempt to perform the totals by building the results
		//		I'm going with the 2nd approach.
		String query = 'SELECT id, kwac__Related_Action__c ' +
						'FROM kweos__EOCS_Data__c ' +
						'WHERE kwac__Related_Action__r.Advocacy_Action_Count_Dirty__c = true ' +
						'ORDER BY kwac__Related_Action__c';
		//String queryA = 'SELECT id, kwac__Related_Action__c ' +
		//				'FROM kweos__EOCS_Data__c ' +
		//				'WHERE kwac__Related_Action__r.Advocacy_Action_Count_Dirty__c = true ' +
		//				'ORDER BY kwac__Related_Action__c';
		//String queryB = 'SELECT Id, Related_Convio_Action__r.Advocacy_Action_Count__c ' +
		//				'FROM Campaign ' +
		//				'WHERE Advocacy_Action_Count_Dirty__c = true';
										
        
		//'WHERE CreatedById = \'005i00000066uf9\''; 
        //List<kweos__EOCS_Data__c> aaList = new List<kweos__EOCS_Data__c>([
		//	SELECT Id, kwac__Related_Action__c 
		//		FROM kweos__EOCS_Data__c
		//		WHERE kwac__Related_Action__c IN :campaignIds
		//		ORDER BY kwac__Related_Action__c]
		//);
        
        batchCampaignAATotals  countBatch = new batchCampaignAATotals(query);
        //batchCampaignAATotals  countBatch = new batchCampaignAATotals(queryA,queryB);
        Id BatchProcessId = Database.ExecuteBatch(countBatch);
    }
}