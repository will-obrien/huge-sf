global class UpdateGARPMemberIdBatch implements Database.Batchable<sObject>{ 

  global Database.QueryLocator start(Database.BatchableContext BC){
       
       return Database.getQueryLocator('select id,GARP_Member_ID__c ,LEGACY_PK_PID__c  from Contact where LEGACY_PK_PID__c  != null');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
    
         list<contact> contactsToUpdate = new list<contact>();
         for(Contact con : scope)
         {
             
            con.GARP_Member_ID__c = con.LEGACY_PK_PID__c;
            contactsToUpdate.add(con);  
             
         }
        try{
            update contactsToUpdate;
        }catch(Exception ex){}
    }
   
    global void finish(Database.BatchableContext BC){
       
    }


    
    
    
}