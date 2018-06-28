// ChangeLog        : MM: 4/10/2015 - Get CastIron UserId from Custom Setting, to reduce SOQL queries
//                    MM: 5/12/2015 - Check for changes to districts. Move call to ManageAccounts.afterUpdate so that it executes regardless of user.
//                                    Change check for user from user id to profile id.
//					  MM: 8/2015 -    Bypass processing if triggered by workflow
//					  VB: 11/4/2015 - Moved return on accountInWorkflow to below Peter's ManageAccounts.afterUpdate call
//										to ensure Account Address is copied to Contacts                 
trigger CIAccountChangesAfterUpdate on Account (after update) {
    // Grab Cast Iron's Id
    //private static final Id castironUserId = 
        //[SELECT Id FROM User WHERE alias = 'ciron'].Id;
        //UserLookup.getId('ciron');
    private static Id profileId=userinfo.getProfileId();
	private static String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    
    // Look up the Account Record Types    
    static Id householdRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    static Id organizationRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();

    //PNC April 2015 Add call to Contact Update
    ManageAccounts.afterUpdate(Trigger.New, Trigger.OldMap);

	// VB: 11/4/15 - Moved this down from the first line to below the above line.
	//			This was resulting in a return before the Account Address could
	//			be copied to the Contact
    if(OutboundMessageHelper.accountInWorkflow) {
    	return;
    }
    
    // Execute only if the Account was NOT modified by Cast Iron
    //if (System.UserInfo.getUserId() == castironUserId) {
    if(profileName == 'CastIron') {
        return;
    }
    
    Set<Id> accountIds = new Set<Id>();
    for (Account newAccount : Trigger.new) {
        // Grab the corresponding Account from the old Values map
        Account oldAccount = Trigger.oldMap.get(newAccount.Id);
        if (newAccount.RecordTypeId == householdRTId &&
            newAccount.CastIron_Integration_Status__c != 'In Transit' &&
            (oldAccount.Email__c != newAccount.Email__c || 
             oldAccount.Phone != newAccount.Phone ||
             oldAccount.rC_Bios__Preferred_Contact__c != newAccount.rC_Bios__Preferred_Contact__c) //||
    		 //oldAccount.kwzd__KW_CountyCode__c != newAccount.kwzd__KW_CountyCode__c ||
         	 //oldAccount.kwzd__KW_StateHouseDistrict__c != newAccount.kwzd__KW_StateHouseDistrict__c ||
         	 //oldAccount.kwzd__KW_StateSenateDistrict__c != newAccount.kwzd__KW_StateSenateDistrict__c ||
         	 //oldAccount.kwzd__KW_USHouseDistrict__c != newAccount.kwzd__KW_USHouseDistrict__c 
            ) 
        {
            accountIds.add(newAccount.Id);
        }
    }
    Map<Id, Account> accountsToUpdate = new Map<Id, Account>(
        [SELECT Id, CastIron_Integration_Status__c, Transmit_Date__c, CastIron_Resubmit__c FROM Account WHERE Id IN :accountIds]
    );
    for(Id accountId : accountIds) {
        Account account = accountsToUpdate.get(accountId);
        if(account != null) {
            account.CastIron_Integration_Status__c = 'In Transit';
            account.Transmit_Date__c               = datetime.now();
            account.CastIron_Resubmit__c           = FALSE;
        }
    }
    if(accountsToUpdate.size() > 0) {
        update accountsToUpdate.values();
    }
    
}