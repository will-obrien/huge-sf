//******************************************************************************************
//
//  MS_Notify_ClientRelations
//
//  Send an email notice to the Client Relations email account any time
//  a contact is added to SFDC or their associated Account value changes
//  (change of employment).
//
//  This trigger was developer for Microsystems by InSitu Software LLC.
//   
//  History:
//  InSitu    12/24/2009    Original version
// ******************************************************************************************
trigger MS_Notify_ClientRelations on Contact (after insert, after update) 
{
	// ---------------------------------------------------------------------------
	// Get the custom settings 
	// ---------------------------------------------------------------------------
	CRCN_Settings__c settingsCN = CRCN_Settings__c.getInstance(UserInfo.getUserId());
	
	// Check if the notification mechanism is active
	if (settingsCN == null || !settingsCN.Active__c)
	{
		// Notification is turned off so just exit
		return;
	}
	
	// ---------------------------------------------------------------------------
	// Build a unique collection of accounts that are referenced by the impacted
	// contacts
	// ---------------------------------------------------------------------------
	
	// Use a Set because we only need a distinct collection of IDs
	Set<ID> setReferencedAccountIds = new Set<Id>(); 
	Integer idx; 
	for (idx = 0; idx < Trigger.new.size(); idx++)
	{
		// NEW CONTACT
		if (Trigger.isInsert == true && 
		    Trigger.new[idx].AccountId != null)
		{	
			setReferencedAccountIds.add(Trigger.new[idx].AccountId);
		}
		// EDIT
		else if (Trigger.isUpdate == true && 
		         Trigger.new[idx].AccountId != Trigger.old[idx].AccountId)
		{	
			if (Trigger.new[idx].AccountId != null)
			{
				setReferencedAccountIds.add(Trigger.new[idx].AccountId);	
			}
			if (Trigger.old[idx].AccountId != null)
			{
				setReferencedAccountIds.add(Trigger.old[idx].AccountId);	
			}
		}
	} 
	// If the set is empty, then no possible notifications so just exit
	if (setReferencedAccountIds.isEmpty()) return;
	
	// Fill a map of referenced accounts 
	// NOTE: If customer status is determined using an attribute other than 
	//       Customer__c then the column list in the query below needs to be
	//       modified to get the appropriate attribute.
	Map<ID, Account> mapAcctIdToAcct = new Map<ID, Account>();
	for (Account acct : [SELECT Id, Name, Customer__c 
	                     FROM Account 
	                     WHERE Id in :setReferencedAccountIds])
	{	
		mapAcctIdToAcct.put(acct.Id, acct);
	}
	
	// ---------------------------------------------------------------------------
	// Build a collection of contacts that require notification
	// ---------------------------------------------------------------------------	
	List<Contact> listNotifyContactNew = new List<Contact>();
	List<Contact> listNotifyContactOld = new List<Contact>();
	for (idx = 0; idx < Trigger.new.size(); idx++)
	{
		// NEW CONTACT
		if (Trigger.isInsert == true && 
		    Trigger.new[idx].AccountId != null)
		{	
			// Only notify if Contact's Account is a customer
			// NOTE: This logic will change if customer status is not based on value in Customer__c
			if (settingsCN.Customers_Only__c)
			{
				if (mapAcctIdToAcct.get(Trigger.new[idx].AccountId).Customer__c == 'Yes')
				{
					listNotifyContactNew.add(Trigger.new[idx]);	
				}	
			}
			// Always Notify
			else
			{
				listNotifyContactNew.add(Trigger.new[idx]);	
			}
	
		}
		// EDIT (Change of Employment)
		else if (Trigger.isUpdate == true && 
		         Trigger.new[idx].AccountId != Trigger.old[idx].AccountId)
		{
			 // Only notify if Contact's Old or New Account is a customer
			 // NOTE: This logic will change if customer status is not based on value in Customer__c
			if (settingsCN.Customers_Only__c)
			{
		         if ((Trigger.new[idx].AccountId != null && mapAcctIdToAcct.get(Trigger.new[idx].AccountId).Customer__c == 'Yes') ||
		             (Trigger.old[idx].AccountId != null && mapAcctIdToAcct.get(Trigger.old[idx].AccountId).Customer__c == 'Yes'))
		         {
		         	listNotifyContactOld.add(Trigger.old[idx]);
					listNotifyContactNew.add(Trigger.new[idx]);	
		         }
			}
			// Always Notify
			else
			{	
				listNotifyContactOld.add(Trigger.old[idx]);
				listNotifyContactNew.add(Trigger.new[idx]);
			}
		}
	} 
	// Check that at least one notification is required
	if (listNotifyContactNew.isEmpty())return;
	
	// ---------------------------------------------------------------------------
	// Send Notification Message
	// ---------------------------------------------------------------------------
	// Email message object
    Messaging.SingleEmailMessage msgNotification = new Messaging.SingleEmailMessage();
        
    // Set the recipient information
    String [] toAddresses = new String [] {settingsCN.Notification_Address__c};
    msgNotification.setToAddresses(toAddresses);
                        
    // Set other message attributes 
    msgNotification.setSaveAsActivity(false);
    msgNotification.setUseSignature(false);
    msgNotification.setBccSender(false);
    msgNotification.setSenderDisplayName(settingsCN.Sender_Display_Name__c); 
       
    // Subject
    String sSubject;
    String sHTMLBody;
    
    // Special processing for case where Contact's first name is null
    String sSingleContactFirstName;
    if (Trigger.new[0].FirstName != null)
    {
    	sSingleContactFirstName = Trigger.new[0].FirstName;		
    }
    else
    {
    	sSingleContactFirstName = '';	
    }
    
    // Subject when a new contact
    if (Trigger.isInsert == true)
    {
    	// If multiple contacts were added at the same time (e.g. import)
    	if (listNotifyContactNew.size() > 1)
    	{
    		sSubject = 'New Contact: (multiple contacts)';
    		sHTMLBody = 'The following contacts were added to Salesforce.com:<br/><br/>';	
    	}
    	// Just one contact was added	
    	else
    	{
    		sSubject = 'New Contact: ' + sSingleContactFirstName + ' ' + Trigger.new[0].LastName + ' of ' + 
    		            mapAcctIdToAcct.get(Trigger.new[0].AccountId).Name;	
    		sHTMLBody = 'The following contact was added to Salesforce.com:<br/><br/>';	
    	}
    }
    // Subject when an employment change
    else
    {
    	// If multiple contacts had their associated account changed
    	if (listNotifyContactNew.size() > 1)
    	{
    		sSubject = 'Employment Change: (multiple contacts)';
    		sHTMLBody = 'The following contacts had an employment change:<br/><br/>';	
    	}
    	// Just one contact had their associated account changed	
    	else
    	{
    		sSubject = 'Employment Change: ' + sSingleContactFirstName + ' ' + Trigger.new[0].LastName;
    		if (Trigger.old[0].AccountId != null)
    		{
    			sSubject = sSubject + ' formerly of ' + mapAcctIdToAcct.get(Trigger.old[0].AccountId).Name;	
    		}
    		if (Trigger.new[0].AccountId != null)
    		{
    			sSubject = sSubject + ' now with ' + mapAcctIdToAcct.get(Trigger.new[0].AccountId).Name;	
    		}
    		
    		sHTMLBody = 'The following contact had an employment change:<br/><br/>';		
    	}
    }
    msgNotification.setSubject(sSubject);
    
    // HTML Body
    String sIndent = '&nbsp;&nbsp;&nbsp;';
    for (idx = 0; idx < listNotifyContactNew.size(); idx++)
	{
    	// Special handling of null first name
    	String sFirstName;
    	if (listNotifyContactNew[idx].FirstName != null)
    	{
    		sFirstName = listNotifyContactNew[idx].FirstName;
    	}
    	else
    	{
    		sFirstName = '';
    	}

    	// Contact Name (bold and hyperlink to contact in SFDC)
    	sHTMLBody = sHTMLBody + '<a href=https://na3.salesforce.com/' + listNotifyContactNew[idx].Id +
    	                        '><b><big>' + sFirstName + ' ' + listNotifyContactNew[idx].LastName + '</b></big></a><br/>';
    	
    	// Contact's Job Title
    	if (listNotifyContactNew[idx].Title != null)
    	{
    		sHTMLBody = sHTMLBody + sIndent + listNotifyContactNew[idx].Title + '<br/>';
    	}
    	else
    	{
    		sHTMLBody = sHTMLBody + sIndent + '(Job Title not specified)<br/>';	
    	}
    	
    	// Contact's current company (bold if a customer)
    	// NOTE: This logic will change if customer status is not based on value in Customer__c
    	if (listNotifyContactNew[idx].AccountId != null)
    	{
    		if(mapAcctIdToAcct.get(listNotifyContactNew[idx].AccountId).Customer__c == 'Yes')
    		{
    			sHTMLBody = sHTMLBody + sIndent + '<b>' + mapAcctIdToAcct.get(listNotifyContactNew[idx].AccountId).Name + '</b><br/>';	
    		}
    		else
    		{
    			sHTMLBody = sHTMLBody + sIndent + mapAcctIdToAcct.get(listNotifyContactNew[idx].AccountId).Name + '<br/>';	
    		}
    	}
    	else
    	{
    		sHTMLBody = sHTMLBody + sIndent + '(Account Name not specified)<br/>';	
    	}
    	
    	// Contact's Former Information - EDIT only
    	if (Trigger.isUpdate == true)
    	{
    		sHTMLBody = sHTMLBody + 'Formerly<br/>';
    			
    		// Contact's Former Job Title
	    	if (listNotifyContactOld[idx].Title != null)
	    	{
	    		sHTMLBody = sHTMLBody + sIndent + listNotifyContactOld[idx].Title + '<br/>';
	    	}
	    	else
	    	{
	    		sHTMLBody = sHTMLBody + sIndent + '(Job Title not specified)<br/>';	
	    	}
	    	
	    	// Contact's Former company (bold if a customer)
	    	// NOTE: This logic will change if customer status is not based on value in Customer__c
	    	if (listNotifyContactOld[idx].AccountId != null)
	    	{
	    		if(mapAcctIdToAcct.get(listNotifyContactOld[idx].AccountId).Customer__c == 'Yes')
	    		{
	    			sHTMLBody = sHTMLBody + sIndent + '<b>' + mapAcctIdToAcct.get(listNotifyContactOld[idx].AccountId).Name + '</b><br/>';	
	    		}
	    		else
	    		{
	    			sHTMLBody = sHTMLBody + sIndent + mapAcctIdToAcct.get(listNotifyContactOld[idx].AccountId).Name + '<br/>';	
	    		}
	    	}
	    	else
	    	{
	    		sHTMLBody = sHTMLBody + sIndent + '(Account Name not specified)<br/>';	
	    	}
	
    	}
    	
		// Blank line between contacts in case of a multiple contact changes
		sHTMLBody = sHTMLBody + '<br/>';
		                      	
	} // End loop
    msgNotification.setHtmlBody(sHTMLBody);
    
    // NOTE: Assumes that all recipients have an HTML based email reader as
    //       NO text body is constructed.
        
    // Send the message
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { msgNotification });   
		
}