trigger TravellerServices_OnAfterUpsert on TravellerServices__c (after insert, after update) {
    
    Set<Id> TravellerIds = new Set<Id>();
    Set<Id> ServiceIds = new Set<Id>();
    Boolean boolServiceStatus = false;
    
    for(TravellerServices__c ts : trigger.new){
        TravellerIds.add(ts.Account__c);
        ServiceIds.add(ts.Service__c);
    }
    
    TravellerUtility.updateTravellers_OnAfterServiceUpdate(TravellerIds, ServiceIds);
    TravellerUtility.updateClientType(travellerIds, ServiceIds);
 }