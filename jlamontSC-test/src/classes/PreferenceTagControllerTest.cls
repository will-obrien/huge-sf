@isTest
private class PreferenceTagControllerTest {

    static testMethod void myUnitTest() {
    	BulkEntryController bec = new BulkEntryController();
    	PreferenceTagController ptc = new PreferenceTagController();
    	ptc.pageController = bec;
    	
    	ptc.saveTag();
    	ptc.getCloseAction();
    	
    	Schema.DescribeFieldResult fieldResult = rC_Bios__Preference__c.rC_Bios__Category__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		ptc.preference.rC_Bios__Category__c = ple.get(0).getValue();
		
    	fieldResult = rC_Bios__Preference__c.rC_Bios__Subcategory__c.getDescribe();
		ple = fieldResult.getPicklistValues();
		ptc.preference.rC_Bios__Subcategory__c = ple.get(0).getValue();
		
    	ptc.saveTag();
    	ptc.cancelTag();
    	ptc.getCloseAction();
    }
}