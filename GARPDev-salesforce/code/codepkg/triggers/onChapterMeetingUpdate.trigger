trigger onChapterMeetingUpdate on Chapter_Meeting__c (before insert, before update) {
    
	List<Chapter_Meeting__c> cms = Trigger.new;
	List<Id> ids = new List<Id>();
    for (Chapter_Meeting__c c:cms){
        if(c.Time_Zone__c==null) {
            ids.add(c.Chapter__c);
        }            
    }
    
    system.debug('* * * ids ...'+ ids);
    
    List<Chapter__c> chaps = [select Id, Name, Time_Zone__c from Chapter__c where Id in :ids];
    Map<Id,Id> chapTimeZoneMap = new Map<Id,Id>();
    for(Chapter__c ch :chaps) {
        chapTimeZoneMap.put(ch.id, ch.Time_Zone__c);
    }

    system.debug('* * * chapTimeZoneMap ...'+ chapTimeZoneMap);

    for (Chapter_Meeting__c c:cms){
		Id timeZoneId = chapTimeZoneMap.get(c.Chapter__c);   
        if(timeZoneId != null) {
        	c.Time_Zone__c = timeZoneId;
        }
    }
}