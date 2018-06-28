global class EventLeaderToActionSched implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Id offlineId = Schema.SObjectType.kweos__EOCS_Data__c.getRecordTypeInfosByName().get('Offline').getRecordTypeId();
        //select event leaders for past events that were active
        List<Event_Leader__c> leaders = [SELECT Id, Campaign__c, Contact__c, Campaign__r.Start_Date__c, Campaign__r.Status__c FROM Event_Leader__c WHERE Advocacy_Action_Created__c = false AND Contact__c != null AND Campaign__r.Start_Date__c < TODAY AND (Campaign__r.Status__c = 'Active' OR Campaign__r.Status__c = 'At Capacity')];
        List<kweos__EOCS_Data__c> actions = new List<kweos__EOCS_Data__c>();
        
        //for each event leader record, create an advocacy action and update event leader Adv Action Created field
        for (Event_Leader__c ldr : leaders) {
            kweos__EOCS_Data__c newAction = new kweos__EOCS_Data__c(
                RecordTypeId = offlineId,
                kwac__Contact__c = ldr.Contact__c,
                kwac__Related_Action__c = ldr.Campaign__c,
                Action_Date__c = ldr.Campaign__r.Start_Date__c,
                Action__c = 'Event Leadership');
            actions.add(newAction);
            ldr.Advocacy_Action_Created__c = true;
        }  
        insert actions;
        update leaders;
    }  
}