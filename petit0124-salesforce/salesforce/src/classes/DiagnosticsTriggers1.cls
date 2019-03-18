public class DiagnosticsTriggers1 Implements DiagnosticsMain.ITriggerEntry {


	public void MainEntry(String TriggerObject, Boolean IsBefore, Boolean IsDelete, Boolean IsAfter, Boolean IsInsert, Boolean IsUpdate, Boolean IsExecuting, List<SObject> newlist, Map<ID, SObject> newmap, List<SObject> oldlist, Map<ID,SObject> oldmap)
	{
		DiagnosticsInstrumentation.Push('DiagnosticsTriggers1.MainEntry');
		AfterUpdateOpportunityBetterQueries((List<Opportunity>)newlist, (Map<ID,Opportunity>) newmap, (Map<ID,Opportunity>) oldmap, IsInsert, IsUpdate);
		DiagnosticsInstrumentation.Pop();
	}
	public void InProgressEntry(String TriggerObject, Boolean IsBefore, Boolean IsDelete, Boolean IsAfter, Boolean IsInsert, Boolean IsUpdate, Boolean IsExecuting, List<SObject> newlist, Map<ID, SObject> newmap, List<SObject> oldlist, Map<ID,SObject> oldmap)
	{
		// Ignore triggers within triggers
	}

	public static void AfterUpdateOpportunityBetterQueries(List<Opportunity> newlist, Map<ID, Opportunity> newmap, Map<ID, Opportunity> oldmap, Boolean IsInsert, Boolean IsUpdate)
	{
		DiagnosticsInstrumentation.Push('DiagnosticsTriggers1.AfterUpdateOpportunityBetterQueries');

		// Pattern 4 - Implementation with SOQL aggregates
		
		Set<ID> OpportunityIDsWithStagenameChanges = new Set<ID>();
		
		// Get OpportunityContactRoles
		for(Opportunity op: newlist)
		{
			if(op.StageName != oldmap.get(op.id).StageName) OpportunityIDsWithStagenameChanges.add(op.id);
		}
		
		if(OpportunityIDsWithStagenameChanges.size()==0)
		{
			DiagnosticsInstrumentation.Pop();
			return;	// Quick exit if no processing required
		}
			
			
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
		DiagnosticsInstrumentation.Pop();
			
	}
}