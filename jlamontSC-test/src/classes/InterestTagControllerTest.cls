@isTest
private class InterestTagControllerTest {

    static testMethod void myUnitTest() {
    	BulkEntryController bec = new BulkEntryController();
    	InterestTagController itc = new InterestTagController();
    	itc.pageController = bec;
    	
    	itc.saveTag();
    	itc.getCloseAction();
    	
    	Schema.DescribeFieldResult fieldResult = Interest__c.Interest_Type__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		itc.interest.Interest_Type__c = ple.get(0).getValue();
		
    	fieldResult = Interest__c.Interest_Description__c.getDescribe();
		ple = fieldResult.getPicklistValues();
		itc.interest.Interest_Description__c = ple.get(0).getValue();
		
    	itc.saveTag();
    	itc.cancelTag();
    	itc.getCloseAction();
    	
    }
}