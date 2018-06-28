// ChangeLog		: MM: 4/9/2015 - Get CastIron UserId from Custom Setting, to reduce SOQL queries
//                        8/2015     Check integration status and workflow status to set flags correctly or bypass processing
//                        8/2015     Check integration status and workflow status to set flags correctly or bypass processing
// 			        : VB: 5/6/2016 - Removed references to CI tables (CI_Account_Change__c)
//                  : MM: 5/19/2106 - Set DistrictChanged flag if selected districts have changed 
trigger CIAccountChanges on Account (before update) {
	if(OutboundMessageHelper.accountInWorkflow) {
    	return;
	}
    for (Account newAccount : Trigger.new) {
		if(newAccount.CastIron_Integration_Status__c == 'Sent') {
			OutboundMessageHelper.accountInWorkflow = true;
			newAccount.CastIron_Integration_Status__c = 'Success';
		}    	
    }
    if(OutboundMessageHelper.accountInWorkflow) {
    	return;
    }
    //System.debug('CIAccount Start');
        
    // Look up the Account Record Types    
    static Id householdRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    static Id organizationRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();

    // Grab Cast Iron's Id
    private static final Id castironUserId = 
        //[SELECT Id FROM User WHERE alias = 'ciron'].Id;
		UserLookup.getId('ciron');
    
    Map<Id, Account> accountMap = new Map<Id, Account>();

    // Step through each of the Acccounts that's been modified
    for (Account newAccount : Trigger.new) {
        // Grab the corresponding Account from the old Values map
        Account oldAccount = Trigger.oldMap.get(newAccount.Id);
		//Set DistrictChanged flag if selected districts have changed
		if(newAccount.RecordTypeId == householdRTId || newAccount.RecordTypeId == organizationRTId) {
			if(
				newAccount.kwzd__KW_CountyCode__c != oldAccount.kwzd__KW_CountyCode__c ||
				newAccount.kwzd__KW_StateHouseDistrict__c != oldAccount.kwzd__KW_StateHouseDistrict__c ||
				newAccount.kwzd__KW_StateSenateDistrict__c != oldAccount.kwzd__KW_StateSenateDistrict__c ||
				newAccount.kwzd__KW_USHouseDistrict__c != oldAccount.kwzd__KW_USHouseDistrict__c
			) {
				newAccount.DistrictChanged__c = true;
			}
		}
        // BUG: Don't check the last modified by, it will be what is on the record
        //System.debug('LMB Id :' + newAccount.LastModifiedById + ':  CI Id:' + castironUserId + ':');
        //if (newAccount.LastModifiedById != castironUserId) {
        //
        // If the Account was NOT modified by Cast Iron
        if (System.UserInfo.getUserId() != castironUserId) {
            //System.debug('CIAccount:');
            //System.debug('Old Name :' + oldAccount.Name + ':  New Name:' + newAccount.Name + ':');
            //System.debug('Old Sal  :' + oldAccount.Club_System_Salutation__c + ':  New Name:' + newAccount.Club_System_Salutation__c + ':');
            //System.debug('Old Email:' + oldAccount.Email__c + ':  New Name:' + newAccount.Email__c + ':');
            //System.debug('Old Warn :' + oldAccount.rC_Bios__Warning_Comments__c + ':  New Name:' + newAccount.rC_Bios__Warning_Comments__c + ':');
    
            // If the Name, Club Salutation, Email or Warning Comment has changed.
            if (
                newAccount.CastIron_Resubmit__c ||  // Has the Account been marked for resubmission?
                oldAccount.Name != newAccount.Name ||
                oldAccount.Club_System_Salutation__c != newAccount.Club_System_Salutation__c ||
                oldAccount.Email__c != newAccount.Email__c ||
                oldAccount.Phone != newAccount.Phone ||
                oldAccount.Original_Campaign__c != newAccount.Original_Campaign__c ||
                oldAccount.Club_System_Search_Key__c != newAccount.Club_System_Search_Key__c ||
                oldAccount.rC_Bios__Warning_Comments__c != newAccount.rC_Bios__Warning_Comments__c 
               ) {
                
                // Set some values to support the Cast Iron integration
                //      The integration status 'in transit' drives the 
                //      start of the cast 
                newAccount.CastIron_Integration_Status__c = 'In Transit';
                newAccount.Transmit_Date__c               = datetime.now();
                newAccount.CastIron_Resubmit__c           = FALSE;
                    
            // Else, if the Account is an Organizational Account
            //      Check to see if the Type, Club Search Key, Website, Phone, or Fax has changed.
            } else if (
                (oldAccount.RecordTypeId == organizationRTId) &&
                (oldAccount.Type != newAccount.Type ||
                 oldAccount.Website != newAccount.Website ||
                 oldAccount.Fax != newAccount.Fax)) {
                     
                // Set some values to support the Cast Iron integration
                //      The integration status 'in transit' drives the 
                //      start of the cast 
                newAccount.CastIron_Integration_Status__c = 'In Transit';
                newAccount.Transmit_Date__c               = datetime.now();
                newAccount.CastIron_Resubmit__c           = FALSE;
                 
             }
        }
    }    
}