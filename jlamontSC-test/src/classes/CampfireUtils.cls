public with sharing class CampfireUtils {
	public static String getPageBase() {
		if(UserInfo.getUserType() == 'Standard') {
			return System.Url.getSalesforceBaseUrl().toExternalForm() + '/apex/';
		}
		return '/campfire/';
	}
	public Static Id getUserContactId() {
		Id userId = UserInfo.getUserId();
		Id contactId;
        if(UserInfo.getUserType() == 'Standard') {
        	contactId = [select Contact__c from User_Lookups__c where User__c = :userId].Contact__c;
        }
        else {
            contactId = [select ContactId from User where Id=:userId].ContactId;
        }
        return contactId;
	}
}