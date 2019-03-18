//******************************************************************************************
//
//  updateL2UserSelect
//
//  Updates the value of the Assigned_L2_A__c custom field to the SFDC user corresponding to the  
//  text selectd in the Assigned_L2__c field.  This allows for email notificatoins to the selected SFDC
//  user when a case has been escalated to them.
//
//   
//  History:
// 1/04/2010    Robb Allen  - Comments added
// 1/19/2010	Robb Allen - verified bulk safe operation, removed vestiges of non bulk-safe processing
// ******************************************************************************************


trigger updateL2UserSelect on Case (before update, before insert)
{

	Set <string> userIds = new Set<string>();
	for (case myCase : Trigger.new) 
		{
			userIds.add(myCase.Assigned_L2__c);
		}

	// Create a new user map, and add all users who were passed into the userID set
	Map<String, Id> users = new Map<String, Id>();
	for (user myUsers : [select name, id from user where name in :userIds])
		{
			users.put(myusers.name, myusers.id);
		}

	for (Case myCase : Trigger.new)
		{
			string l2Picklist = myCase.Assigned_L2__c;

	// If there was a value entered into the assigned_l2__c field, continue
		if (l2Picklist != null) 
			{

			// Determine if name passed into l2Picklist represents a valid SFDC user.  
			Boolean isRealUser = users.containsKey(l2Picklist);

			//If is is a valid user, then determine if the case has been escalated and set
			//hidden SFDC user field to associated user.
			if (isRealUser == true) 
				{

					// If the case has been escalated, set the value of the hidden SFDC user field to the user selected in the picklist
    				if (myCase.Status == 'Escalated to Tier2') 
    					{
	    					myCase.Assigned_L2_A__c = users.get(myCase.Assigned_L2__c);
						}
    			}
     		else
		    	{
    				myCase.Assigned_L2_A__c = null;
    			}
			}
    	else // If the Assigned L2 picklist is null, clear the hidden SFDC user field.
    		{
          		myCase.Assigned_L2_A__c = null;
    		}
		} // End case loop
}