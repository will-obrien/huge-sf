trigger ExperienceOtherCompany on Experience__c (before insert,before update) {
    /*Experience__c myExp=trigger.new[0];

    String otherField = myExp.CompanyOther__c;
    if(!String.isEmpty(otherField)) {
    
        List<RecordType> rtypes = [Select Name, Id From RecordType 
                                   where sObjectType='Account' and isActive=true];
        
        List<Site> sites = [SELECT AdminId FROM Site where Name=: Label.Site_Name LIMIT 1];
        
        String adminId = sites[0].AdminId;
            
        Map<String,String> accountRecordTypes = new Map<String,String>{};
            for(RecordType rt: rtypes)
            accountRecordTypes.put(rt.Name,rt.Id);
        
        String recordTypeId = accountRecordTypes.get('Business');
    
        Account objNewAccount = new Account();
        objNewAccount.Name = myExp.CompanyOther__c;
        objNewAccount.RecordTypeId = recordTypeId;
        objNewAccount.ownerid = adminId;
        insert objNewAccount;     

        myExp.Company__c = objNewAccount.id;
        myExp.CompanyOther__c = '';
        
    }*/
}