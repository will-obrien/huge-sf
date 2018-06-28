@isTest
private class RegisterForMeetingController_Test {

	static user user;
	static profile profile;
	static account acc;
	static Chapter_Meeting__c chapMeeting;
		
	static void testData(){
		
		chapMeeting = new Chapter_Meeting__c();
        insert chapMeeting;
        
		Acc = new Account(Name = 'test');
        insert acc;
        
		contact contact1 = new Contact(recordtypeId = recordtypehelper.getRecordtypeID('Contact','Business Relationship'),lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact1;
        profile = [SELECT Id FROM Profile WHERE usertype = 'CspLitePortal' limit 1]; 
        user = new User(Alias = 'newUser', Email='newuser@testorg.com', contactId = contact1.id,EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = profile.Id, TimeZoneSidKey='America/Los_Angeles', UserName='newuser@testorg.com');
        
	}
    static testMethod void myUnitTest() {
        testData();
        RegisterForMeetingController cntrlr = new RegisterForMeetingController();
        ApexPages.currentPage().getParameters().put('id',chapMeeting.id);
        String userId = ApexPages.currentPage().getParameters().put('userId',user.id);
        system.runAs(user){
        cntrlr.registerForMeeting();
        }
        cntrlr.goToDashboard();
        
    }
}