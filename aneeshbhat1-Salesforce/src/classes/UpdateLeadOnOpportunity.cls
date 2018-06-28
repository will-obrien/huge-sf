public class UpdateLeadOnOpportunity {
    public static void UpdateLeadDataOnOpportunity(){
		List<Opportunity> opportunitiesToBeUpdated=new List<Opportunity>();
        for(Opportunity opportunity:[Select Id FROM Opportunity WHERE Lead__c=NULL])
        {
            List<Lead> leads=[SELECT Id,Name FROM Lead WHERE ConvertedOpportunityId=:opportunity.Id];
            Opportunity tempOpportunity=[Select Id,Lead__c FROM Opportunity where Id=:opportunity.Id];
            if(leads!=null&&leads.size()>0)
            {
                tempOpportunity.Lead__c=(leads[0]).Id;
                opportunitiesToBeUpdated.Add(tempOpportunity);
            }
        }
    
    	for(Opportunity opportunity:opportunitiesToBeUpdated)
    	{
        	update opportunity;
    	}
    }
}