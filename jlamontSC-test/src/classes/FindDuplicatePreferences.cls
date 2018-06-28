global class FindDuplicatePreferences implements Database.Batchable<sObject>, Schedulable {
    global Database.QueryLocator start(Database.BatchableContext BC) {
    	return Database.getQueryLocator([select Id from Contact]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        Set<Id> contactIdsToProcess = new Set<Id>();
        for(sObject obj : scope) {
            Contact ctct = (Contact) obj;
            contactIdsToProcess.add(ctct.Id);
        }
    	List<rC_Bios__Preference__c> preferenceList = [
    		select
    			Id,
    			rC_Bios__Account__c,
    			rC_Bios__Contact__c,
    			rC_Bios__Category__c,
    			rC_Bios__Subcategory__c,
    			CreatedDate,
    			LastModifiedDate
    		from rC_Bios__Preference__c
    		where
    			rC_Bios__Active__c = true 
    			and rC_Bios__Contact__c in :contactIdsToProcess
    		order by 
    			rC_Bios__Account__c,
    			rC_Bios__Contact__c,
    			rC_Bios__Category__c,
    			rC_Bios__Subcategory__c
    	];
    	if(preferenceList.isEmpty()) {
    		return;
    	}
    	List<rC_Bios__Preference__c> preferencesToDelete = new List<rC_Bios__Preference__c>();
    	rC_Bios__Preference__c lastPreference = preferenceList.get(0);
    	for(rC_Bios__Preference__c pref : preferenceList) {
    		if(pref.Id != lastPreference.Id) {
	    		if(pref.rC_Bios__Account__c == lastPreference.rC_Bios__Account__c) {
		    		if(pref.rC_Bios__Contact__c == lastPreference.rC_Bios__Contact__c) {
		    			if(pref.rC_Bios__Category__c == lastPreference.rC_Bios__Category__c) {
		    				if(pref.rC_Bios__Subcategory__c == lastPreference.rC_Bios__Subcategory__c) {
		    					rC_Bios__Preference__c prefToRetain, prefToDelete;
	    						if(pref.CreatedDate < lastPreference.CreatedDate) {
	    							prefToDelete = lastPreference;
	    							prefToRetain = pref;
	    						}
	    						else {
	    							prefToDelete = pref;
	    							prefToRetain = lastPreference;
	    						}
	    						preferencesToDelete.add(prefToDelete);
	    						lastPreference = prefToRetain;
		    				}
		    				else {
		    					lastPreference = pref;
		    				}
		    			}
		    			else {
		    				lastPreference = pref;
		    			}
		    		}
		    		else {
		    			lastPreference = pref;
		    		}
	    		}
	    		else {
	    			lastPreference = pref;
	    		}
    		}
    	}
    	if( ! preferencesToDelete.isEmpty() ) {
    		delete preferencesToDelete;
    	}
    }
    
    global void finish(Database.BatchableContext BC) {
    	
    }
	public void execute(SchedulableContext sc) {
		Database.executeBatch(this, 2000);
	}
}