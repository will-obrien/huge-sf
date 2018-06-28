@isTest
private class FunWithCollections {

	static testMethod void QuickSet()
	{
		List<Contact>cts = new List<Contact>();    
		for(Integer x=0;x<5;x++)    
		{      
			cts.add(new Contact(LastName = 'cttest_' + String.valueOf(x)));
		}
		
		insert cts;
		
		Set<ID> contactids = new Set<ID>();
		for(Contact ct: cts) contactids.add(ct.id);

		List<Task> tasks = [Select ID from Task where Whoid in :contactids Limit 500];
		
		Map<ID, Contact> contactmap = new Map<ID, Contact>(cts);
		
		List<Task> tasks2 = [Select ID from Task where Whoid in :contactmap.keyset() Limit 500];
		
	}



	static testMethod void CollectionGroup()
	{
		List<Contact>cts = new List<Contact>();    
		for(Integer x=0;x<50;x++)    
		{      
			cts.add(new Contact(LastName = 'cttest_' + String.valueOf(x)));
		}
		
		insert cts;
		
		List<Task> newtasks = new List<Task>();
		for(Integer x=0; x<50; x++)
		{
			newtasks.add(new Task(WhoID = cts[x].id, ActivityDate = Date.Today().addDays(x), Description='some task', Type='Call'));			
		}
		insert newtasks;
		
		// cts is the list of input contacts
		Map<ID, Contact> contactmap = new Map<ID, Contact>(cts);
		
		List<Task> tasks = [Select ID, ActivityDate, Description from Task where Whoid in :contactmap.keyset() Order By ActivityDate Desc Limit 500];
		
		Map<Date, List<Task>> tasksbyweek = new Map<Date, List<Task>>();
		
		for(Task t: tasks)
		{
			// Perform global task operation here
			
			
			// Group by week
			Date weekstart = t.ActivityDate.toStartOfWeek();
			if(tasksbyweek.get(weekstart)==null) tasksbyweek.put(weekstart, new List<Task>());
			tasksbyweek.get(weekstart).add(t);
			
			// Perform week related operation here
		}
		
		system.debug(tasksbyweek);
		
		
	}

	static testMethod void casesensitivity()
	{
		Map<String,Integer> intmap = new Map<String,Integer>{'A'=>0, 'b'=>1, 'C'=>2};
		system.assert(!intmap.containskey('a'));
		system.assert(!intmap.containskey('B'));

	}

    static testMethod void caseOnDescribe() {
        // Get global describe
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        
        System.Assert(gd.ContainsKey('CampaignMember'));
        System.Assert(gd.ContainsKey('campaignmember'));
        System.Assert(gd.ContainsKey('CAMPAIGNMEMBER'));
        system.debug(gd);

        System.Assert(gd.keyset().Contains('campaignmember'));
        System.Assert(!gd.keyset().Contains('CampaignMember'));
        System.Assert(!gd.keyset().Contains('CAMPAIGNMEMBER'));
        
    }
    
    static testMethod void objectKeys()
    {
		List<Contact>cts = new List<Contact>();    
		for(Integer x=0;x<5;x++)    
		{      
			cts.add(new Contact(LastName = 'cttest_' + String.valueOf(x)));
		}
		
		insert cts;

		// Create a map keyed on contacts
		Map<Contact, Integer> contactmap = new Map<Contact, Integer>();
		
		for(Integer x = 0; x< 5; x++)
		{
			contactmap.put(cts[x], x);
		}

		system.assertEquals(contactmap.size(),5);
		
		// Create another list to reference these
		List<Contact> samecontacts = new List<Contact>(cts);

		for(Integer x = 0; x< 5; x++)
		{
			samecontacts[x].AssistantName = 'person' + string.ValueOf(x);
			system.assertEquals(cts[x].AssistantName ,samecontacts[x].AssistantName);
			system.assertNotEquals(contactmap.get(cts[x]), x);
			contactmap.put(samecontacts[x], x);
		}
		system.assertNotEquals(contactmap.size(),5);
		
    	
    }

    static testMethod void objectSets()
    {
		List<Contact>cts = new List<Contact>();    
		for(Integer x=0;x<5;x++)    
		{      
			cts.add(new Contact(LastName = 'cttest_' + String.valueOf(x)));
		}
		
		insert cts;

		// Create a map keyed on contacts
		Set<Contact> contactset = new Set<Contact>();
		
		for(Integer x = 0; x< 5; x++)
		{
			contactset.add(cts[x]);
		}

		system.assertEquals(contactset.size(),5);
		
		// Create another list to reference these
		List<Contact> samecontacts = new List<Contact>(cts);

		for(Integer x = 0; x< 5; x++)
		{
			samecontacts[x].AssistantName = 'person' + string.ValueOf(x);
			system.assertEquals(cts[x].AssistantName ,samecontacts[x].AssistantName);
			system.assert(!contactset.contains(cts[x]));
			contactset.add(samecontacts[x]);
		}
		system.assertNotEquals(contactset.size(),5);
		
    	
    }
    
    static testMethod void objectKeysCorrect()
    {
		List<Contact>cts = new List<Contact>();    
		for(Integer x=0;x<5;x++)    
		{      
			cts.add(new Contact(LastName = 'cttest_' + String.valueOf(x)));
		}
		
		insert cts;

		// Create a map keyed on contacts
		Map<ID, Integer> contactmap = new Map<ID, Integer>();
		
		for(Integer x = 0; x< 5; x++)
		{
			contactmap.put(cts[x].id, x);
		}

		system.assertEquals(contactmap.size(),5);
		
		// Create another list to reference these
		List<Contact> samecontacts = new List<Contact>(cts);

		for(Integer x = 0; x< 5; x++)
		{
			samecontacts[x].AssistantName = 'person' + string.ValueOf(x);
			system.assertEquals(cts[x].AssistantName ,samecontacts[x].AssistantName);
			system.assertEquals(contactmap.get(cts[x].id), x);
			contactmap.put(samecontacts[x].id, x);
		}
		system.assertEquals(contactmap.size(),5);
		
    	
    }    

	static testMethod void LimitUpdates()
	{
		List<Contact>cts = new List<Contact>();    
		for(Integer x=0;x<50;x++)    
		{      
			cts.add(new Contact(LastName = 'cttest_' + String.valueOf(x)));
		}
		
		insert cts;
		
		Map<ID,Contact> contactstoupdate = new Map<ID, Contact>();
		
		// First set of operations
		for(Contact ct: cts)
		{
			// Do various operations
			// If an update is needed:
			contactstoupdate.put(ct.id, ct);
			
		}
		
		// Second set of operations
		for(Contact ct: cts)
		{
			// Do various operations
			// If an update is needed:
			contactstoupdate.put(ct.id, ct);
			
		}

		
		
		if(contactstoupdate.size()>0) update contactstoupdate.values();
		
		
	}
    
}