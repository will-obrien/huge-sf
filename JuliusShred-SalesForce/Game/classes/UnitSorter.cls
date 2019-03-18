public class UnitSorter implements Comparable 
{
    public Unit__c unit {get; set;}
    public Integer compareTo(Object compareObject)
    {
    // Cast argument to GameFightUnitSorter
        UnitSorter compareToUnitSorter = (UnitSorter) compareObject;
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
                        
        if (unit.Number_of_victories__c < compareToUnitSorter.unit.Number_of_victories__c) 
        {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (unit.Number_of_victories__c > compareToUnitSorter.unit.Number_of_victories__c) 
        {
            // Set return value to a negative value.
            returnValue = -1;
        }
        return returnValue;
    }
}