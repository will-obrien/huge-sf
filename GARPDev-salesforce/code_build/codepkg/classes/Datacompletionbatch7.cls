global class Datacompletionbatch7 implements Database.Batchable<SObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,Email,FirstName,LastName,GARP_Member_ID__c,recordTypeId from Contact where GARP_Member_ID__c != null ');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        
        CommunityUtils.createCommunityUser(scope);

    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}