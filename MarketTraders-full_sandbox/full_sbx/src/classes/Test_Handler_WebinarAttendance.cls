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
private class Test_Handler_WebinarAttendance {

    static testMethod void testTalkpointStamping() {
    	
    	Webinar__c webinar = new Webinar__c();
    	webinar.Name = 'test';
    	webinar.Description__c = 'test';
    	webinar.Event_Date_Time__c = DateTime.now().addDays(-5);
    	webinar.Webinar_Type__c = 'UTP OnDemand';
    	webinar.Webinar_ID__c = '102556';
    	webinar.Platform__c = 'Talkpoint';
    	Database.insert(webinar);
    	
    	list<Webinar_Attendance__c>  webinarAttendances = new list<Webinar_Attendance__c>();
    	
    	list<Lead> leads = new list<Lead>();
    	for(integer x = 0; x < 2; x++){
    		Lead lead = new Lead();
    		lead.FirstName = 'Clark';
   	 		lead.LastName = 'Kent';
    		lead.leadSource = 'Newspaper';
    		lead.Email = 'clark' + String.valueOf(x) + '.kent@smallville.com';
    		leads.add(lead);
    	}
    	Database.insert(leads);
    	
    	for(Lead lead : leads){
    		Webinar_Attendance__c webinarAttendance = new Webinar_Attendance__c();
    		webinarAttendance.Lead__c = lead.id;
    		webinarAttendance.Attended__c = true;
    		webinarAttendance.Duration__c = 55;
    		webinarAttendance.OnDemand_Attendance_Date__c = Date.today();
    		webinarAttendance.OnDemand_Views__c = 1;
    		webinarAttendance.Stamp_Type__c = 'OnDemand';
    		webinarAttendance.Source_Other__c = 'test';
    		webinarAttendance.Registration_Date__c = Date.today().addDays(-7);
    		webinarAttendance.Raised_Hands__c = 'Free';
    		webinarAttendance.Webinar__c = webinar.Id;
    		webinarAttendances.add(webinarAttendance);
    	}

		list<Account> accounts = new list<Account>();
		for(integer x = 0; x < 2; x++){
			Account account = new Account();
		    account.FirstName = 'Bruce';
		    account.LastName = 'Wayne';
		    account.PersonEmail = 'bruce' + String.valueOf(x) + '.wayne@gotham.com';
		    account.Country_List__c = 'United States of America';
		    account.RecordTypeId = '012600000005CeK';
		    Database.insert(account);
		}
		
		for(Account account : accounts){
			Webinar_Attendance__c webinarAttendance = new Webinar_Attendance__c();
    		webinarAttendance.Account__c = account.id;
    		webinarAttendance.Attended__c = true;
    		webinarAttendance.Duration__c = 55;
    		webinarAttendance.OnDemand_Attendance_Date__c = Date.today();
    		webinarAttendance.OnDemand_Views__c = 1;
    		webinarAttendance.Stamp_Type__c = 'OnDemand';
    		webinarAttendance.Source_Other__c = 'test';
    		webinarAttendance.Registration_Date__c = Date.today().addDays(-7);
    		webinarAttendance.Raised_Hands__c = 'Free';
    		webinarAttendance.Webinar__c = webinar.Id;
    		webinarAttendances.add(webinarAttendance);
		}
		
		for(Account account : accounts){
			Webinar_Attendance__c webinarAttendance = new Webinar_Attendance__c();
    		webinarAttendance.Account__c = account.id;
    		webinarAttendance.Attended__c = true;
    		webinarAttendance.Duration__c = 55;
    		webinarAttendance.OnDemand_Attendance_Date__c = Date.today();
    		webinarAttendance.OnDemand_Views__c = 1;
    		webinarAttendance.Stamp_Type__c = 'UOC';
    		webinarAttendance.Source_Other__c = 'test';
    		webinarAttendance.Registration_Date__c = Date.today().addDays(-7);
    		webinarAttendance.Raised_Hands__c = 'Free';
    		webinarAttendance.Webinar__c = webinar.Id;
    		webinarAttendances.add(webinarAttendance);
		}
		
		for(Account account : accounts){
			Webinar_Attendance__c webinarAttendance = new Webinar_Attendance__c();
    		webinarAttendance.Account__c = account.id;
    		webinarAttendance.Attended__c = true;
    		webinarAttendance.Duration__c = 55;
    		webinarAttendance.OnDemand_Attendance_Date__c = Date.today();
    		webinarAttendance.OnDemand_Views__c = 1;
    		webinarAttendance.Stamp_Type__c = 'UTP';
    		webinarAttendance.Source_Other__c = 'test';
    		webinarAttendance.Registration_Date__c = Date.today().addDays(-7);
    		webinarAttendance.Raised_Hands__c = 'Free';
    		webinarAttendance.Webinar__c = webinar.Id;
    		webinarAttendances.add(webinarAttendance);
		}
		
		test.startTest();
			Database.insert(webinarAttendances);
			Database.update(webinarAttendances);
			Database.delete(webinarAttendances);
			Database.undelete(webinarAttendances);
		test.stopTest();

    }
}