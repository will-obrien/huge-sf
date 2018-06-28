trigger updateContactsByGarpId on certificate_shipping__c (before insert,before update) {
    Set<String> setGarpIds = new Set<String>();
    for(certificate_shipping__c obj : trigger.new)
    {
        
                    
        if(obj.Garp_id__c != null)
            setGarpIds.add(obj.Garp_id__c);
    }
    if(!setGarpIds.isEmpty())
    {
        Map<String,Contact> mapGarpContactIds = new Map<String,Contact>();
        for(Contact ct : [select id,GARP_Member_ID__c,MailingCountry from Contact where GARP_Member_ID__c in: setGarpIds])
        {
            mapGarpContactIds.put(ct.GARP_Member_ID__c,ct);
        }
        
        for(certificate_shipping__c obj : trigger.new)
        {
            Id contactID = mapGarpContactIds == null || mapGarpContactIds.size() <= 0  ? null : mapGarpContactIds.get(obj.Garp_id__c).id;
            if(contactID != null)
            {
                obj.Member__c = contactID;
                CountryCodes__c countryCodes = CountryCodes__c.getValues(mapGarpContactIds.get(obj.Garp_id__c).MailingCountry);
                obj.Country_Code_for_UPS__c = countryCodes != null ? countryCodes.Country_Code__c : '';
            }
                
            else
                obj.addError('No valid Garp ID found on contact.');
        }
    }

}