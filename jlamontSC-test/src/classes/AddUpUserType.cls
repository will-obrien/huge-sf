/*
AddUpUserType

Created by: Mark Maslow, January 2017

This class is meant to be called by AddUp as a REST call.

AddUp passes a Contact Id

This class passes back an AddUp User Type
*/
@RestResource(urlMapping='/AddUpUserType/*')
global without sharing class AddUpUserType {
	@HttpGet
	global static AddUpUserTypeReturn getUserType() {
		RestRequest req = RestContext.request;
		String contactId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		AddUpUserTypeReturn userType = new AddUpUserTypeReturn();
		userType.contactId = contactId;
		userType.userType = '0';
		if( ! String.isEmpty(contactId)) {
			List<Contact> contactList = 
				[select Id, AddUP_User_Type__c from Contact where Id=:contactId];
			if(contactList.size() > 0) {
				Contact ctct = contactList.get(0);
				if( ! String.isEmpty(ctct.AddUP_User_Type__c)) {
					userType.userType = ctct.AddUP_User_Type__c.substring(0,1);
				}
			}
		}
		return userType;
	}
	global class AddUpUserTypeReturn {
		public String contactId;
		public String userType;
	}
}