trigger onContentUpdateInsert on Content__c (before update, before insert) {
    
    List<Id> updateContentIds = new List<Id>();
    List<Id> updateStoryContentIds = new List<Id>();
    
    if (Trigger.isInsert) {
    
        for(Content__c obj : trigger.New) {
            if(Obj.Published_Date__c == null) {
                obj.Published_Date__c = Date.today();
            }
            if(obj.Raw_HTML__c != null) {
                updateStoryContentIds.add(obj.Id);
                obj.Story__c = obj.Raw_HTML__c;
            }
        }
        
    } else {
        for(Content__c obj : trigger.New) {
            if(obj.Status__c == 'Active' && Trigger.oldMap.get(Obj.Id).Status__c != 'Active' && Obj.Published_Date__c == null) {
                obj.Published_Date__c = Date.today();
            }
            if(obj.Raw_HTML__c != null) {
                updateStoryContentIds.add(obj.Id);
                obj.Story__c = obj.Raw_HTML__c;
            }
        }
        
    }
}