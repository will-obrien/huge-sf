trigger updatecountrycode on Bulk_Orders__c (before insert,before update) {
    Set<String> Ids = new Set<String>();
    for(Bulk_Orders__c obj : trigger.new)
    {
            Ids.add(obj.id);
    }
    if(!Ids.isEmpty())
    {
        for(Bulk_Orders__c obj : trigger.new)
        {
                CountryCodes__c countryCodes = CountryCodes__c.getValues(obj.Shipping_Country__c);
                obj.Country_Code_for_UPS__c = countryCodes != null ? countryCodes.Country_Code__c : '';
            }}}