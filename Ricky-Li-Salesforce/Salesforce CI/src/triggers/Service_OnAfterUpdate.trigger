trigger Service_OnAfterUpdate on Service__c (after update) {
    
    System.Debug('Service_OnAfterUpsert is getting called');
    
    Set<Id> serviceIds = new Set<Id>();
    Set<Id> travellerIds = new Set<Id>();
    
    for(Service__c s : trigger.new){
        serviceIds.add(s.Id);   
    }
    
    //Get Travellers linked to these Service(s) 
   List<Service__c> listServices = [select Id 
                                        , (select Id, Account__c from TS__r)
                                        from Service__c 
                                        where Id in : serviceIds];
    System.Debug('list services' + listServices.size());
    
        for(Service__c s : listServices){
            for(TravellerServices__c ts : s.TS__r){
                travellerIds.add(ts.Account__c);
            }
        }   
    System.Debug('traveller Ids' + travellerIds.size());
    System.Debug('traveller Ids' + travellerIds);
    
    TravellerUtility.updateTravellers_OnAfterServiceUpdate(TravellerIds, ServiceIds);
    TravellerUtility.updateClientType(travellerIds, ServiceIds);
 
    
}