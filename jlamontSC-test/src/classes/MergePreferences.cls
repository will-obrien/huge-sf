/*
MergePreferences

Created by:	Mark Maslow
Created on: October, 2014

Merge Preferences

Preferences are moved from Previous Account to Retained Account 
if this would not create a "duplicate" Preference.

If moving the Preference would create a duplicate, Preference is deleted.
Otherwise, it is moved.

Program looks at Category and Subcategory to determine if moving a Preferences
would create a "duplicate" record.
*/
public with sharing class MergePreferences {
    public static void processPreferences(List<Merge_Request__c> mergeRequestList) {
        //Create:
        // 1. Set of Previous AccountIds 
        // 2. Set of Retained AccountIds 
        // 3. Map to correlate Previous AccountId with Merge Request
        // 4. Map to correlate Merge Request Id with Merge Request
        Set<Id> previousAccounts = new Set<Id>();
        Set<Id> retainedAccounts = new Set<Id>();
        Map<Id, Merge_Request__c> prevIdToMergeRequestMap = new Map<Id, Merge_Request__c>();
        Map<Id, Merge_Request__c> mergeIdToRequestMap = new Map<Id, Merge_Request__c>();
        for(Merge_Request__c request : mergeRequestList) {
            mergeIdToRequestMap.put(request.Id, request);
            if(request.Previous_Account__c != null && request.Retained_Account__c != null) {
                if(request.Previous_Account__c != request.Retained_Account__c) {
                    previousAccounts.add(request.Previous_Account__c);
                    retainedAccounts.add(request.Retained_Account__c);
                    prevIdToMergeRequestMap.put(request.Previous_Account__c, request);
                }
            }
        }
        //Find any preferences for Previous Accounts
        List<rC_Bios__Preference__c> previousPreferences = new List<rC_Bios__Preference__c>([
            SELECT 
                Id,
                rC_Bios__Account__c,
                rC_Bios__Category__c,
                rC_Bios__Subcategory__c
            FROM rC_Bios__Preference__c
            WHERE rC_Bios__Account__c IN :previousAccounts
            ORDER BY rC_Bios__Account__c
        ]);
        if(previousPreferences.size() > 0) {
            //There are Preferences for Previous Accounts - 
            //If Retained Account does not already have Preference, 
            //it should be moved from Previous Account to Retained Account 
            List<rC_Bios__Preference__c> retainedPreferences = new List<rC_Bios__Preference__c>([
                SELECT 
                    Id,
                    rC_Bios__Account__c,
                    rC_Bios__Category__c,
                    rC_Bios__Subcategory__c
                FROM rC_Bios__Preference__c
                WHERE rC_Bios__Account__c IN :retainedAccounts
                ORDER BY rC_Bios__Account__c
            ]);
            //Create map to associate Retained AccountId with set of all Preference Code Values
            Map<Id, Set<String>> retainedPreferenceMap = new Map<Id, Set<String>>();
            
            if(retainedPreferences.size() > 0) {
	            Id lastAccount = retainedPreferences[0].rC_Bios__Account__c;
	            Set<String> codeSet = new Set<String>();
	            for(rC_Bios__Preference__c preference : retainedPreferences) {
	                if(preference.rC_Bios__Account__c != lastAccount) {
	                    retainedPreferenceMap.put(lastAccount, codeSet);
	                    lastAccount = preference.rC_Bios__Account__c;
	                    codeSet = new Set<String>();
	                }
	                codeSet.add(preference.rC_Bios__Category__c + preference.rC_Bios__Subcategory__c);
	            }
	            retainedPreferenceMap.put(lastAccount, codeSet);
            }
            
            //Move Preference from Previous Account to Retained Account 
            //if Retained Account does not already have a Preference with the same Category/Subcategory 
            List<rC_Bios__Preference__c> preferencesToUpdate = new List<rC_Bios__Preference__c>();
            List<rC_Bios__Preference__c> preferencesToDelete = new List<rC_Bios__Preference__c>();
            Map<Id, Merge_Request__c> preferenceToMergeRequestMap = new Map<Id, Merge_Request__c>();
            for(rC_Bios__Preference__c prevPreference : previousPreferences) {
                Merge_Request__c mergeRequest = prevIdToMergeRequestMap.get(prevPreference.rC_Bios__Account__c);
                Set<String> retainedPreferenceCodes = retainedPreferenceMap.get(mergeRequest.Retained_Account__c);
                String dupCheck = prevPreference.rC_Bios__Category__c + prevPreference.rC_Bios__Subcategory__c;
                if(retainedPreferenceCodes == null || ((retainedPreferenceCodes != null) && ( ! retainedPreferenceCodes.contains(dupCheck)))) {
                    //Retained Account does not have a Preference with the same Category/Subcategory -
                    // move Preference from Previous Account to Retained Account
                    prevPreference.rC_Bios__Account__c = mergeRequest.Retained_Account__c;
                    preferencesToUpdate.add(prevPreference);
                    preferenceToMergeRequestMap.put(prevPreference.Id, mergeRequest);
                }
                else {
                    //Retained Account already has a Preference with same Code Value
                    //Delete Preference for Previous Account
                    preferencesToDelete.add(prevPreference);
                }
            }
            if(preferencesToUpdate.size() > 0) {
                //One or more Preferences have been moved - save the changed Preferences
                Database.SaveResult[] srList = Database.update(preferencesToUpdate, false);
                for(Integer i=0; i < srList.size(); i++) {
                    if( ! srList[i].isSuccess() ) {
                        String errorMessage = formatSaveError(srList[i]);
                        //Find mergeRequestPref by Preference Id
                        Merge_Request__c mergeRequestPref = preferenceToMergeRequestMap.get(preferencesToUpdate[i].Id);

                        //Find mergeRequest by Merge Request Id - 
                        Merge_Request__c mergeRequest = mergeIdToRequestMap.get(mergeRequestPref.Id);
                        
                        //Add error message to Merge Request that will be updated
                        mergeRequest.Error_Message__c = MergeProcessor.AppendMergeError(mergeRequest.Error_Message__c, errorMessage);
                    }
                }
            }
            if(preferencesToDelete.size() > 0) {
                Database.DeleteResult[] delList = Database.delete(preferencesToDelete, false);
                for(Integer i=0; i < delList.size(); i++) {
                    if( ! delList[i].isSuccess() ) {
                        String errorMessage = formatDeleteError(delList[i]);
                        //Find mergeRequestPref by Preference Id
                        Merge_Request__c mergeRequestPref = preferenceToMergeRequestMap.get(preferencesToDelete[i].Id);

                        //Find mergeRequest by Merge Request Id - 
                        Merge_Request__c mergeRequest = mergeIdToRequestMap.get(mergeRequestPref.Id);
                        
                        //Add error message to Merge Request that will be updated
                        mergeRequest.Error_Message__c = MergeProcessor.AppendMergeError(mergeRequest.Error_Message__c, errorMessage);
                    }
                }
            }
        }
        
        //Update all Merge Requests
        List<Merge_Request__c> mergesToUpdate = new List<Merge_Request__c>();
        for(Merge_Request__c request : mergeIdToRequestMap.values()) {
            request.Last_Step_Completed__c = MergeProcessor.mergePreferencesStep;
            request.Date_Last_Step_Completed__c = System.now();
            mergesToUpdate.add(request);
        }
        update mergesToUpdate;
    }
    private static String formatSaveError(Database.SaveResult sr) {
        String errMsg = '';
        for(Database.Error error : sr.getErrors()) {
            for(String field : error.getFields()) {
                errMsg += 'Field:' + field + ' '; 
            }
            errMsg += 'Message:' + error.getMessage();
        }
        return errMsg;                  
    }
    private static String formatDeleteError(Database.DeleteResult sr) {
        String errMsg = '';
        for(Database.Error error : sr.getErrors()) {
            for(String field : error.getFields()) {
                errMsg += 'Field:' + field + ' '; 
            }
            errMsg += 'Message:' + error.getMessage();
        }
        return errMsg;                  
    }
}