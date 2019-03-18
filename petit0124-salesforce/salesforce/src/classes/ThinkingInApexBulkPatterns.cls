public class ThinkingInApexBulkPatterns {

/*
	public static void AfterUpdateOpportunityCommon(List<Opportunity> newlist, Map<ID, Opportunity> newmap, Map<ID, Opportunity> oldmap)
	{
		// Pattern 2 - Straightforward common implementation
		
		Set<ID> OpportunityIDsWithStagenameChanges = new Set<ID>();
		
		// Get OpportunityContactRoles
		for(Opportunity op: newlist)
		{
			if(op.StageName != oldmap.get(op.id).StageName) OpportunityIDsWithStagenameChanges.add(op.id);
		}
		
		if(OpportunityIDsWithStagenameChanges.size()==0) return;	// Quick exit if no processing required
			
			
		// Query for all related OpportunityContactRole
		List<OpportunityContactRole> ocrs = [Select ID, ContactID, IsPrimary, OpportunityID from OpportunityContactRole where OpportunityID in :OpportunityIDsWithStagenameChanges];

		// Look for primary, or for no OCR on opportunities
		Set<ID> primaryfound = new Set<ID>();
		Set<ID> anyfound = new Set<ID>();
		
		for(OpportunityContactRole ocr: ocrs)
		{
			if(ocr.IsPrimary) primaryfound.add(ocr.OpportunityID);
			anyfound.add(ocr.OpportunityID);
		}

		// Build list of opportunities with no contact role, and list with contact role but no primary contact role
		// Use maps because it's an easy way to get the keyset for later queries
		Map<ID, Opportunity> OpsWithNoContactRoles = new Map<ID, Opportunity>();
		Map<ID, Opportunity> OpsWithNoPrimary = new Map<ID, Opportunity>();

		for(ID opid: OpportunityIDsWithStagenameChanges)
		{
			if(!primaryfound.contains(opid))
			{
				if(anyfound.contains(opid)) OpsWithNoPrimary.put(opid, newmap.get(opid));
				else OpsWithNoContactRoles.put(opid, newmap.get(opid));
			}
		}
		
		// First deal with any opportunities without contact roles
		if(OpsWithNoContactRoles.size()>0)
		{
			// Find out which ones have existing tasks
			List<Task> tasks = [SELECT ID, OwnerID, WhatID, Status, Subject, Type from Task where Type='Other' And WhatID in :OpsWithNoContactRoles.keyset() And IsClosed = False And Subject = 'Assign Primary Contact'   ];

			// Don't loop through opportunities - waste of script lines. Loop through tasks to build set of IDs with tasks
			Set<ID> opswithtasks = new Set<ID>();
			for(Task t: tasks)
			{
				Opportunity op = OpsWithNoContactRoles.get(t.WhatID);	// Get the opportunity
				if(t.OwnerID == op.OwnerID) opswithtasks.add(op.ID);	// Make sure it's assigned to the right person
			}
			// Now create new tasks
			List<Task> newtasks = new List<Task>();
			for(Opportunity op: OpsWithNoContactRoles.values())
			{
				if(!opswithtasks.contains(op.id))
				{
					newtasks.add(new Task(OwnerID = op.OwnerID, Type='Other', WhatID = op.ID, Subject = 'Assign Primary Contact', ActivityDate = Date.Today().AddDays(3) ));
				}				
			}
			if(newtasks.size()>0) insert newtasks;
			
		}
		if(OpsWithNoPrimary.size()>0)
		{			
			// Get a list of the contacts
			List<ID> contactidsforops = new List<ID>();
			for(OpportunityContactRole ocr: ocrs)
			{
				if(OpsWithNoPrimary.containskey(ocr.OpportunityID)) contactidsforops.add(ocr.ContactID);
			}
			
			// Now query the contacts with their OpportunityContactRoles
			Map<ID, Contact> contactsforops = new Map<ID, Contact>([Select ID, (Select ID, IsPrimary, OpportunityID from OpportunityContactRoles) from Contact where ID in :contactidsforops]);

			// Now figure out which of the OpportunityContactRoles should be set to primary
			Map<ID,OpportunityContactRole> bestocrs = new Map<ID, OpportunityContactRole>();
			Map<ID,Integer> bestcontactallocrcount = new Map<ID,Integer>();
			Map<ID,Integer> bestcontactprimaryocrcount = new Map<ID, Integer>();
			
			for(OpportunityContactRole ocr: ocrs)
			{
				if(!OpsWithNoPrimary.containskey(ocr.OpportunityID)) continue;
				Contact currentcontact = contactsforops.get(ocr.ContactID);
				Integer primarycount = 0;
				for(OpportunityContactRole testocr: currentcontact.OpportunityContactRoles)
				{
					if(testocr.IsPrimary) primarycount ++;
				}
				if(!bestocrs.containskey(ocr.OpportunityID) || primarycount > bestcontactprimaryocrcount.get(ocr.OpportunityID) ||
					(primarycount == bestcontactallocrcount.get(ocr.OpportunityID) && currentcontact.OpportunityContactRoles.size()> bestcontactallocrcount.get(ocr.OpportunityID)))
				{
					bestocrs.put(ocr.OpportunityID, ocr);
					bestcontactallocrcount.put(ocr.OpportunityID, currentcontact.OpportunityContactRoles.size());
					bestcontactprimaryocrcount.put(ocr.OpportunityID, primarycount);
				}
			}
			
			for(OpportunityContactRole best: bestocrs.values()) best.IsPrimary = true;
			update bestocrs.values();
		}

		
		
		
	}
	

	public static void AfterUpdateOpportunitySets(List<Opportunity> newlist, Map<ID, Opportunity> newmap, Map<ID, Opportunity> oldmap)
	{
		// Pattern 3 - Straightforward common implementation with sets
		
		Set<ID> OpportunityIDsWithStagenameChanges = new Set<ID>();
		
		// Get OpportunityContactRoles
		for(Opportunity op: newlist)
		{
			if(op.StageName != oldmap.get(op.id).StageName) OpportunityIDsWithStagenameChanges.add(op.id);
		}
		
		if(OpportunityIDsWithStagenameChanges.size()==0) return;	// Quick exit if no processing required
			
			
		// Query for all related OpportunityContactRole
		List<OpportunityContactRole> ocrs = [Select ID, ContactID, IsPrimary, OpportunityID from OpportunityContactRole where OpportunityID in :OpportunityIDsWithStagenameChanges];

		// Look for primary, or for no OCR on opportunities
		Set<ID> OpsWithNoPrimary = OpportunityIDsWithStagenameChanges.Clone();
		Set<ID> OpsWithNoContactRoles = OpportunityIDsWithStagenameChanges.Clone();

		
		for(OpportunityContactRole ocr: ocrs)
		{
			if(ocr.IsPrimary) OpsWithNoPrimary.remove(ocr.OpportunityID);
			OpsWithNoContactRoles.remove(ocr.OpportunityID);
		}

		// First deal with any opportunities without contact roles
		if(OpsWithNoContactRoles.size()>0)
		{
			// Find out which ones have existing tasks
			List<Task> tasks = [SELECT ID, OwnerID, WhatID, Status, Subject, Type from Task where Type='Other' And WhatID in :OpsWithNoContactRoles And IsClosed = False And Subject = 'Assign Primary Contact'   ];

			// Don't loop through opportunities - waste of script lines. Loop through tasks to build set of IDs with tasks
			Set<ID> opswithouttasks = OpsWithNoContactRoles.clone();
			for(Task t: tasks)
			{
				Opportunity op = newmap.get(t.WhatID);	// Get the opportunity
				if(t.OwnerID == op.OwnerID) opswithouttasks.remove(op.ID);	// Make sure it's assigned to the right person
			}
			// Now create new tasks
			List<Task> newtasks = new List<Task>();
			for(ID opid: opswithouttasks)
			{
				Opportunity op = newmap.get(opid);
				newtasks.add(new Task(OwnerID = op.OwnerID, Type='Other', WhatID = op.ID, Subject = 'Assign Primary Contact', ActivityDate = Date.Today().AddDays(3) ));
			}
			if(newtasks.size()>0) insert newtasks;
			
		}
		if(OpsWithNoPrimary.size()>0)
		{			
			// Get a list of the contacts
			List<ID> contactidsforops = new List<ID>();
			for(OpportunityContactRole ocr: ocrs)
			{
				if(OpsWithNoPrimary.contains(ocr.OpportunityID)) contactidsforops.add(ocr.ContactID);
			}
			
			// Now query the contacts with their OpportunityContactRoles
			Map<ID, Contact> contactsforops = new Map<ID, Contact>([Select ID, (Select ID, IsPrimary, OpportunityID from OpportunityContactRoles) from Contact where ID in :contactidsforops]);

			// Now figure out which of the OpportunityContactRoles should be set to primary
			Map<ID,OpportunityContactRole> bestocrs = new Map<ID, OpportunityContactRole>();
			Map<ID,Integer> bestcontactallocrcount = new Map<ID,Integer>();
			Map<ID,Integer> bestcontactprimaryocrcount = new Map<ID, Integer>();
			
			for(OpportunityContactRole ocr: ocrs)
			{
				if(!OpsWithNoPrimary.contains(ocr.OpportunityID)) continue;
				Contact currentcontact = contactsforops.get(ocr.ContactID);
				Integer primarycount = 0;
				for(OpportunityContactRole testocr: currentcontact.OpportunityContactRoles)
				{
					if(testocr.IsPrimary) primarycount ++;
				}
				if(!bestocrs.containskey(ocr.OpportunityID) || primarycount > bestcontactprimaryocrcount.get(ocr.OpportunityID) ||
					(primarycount == bestcontactallocrcount.get(ocr.OpportunityID) && currentcontact.OpportunityContactRoles.size()> bestcontactallocrcount.get(ocr.OpportunityID)))
				{
					bestocrs.put(ocr.OpportunityID, ocr);
					bestcontactallocrcount.put(ocr.OpportunityID, currentcontact.OpportunityContactRoles.size());
					bestcontactprimaryocrcount.put(ocr.OpportunityID, primarycount);
				}
			}
			
			for(OpportunityContactRole best: bestocrs.values()) best.IsPrimary = true;
			update bestocrs.values();
		}

		
		
		
	}
	
	public static void AfterUpdateOpportunityBetterQueries(List<Opportunity> newlist, Map<ID, Opportunity> newmap, Map<ID, Opportunity> oldmap)
	{
		// Pattern 4 - Implementation with SOQL aggregates
		
		Set<ID> OpportunityIDsWithStagenameChanges = new Set<ID>();
		
		// Get OpportunityContactRoles
		for(Opportunity op: newlist)
		{
			if(op.StageName != oldmap.get(op.id).StageName) OpportunityIDsWithStagenameChanges.add(op.id);
		}
		
		if(OpportunityIDsWithStagenameChanges.size()==0) return;	// Quick exit if no processing required
			
			
		// Query for all related OpportunityContactRole
		List<OpportunityContactRole> ocrs = [Select ID, ContactID, IsPrimary, OpportunityID from OpportunityContactRole where OpportunityID in :OpportunityIDsWithStagenameChanges];

		// Look for primary, or for no OCR on opportunities
		Set<ID> OpsWithNoPrimaryWithContactRoles = OpportunityIDsWithStagenameChanges.Clone();
		Set<ID> OpsWithNoContactRoles = OpportunityIDsWithStagenameChanges.Clone();

		
		for(OpportunityContactRole ocr: ocrs)
		{
			if(ocr.IsPrimary) OpsWithNoPrimaryWithContactRoles.remove(ocr.OpportunityID);
			OpsWithNoContactRoles.remove(ocr.OpportunityID);
		}
		OpsWithNoPrimaryWithContactRoles.RemoveAll(OpsWithNoContactRoles);

		// First deal with any opportunities without contact roles
		if(OpsWithNoContactRoles.size()>0)
		{
			// Find out which ones have existing tasks
			List<Task> tasks = [SELECT ID, OwnerID, WhatID, Status, Subject, Type from Task where Type='Other' And WhatID in :OpsWithNoContactRoles And IsClosed = False And Subject = 'Assign Primary Contact'   ];

			// Don't loop through opportunities - waste of script lines. Loop through tasks to build set of IDs with tasks
			Set<ID> opswithouttasks = OpsWithNoContactRoles.clone();
			for(Task t: tasks)
			{
				Opportunity op = newmap.get(t.WhatID);	// Get the opportunity
				if(t.OwnerID == op.OwnerID) opswithouttasks.remove(op.ID);	// Make sure it's assigned to the right person
			}
			// Now create new tasks
			List<Task> newtasks = new List<Task>();
			for(ID opid: opswithouttasks)
			{
				Opportunity op = newmap.get(opid);
				newtasks.add(new Task(OwnerID = op.OwnerID, Type='Other', WhatID = op.ID, Subject = 'Assign Primary Contact', ActivityDate = Date.Today().AddDays(3) ));
			}
			if(newtasks.size()>0) insert newtasks;
			
		}
		if(OpsWithNoPrimaryWithContactRoles.size()>0)
		{			
			// Get a list of the contacts
			List<ID> contactidsforops = new List<ID>();
			for(OpportunityContactRole ocr: ocrs)
			{
				if(OpsWithNoPrimaryWithContactRoles.contains(ocr.OpportunityID)) contactidsforops.add(ocr.ContactID);
			}
			
			// Now get the totals count and primary count for each contact by using aggregate functions and grouping by contact
			List<AggregateResult> ocrsbycontact = [Select ContactID, Count(ID) total from OpportunityContactRole where ContactID in :contactidsforops Group By ContactID];
			List<AggregateResult> primaryocrsbycontact = [Select ContactID, Count(ID) total from OpportunityContactRole where IsPrimary=true and ContactID in :contactidsforops Group By ContactID];

			// Let's get the totals by contact for faster loop
			Map<ID, Integer> totalsbycontact = new Map<ID, Integer>();
			Map<ID, Integer> primarybycontact = new Map<ID, Integer>();
			for(AggregateResult ar: ocrsbycontact) totalsbycontact.put((ID)ar.get('ContactID'), Integer.ValueOf(ar.get('total')));
			for(AggregateResult ar: primaryocrsbycontact) primarybycontact.put((ID)ar.get('ContactID'), Integer.ValueOf(ar.get('total')));

			List<Opportunity> OpportunitiesWithoutPrimary = [Select ID ,(Select ID, ContactID, IsPrimary from OpportunityContactRoles) from Opportunity where ID in :OpsWithNoPrimaryWithContactRoles];
			List<OpportunityContactRole> ocrstoupdate = new List<OpportunityContactRole>();
			
			for(Opportunity op: OpportunitiesWithoutPrimary)
			{
				OpportunityContactRole bestocr = null;
				Integer primarycount = 0;
				Integer totalcount = 0;
				for(OpportunityContactRole opocrs: op.OpportunityContactRoles)
				{
					if(bestocr==null || primarybycontact.get(opocrs.contactid) > primarycount ||
					   (primarybycontact.get(opocrs.contactid) == totalcount && 
					    totalsbycontact.get(opocrs.contactid) > totalcount ))
					   primarycount = primarybycontact.get(opocrs.contactid);
					   totalcount = totalsbycontact.get(opocrs.contactid);
					   bestocr = opocrs;
				}
				bestocr.IsPrimary = true;
				ocrstoupdate.add(bestocr);
			}
			update ocrstoupdate;
		}		
	}


	@future
	public static void FutureUpdateOpportunities(Set<ID> opportunitiyids)
	{
		Map<ID, Opportunity> newmap = new Map<ID, Opportunity>([SELECT ID, OwnerID from Opportunity where ID in :opportunitiyids]);
		AfterUpdateOpportunityFutureSupport(newmap.values(), newmap, null);
	}
	private static Boolean FutureCalled = false;

	public static void AfterUpdateOpportunityFutureSupport(List<Opportunity> newlist, Map<ID, Opportunity> newmap, Map<ID, Opportunity> oldmap)
	{
		// Pattern 5 - with future support
		
		Set<ID> OpportunityIDsWithStagenameChanges = new Set<ID>();
		
		// Get OpportunityContactRoles
		if(!System.isFuture())
		{
			for(Opportunity op: newlist)
			{
				if(op.StageName != oldmap.get(op.id).StageName) OpportunityIDsWithStagenameChanges.add(op.id);
			}
			if(newlist.size()>100)
			{
				if(!FutureCalled) FutureUpdateOpportunities(OpportunityIDsWithStagenameChanges);
				FutureCalled = true;
				return;
			}
		}
		else OpportunityIDsWithStagenameChanges.addall(newmap.keyset());
		
		if(OpportunityIDsWithStagenameChanges.size()==0) return;	// Quick exit if no processing required
			
			
		// Query for all related OpportunityContactRole
		List<OpportunityContactRole> ocrs = [Select ID, ContactID, IsPrimary, OpportunityID from OpportunityContactRole where OpportunityID in :OpportunityIDsWithStagenameChanges];

		// Look for primary, or for no OCR on opportunities
		Set<ID> OpsWithNoPrimaryWithContactRoles = OpportunityIDsWithStagenameChanges.Clone();
		Set<ID> OpsWithNoContactRoles = OpportunityIDsWithStagenameChanges.Clone();

		
		for(OpportunityContactRole ocr: ocrs)
		{
			if(ocr.IsPrimary) OpsWithNoPrimaryWithContactRoles.remove(ocr.OpportunityID);
			OpsWithNoContactRoles.remove(ocr.OpportunityID);
		}
		OpsWithNoPrimaryWithContactRoles.RemoveAll(OpsWithNoContactRoles);

		// First deal with any opportunities without contact roles
		if(OpsWithNoContactRoles.size()>0)
		{
			// Find out which ones have existing tasks
			List<Task> tasks = [SELECT ID, OwnerID, WhatID, Status, Subject, Type from Task where Type='Other' And WhatID in :OpsWithNoContactRoles And IsClosed = False And Subject = 'Assign Primary Contact'   ];

			// Don't loop through opportunities - waste of script lines. Loop through tasks to build set of IDs with tasks
			Set<ID> opswithouttasks = OpsWithNoContactRoles.clone();
			for(Task t: tasks)
			{
				Opportunity op = newmap.get(t.WhatID);	// Get the opportunity
				if(t.OwnerID == op.OwnerID) opswithouttasks.remove(op.ID);	// Make sure it's assigned to the right person
			}
			// Now create new tasks
			List<Task> newtasks = new List<Task>();
			for(ID opid: opswithouttasks)
			{
				Opportunity op = newmap.get(opid);
				newtasks.add(new Task(OwnerID = op.OwnerID, Type='Other', WhatID = op.ID, Subject = 'Assign Primary Contact', ActivityDate = Date.Today().AddDays(3) ));
			}
			if(newtasks.size()>0) insert newtasks;
			
		}
		if(OpsWithNoPrimaryWithContactRoles.size()>0)
		{			
			// Get a list of the contacts
			List<ID> contactidsforops = new List<ID>();
			for(OpportunityContactRole ocr: ocrs)
			{
				if(OpsWithNoPrimaryWithContactRoles.contains(ocr.OpportunityID)) contactidsforops.add(ocr.ContactID);
			}
			
			// Now get the totals count and primary count for each contact by using aggregate functions and grouping by contact
			List<AggregateResult> ocrsbycontact = [Select ContactID, Count(ID) total from OpportunityContactRole where ContactID in :contactidsforops Group By ContactID];
			List<AggregateResult> primaryocrsbycontact = [Select ContactID, Count(ID) total from OpportunityContactRole where IsPrimary=true and ContactID in :contactidsforops Group By ContactID];

			// Let's get the totals by contact for faster loop
			Map<ID, Integer> totalsbycontact = new Map<ID, Integer>();
			Map<ID, Integer> primarybycontact = new Map<ID, Integer>();
			for(AggregateResult ar: ocrsbycontact) totalsbycontact.put((ID)ar.get('ContactID'), Integer.ValueOf(ar.get('total')));
			for(AggregateResult ar: primaryocrsbycontact) primarybycontact.put((ID)ar.get('ContactID'), Integer.ValueOf(ar.get('total')));

			List<Opportunity> OpportunitiesWithoutPrimary = [Select ID ,(Select ID, ContactID, IsPrimary from OpportunityContactRoles) from Opportunity where ID in :OpsWithNoPrimaryWithContactRoles];
			List<OpportunityContactRole> ocrstoupdate = new List<OpportunityContactRole>();
			
			for(Opportunity op: OpportunitiesWithoutPrimary)
			{
				OpportunityContactRole bestocr = null;
				Integer primarycount = 0;
				Integer totalcount = 0;
				for(OpportunityContactRole opocrs: op.OpportunityContactRoles)
				{
					if(bestocr==null || primarybycontact.get(opocrs.contactid) > primarycount ||
					   (primarybycontact.get(opocrs.contactid) == totalcount && 
					    totalsbycontact.get(opocrs.contactid) > totalcount ))
					   primarycount = primarybycontact.get(opocrs.contactid);
					   totalcount = totalsbycontact.get(opocrs.contactid);
					   bestocr = opocrs;
				}
				bestocr.IsPrimary = true;
				ocrstoupdate.add(bestocr);
			}
			update ocrstoupdate;
		}		
	}

	private static Boolean BatchCalled = false;

	public static void AfterUpdateOpportunityBatchSupport(List<Opportunity> newlist, Map<ID, Opportunity> newmap, Map<ID, Opportunity> oldmap)
	{
		// Pattern 6 - with batch support
		
		Set<ID> OpportunityIDsWithStagenameChanges = new Set<ID>();
		
		// Get OpportunityContactRoles
		if(!System.isBatch())
		{
			for(Opportunity op: newlist)
			{
				if(op.StageName != oldmap.get(op.id).StageName) OpportunityIDsWithStagenameChanges.add(op.id);
			}
			if(newlist.size()>100)
			{
				if(!BatchCalled) 
				{
					Database.executeBatch(new BulkPatternBatch(OpportunityIDsWithStagenameChanges), 100);
				}
				BatchCalled = true;
				return;
			}
		}
		else OpportunityIDsWithStagenameChanges.addall(newmap.keyset());
		
		if(OpportunityIDsWithStagenameChanges.size()==0) return;	// Quick exit if no processing required
			
			
		// Query for all related OpportunityContactRole
		List<OpportunityContactRole> ocrs = [Select ID, ContactID, IsPrimary, OpportunityID from OpportunityContactRole where OpportunityID in :OpportunityIDsWithStagenameChanges];

		// Look for primary, or for no OCR on opportunities
		Set<ID> OpsWithNoPrimaryWithContactRoles = OpportunityIDsWithStagenameChanges.Clone();
		Set<ID> OpsWithNoContactRoles = OpportunityIDsWithStagenameChanges.Clone();

		
		for(OpportunityContactRole ocr: ocrs)
		{
			if(ocr.IsPrimary) OpsWithNoPrimaryWithContactRoles.remove(ocr.OpportunityID);
			OpsWithNoContactRoles.remove(ocr.OpportunityID);
		}
		OpsWithNoPrimaryWithContactRoles.RemoveAll(OpsWithNoContactRoles);

		// First deal with any opportunities without contact roles
		if(OpsWithNoContactRoles.size()>0)
		{
			// Find out which ones have existing tasks
			List<Task> tasks = [SELECT ID, OwnerID, WhatID, Status, Subject, Type from Task where Type='Other' And WhatID in :OpsWithNoContactRoles And IsClosed = False And Subject = 'Assign Primary Contact'   ];

			// Don't loop through opportunities - waste of script lines. Loop through tasks to build set of IDs with tasks
			Set<ID> opswithouttasks = OpsWithNoContactRoles.clone();
			for(Task t: tasks)
			{
				Opportunity op = newmap.get(t.WhatID);	// Get the opportunity
				if(t.OwnerID == op.OwnerID) opswithouttasks.remove(op.ID);	// Make sure it's assigned to the right person
			}
			// Now create new tasks
			List<Task> newtasks = new List<Task>();
			for(ID opid: opswithouttasks)
			{
				Opportunity op = newmap.get(opid);
				newtasks.add(new Task(OwnerID = op.OwnerID, Type='Other', WhatID = op.ID, Subject = 'Assign Primary Contact', ActivityDate = Date.Today().AddDays(3) ));
			}
			if(newtasks.size()>0) insert newtasks;
			
		}
		if(OpsWithNoPrimaryWithContactRoles.size()>0)
		{			
			// Get a list of the contacts
			List<ID> contactidsforops = new List<ID>();
			for(OpportunityContactRole ocr: ocrs)
			{
				if(OpsWithNoPrimaryWithContactRoles.contains(ocr.OpportunityID)) contactidsforops.add(ocr.ContactID);
			}
			
			// Now get the totals count and primary count for each contact by using aggregate functions and grouping by contact
			List<AggregateResult> ocrsbycontact = [Select ContactID, Count(ID) total from OpportunityContactRole where ContactID in :contactidsforops Group By ContactID];
			List<AggregateResult> primaryocrsbycontact = [Select ContactID, Count(ID) total from OpportunityContactRole where IsPrimary=true and ContactID in :contactidsforops Group By ContactID];

			// Let's get the totals by contact for faster loop
			Map<ID, Integer> totalsbycontact = new Map<ID, Integer>();
			Map<ID, Integer> primarybycontact = new Map<ID, Integer>();
			for(AggregateResult ar: ocrsbycontact) totalsbycontact.put((ID)ar.get('ContactID'), Integer.ValueOf(ar.get('total')));
			for(AggregateResult ar: primaryocrsbycontact) primarybycontact.put((ID)ar.get('ContactID'), Integer.ValueOf(ar.get('total')));

			List<Opportunity> OpportunitiesWithoutPrimary = [Select ID ,(Select ID, ContactID, IsPrimary from OpportunityContactRoles) from Opportunity where ID in :OpsWithNoPrimaryWithContactRoles];
			List<OpportunityContactRole> ocrstoupdate = new List<OpportunityContactRole>();
			
			for(Opportunity op: OpportunitiesWithoutPrimary)
			{
				OpportunityContactRole bestocr = null;
				Integer primarycount = 0;
				Integer totalcount = 0;
				for(OpportunityContactRole opocrs: op.OpportunityContactRoles)
				{
					if(bestocr==null || primarybycontact.get(opocrs.contactid) > primarycount ||
					   (primarybycontact.get(opocrs.contactid) == totalcount && 
					    totalsbycontact.get(opocrs.contactid) > totalcount ))
					   primarycount = primarybycontact.get(opocrs.contactid);
					   totalcount = totalsbycontact.get(opocrs.contactid);
					   bestocr = opocrs;
				}
				bestocr.IsPrimary = true;
				ocrstoupdate.add(bestocr);
			}
			update ocrstoupdate;
		}		
	}
*/
	
	/* Bad implementation. Not included in the book - just used for limits comparison */
/*	
	public static void AfterUpdateOpportunityAwful(List<Opportunity> newlist, Map<ID, Opportunity> oldmap)
	{
		// Pattern 1 - terrible implementation
		
		// Get OpportunityContactRoles
		for(Opportunity op: newlist)
		{
			if(op.StageName == oldmap.get(op.id).StageName) continue;	// Only process changes to stagename
			
			List<OpportunityContactRole> ocrs = [Select ID, ContactID, IsPrimary from OpportunityContactRole where OpportunityID = :op.id];
			
			if(ocrs.size()==0)
			{
				// No associated contacts at all - create a new task for the owner to create said contact
				// Is task already set?
				List<Task> tasks = [SELECT ID, OwnerID, WhatID, Status, Subject, Type from Task where OwnerID = :op.OwnerID And Type='Other' And WhatID = :op.ID And IsClosed = False And Subject = 'Assign Primary Contact'   ];
				if(tasks.size()>0) continue;	// Already set
				Task t = new Task(OwnerID = op.OwnerID, Type='Other', WhatID = op.ID, Subject = 'Assign Primary Contact', ActivityDate = Date.Today().AddDays(3) );
				insert t;
				continue;
			}
			
			// If primary exists, we're done
			Boolean primaryfound = false;
			for(OpportunityContactRole ocr: ocrs)
			{
				if(ocr.IsPrimary)
				{
					primaryfound = true;
					break;
				}
				
			}
			if(primaryfound) continue;
			
			// Get a list of the contacts
			List<ID> contactidsforops = new List<ID>();
			for(OpportunityContactRole ocr: ocrs)
			{
				contactidsforops.add(ocr.ContactID);
			}
			
			// Now query the contacts with their OpportunityContactRoles
			Map<ID, Contact> contactsforops = new Map<ID, Contact>([Select ID, (Select ID, IsPrimary from OpportunityContactRoles) from Contact where ID in :contactidsforops]);

			// Now figure out which of the OpportunityContactRoles should be set to primary
			OpportunityContactRole bestocr = null;
			Integer bestcontactallocrcount = 0;
			Integer bestcontactprimaryocrcount = 0;
			
			for(OpportunityContactRole ocr: ocrs)
			{
				Contact currentcontact = contactsforops.get(ocr.ContactID);
				Integer primarycount = 0;
				for(OpportunityContactRole testocr: currentcontact.OpportunityContactRoles)
				{
					if(testocr.IsPrimary) primarycount ++;
				}
				if(bestocr == null || primarycount > bestcontactprimaryocrcount ||
					(primarycount == bestcontactallocrcount && currentcontact.OpportunityContactRoles.size()> bestcontactallocrcount))
				{
					bestocr = ocr;
					bestcontactallocrcount = currentcontact.OpportunityContactRoles.size();
					bestcontactprimaryocrcount = primarycount;
				}
			}
			bestocr.IsPrimary = true;
			update bestocr;
		}

		
	}
*/	
}