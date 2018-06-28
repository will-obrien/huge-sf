global class ERPRoomBatch implements Database.Batchable<SObject>,Database.Stateful
{
   global List<ExamSiteids__c> examSiteIds = ExamSiteids__c.getall().values();
   global Set<String> setSiteIds;
   global Database.QueryLocator start(Database.BatchableContext BC){
     setSiteIds = new Set<String>();
      for(ExamSiteids__c examSite : examSiteIds)
      {
        setSiteIds.add(examSite.Name);
      }
    
      system.debug('setSiteIds == '+setSiteIds);
      if(setSiteIds.isEmpty()) return null;
      return Database.getQueryLocator('select id,Latest_Seat_No__c,Priority__c,Room_Code__c,Capacity__c,Active__c,Venue__c,Venue__r.Site__c,ERP_Seats_Allocated__c from Room__c where Active__c = true and Capacity__c > 0 and Priority__c != null and Venue__r.Site__c in: setSiteIds order by Priority__c ASC');
     
     }
    
    
    global void execute(Database.BatchableContext BC, List<Room__c> scope){
        if(scope == null) return;
        RoomCounter.updateRooms(scope,setSiteIds,'ERP');
        
    }
   
    global void finish(Database.BatchableContext BC){
         
       
    }

}