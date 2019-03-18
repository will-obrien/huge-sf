public class DETableCtrl {
    
    @AuraEnabled
    public static List<Contact> getContacts(String acctId){
        return [Select Id, Name from Contact where AccountId = :acctId];
    }
    
    @AuraEnabled
    public static List<Involved_Users__c> getUsers(String acctId){
        return [Select Id, Company_Personnel__r.Name from Involved_Users__c where Account__c = :acctId];
    }
    
    /*
@AuraEnabled
public static TableWrapper getData(String acctId){
TableWrapper tw = new TableWrapper();
tw.users = [Select Id, Trelleborg_Personnel__r.Name from Involved_Users__c where Account__c = :acctId];
tw.cs = [Select Id, Name from Contact where AccountId = :acctId];
return tw;
}
*/
    
    /*@AuraEnabled
public static Contact_User_Relationship__c getRelationshipDetails(String relationId){
Contact_User_Relationship__c userRel = [SELECT Id, Relationship_Classification__c, Name, Relationship_Comment__c FROM Contact_User_Relationship__c WHERE Id = :relationId];
system.debug('=========='+ userRel);
return userRel;
}*/
    
    @AuraEnabled
    public static Contact_User_Relationship__c updateComment(String newComment, Contact_User_Relationship__c relationObject){
        system.debug('newComment: ' + newComment);
        system.debug('relationObject: ' + relationObject);
        //system.debug('relationObjectId' + relationObject.Id);
        relationObject.Relationship_Comment__c = newComment;
        update relationObject;
        system.debug('relationObject updated!!!');
        
        return relationObject;
    }
    
    @AuraEnabled
    public static Contact_User_Relationship__c updateRelationType(String newRelationId, Contact_User_Relationship__c thisRelation){
        system.debug('newRelationId: ' + newRelationId);
        system.debug('thisRelation: ' + thisRelation);
        
        if(newRelationId == 'trusted'){
            thisRelation.Relationship_Classification__c = 'Trusted Advisor: willing to be influenced';
        }
        
        else if(newRelationId == 'regular'){
            thisRelation.Relationship_Classification__c = 'Regular contact: always willing to see';
        }
        
        else if(newRelationId == 'difficult'){
            thisRelation.Relationship_Classification__c = 'Difficult to contact/engage';
        }
        
        system.debug('thisRelation.Relationship_Classification__c: ' + thisRelation.Relationship_Classification__c);
        update thisRelation;
        return thisRelation;
    }
}