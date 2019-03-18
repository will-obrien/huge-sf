@isTest (oninstall=true)
public class TestDiagnostics2 {

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
    static void CreateTaskTestSingle()
    {
    	CreateTaskTest(1);
    }

    @istest(oninstall=false seealldata=false)
    static void CreateTaskTestBulk()
    {
    	CreateTaskTest(100);
    }

    static void CreateTaskTest(Integer NumberOfOpportunities)
    {
        List<Opportunity> ops = CreateOpportunities('optest_', NumberOfOpportunities);
		for(Opportunity op: ops)
		{
			op.CloseDate = Date.Today().addDays(5);
			op.StageName = 'Prospecting';	
		}
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
    	if(IsTestDisabled(1)) return;
    	
    	List<Opportunity> ops = CreateOpportunities('optest_', NumberOfStageUpdateOpportunities);
    	
        for(Opportunity op: ops)
		{
			op.CloseDate = Date.Today().addDays(5);
			op.StageName = 'Prospecting' ;	
		}
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
        //System.AssertEquals(NumberOfStageUpdateOpportunities, tasks.size());

        System.AssertEquals(NumberOfStageUpdateOpportunities, tasks.size(),'Error in TestTaskCount. Stacktrace: ' + DiagnosticsInstrumentation.ExceptionTrace);
    }    
  
  	static testmethod void TestFakeException()
  	{
  		DiagnosticsMain.FakeException = true;
  		DiagnosticsInstrumentation.DiagnosticsEnabled = true;
    	List<Opportunity> ops = CreateOpportunities('optest_', NumberOfStageUpdateOpportunities);
    	
        for(Opportunity op: ops)
		{
			op.CloseDate = Date.Today().addDays(5);
			op.StageName = 'Prospecting' ;	
		}
		Test.StartTest();
		insert ops;
		Test.StopTest();
		
		List<DebugInfo__c> dbg = [Select ID from DebugInfo__c];
		system.Assert(dbg.size()>0);
		
  	}
  
    // Prepare the specified number of opportunities, with contact roles on each.
    // The contact roles are distributed evenly among the number of contacts specified.
    public static void InitTestObjects(List<Opportunity> newopportunities, Integer NumberOfOpportunities, Integer NumberOfOtherOpportunities, Integer ContactRolesPerOp, Integer NumberOfContacts)
    {
    	if(NumberOfContacts < ContactRolesPerOp) NumberOfContacts = ContactRolesPerOp;

		List<Contact>cts = CreateContacts('cttest_', numberofcontacts);    

		insert cts;

		newopportunities = CreateOpportunities('optest_', NumberOfOpportunities);
		for(Opportunity op: newopportunities)
		{
			op.CloseDate = Date.Today().addDays(5);
			op.StageName = 'Prospecting';	
		}

		// Insert the test opportunities
		insert newopportunities;
		
		List<Opportunity> otheropportunities = CreateOpportunities('optest2_', NumberOfOtherOpportunities);
		for(Opportunity op:otheropportunities)
		{
			op.CloseDate = Date.Today().addDays(5);
			op.StageName = 'Prospecting';	
		}
		insert otheropportunities;
		otheropportunities.addall(newopportunities);	// Combine the two for creating OpportunityContactRoles
		
		// Now insert contact roles
		List<OpportunityContactRole> ocrlist = new List<OpportunityContactRole>();
		Integer contactnumber = 0;
		for(Opportunity op: otheropportunities)
		{
			for(Integer ocrnumber = 0; ocrnumber < ContactRolesPerOp; ocrnumber++)
			{
				// No need to centralize OpportunityContactRole - object is not configurable
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
    
    public static List<Opportunity> CreateOpportunities(String basename, Integer count)
    {
    	List<Opportunity> results = new List<Opportunity>();
    	for(Integer x = 0; x< count; x++)
    	{
			//results.add(new Opportunity(Name = basename + String.valueOf(x) ));
			Opportunity op = (Opportunity)Opportunity.sObjectType.newSObject(null, true);
			op.Name = basename + String.valueOf(x);
			results.add(op);
    	}
		SetDefaultFields('Opportunity', results);
		return results;	
    	
    }
    
    public static List<Contact> CreateContacts(String basename, Integer count)
    {
    	List<Contact> results = new List<Contact>();
    	
    	for(Integer x = 0; x< count; x++)
    	{
			//results.add(new Contact(LastName = basename + String.valueOf(x) ));
			Contact ct = (Contact)Contact.sObjectType.newSObject(null, true);
			ct.LastName = basename + String.valueOf(x);
			results.add(ct);
    	}
		
		return results;	
    	
    }
    
    public static List<Account> CreateAccounts(String basename, Integer count)
    {
    	List<Account> results = new List<Account>();
    	
    	for(Integer x = 0; x< count; x++)
    	{
			//results.add(new Account(Name = basename + String.valueOf(x) ));
			Account act = (Account)Account.sObjectType.newSObject(null, true);
			act.Name = basename + String.valueOf(x);
			results.add(act);
    	}
		
		return results;	
    	
    }


    public static Boolean IsTestDisabled(Integer testnumber)
    {
    	List<StaticResource> resources = [Select Body from StaticResource where Name = 'Apx1Predeployment' ];
    	if(resources.size()==0) return false;
    	String contents = resources[0].Body.ToString();
    	if(contents==null) return false;
    	List<String> lines = contents.split('\\n');
    	for(String line:lines)
    	{
    		List<String> entries = line.split(':');
    		system.debug('entries ' + entries);
    		try
    		{
    			if(entries[0]=='disable' && Integer.valueOf(entries[1].trim())== testnumber) return true;
    		}
    		catch(Exception ex){}
    	}
    	return false;
    }
    
	public static Boolean SetDefaultFields(String objecttype, List<SObject> theobjects)
    {
    	List<StaticResource> resources = [Select Body from StaticResource where Name = 'Apx1Predeployment' ];
    	if(resources.size()==0) return false;
    	String contents = resources[0].Body.ToString();
    	if(contents==null) return false;
    	List<String> lines = contents.split('\\n');
    	for(String line:lines)
    	{
    		List<String> entries = line.split(':');
    		try
    		{
    			if(entries[0]==objecttype)
    			{
    				List<String> fieldinfo = entries[1].split('=');
    				for(SObject obj: theobjects)
    				{
    					obj.put(fieldinfo[0], fieldinfo[1]);	// Implemented only for strings
    				}
    			}
    		}
    		catch(Exception ex){}
    	}
    	return false;
    }
	

    
}