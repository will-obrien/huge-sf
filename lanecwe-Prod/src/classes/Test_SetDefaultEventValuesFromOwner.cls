/*********************************************************************
Name : Test_SetDefaultEventValuesFromOwner 
Created On : Feb 14, 2012  
Created By : Lalit Bohra
Description : Test class to check functionality of trigger SetDefaultEventValuesFromOwner on Event object
**********************************************************************/
@isTest
private class Test_SetDefaultEventValuesFromOwner {

    static testMethod void setDefaultEventValuesFromOwner_UnitTest() {
        // TO DO: implement unit test
        User u=createUser();
        list<Event> EventList=new list<Event>();
        for(Integer i=0;i<10;i++){
				Event objEvent = new Event();
				objEvent.OwnerId =u.Id;
				objEvent.Subject='Call';
				objEvent.ActivityDate  =Date.today();
				objEvent.StartDateTime=	Date.today();
				objEvent.EndDateTime=	Date.today().AddDays(5);				
				EventList.add(objEvent);
			}
			insert EventList;
			list<Event> UpdateEventList= [Select id from Event where Channel__c=:'Test Channel'];
			if(UpdateEventList != null && UpdateEventList.size()>0){
				system.assert(True);
			}
			else{
				system.assert(false);
			}
    }
    public static User createUser() {
	  	// need to change these values
	    /*List<Profile> profiles = [select Id From Profile where Name = 'System Administrator' limit 1];
	    String profileId = profiles.get(0).Id;
	    User user = new User();
	    user.Email = 'test.dummy.20110405'+sufix+'@appirio.com';
	    user.CommunityNickname = 'test.dummy.20110405'+sufix+'@appirio.com';
	    //user.UserName = 'test.dummy.20110405@appirio.com';
	    user.UserName = 'testing1'+sufix+'@pgi.com';
	    user.FirstName = 'Foo'+sufix;
	    user.LastName = 'Bar'+sufix;
	    user.Alias = 'foo'+sufix;
	    user.ProfileId = profileId;
	    user.EmailEncodingKey = 'ISO-2022-JP';
	    user.LanguageLocaleKey = 'ja';
	    user.LocaleSidKey = 'ja_JP';
	    user.TimeZoneSidKey = 'Asia/Tokyo';*/
	    //user.TESLA_SalesRep_Email__c ='testing1@testsite.com';
	    User user = PGITestUtilities.getTestUser();
	    user.TESLA_SalesRep_Email__c ='testing1@testsite.com';
	    user.TESLA_SALESMANAGER_ID__c='testsm1';
	    user.User_can_select_Account_Partner_Type__c = true;
	    user.Channel__c='Test Channel';
	    insert user;
	    return user;
	}
}