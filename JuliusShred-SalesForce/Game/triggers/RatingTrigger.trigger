/**
* This is Trigger that fires when record is preparing to be update 
* It refreshes the unit's positinion in top and unit's percent ofvictories
*/
trigger RatingTrigger on Unit__c (before update) 
{   
    if(Trigger.isUpdate)
    {
        Integer unitsThatFighted  = 0;
        Integer unitsThatWon  = 0;
        //checking if there wassome changes
        for (Unit__c unit: Trigger.new)
        {
            if (Trigger.oldMap.get(unit.Id).Number_of_victories__c  != Trigger.newMap.get(unit.Id).Number_of_victories__c )
            {
                unitsThatWon ++;
            }
            if (Trigger.oldMap.get(unit.Id).Number_of_Games__c  != Trigger.newMap.get(unit.Id).Number_of_Games__c )
            {
                unitsThatFighted ++;
            }
        }
        //thelist of unit'sthat haven't changed
    	List<Unit__c> otherUnits = [SELECT Id, Number_of_victories__c, Position_in_top__c, Number_of_Games__c
                                    FROM Unit__c
                                    WHERE Id NOT IN :Trigger.new];
        List<Unit__c> newUnits = Trigger.new;
        List<Unit__c> allUnits = new List<Unit__c>();
        allUnits.addAll(newUnits);
        allUnits.addAll(otherUnits);
        List<UnitSorter> unitSorter = new List<UnitSorter>();
        //sortering the units
        for (Unit__c unit: allUnits)
        {
            UnitSorter sorter = new UnitSorter();
            sorter.unit = unit;
            unitSorter.add(sorter);
        }
        unitSorter.sort();
    
        Integer PositionInTop = 0;
        /**
        * i really needed to seperate this two things because i coundn't make them work together for a long time
        * i'm planning to work it out little bit later, 'cause now it still works ok
        */
        //this serves for determining the postiton in top
        if (unitsThatWon > 0)
        {
            List<Unit__c> unitsToUpdate = new List<Unit__c>();
            Decimal NumberOfGames;
            for (UnitSorter sorter: unitSorter)
            {
                
                Unit__c unit = sorter.unit;
                PositionInTop++;
                unit.Position_in_top__c = PositionInTop;
                if (!(Trigger.newMap.containsKey(unit.Id)))
                {
                    unitsToUpdate.add(unit);
                }
            }
            update unitsToUpdate;
        }
        //this is for percentage of victories
        if (unitsThatFighted > 0)
        {
            List<Unit__c> unitsToUpdate = new List<Unit__c>();
            Decimal NumberOfGames;
            for (UnitSorter sorter: unitSorter)
            {
                Unit__c unit = sorter.unit;
                if (!(Trigger.newMap.containsKey(unit.Id)))
                {
                    unitsToUpdate.add(unit);
                    NumberOfGames = unit.Number_of_Games__c == 0 ? 1 : unit.Number_of_Games__c;
                }
                else
                {
                   NumberOfGames = unit.Number_of_Games__c;
                }
                unit.Percent_of_Victories__c = unit.Number_of_Victories__c / NumberOfGames * 100;
            }
            update unitsToUpdate;
        } 
    
    }
}