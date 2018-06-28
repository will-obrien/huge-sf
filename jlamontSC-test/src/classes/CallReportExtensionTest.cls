/*********************************************************************************************************
Name                  : CallReportExtensionTest
Created By            : Dipika Gupta (Appirio JDC)
Created Modified Date : Feb 10, 2013
Description           : test class for CallReportExtension
***********************************************************************************************************/
@isTest
private class CallReportExtensionTest {

	//test method to create task on contact
	private static testMethod void taskCreationForContact(){
		Test.startTest();
		Task task = new task();
		Contact testContact = new Contact(LastName='Sierra');
		insert testContact;
		ApexPages.currentPage().getParameters().put('retURL',testContact.Id);
		ApexPages.currentPage().getParameters().put('OwnerId',UserInfo.getUserId());
		ApexPages.StandardController con = new ApexPages.StandardController(task);
		CallReportExtension CRE = new callReportExtension(con);
		CRE.saveAction();

		task = [SELECT ID FROM Task Where whoId =: testContact.Id];
		system.assert(task!= null);
		CRE.cancel();
		CRE.changeCallType();
		ApexPages.currentPage().getParameters().put('retURL',testContact.Id);
		con = new ApexPages.StandardController(task);
		CRE = new callReportExtension(con);


		Test.stoptest();
	}

	//test method to create task on account
	private static testMethod void taskCreationForAccount(){
		Test.startTest();
		Task task = new task();
		Account testAccount = new Account(Name='Sierra');
		insert testAccount;
		ApexPages.currentPage().getParameters().put('retURL',testAccount.Id);
		ApexPages.currentPage().getParameters().put('OwnerId',UserInfo.getUserId());
		ApexPages.StandardController con = new ApexPages.StandardController(task);
		CallReportExtension CRE = new callReportExtension(con);
		CRE.saveAction();

		task = [SELECT ID FROM Task Where whatId =: testAccount.Id];

		CRE.cancel();
		CRE.changeCallType();
		ApexPages.currentPage().getParameters().put('retURL',testAccount.Id);
		con = new ApexPages.StandardController(task);
		CRE = new callReportExtension(con);
		system.assert(CRE.call!= null);
		Test.stoptest();
	}

}