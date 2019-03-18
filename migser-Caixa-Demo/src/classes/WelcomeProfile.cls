public with sharing class WelcomeProfile {
    @AuraEnabled
    public  static map<string,object> getHierarchy(string userid) { 
        if(userid == null || userid == '')
            userid = UserInfo.getUserId();
        	User currentUser=getProfileUser(userid);
        
        map<string,object> JSONHierarchy = new map<string,object>();
        JSONHierarchy.put('selectedUser', currentUser);
        return JSONHierarchy;
    } 
    

    public static User getProfileUser(id userid) {
        User u = [SELECT Id, Name, FirstName, physicalDeliveryOfficeName__c, FullPhotoUrl FROM User where Id =: userid];
        return u;
    }
}