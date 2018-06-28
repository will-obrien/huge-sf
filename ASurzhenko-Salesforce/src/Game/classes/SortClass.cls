/**
 *This class sorts units according to their victories quantity and all games
*/

public with sharing class SortClass implements Comparable {

    private Unit__c unit;
    
    public Unit__c getUnit()
    {
        return unit;
    }    
        
    public SortClass (Unit__c unit)
    {
        this.unit = unit;
    }
       
    public Integer compareTo (Object o)
    {
        SortClass unitToSort = (SortClass) o;
		if(unit.Games_Quantity__c == 0)
        {
        	unit.Games_Quantity__c = 1;    
        }
        if(unitToSort.unit.Games_Quantity__c == 0)
        {
        	unitToSort.unit.Games_Quantity__c = 1;    
        }
        Decimal sortNumber1 = unit.Victory_Quantity__c / unit.Games_Quantity__c;
        Decimal sortNumber2 = unitToSort.unit.Victory_Quantity__c / unitToSort.unit.Games_Quantity__c;
        
        if(sortNumber1 > sortNumber2)
        {
            return -1;
        }
        else if(sortNumber1 < sortNumber2)
        {
            return 1;
        }
        
        return 0;
    }
}