global class UnitSorter implements Comparable
{
    public Unit__c unit;
    
    /*
     * Constructor for UnitSorter class
     */
    public UnitSorter(Unit__c unit)
    {
        this.unit = unit;
    }
        
    /*
     * Compare units based on the winn amount
     */
    public Integer compareTo(Object compareUnit) 
    {
        UnitSorter compareToUnit = (UnitSorter) compareUnit;
        Integer returnValue = 0;
                        
        if (unit.Winn__c < compareToUnit.unit.Winn__c) 
        {
            returnValue = 1;
        } else if (unit.Winn__c > compareToUnit.unit.Winn__c) 
        {
            returnValue = -1;
        }
        return returnValue;
    }
}
