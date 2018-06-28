public class OpportunityObjectReferenceUpdate {
    public static void UpdateOpportunityObjectReference(){
        List<Lead> convertedLeads=new List<Lead>();
        convertedLeads=[Select Id,Opportunity__c,ConvertedOpportunityId from Lead where IsConverted=true];
        for(Lead lead:convertedLeads)
        {
            lead.Opportunity__c=([SELECT Id,Name,StageName FROM Opportunity WHERE Id=:lead.ConvertedOpportunityId][0]).Id;
            update lead;
    	}
    }
}