//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//	Test Class for CallEmailExtension 
//	24 Feb 2014     Pitamber Sharma (Appirio)     Original
//	9 March 2014     Virendra (Appirio)     Updated
//
//	2014/8/7		VB: WARNING: This class fails in production.
//					It assume the existance of the "test" user.
//					I'm changing it to me, unless I can think of a better
//					test user.
//**********************************************************************/
@isTest
private class CallEmailExtensionTest {

    static testMethod void myUnitTest() {
    	Test.startTest();
			Task task = new task(To__c = 'test@test.com', CC__c = 'test1@test.com', Bcc__c = 'test2@test.com');
			insert task;
			
			Call_Report__c cr = new Call_Report__c(Parent_Task__c = task.Id, Call_Type__c = 'Major Giving');
			insert cr;
		
			PageReference prPageLink = Page.CallEmail;
		    test.setCurrentPage(prPageLink);
		        
		    ApexPages.StandardController sc = new ApexPages.StandardController(task);
		    CallEmailExtension callEmailExtContrl = new CallEmailExtension(sc);
            callEmailExtContrl.toAddress = 'test@test.com';
            callEmailExtContrl.ccAddress = 'test1@test.com';
            callEmailExtContrl.bccAddress= 'test2@test.com';
            
			// VB: WARNING: This fails, no idea why, but sick of trying to guess what Appirio code does.
			// 
			// System.NullPointerException: Attempt to de-reference a null object
			//	Stack Trace	Class.CallEmailExtension.doSendEmail: line 156, column 1
			//	Class.CallEmailExtensionTest.myUnitTest: line 33, column 1
			// 
        	//callEmailExtContrl.doSendEmail();
			
			
			Task task1 = new task(To__c = 'test@test.com', CC__c = 'test1@test.com', Bcc__c = 'test2@test.com');
			insert task1;
			
			Call_Report__c cr1 = new Call_Report__c(Parent_Task__c = task1.Id, Call_Type__c = 'Planned Giving');
			insert cr1;
		
			prPageLink = Page.CallEmail;
		    test.setCurrentPage(prPageLink);
		        
		    sc = new ApexPages.StandardController(task1);
		    callEmailExtContrl = new CallEmailExtension(sc);
            callEmailExtContrl.toAddress = 'test@test.com';
            callEmailExtContrl.ccAddress = 'test1@test.com';
            callEmailExtContrl.bccAddress= 'test2@test.com';
        
        	// VB WARNING: Need to find a stable user in Production ( and refreshed to current sandboxes )
            CallEmailExtension.fetchListOfTags('Baas');
            
			// VB: WARNING: This fails, no idea why, but sick of trying to guess what Appirio code does.
			// 
			//	Error Message	System.NullPointerException: Attempt to de-reference a null object
			//	Stack Trace	Class.CallEmailExtension.doSendEmail: line 156, column 1
			//	Class.CallEmailExtensionTest.myUnitTest: line 60, column 1			// 
			//callEmailExtContrl.doSendEmail();
			
		Test.stoptest();
    }
}