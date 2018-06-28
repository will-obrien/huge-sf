/*********************************************************************************************************
Name			: PreferenceTrigger
Created by		: Dipika Gupta (Appirio)
Created Date	: Feb 7, 2014
Description		: T-242113
Modifications	: 2015/May Maslow: add calls to PreferenceSubscriptionHandler
				: 2015/08/21 VB: Added exception to skip processing for SierraRise Profile
                : 2016/08/08 MM: Add calls to PreferencesToAddUp.
				: 2016/12    Maslow: Added calls to CheckStaffPreference
***********************************************************************************************************/
trigger PreferenceTrigger on rC_Bios__Preference__c (After insert,After update,after delete,after undelete) {
	
	private static Id profileId=userinfo.getProfileId();
	private static String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    
    // Execute only if the Account was NOT modified by SierraRise profile user
    if(profileName == 'SierraRise') {
        return;
    }
	
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUndelete){
            PreferenceTriggerHandler.AfterInsert(trigger.new);
        }
        if(Trigger.isUpdate){
             PreferenceTriggerHandler.AfterUpdate(trigger.new,trigger.oldMap);
             CheckStaffPreference.afterUpdate(trigger.new,trigger.oldMap);
        }
        if(Trigger.isDelete){
             PreferenceTriggerHandler.AfterInsert(trigger.old);
        }
        if(Trigger.isInsert) {
            PreferenceSubscriptionHandler.synchronizeSubscriptions(true, Trigger.new, null);            
            if(profileName != 'BSD User') {
                if(PreferencesToAddUp.sendToAddUp) {           
                    PreferencesToAddUp.sendPreferences(true, Trigger.new, null);
                }
            }
            CheckStaffPreference.afterInsert(trigger.new);
        }
        else if(Trigger.isUpdate) {
            PreferenceSubscriptionHandler.synchronizeSubscriptions(false, Trigger.new, Trigger.oldMap);         
            if(profileName != 'BSD User') {
                if(PreferencesToAddUp.sendToAddUp) {           
                    PreferencesToAddUp.sendPreferences(false, Trigger.new, Trigger.oldMap);
                }
            }
        }
    }
}