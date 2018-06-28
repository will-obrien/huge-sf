/*********************************************************************
Name : Test_SetDefaultTaskValuesFromOwner 
Created On : Feb 14, 2012  
Created By : Lalit Bohra
Description : Test class to check functionality of trigger SetDefaultTaskValuesFromOwner on Task object
**********************************************************************/
@isTest
private class Test_SetDefaultTaskValuesFromOwner {

    static testMethod void setDefaultTaskValuesFromOwner_UnitTest() {
        // TO DO: implement unit test
        User u=createUser('');
        list<Task> TaskList=new list<Task>();
        for(Integer i=0;i<10;i++){
				Task objTask = new Task();
				objTask.OwnerId =u.Id;
				objTask.Subject='Call';
				objTask.ActivityDate  =Date.today();
				objTask.Status='In Progress';
				objTask.Priority='High';				
				TaskList.add(objTask);
			}
			insert TaskList;
			list<Task> UpdateTaskList= [Select id from Task where Channel__c=:'Test Channel'];
			if(UpdateTaskList != null && UpdateTaskList.size()>0){
				system.assert(True);
			}
			else{
				system.assert(false);
			}
    }
    public static User createUser(String sufix) {
	  	// need to change these values
	    /*List<Profile> profiles = [select Id From Profile where Name = 'System Administrator' limit 1];
	    String profileId = profiles.get(0).Id;
	    User user = new User();
	    user.Email = 'test.dummy.20110405'+sufix+'@appirio.com';
	    user.CommunityNickname = 'test.dummy.20110405'+sufix+'@appirio.com';
	    //user.UserName = 'test.dummy.20110405@appirio.com';
	    user.UserName = 'testing1'+sufix+'@testsite.com';
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
	    user.TESLA_SalesRep_Email__c ='testing1'+sufix+'@testsite.com';
	    user.TESLA_SALESMANAGER_ID__c='testsm1'+sufix;
	    user.User_can_select_Account_Partner_Type__c = true;
	    user.Channel__c='Test Channel';
	    insert user;
	    return user;
	}
}