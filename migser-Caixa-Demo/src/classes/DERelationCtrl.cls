public class DERelationCtrl {
	
    @AuraEnabled
    public static Contact_User_Relationship__c getRelation(String cId, String uId){
        Contact_User_Relationship__c contact_user_Rel =  [Select Id, Relationship_Classification__c, Name, Relationship_Comment__c from Contact_User_Relationship__c
               	where Involved_User__c = :uId AND Contact__c = :cId];
        
        system.debug('contact_user_Rel: ' + contact_user_Rel);
        return contact_user_Rel;
    }
}