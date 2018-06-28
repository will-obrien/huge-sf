public with sharing class OpenOpportunityUtils {

    public static void updateStageName(Opportunity[] opportunities) {
    
        for (Opportunity opportunity :opportunities) {
        	
        	opportunity.Stage_Name_Updated_Date__c = Date.today();
        }    
    }

    public static void updateStageName(Opportunity[] opportunities, Map<Id, Opportunity> oldOpportunities) {
    
        for (Opportunity opportunity :opportunities) {
            
            Opportunity oldOpportunity = oldOpportunities.get(opportunity.Id);
            
            if (oldOpportunity.StageName != opportunity.StageName) {            
                opportunity.Stage_Name_Updated_Date__c = Date.today();	
            }
        }
    }
    
}