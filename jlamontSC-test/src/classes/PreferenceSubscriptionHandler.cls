/*********************************************************************************************************
Name               : PreferenceSubscriptionHandler
Created by         : Mark Maslow
Created Date       : May, 2015
Description        : When No Email preference is activated or inactivated, set subscriber status
                     appropriately on Exact Target 

Modifications      : August 28, 2015 Maslow - Bypass preferences with no ContactId
***********************************************************************************************************/
public with sharing class PreferenceSubscriptionHandler {
    public static final String exactTargetUrl = 'http://pages.emails.sierraclub.org/set_subscriber_status';
    private static boolean updatesProcessed = false;
    public static void synchronizeSubscriptions (boolean isNew, List<rC_Bios__Preference__c> newList, Map<Id, rC_Bios__Preference__c> oldMap) {
        List<Id> subscribeList = new List<Id>();
        List<Id> unsubscribeList = new List<Id>();
        
        for(rC_Bios__Preference__c pref : newList) {
            if( ! String.isEmpty(pref.rC_Bios__Contact__c)) {
                if(pref.rC_Bios__Subcategory__c == 'No Email') {
                    if(pref.rC_Bios__Active__c) {
                        if(isNew) {
                            //New Active Preference
                            unsubscribeList.add(pref.rC_Bios__Contact__c);                      
                        }
                        else {
                            rC_Bios__Preference__c oldPref = oldMap.get(pref.Id);
                            if(oldPref != null) {
                                if( ! oldPref.rC_Bios__Active__c) {
                                    //Preference changed from Inactive to Active
                                    unsubscribeList.add(pref.rC_Bios__Contact__c);
                                }
                            }
                        }
                    }
                    else if( ! isNew) {
                        rC_Bios__Preference__c oldPref = oldMap.get(pref.Id);
                        if(oldPref != null) {
                            if( oldPref.rC_Bios__Active__c) {
                                //Preference changed from Active to Inactive
                                subscribeList.add(pref.rC_Bios__Contact__c);
                            }
                        }
                    } 
                }
            }
        }
        if((subscribeList.size() + unsubscribeList.size()) > 0) {
            updateSubscriptions(subscribeList, unsubscribeList);
        }
    }
    @future(callout=true)
    private static void updateSubscriptions(List<Id> subscribeList, List<Id> unsubscribeList) {
        for(Id contactId : unsubscribeList) {
            callService(contactId, 'unsub');
        }
        for(Id contactId : subscribeList) {
            callService(contactId, 'resub');
        }
    }
    private static void callService(String contactId, String action) {
        String encodedId = EncodingUtil.base64Encode(Blob.valueOf(contactId));
        String url = ExactTargetUrl + '?id=' + encodedId + '&action=' + action;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        Http h = new Http();
        if( ! Test.isRunningTest()) {
            HttpResponse res = h.send(req);
            if(res.getStatus() != 'OK') {
                System.debug('Error ' + res.getStatusCode() + ' returned from Exact Target web service');
            }
        }
    }
}