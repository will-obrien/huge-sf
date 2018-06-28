public class selfServiceController {

    @AuraEnabled
    public static void createCase(String pTime, String pSubject, String pDescription ){

        Callback__c newCall = new Callback__c();
        
        // Query for User's Phone number, and Queue Id to insert Callback Object into
        User myUser = [SELECT ContactId, Phone FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
        
        
        if(myUser.ContactId != null){
        	Contact contactInfo = [SELECT Name FROM Contact WHERE Id=:myUser.ContactId LIMIT 1];    
			        newCall.ContactName__c = contactInfo.Name;
        }
        
        Group g = [SELECT Id,Name FROM Group WHERE Name='Callback Queue' AND Type = 'Queue' LIMIT 1];
        
        // Assign Callback__c Object values based on user input from Lightning Component
        newCall.OwnerId = g.Id;

        newCall.Phone__c = myUser.Phone;
        newCall.subject__c = pSubject;
        newCall.description__c = pDescription;
        
        System.debug('newCall: ' + newCall);
        insert newCall;
    }
}