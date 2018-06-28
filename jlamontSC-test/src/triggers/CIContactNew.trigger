/*
//*************************************************************************************************
//
// Name              : CIContactNew
// By                : Vernon Baas
// Description       : Simple trigger to set new Contact records 
//                         so they are picked up by Cast Iron
//                         We attempted this a few different ways, but Appirio/rC
//                         code seemed to prevent several solutions.
//
// ChangeLog		: MM: 4/10/2015 - Get CastIron UserId from Custom Setting, to reduce SOQL queries
//					  MM: 8/2015 - Bypass processing if triggered by workflow                 
*/
trigger CIContactNew on Contact (before insert) {
	if(OutboundMessageHelper.contactInWorkflow) {
    	return;
    }
        
    // Look up the Contact Record Types    
    static Id householdRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();

    // Grab Cast Iron's User Id
    private static final Id castironUserId = 
        //[SELECT Id FROM User WHERE alias = 'ciron'].Id;
		UserLookup.getId('ciron');


    // Step through each of the New Contacts and build a list of affected accounts
    List<Id> AccountsToLookup = new List<Id>();
    for (Contact newContact : Trigger.new) {
        
        // Save the Account's Id's, we'll have to look up the Record Type
        AccountsToLookup.add(newContact.AccountId);
    }

    // Now create a map of the affected Accounts and their Record Type Id's
    Map<Id, Id> AccountRTMap = new Map<Id, Id>();
    for (Account theAccount : [SELECT Id, RecordTypeId FROM Account WHERE Id IN :AccountsToLookup]) {
        
        // Save the Account ID and the Account's Record Type into the map.
        AccountRTMap.put(theAccount.Id, theAccount.RecordTypeId);
    }
    
    // Step through each of the Acccounts that's been modified
    for (Contact newContact : Trigger.new) {
        
        //if (System.UserInfo.getUserId() != castironUserId && newContact.RecordTypeId == householdRTId) {
        Id contactAccountRecordTypeId = AccountRtMap.get(newContact.AccountId);
        
        //System.debug('householdRTId:' + householdRTId + ':');
        //System.debug('newContact.Account.RecordType.Id:' + contactAccountRecordTypeId + ':');

        // If the Contact was NOT modified by Cast Iron
        //  
        if (System.UserInfo.getUserId() != castironUserId && contactAccountRecordTypeId == householdRTId) {
    
            // Set some values to support the Cast Iron integration
            //      The integration status 'in transit' drives the 
            //      start of the cast 
            newContact.CastIron_Integration_Status__c = 'In Transit';
            newContact.Transmit_Date__c               = datetime.now();
            newContact.CastIron_Resubmit__c           = FALSE;
        }        
    }    
    
}