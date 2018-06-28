trigger UnitPlaceInTop on Unit__c (before update)  
{   
    List<Unit__c> changedUnits = new List<Unit__c>();
    for (Unit__c unit: Trigger.new)
    {
        if (Trigger.oldMap.get(unit.ID).Winn__c != Trigger.newMap.get(unit.ID).Winn__c)
        {
            changedUnits.add(unit);
        }
    }
    
    if (changedUnits.size() > 0)
    {
        List<Unit__c> notChangedUnits = [SELECT ID, Name, Winn__c, Position_in_top__c FROM Unit__c 
                                         WHERE ID NOT IN :Trigger.new];
        List<Unit__c> newUnits = Trigger.new;
        List<Unit__c> allUnits = new List<Unit__c>();
        allUnits.addAll(newUnits);
        allUnits.addAll(notChangedUnits);
        
        List<UnitSorter> sortUnits = new List<UnitSorter>();
        
        for (Unit__c unit: allUnits)
        {
            UnitSorter sorter = new UnitSorter(unit);
            sortUnits.add(sorter);
        }
        sortUnits.sort();

        List<Unit__c> updateUnits = new List<Unit__c>();
        Integer position = 0;
        for (UnitSorter sorter: sortUnits)
        {
            
            Unit__c unit = sorter.unit;
            position++;
            unit.Position_in_top__c = position;
            if (!(Trigger.newMap.containsKey(unit.ID)))
            {
            	updateUnits.add(unit);
            }
        }
        update updateUnits;
    }
}