@isTest
private class WaiverControllerTest {

    static testMethod void myUnitTest() {
        Event_Registration__c reg = new Event_Registration__c(
			First_Name__c = 'First',
			Last_Name__c = 'Last',
			Image_Authorization_Declined__c = false,
			Is_Minor__c = false,
			Guardian_First_Name__c = '',
			Guardian_Last_Name__c = ''
        );
        insert reg;

		WaiverController ctl = new WaiverController();
		PageReference pageRef = Page.WaiverGenerator;
		Test.setCurrentPage(pageRef);
		ApexPages.currentPage().getParameters().put('id', reg.Id);
		Event_Registration__c reg2 = ctl.getRegistration();
		System.assertEquals(reg.Id, reg2.Id);
    }
}