/*
********************************************************************
//
//  Trigger for Contact After Insert  
//  2014                Original
//                      Roll up Preferred Email of Preferred Contact to Account
//
//  18 June 2015        VB
//                      Add SierraRise 
//
//  August 2015         Mark Maslow
//                      Add call to FlagAddUpAccounts
**********************************************************************
*/

trigger ContactAfterInsert on Contact (after insert) {

    // Call the new Trigger handler 
    ContactAfterInsertHandler conTrHandle = new ContactAfterInsertHandler();
    conTrHandle.OnAfterInsert(Trigger.new);

    // VB: Not bothering to clean up the below code. 
    
    // Look up the Household Record Type
    static Id householdRTId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    Set<Id> accountIds = new Set<Id>();
    for (Contact newContact : Trigger.new) {
        if(newContact.RecordTypeId == householdRTId && newContact.rC_Bios__Preferred_Contact__c) {
            accountIds.add(newContact.AccountId);
        }
    }
    Map<Id, Account> accountsToUpdate = new Map<Id, Account>([SELECT Id, Email__c FROM Account WHERE Id in :accountIds]);
    for (Contact newContact : Trigger.new) {
        if(newContact.RecordTypeId == householdRTId && newContact.rC_Bios__Preferred_Contact__c) {
            String newEmail;
            if(newContact.rC_Bios__Preferred_Email__c == 'Work') {
                newEmail = newContact.rC_Bios__Work_Email__c;
            }
            else if(newContact.rC_Bios__Preferred_Email__c == 'Other') {
                newEmail = newContact.rC_Bios__Other_Email__c;
            }
            else {
                newEmail = newContact.rC_Bios__Home_Email__c;
            }
            accountsToUpdate.get(newContact.AccountId).Email__c = newEmail;
        }
    }
    if(accountsToUpdate.size() > 0) {
        update accountsToUpdate.values();
    }
    
    FlagAddUpAccounts.flagAccounts(Trigger.new, null);
    
}