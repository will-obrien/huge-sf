@IsTest
private class Test_CheckListClientController
{
	static CheckListClientController controller;
	static CheckList__c checklist;
	static List<CheckList__c> checklistToInsert;

	private static void createData()
	{
		Itinerary__c itinerary = TestDataUtils.createItinerary();
		insert itinerary;
		checklistToInsert = new List<CheckList__c>();
		for (Integer i = 0; i < 5; i++)
		{
			checkList = TestDataUtils.createCheckList();
			checklist.Itinerary__c = itinerary.Id;
			checklist.Order__c = 5 - i;
			checklist.Short_Description__c = String.valueOf(i + 1);
			checklistToInsert.add(checkList);
		}
		insert checklistToInsert;

		PageReference prefer = Page.CheckListClient;
		Test.setCurrentPage(prefer);
		ApexPages.StandardController stc = new ApexPages.StandardController(itinerary);
		controller = new CheckListClientController(stc);

	}

	@isTest
	static void testCheckbox()
	{
		createData();
		Test.startTest();
		controller.checklistId = checklistToInsert.get(2).Id;
		checklistToInsert.get(2).Done__c = true;
		controller.doChangeCheckBox();
		System.assertEquals(1, [SELECT Done__c FROM CheckList__c WHERE Done__c = true].size());
		Test.stopTest();
	}

	@isTest
	static void testSortByOrder()
	{
		createData();
		Test.startTest();
		System.assertEquals(1, controller.results.get(0).Order__c);
		Test.stopTest();
	}
}
