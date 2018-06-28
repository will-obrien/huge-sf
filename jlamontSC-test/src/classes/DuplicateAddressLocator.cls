/*
DuplicateAddressLocator

Created by:	Mark Maslow
Created on: November, 2014

Find Accounts that have more than one Account Address of the same Type
Add Duplicate Addresses to DuplicateAddress__c
*/
global class DuplicateAddressLocator implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([
            SELECT 
                Id
            FROM Account
        ]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Set<Account> accountSet = new Set<Account>();
        for(sObject obj : scope) {
            Account acct = (Account) obj;
            accountSet.add(acct);
        }
        List<rC_Bios__Account_Address__c> addrList = new List<rC_Bios__Account_Address__c>([
            SELECT Id, rC_Bios__Account__c, rC_Bios__Type__c 
            FROM rC_Bios__Account_Address__c
            WHERE rC_Bios__Account__c in :accountSet
            ORDER BY rC_Bios__Account__c, rC_Bios__Type__c
        ]);
        if(addrList.size() > 0) {
        	List<DuplicateAddress__c> dupList = new List<DuplicateAddress__c>();
        	String lastAccount = addrList[0].rC_Bios__Account__c;
        	String lastType = '';
        	String lastId = '';
        	for(rC_Bios__Account_Address__c addr : addrList) {
        		if(addr.rC_Bios__Account__c == lastAccount) {
					if(addr.rC_Bios__Type__c == lastType) {
						dupList.add(
							new DuplicateAddress__c(
								Account__c = addr.rC_Bios__Account__c,
								Address__c = lastId
							)
						);
						dupList.add(
							new DuplicateAddress__c(
								Account__c = addr.rC_Bios__Account__c,
								Address__c = addr.Id
							)
						);
					}
				}
				lastAccount = addr.rC_Bios__Account__c;
				lastType = addr.rC_Bios__Type__c;
				lastId = addr.Id;        		
        	}
        	if(dupList.size() > 0) {
        		insert dupList;
        	} 
        }
    }

    global void finish(Database.BatchableContext BC){
    }   
}