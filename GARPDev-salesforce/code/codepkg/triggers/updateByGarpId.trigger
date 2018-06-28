trigger updateByGarpId on Shipping_Boxes__c (before insert,before update) {
    Set<String> setGarpIds = new Set<String>();
    for(Shipping_Boxes__c obj : trigger.new)
    {
        
                    
        if(obj.Garp_id__c != null)
            setGarpIds.add(obj.Garp_id__c);
    }
    if(!setGarpIds.isEmpty())
    {
        Map<String,Proctor_Registration__c > mapproctorids = new Map<String,Proctor_Registration__c>();
        for(Proctor_Registration__c pr : [select id,Exam_Group__r.name,Exam_Shipping_Country__c,Member_GARP_ID__c, Box_Shipping_Country__c from Proctor_Registration__c where Member_GARP_ID__c in: setGarpIds and Exam_Group__r.name='15-Nov'])
        {
            mapproctorids.put(pr.Member_GARP_ID__c,pr);
        }
        
        for(Shipping_Boxes__c obj : trigger.new)
        {
            Id proctorids =  mapproctorids == null ||  mapproctorids.size() <= 0  ? null : mapproctorids.get(obj.Garp_id__c).id;
            if(proctorids != null)
            {
                obj.proctor__C = proctorids;
                CountryCodes__c countryCodes = CountryCodes__c.getValues(mapproctorids.get(obj.Garp_id__c).Box_Shipping_Country__c);
               CountryCodes__c countryCodes1 = CountryCodes__c.getValues(obj.Ship_To_Country_Code__c);
                obj.Pre_Test_Box_Country_Code_for_UPS__c = countryCodes != null ? countryCodes.Country_Code__c : '';
                obj.Exam_Box_Country_Code_for_UPS__c= countryCodes1 != null ? countryCodes1.Country_Code__c : '';
            }
                
            else
                obj.addError('No valid Garp ID found on contact.');
        }
    }

}