@isTest
private class TestBulkPatterns {

    static testMethod void BulkOpportunityTest() {
        List<Opportunity> ops = new List<Opportunity>();
        InitTestObjects(ops, 100, 20, 20, 40);
        
        Test.StartTest();
        for(Opportunity op: ops) op.StageName = 'Qualification';
        update ops;
        Test.StopTest();
        
        ValidateOCRs(ops);
        
    }
    
    @istest(oninstall=true seealldata=false)
    static void CreateTaskTest()
    {
    	Integer NumberOfOpportunities = 100;
        List<Opportunity> ops = new List<Opportunity>();
		for(Integer x=0; x<NumberOfOpportunities; x++)
		{
			ops.add(new Opportunity(CloseDate = Date.Today().addDays(5), Name = 'optest_' + String.valueOf(x), StageName = 'Prospecting' ));	
		}
		TestDiagnostics2.SetDefaultFields('Opportunity', ops);	// Used for deployment, not part of this example
		
		insert ops;

        Test.StartTest();
        for(Opportunity op: ops) op.StageName = 'Qualification';
        update ops;
        Test.StopTest();

		List<Task> tasks = [SELECT ID, OwnerID, WhatID, Status, Subject, Type from Task where OwnerID = :UserInfo.getUserID() And Type='Other' And IsClosed = False And Subject = 'Assign Primary Contact'   ];
		system.assertEquals(NumberOfOpportunities, tasks.size());
    	
    }
  
    // Prepare the specified number of opportunities, with contact roles on each.
    // The contact roles are distributed evenly among the number of contacts specified.
    public static void InitTestObjects(List<Opportunity> newopportunities, Integer NumberOfOpportunities, Integer NumberOfOtherOpportunities, Integer ContactRolesPerOp, Integer NumberOfContacts)
    {
    	if(NumberOfContacts < ContactRolesPerOp) NumberOfContacts = ContactRolesPerOp;

		List<Contact>cts = new List<Contact>();    
		for(Integer x=0;x<numberofcontacts;x++)    
		{      
			cts.add(new Contact(LastName = 'cttest_' + String.valueOf(x)));
		}
		
		insert cts;

		newopportunities.clear();
		for(Integer x=0; x<NumberOfOpportunities; x++)
		{
			newopportunities.add(new Opportunity(CloseDate = Date.Today().addDays(5), Name = 'optest_' + String.valueOf(x), StageName = 'Prospecting' ));	
		}
		TestDiagnostics2.SetDefaultFields('Opportunity', newopportunities);	// Used for deployment, not part of this example
		

		// Insert the test opportunities
		insert newopportunities;
		
		List<Opportunity> otheropportunities = new List<Opportunity>();
		for(Integer x=0; x<NumberOfOtherOpportunities; x++)
		{
			otheropportunities.add(new Opportunity(CloseDate = Date.Today().addDays(5), Name = 'optest_' + String.valueOf(x + NumberOfOpportunities), StageName = 'Prospecting' ));	
		}
		TestDiagnostics2.SetDefaultFields('Opportunity', otheropportunities);	// Used for deployment, not part of this example
		
		insert otheropportunities;
		otheropportunities.addall(newopportunities);	// Combine the two for creating OpportunityContactRoles
		
		// Now insert contact roles
		List<OpportunityContactRole> ocrlist = new List<OpportunityContactRole>();
		Integer contactnumber = 0;
		for(Opportunity op: otheropportunities)
		{
			for(Integer ocrnumber = 0; ocrnumber < ContactRolesPerOp; ocrnumber++)
			{
				ocrlist.add(new OpportunityContactRole(OpportunityID = op.id, ContactID = cts[contactnumber].id));
				contactnumber++;
				if(contactnumber >= NumberOfContacts) contactnumber = 0;
			}
			
		}
		insert ocrlist;
    }
    
    public static void ValidateOCRs(List<Opportunity> ops)
    {
    	// Get map for IDs
    	Map<ID, Opportunity> opmap = new Map<ID, Opportunity>(ops);
    	
/*    	
    	// Query for primary Contacts
    	List<OpportunityContactRole> ocrs = [SELECT ID from OpportunityContactRole where OpportunityID in :opmap.keyset() And IsPrimary= true];
    	
    	// Create set of opportunity IDs with primary contacts
    	Set<ID> OpportunitiesWithPrimaryContact = new Set<ID>();
    	for(OpportunityContactRole ocr: ocrs) OpportunitiesWithPrimaryContact.add(ocr.OpportunityID);
    	
    	// Now make sure every opportunity has a primary contact role
    	for(Opportunity op: ops) System.Assert(OpportunitiesWithPrimaryContact.contains(op.id));
*/

		List<Opportunity> opresults = [SELECT ID, (SELECT ID from OpportunityContactRoles where IsPrimary = true) from opportunity where ID in :opmap.keyset() ];
    	for(Opportunity op: opresults) System.Assert(op.OpportunityContactRoles.size()==1);	
    }
    
    // This test is purely to acheive code coverage for deployment of sample code as a package
    // It is not actually a sample for the book
    static testmethod void GetCodeCoverageOnBulkTest()
    {
    	List<Opportunity> ops = new List<Opportunity>();
		for(Integer x=0; x<5; x++)
		{
			ops.add(new Opportunity(CloseDate = Date.Today().addDays(5), Name = 'optest_' + String.valueOf(x), StageName = 'Prospecting' ));	
		}
		TestDiagnostics2.SetDefaultFields('Opportunity', ops);	// Used for deployment, not part of this example
		insert ops;
		Map<ID, Opportunity> opsmap = new Map<ID, Opportunity>(ops);
		Database.executeBatch(new BulkPatternBatch(opsmap.keyset()), 100);
    	
    }
}