trigger onCPEActivityInsertUpdate on CPE_Activity__c (before insert, before update) {

    //if (Trigger.isInsert) {
        
        Map<String, String> providerMap = new Map<String, String>();
        Map<String, String> activityTypeMap = new Map<String, String>();
    
    	Map<String, CPE_Activity__c> activityMap = new Map<String, CPE_Activity__c>();
    
        for(CPE_Activity__c obj : trigger.New) {
                        
           	String objId = obj.Title__c;
                
            if(obj.Provider__c != null) {
                providerMap.put(objId, obj.Provider__c);
            }
            if(obj.Activity_Type_Description__c != null) {
                activityTypeMap.put(objId, obj.Activity_Type_Description__c);
            }
            if(obj.Title__c != null) {
                if(obj.Title__c.length() <= 80)
                    obj.Name = obj.Title__c;
                else obj.Name = obj.Title__c.SubString(0,80); 
            }
            
            activityMap.put(objId, obj);
        }
        
        List<Account> lstAccount = [select Id, Name from Account where Name in :providerMap.values()];
    	List<CPE_Activity_Type__c> lstActType = [select Id, Name from CPE_Activity_Type__c where Name in :activityTypeMap.values()];
        
        for(String actId : providerMap.keySet()) {
            String prov = providerMap.get(actId);
            CPE_Activity__c act = activityMap.get(actId);
            for(Account acct :lstAccount) {
                if(acct.Name == prov) {
                    act.Account__c = acct.Id;
                }
            }            
        }

    	system.debug('* * * activityMap ...'+ activityMap);
    	system.debug('* * * activityTypeMap ...'+ activityTypeMap);
    	system.debug('* * * lstActType ...'+ lstActType);
    
        for(String actId : activityTypeMap.keySet()) {
            String actTypeName = activityTypeMap.get(actId);
            CPE_Activity__c act = activityMap.get(actId);
            for(CPE_Activity_Type__c acttype :lstActType) {
                if(acttype.Name == actTypeName) {
                    act.CPE_Activity_Type__c = acttype.Id;
                }
            }            
        }

   //}
    
    
}