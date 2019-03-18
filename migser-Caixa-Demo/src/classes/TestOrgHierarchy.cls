@isTest(SeeAllData=true)
private class TestOrgHierarchy {
	
	@isTest static void runTest() {
		OrgHierarchyCtrl org = new OrgHierarchyCtrl();
		UserNode u = new UserNode(new User(), new User());
	}
}