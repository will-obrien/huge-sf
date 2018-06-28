global class SetDistrictChangedFlag implements Database.Batchable<sObject> {
    static Id householdRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    static Id organizationRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([
            SELECT 
                Id
            FROM Account
            WHERE
            	DistrictChanged__c = false
            	AND (RecordTypeId = :householdRTId OR RecordTypeId = :organizationRTId)
        ]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
    	List<Account> acctList = new List<Account>();
        for(sObject obj : scope) {
            Account acct = (Account) obj;
           	acctList.add(new Account(Id=acct.Id, DistrictChanged__c = true));
        }
        database.update(acctList, false);
    }
    global void finish(Database.BatchableContext BC){
    }
}