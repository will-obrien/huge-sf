trigger TravellerServices_OnAfterDelete on TravellerServices__c (after delete) {
    Set<Id> TravellerIds = new Set<Id>();
    Set<Id> ServiceIds = new Set<Id>();
    
    for(TravellerServices__c ts : trigger.old)
    {
        TravellerIds.add(ts.Account__c);
        ServiceIds.add(ts.Service__c);
    }
    
    List <TravellerServices__c> listServices = [Select Service__c from TravellerServices__c where Account__c in : TravellerIds];
    
    if (listServices.size() == 0){
        TravellerUtility.updateTravellers_OnAfterTSDelete(TravellerIds);
        TravellerUtility.updateClientType(TravellerIds, ServiceIds);
    }
    else{
        TravellerUtility.updateTravellers_OnAfterServiceUpdate(TravellerIds, ServiceIds);
        TravellerUtility.updateClientType(TravellerIds, ServiceIds);   
    }
}