global class batchUpdateContactEmailAddress implements Database.Batchable<SObject>
{
    //global boolean bIsTestCall = false;
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,GARP_Member_ID__c,Email from Contact');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        String strPostFix = '@Garp.com';
        for(Contact ct : scope)
        {
            ct.Email = ct.GARP_Member_ID__c + strPostFix;
            
        }
        
       if(!scope.isEmpty())
            update scope;
       
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}