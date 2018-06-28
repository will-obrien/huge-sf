trigger GameTrigger on Unit__c (before insert, before update, after delete) 
{
	if(Trigger.isInsert)
	{
		List<Unit__c> unitList = new List<Unit__c>([SELECT Name, Win__c, Position__c
													FROM Unit__c WHERE Id NOT IN : Trigger.new]);
		Integer lastPosition = unitList.size();
		for(Unit__c unit : Trigger.new)
		{
			unit.Position__c = ++lastPosition;
		}
	}

	if(Trigger.isUpdate)
	{
		if(Trigger.new[0].Win__c != Trigger.old[0].Win__c || Trigger.new[0].Loss__c != Trigger.old[0].Loss__c)
		{
			List<Unit__c> unitList = new List<Unit__c>([SELECT Name, Win__c, Loss__c, Position__c
														FROM Unit__c WHERE Id NOT IN : Trigger.new 
														AND (Win__c != 0 OR Loss__c != 0)]);
			unitList.addAll(Trigger.new);
			for(Integer i = 0; i < unitList.size(); i++)
			{
				for(Integer j = 0; j < unitList.size() - 1; j++)
				{		
					if(unitList[j].Win__c / (unitList[j].Win__c  +  unitList[j].Loss__c)  < 
						unitList[j + 1].Win__c / (unitList[j + 1].Win__c  +  unitList[j + 1].Loss__c))
					{
						Unit__c unitTemp = unitList[j];
						unitList[j] = unitList[j + 1];
						unitList[j + 1] = unitTemp;
					}
				}	
			}
			for(Integer i = 0; i < unitList.size(); i++)
			{
				unitList[i].Position__c = i + 1;
			}
			Set<Unit__c> newUnitSet = new Set<Unit__c>();
			newUnitSet.addAll(Trigger.new);
			List<Unit__c> unitUpdateList = new List<Unit__c>();
			for(Unit__c unit : unitList)
			{
				if(!newUnitSet.contains(unit))
				{
					unitUpdateList.add(unit);
				}
			}
			List<Unit__c> unitWithoutPlayList = new List<Unit__c>([SELECT Name, Win__c, Loss__c, Position__c
																	FROM Unit__c WHERE Id NOT IN : Trigger.new 
																	AND (Win__c = 0 AND Loss__c = 0)]);
			Integer lastPosition = unitList.size();
			for(Unit__c unit : unitWithoutPlayList)
			{
				unit.Position__c = ++lastPosition;
			}
			unitUpdateList.addAll(unitWithoutPlayList);
			update unitUpdateList;
		}
	}

	if(Trigger.isDelete)
	{
		List<Unit__c> unitList = new List<Unit__c>([SELECT Name, Win__c, Loss__c, Position__c
													FROM Unit__c WHERE Win__c != 0 OR Loss__c != 0]);
		for(Integer i = 0; i < unitList.size(); i++)
		{
			for(Integer j = 0; j < unitList.size() - 1; j++)
			{		
				if(unitList[j].Win__c / (unitList[j].Win__c  +  unitList[j].Loss__c)  < 
					unitList[j + 1].Win__c / (unitList[j + 1].Win__c  +  unitList[j + 1].Loss__c))
				{
					Unit__c unitTemp = unitList[j];
					unitList[j] = unitList[j + 1];
					unitList[j + 1] = unitTemp;
				}
			}	
		}
		for(Integer i = 0; i < unitList.size(); i++)
		{
			unitList[i].Position__c = i + 1;
		}
		List<Unit__c> unitWithoutPlayList = new List<Unit__c>([SELECT Name, Win__c, Loss__c, Position__c
																FROM Unit__c WHERE Win__c = 0 AND Loss__c = 0]);
		Integer lastPosition = unitList.size();
		for(Unit__c unit : unitWithoutPlayList)
		{
			unit.Position__c = ++lastPosition;
		}
		unitList.addAll(unitWithoutPlayList);
		update unitList;
	}
}