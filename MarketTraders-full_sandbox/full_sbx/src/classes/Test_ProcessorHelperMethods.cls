/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_ProcessorHelperMethods {

    static testMethod void myUnitTest() {
        Lead lead = new Lead();
	    lead.FirstName = 'Clark';
	    lead.LastName = 'Kent';
	    lead.leadSource = 'Newspaper';
	    lead.Email = 'clark.kent@smallville.com';
	    lead.Webinar_UTP_Latest_Missed_Date__c = Date.valueOf('2013-01-15');
	    Database.insert(lead);
		
		Account account = new Account();
	    account.FirstName = 'Bruce';
	    account.LastName = 'Wayne';
	    account.PersonEmail = 'bruce.wayne@gotham.com';
	    account.Country_List__c = 'United States of America';
	    account.RecordTypeId = '012600000005CeK';
	    account.Webinar_UTP_Latest_Missed_Date__c = Date.valueOf('2014-02-03');
	 	Database.insert(account);
	 	
	 	account = [SELECT id,PersonContactId,PersonEmail,FirstName,LastName,Webinar_UTP_Latest_Missed_Date__c FROM Account limit 1];
	 	system.assertEquals(account.PersonEmail,'bruce.wayne@gotham.com');

		list<Task> tasks = new list<Task>();
	    Task leadTask = new Task();
	    leadTask.Subject = 'Webinar';
	    leadTask.ActivityDate = Date.valueOf('2014-02-04');
	    leadTask.Priority = 'Normal';
	    leadTask.Event_Name__c = 'Test Webinar';
	    leadTask.Registration_Date__c = Date.today();
	    leadTask.Webinar_Type__c = 'UTP OnDemand';
	    leadTask.Activity_Type__c = 'OnDemand Webinar';
	    leadTask.Status = 'Complete';
	    leadTask.Registered__c = true;
	    leadTask.Attended__c = false;
	    leadTask.Event_Date_Time__c = DateTime.valueOf('2014-02-04 12:00:00');
	    leadTask.WhoId = lead.id;
	    leadTask.Webinar_Id__c = '12345';
	    tasks.add(leadTask);
	    
	    Webinar__c webinar = new Webinar__c();
	    webinar.Webinar_Id__c = '12345';
	    webinar.Event_Date_Time__c = DateTime.now();
	    Database.insert(webinar);
	    
	    Task accountTask = new Task();
	    accountTask.Subject = 'Webinar';
	    accountTask.ActivityDate = Date.valueOf('2014-02-04');
	    accountTask.Priority = 'Normal';
	    accountTask.Event_Name__c = 'Test Webinar';
	    accountTask.Registration_Date__c = Date.today();
	    accountTask.Webinar_Type__c = 'UTP OnDemand';
	    accountTask.Status = 'Complete';
	    accountTask.Registered__c = true;
	    accountTask.Attended__c = false;
	    accountTask.Event_Date_Time__c = DateTime.valueOf('2014-02-04 12:00:00');
	    accountTask.WhoId = account.PersonContactId;
	    accountTask.Webinar_Id__c = '12345';
	    tasks.add(accountTask);
	    
	    Database.insert(tasks);
	    
	    list<Webinar_Email_Lookup__c> wels = new list<Webinar_Email_Lookup__c>();
	    
	    Webinar_Email_Lookup__c leadWel = new Webinar_Email_Lookup__c();
    	leadWel.Task_Id__c = leadTask.id;
    	leadWel.Salesforce_ID__c = lead.id;
    	leadWel.Successful_Registration__c = true;
		leadWel.WebinarID__c = '12345';
		leadWel.Webinar_Email_Registered__c = lead.Email;
		wels.add(leadWel);
		
		Webinar_Email_Lookup__c accountWel = new Webinar_Email_Lookup__c();
    	accountWel.Task_Id__c = accountTask.id;
    	accountWel.Salesforce_ID__c = account.id;
    	accountWel.Successful_Registration__c = true;
		accountWel.WebinarID__c = '12345';
		accountWel.Webinar_Email_Registered__c = account.PersonEmail;
		wels.add(accountWel);
		
		Database.insert(wels);
		
		list<Webinar_Attendance__c> webinarAttendances = new list<Webinar_Attendance__c>();
		Webinar_Attendance__c leadWebinarAttendance = new Webinar_Attendance__c();
		leadWebinarAttendance.Lead__c = lead.id;
		leadWebinarAttendance.Attended__c = true;
		leadWebinarAttendance.Duration__c = 0;
		leadWebinarAttendance.Registration_Date__c = Date.today();
		leadWebinarAttendance.Webinar__c = webinar.id;
		webinarAttendances.add(leadWebinarAttendance);
		
		Webinar_Attendance__c accountWebinarAttendance = new Webinar_Attendance__c();
		accountWebinarAttendance.Account__c = account.id;
		accountWebinarAttendance.Attended__c = true;
		accountWebinarAttendance.Duration__c = 0;
		accountWebinarAttendance.Registration_Date__c = Date.today();
		accountWebinarAttendance.Webinar__c = webinar.id;
		webinarAttendances.add(accountWebinarAttendance);
		
		Database.insert(webinarAttendances);
	    
	    set<String> emails = new set<String>();
	    emails.add(lead.Email);
	    emails.add(account.PersonEmail);
	    
	    test.startTest();
	    
	    	ProccessorHelperMethods.createOpportunity('test', '012600000005Cwx', Date.today(), 'New Deal',null,null,'UTP On Demand', account.id);
	    	ProccessorHelperMethods.createTask(webinar,lead.id,'OnDemand Webinar','UTP OnDemand');
	    	DateTime currentTime = DateTime.now();
	    	ProccessorHelperMethods.createWebinarAttendance(true, account.id, true, 15, webinar.id,currentTime,'OnDemand');
	    	ProccessorHelperMethods.createWebinarAttendance(false, lead.id, true, 15, webinar.id,currentTime,'OnDemand');
	    	
	    	ProccessorHelperMethods.getAccountMap(emails,'012600000005Cwx');
	    	ProccessorHelperMethods.getLeadMap(emails,'012600000005N5N');
	    	
	    	map<String,String> whoIdMap = new map<String,String>{lead.Email=>lead.id,account.PersonEmail=>account.id};
	    	ProccessorHelperMethods.getWebinarAttendanceMap(emails,webinar.id,currentTime);

	    	Date quarter1 = Date.newInstance(2014, 1, 1);
	    	ProccessorHelperMethods.getEndOfQuarterDate(quarter1);
	    	Date quarter2 = Date.newInstance(2014, 4, 1);
	    	ProccessorHelperMethods.getEndOfQuarterDate(quarter2);
	    	Date quarter3 = Date.newInstance(2014, 8, 1);
	    	ProccessorHelperMethods.getEndOfQuarterDate(quarter3);
	    	Date quarter4 = Date.newInstance(2014, 12, 1);
	    	ProccessorHelperMethods.getEndOfQuarterDate(quarter4);
	    	
	    test.stopTest();
	    
    }
}