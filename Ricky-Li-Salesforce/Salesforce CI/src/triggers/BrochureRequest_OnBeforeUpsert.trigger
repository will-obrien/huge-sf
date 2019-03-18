trigger BrochureRequest_OnBeforeUpsert on Brochure_Request__c (before insert, before update) {
	//check agent, agency, traveller or lead have address before create/update Brochure Request
    Set<Id> agentIds = new Set<Id>();
    Set<Id> agencyIds = new Set<Id>();
    Set<Id> travellerIds = new Set<Id>();
    Set<Id> leadIds = new Set<Id>();
    
    for(Brochure_Request__c br : trigger.new)
    {
        if(br.Agent__c != null)
            agentIds.add(br.Agent__c);
        
        //to handle the case where only agency (without agent) selected
        if(br.AgencyAccount__c != null)
            agencyIds.add(br.AgencyAccount__c);
        
        if(br.Account__c != null)
            travellerIds.add(br.Account__c);
        
        if(br.Lead__c != null)
            leadIds.add(br.Lead__c);
    }
    
    Map<Id, Contact> mapAgents = new Map<Id, Contact>([select Id, AccountId, Name, MailingStreet, Home_Based_Contact__c
                                                        from Contact where Id in :agentIds]);
        
    for(Contact c : mapAgents.values())
    {
        agencyIds.add(c.AccountId);
    }
    
    Map<Id, Account> mapAgencies = new Map<Id, Account>([select Id, Name, BillingStreet, BillingCity, BillingCountry, BillingPostalCode 
                                                                from Account where Id in : agencyIds]);         
                                                                
    Map<Id, Account> mapTravellers = new Map<Id, Account>([select Id, Name, BillingStreet, BillingCity, BillingCountry, BillingPostalCode 
                                                                from Account where Id in : travellerIds]);  
                                                                
    Map<Id, Lead> mapLeads = new Map<Id, Lead>([select Id, Street, Country from Lead where Id in :leadIds]);                                                                                                        

    for(Brochure_Request__c br : trigger.new){
        //if(br.Agent__c != null){
            //br.AgencyAccount__c = mapAgents.get(br.Agent__c).AccountId;
            ////if(mapAgents.get(br.Agent__c).MailingStreet == null) br.addError('Missing Mailing Address for the Agent you selected');
            //if(mapAgencies.get(br.AgencyAccount__c).BillingStreet == null) br.addError('Missing Mailing Address for the Agency of the Agent you selected');
        //}
        
        if(br.AgencyAccount__c != null || br.Agent__c != null){
            if(br.Agent__c != null){
                if(mapAgents.get(br.Agent__c).Home_Based_Contact__c == TRUE){
                    if(mapAgents.get(br.Agent__c).MailingStreet == null) br.addError('Missing Mailing Address for the Agent you selected');
                }
                br.AgencyAccount__c = mapAgents.get(br.Agent__c).AccountId;
            }
            if(mapAgencies.get(br.AgencyAccount__c).BillingStreet == null) br.addError('Missing Mailing Address for the Agency you selected');
        }
        
        if(br.Account__c != null){
            if(mapTravellers.get(br.Account__c).BillingStreet == null) br.addError('Missing Mailing Address for the Traveller you selected');
        }
        
        if(br.Lead__c != null){
            if(mapLeads.get(br.Lead__c).Street == null) br.addError('Missing Mailing Address for the Lead you selected');   
        }
        
    }
}