global class MyCustomSort implements Comparable{
    
    public Unit unit;
    
    //Constructor
    public MyCustomSort (Unit unit){
        this.unit = unit;
    }
	
	// Compare units based on the units HP    
    global Integer compareTo(Object compareTo){
        // Cast argument to MyCustomSort
        MyCustomSort customSort = (MyCustomSort)compareTo;
        
        //The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        
        if (unit.HP > customSort.unit.HP){
            // Set return value to a positive value.
             returnValue = -1;   
        }
        else if (unit.HP < customSort.unit.HP) {
            // Set return value to a negative value.
            returnValue = -1;
        }        
       return returnValue;
    }

}