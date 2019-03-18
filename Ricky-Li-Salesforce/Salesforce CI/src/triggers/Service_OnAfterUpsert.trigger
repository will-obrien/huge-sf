trigger Service_OnAfterUpsert on Service__c (after insert, after update) {
    
    Set<Id> serviceIds = new Set<Id>();
    Set<Id> travellerIds = new Set<Id>();
    
    Set<Id> serviceUpdateIds = new Set<Id>();
    Set<Id> travellerUpdateIds = new Set<Id>();
    
    for(Service__c s : trigger.new){
    	//Do not update AHS if it's update from compass2 API (load historical data)
    	if(UserInfo.getUserName()!='cmpsupport2@gadventures.com'){
	        if(Trigger.isUpdate)
	            serviceUpdateIds.add(s.Id);
	        serviceIds.add(s.Id);
    	}   
    }
    
    //Get Travellers linked to these Service(s) 
    List<Service__c> listServices = [select Id 
                                        , (select Id, Account__c from TS__r)
                                        from Service__c 
                                        where Id in : serviceIds];
    
    List<Service__c> listUpdateServices = [select Id 
                                        , (select Id, Account__c from TS__r)
                                        from Service__c 
                                        where Id in : serviceUpdateIds];
    
    for(Service__c s : listServices){
        for(TravellerServices__c ts : s.TS__r){
                travellerIds.add(ts.Account__c);
        }
    }
    for(Service__c us : listUpdateServices){
        for(TravellerServices__c ts : us.TS__r){
                travellerUpdateIds.add(ts.Account__c);
        }
    }   
    
    if(listUpdateServices.size() > 0)
    	TravellerUtility.updateTravellers_OnAfterServiceUpdate(travellerUpdateIds, serviceUpdateIds); //call the method only on Service Update
    if(listServices.size() > 0)
    	TravellerUtility.updateClientType(travellerIds, ServiceIds);

}