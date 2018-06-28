/*
AccountAddressDupCheck trigger

Created by: Mark Maslow
Created on: June, 2015

Called by AccountAddressTrigger

For updates: Prevent changing Address Type
For inserts: Prevent creation of more than one address for the same Account/AddressType

11/6/2015 Maslow - Bug Fix
*/
public with sharing class AccountAddressDupCheck {
    // Grab Cast Iron's Id
    private static final Id castironUserId = 
        //[SELECT Id FROM User WHERE alias = 'ciron'].Id;
 		UserLookup.getId('ciron');

	public void checkForDups(List<rC_Bios__Account_Address__c> addrList, Map<Id, rC_Bios__Account_Address__c> oldMap) {
	   //If user is Cast Iron, no need to check for duplicate address types
	    if (System.UserInfo.getUserId() == castironUserId) {
	        return;
	    }
	    
	    if(oldMap != null) {
	    	for(rC_Bios__Account_Address__c newAddr : addrList) {
	    		rC_Bios__Account_Address__c oldAddr = oldMap.get(newAddr.Id);
	    		if(oldAddr != null) {
		    		if(newAddr.rC_Bios__Type__c != oldAddr.rC_Bios__Type__c) {
		    			newAddr.addError('Address Type may not be Changed');
		    		}
	    		}
	    	}
	    	return;
	    }    
	    //Retrieve all Acccount Addresses for Accounts getting a new address
	    //Order list by Account
	    Set<Id> accountSet = new Set<Id>();
	    for(rC_Bios__Account_Address__c accountAddr : addrList) {
	        accountSet.add(accountAddr.rC_Bios__Account__c);
	    }
	    List<rC_Bios__Account_Address__c> allAddrs = new List<rC_Bios__Account_Address__c>([
	        SELECT Id, rC_Bios__Account__c, rC_Bios__Type__c
	        FROM rC_Bios__Account_Address__c
	        WHERE rC_Bios__Account__c IN :accountSet
	        ORDER BY rC_Bios__Account__c
	    ]);
	    
	    //Map AccountId to set of Address Types
	    Map<Id, Set<String>> addrTypeMap = new Map<Id, Set<String>>();
	            
	    Id lastId;
	    if(allAddrs.size() > 0) {
	        //Populate addrTypeMap
	        lastId = allAddrs[0].rC_Bios__Account__c;
	        Set<String> addrTypes = new Set<String>();
	        for(Integer i=0; i < allAddrs.size(); i++) {
	            if(allAddrs[i].rC_Bios__Account__c != lastId) {
	                addrTypeMap.put(lastId, addrTypes);
	                lastId = allAddrs[i].rC_Bios__Account__c;
	                addrTypes = new Set<String>();
	            }
	            addrTypes.add(allAddrs[i].rC_Bios__Type__c);
	        }
	        addrTypeMap.put(lastId, addrTypes);
	        
	        //Check for duplicates
	        for(rC_Bios__Account_Address__c accountAddr : addrList) {
	            Set<String> existingTypes = addrTypeMap.get(accountAddr.rC_Bios__Account__c);
	            if(existingTypes != null) {
	                if(existingTypes.contains(accountAddr.rC_Bios__Type__c)) {
                    	accountAddr.addError('Address Type already exists for Account');
	                }
	            }
	        }
	    }
	}
}