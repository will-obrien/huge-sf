global class batchUpdateUserEmailAddress implements Database.Batchable<SObject>
{
    //global boolean bIsTestCall = false;
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('select id,GARP_Member_ID__c,Email from Contact');
     }
    
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        List<User> lstUser = [select id,Name,Username,Email,contactId from User where contactId in: scope];
        Map<Id,Contact> mapContacts = new Map<Id,Contact>();
        String strPostFix = '@Garp.com';
        for(Contact ct : scope)
        {
            mapContacts.put(ct.Id,ct);
        }
        for(User objUser : lstUser)
        {
            Contact con = mapContacts.get(objUser.contactId);
            objUser.Username = con.GARP_Member_ID__c+strPostFix;
            objUser.Email = con.GARP_Member_ID__c+strPostFix; 
        }
       
      
       if(!lstUser.isEmpty())
            update lstUser;
            
    }
        

    global void finish(Database.BatchableContext BC){
         
       
    }

}