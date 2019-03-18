//******************************************************************************************
//
//  Acct_Case_CRU_OnCase
//
//  Creates an Account-Case Custom Rollup record for every Case record.
//  Updates fields in Account-Case Custom Rollup when corresponding fields
//   in the Case record change.  Currently maintaining:
//      Case Type
//
//   NOTE: A Case does not normally require an Account or a Type but
//         Microsystems has configured their Cases to require these fields
//         so this trigger will assume that all Case records will have an
//         Account and a Type value specified.  			
//
//  This trigger was developed for Microsystems by InSitu Software LLC.
//   
//  History:
//  InSitu    01/10/2010    Original version
// ******************************************************************************************
trigger Acct_Case_CRU_OnCase on Case (after insert, after update) 
{
	// If a new Case record was inserted, insert an Account-Case record
	if (Trigger.isInsert == true)
	{
		// Create a collection of Account-Case records.
		// A collection is needed to make the trigger bulk safe.
		List<acct_case_custom_rollup__c> listAcctCase = new List<acct_case_custom_rollup__c>();
		for (Integer i = 0; i < Trigger.new.size(); i++)
		{
			// Make sure we have a valid account. It may be null if the case was created via Outlook Email to Case or some other
			// automated process.
			if (Trigger.new[i].AccountId != null)
			{
				// Convert the Creat Date/Time to just a date
				Date dateOpened = Date.newInstance(Trigger.new[i].CreatedDate.year(),
												   Trigger.new[i].CreatedDate.month(),
												   Trigger.new[i].CreatedDate.day());
				
				// Creat a new Account-Case record based on the new Case record
				acct_case_custom_rollup__c newAcctCase = new acct_case_custom_rollup__c(
																Account__c = Trigger.new[i].AccountId, 
																Case__c = Trigger.new[i].Id,
																Case_Type__c = Trigger.new[i].Type,
																Case_Open_Date__c = dateOpened);
				// Add new record to the collection															
				listAcctCase.add(newAcctCase);
			}
		}
		
		// Insert the new Account-Case records
		insert listAcctCase;
	}

	// If the Case is being updated, process any field changes tracked by the 
  	// custom rollup object
	if (Trigger.isUpdate == true)
	{
		// Collections used to process updates and potential inserts
	    List<Id> listChangedCaseIDs = new List<id>();
	    Map<ID, String> mapCaseIdCaseType = new Map<Id, String>();
	    List<acct_case_custom_rollup__c> listAddAcctCases = new List<acct_case_custom_rollup__c>();
	    
	    for(Integer i = 0; i < Trigger.old.size(); i++)
	    {
	    	// If the Case Type changed on a record we should have a CRU record for
	      	if (Trigger.old[i].Type != Trigger.new[i].Type && 
	      	    Trigger.new[i].AccountId == Trigger.old[i].AccountId &&
	      	    Trigger.new[i].AccountId != null)
	      	{
	        	// Save the ID of the case so we can get the corresponding
	        	// Account-Case record
	        	listChangedCaseIDs.add(Trigger.new[i].Id);
	        
	        	// Save the Cast Type change
	       		mapCaseIdCaseType.put(Trigger.new[i].Id, Trigger.new[i].Type);  
	    	}
	    	
	    	// If the Account Id was null and is now being provided, we need to 
	    	// process as an INSERT to the CRU
	    	if (Trigger.new[i].AccountId != Trigger.old[i].AccountId &&
	      	    Trigger.old[i].AccountId == null)
	      	{
	      		// Convert the Creat Date/Time to just a date
				Date dateOpened = Date.newInstance(Trigger.new[i].CreatedDate.year(),
												   Trigger.new[i].CreatedDate.month(),
												   Trigger.new[i].CreatedDate.day());
				
				// Create a new Account-Case record based on the new Case record
				acct_case_custom_rollup__c newAcctCase = new acct_case_custom_rollup__c(
																Account__c = Trigger.new[i].AccountId, 
																Case__c = Trigger.new[i].Id,
																Case_Type__c = Trigger.new[i].Type,
																Case_Open_Date__c = dateOpened);
				// Add new record to the collection															
				listAddAcctCases.add(newAcctCase);	
	      	}
	        	
	    }
	      
	    // If we had any Case Type changes we need to update the 
	    // corresponding Account-Case Record
	    if (!listChangedCaseIDs.isEmpty())
	    {
	      	// Get all the Account-Case records then need updating
	      	List<acct_case_custom_rollup__c> listChangedAcctCases = 
	        	new List<acct_case_custom_rollup__c>(
	            	[SELECT Id, Case__r.Id, Case_Type__c FROM acct_case_custom_rollup__c WHERE Case__r.Id in :listChangedCaseIDs]);  
	        
	        // Check if any records were found.
	        // If the Type was changed on a Case that was older then the ones used
	        // in the KP HelachCheck score its CRU would have been purged so it
	        // is possible not records would have been returned.    
	      	if (!listChangedAcctCases.isEmpty())
	      	{
		      	// Loop through the records and update their Case Types
		      	for (Integer idx = 0; idx < listChangedAcctCases.size(); idx++)
		      	{
		        	listChangedAcctCases[idx].Case_Type__c = mapCaseIdCaseType.get(listChangedAcctCases[idx].Case__r.Id);      
		      	}
		      
		      	// Update the records
		      	update listChangedAcctCases;
	      	}
	    }
	    
	    // If we had any Account added to case situations
	    // we need to insert new CRUs
	    if (!listAddAcctCases.isEmpty())
	    {
	    	insert listAddAcctCases;	
	    }
	          
    }
}