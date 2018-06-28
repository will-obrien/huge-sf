public with sharing class QuickSort {
	
	//  This is a simple quicksort algorithm to sort a SelectOption list (dropdown) by label alphabetically.	
	public static List<SelectOption> sortOptionList(List<SelectOption> ListToSort)	{
		
		if(ListToSort == null || ListToSort.size() <= 1) {
			return ListToSort;					
		}
		
		List<SelectOption> Less = new List<SelectOption>();		
		List<SelectOption> Greater = new List<SelectOption>();	
			
		integer pivot = 0;				
		// save the pivot and remove it from the list		
		SelectOption pivotValue = ListToSort[pivot];		
		ListToSort.remove(pivot);				
		for(SelectOption x : ListToSort) {			
			if(x.getLabel().toLowerCase().compareTo(pivotValue.getLabel().toLowerCase()) <= 0) {
				Less.add(x);
			} else if(x.getLabel().toLowerCase().compareTo(pivotValue.getLabel().toLowerCase()) > 0) {
				Greater.add(x);
			} 	
		}		
		List<SelectOption> returnList = new List<SelectOption> ();		
		returnList.addAll(SortOptionList(Less));
		returnList.add(pivotValue);	
		returnList.addAll(SortOptionList(Greater));	
		
		return returnList; 
	}
}