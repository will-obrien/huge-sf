/*
Helper class to UpdatePortalContactInfo trigger
*/

public class UpdatePortalContactInfoHelper{
    
    //To Solve the Mized DML Operations error
    @future(Callout = false)
    public static void updateContactInfo(Map<Id, Boolean> isActiveMap, Map<Id, String> profileNameMap){
        
        List<Contact> updateContacts = new List<Contact>();
        
        for(Id contactId : profileNameMap.keySet()){
           
          updateContacts.add(new Contact(Id = contactId, Is_Community_User__c = true, Is_Community_User_Active__c = isActiveMap.get(contactId), Community_User_Profile__c = profileNameMap.get(contactId))); 
        }
        
        try{
            update updateContacts;    
        }catch(Exception exp){
            System.debug('Cannot handle because of async mode.');
        }
    }
}