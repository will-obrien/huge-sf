@isTest
private class OppCreationWithInfoExtTest {
	testMethod private static void NewOpp() {
		Test.startTest();	
		PageReference pageRef = Page.OppCreationWithInfo;
		Test.setCurrentPage(pageRef);
		Apexpages.Standardcontroller stdController;
		OppCreationWithInfoExt controller = new OppCreationWithInfoExt(stdController);
		pageRef = controller.SetFields();
		
		System.assertEquals(pageRef.getParameters().get('opp11'), 'Identify Target');
		System.assertEquals(pageRef.getParameters().get('nooverride'), '1');
		Test.stopTest();
	}
}