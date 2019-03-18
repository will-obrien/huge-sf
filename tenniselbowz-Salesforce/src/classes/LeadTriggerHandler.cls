public class LeadTriggerHandler {
	
    public static void onAfterUpdate(map<Id, Lead> newMap, map<Id, Lead> oldMap){
   		LeadTriggerHandler.updateOppAfterLeadConversion(newMap.values());
    }
    
    public static void updateOppAfterLeadConversion(List<Lead> leadOpp){
        List<Opportunity> oppUpdate = new List<Opportunity>();
        for(Lead le: leadOpp){
            if(le.isConverted)
            	if(le.ConvertedOpportunityId != NULL){
                	oppUpdate.add(new Opportunity(id =le.ConvertedOpportunityId, Vertical_Market__c = le.Industry));
            	}
        }
        if(oppUpdate.size()>0){
        	update oppUpdate;
      	}
    }
}