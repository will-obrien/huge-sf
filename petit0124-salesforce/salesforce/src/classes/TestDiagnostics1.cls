@isTest
private class TestDiagnostics1 {

    static testMethod void UpdateOpportunityTest() {
        List<Opportunity> ops = new List<Opportunity>();
        InitTestObjects(ops, 100, 100, 40, 80);
        
        DiagnosticsInstrumentation.Debug('Starting testing: UpdateOpportunityTest');
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

        DiagnosticsInstrumentation.Debug('Starting testing: CreateTastTest');
        Test.StartTest();
        for(Opportunity op: ops) op.StageName = 'Qualification';
        update ops;
        Test.StopTest();

		List<Task> tasks = [SELECT ID, OwnerID, WhatID, Status, Subject, Type from Task where OwnerID = :UserInfo.getUserID() And Type='Other' And IsClosed = False And Subject = 'Assign Primary Contact'   ];
		system.assertEquals(NumberOfOpportunities, tasks.size());
    	
    }
    
	private static final Integer NumberOfStageUpdateOpportunities = 5;
    
    static testMethod void TestTaskCount() {
    	if(TestDiagnostics2.IsTestDisabled(1)) return;	// Used for deployment, not part of the sample
    	
    	List<Opportunity> ops = new List<Opportunity>();
    	
        for(Integer x=0; x<NumberOfStageUpdateOpportunities; x++)
		{
			ops.add(new Opportunity(CloseDate = Date.Today().addDays(5), Name = 'optest_' + String.valueOf(x), StageName = 'Prospecting' ));	
		}
		TestDiagnostics2.SetDefaultFields('Opportunity', ops);	// Used for deployment, not part of this example
		
		insert ops;
        
        for(Opportunity op: ops)
        {
        	op.StageName = 'Negotiation/Review';
        }
        Test.StartTest();
        update ops;
        Test.StopTest();
        
        Map<ID, Opportunity> opmap = new Map<ID, Opportunity>(ops);
        
        List<task> tasks = [Select ID, WhatID from Task where WhatID in :opmap.keyset() And Subject ='Opportunity stage update'];
        System.AssertEquals(NumberOfStageUpdateOpportunities, tasks.size());
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
    	
		List<Opportunity> opresults = [SELECT ID, (SELECT ID from OpportunityContactRoles where IsPrimary = true) from opportunity where ID in :opmap.keyset() ];
    	for(Opportunity op: opresults) System.Assert(op.OpportunityContactRoles.size()==1);	
    }
}