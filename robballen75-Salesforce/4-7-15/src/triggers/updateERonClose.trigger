//******************************************************************************************
//
//  updateERonClose
//
//  Updates the closed by user to the current user if no other user selected.
//	Updates the closed date to the current date if not other date selected.
//	If resolution was set, but is now not set, change status to ReOpened 
//   
//  History:
// 1/04/2010    Robb Allen  - Comments added
// 1/10/2010 	Robb Allen - reworked to add bulk safe loop
// ******************************************************************************************

trigger updateERonClose on Enhancement_Request__c (before insert, before update) 
{

	for (Integer idx = 0; idx < trigger.new.size(); idx++)
	{

		if (trigger.new[idx].ER_Resolution__c != null) 
		{
			string currentUser = UserInfo.getUserId();

			//Set Closed By to current user if Resolution is not null and 
			//Closed Bye is not specified.
			string closedBy = trigger.new[idx].ER_Closed_By__c;
				if (closedBy == null) 
				{
    				trigger.new[idx].ER_Closed_By__c = currentUser;
				}

			//Set Closed Date to today if Resolution is not null and Closed Date is not specified.
				if (trigger.new[idx].ER_Close_Date__c == null) 
				{
					trigger.new[idx].ER_Close_Date__c = date.today();		
				}
			
			//Set Status to Closed if Resolution is not null.
				trigger.new[idx].ER_Status__c = 'Closed';
         
		} 
		else // The resolution is null
		{

			// If the ER_Resolution field is null, then clear out the closed by and closed date fields.
				trigger.new[idx].ER_Closed_By__c = null;
				trigger.new[idx].ER_Close_Date__c = null;
				trigger.new[idx].ER_Fixed_In_Version__c = null;
			
			// If the ER_Resolution is null, and is wasn't before this change,
			// set the ER status to Reopened
			if (system.trigger.isUpdate && trigger.old[idx].er_resolution__c != null ) 
			{
				trigger.new[idx].ER_Status__c = 'Reopened';
			}
		}

	}  //End loop
}