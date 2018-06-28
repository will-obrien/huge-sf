@IsTest
public with sharing class QuickSortTest {
	
	@IsTest
	static void testQuickSort_NullList() {
		//create
		List<SelectOption> thisList = null;
		
		//invoke
		thisList = QuickSort.sortOptionList(thisList);
		
		//check
		System.assert(thisList == null);
				
	}
	
	@IsTest
	static void testQuickSort_EmptyList() {
		//create
		List<SelectOption> thisList = new List<SelectOption>();
		
		//invoke
		thisList = QuickSort.sortOptionList(thisList);
		
		//check
		System.assert(thisList.size() == 0);
				
	}
	
	@IsTest
	static void testQuickSort_OneEntry() {
		//create
		List<SelectOption> thisList = new List<SelectOption>();
		thisList.add(new SelectOption('1', '1'));
		
		//invoke
		thisList = QuickSort.sortOptionList(thisList);
		
		//check
		System.assert(thisList.size() == 1);
		System.assert(thisList.get(0).getLabel() == '1');
				
	}
	
	@IsTest
	static void testQuickSort_TwoUniqueEntries() {
		//create
		List<SelectOption> thisList = new List<SelectOption>();
		thisList.add(new SelectOption('2', '2'));
		thisList.add(new SelectOption('1', '1'));
		
		//invoke
		thisList = QuickSort.sortOptionList(thisList);
		
		//check
		System.assert(thisList.size() == 2);
		System.assert(thisList.get(0).getLabel() == '1');
		System.assert(thisList.get(1).getLabel() == '2');
				
	}
	
	@IsTest
	static void testQuickSort_TwoEqualEntries() {
		//create
		List<SelectOption> thisList = new List<SelectOption>();
		thisList.add(new SelectOption('2', '2'));
		thisList.add(new SelectOption('2', '2'));
		
		//invoke
		thisList = QuickSort.sortOptionList(thisList);
		
		//check
		System.assert(thisList.size() == 2);
		System.assert(thisList.get(0).getLabel() == '2');
		System.assert(thisList.get(1).getLabel() == '2');
				
	}
	
	@IsTest
	static void testQuickSort_MultipleUniqueEntries() {
		//create
		List<SelectOption> thisList = new List<SelectOption>();
		thisList.add(new SelectOption('8', '8'));
		thisList.add(new SelectOption('4', '4'));
		thisList.add(new SelectOption('3', '3'));
		thisList.add(new SelectOption('7', '7'));
		thisList.add(new SelectOption('2', '2'));
		thisList.add(new SelectOption('5', '5'));
		thisList.add(new SelectOption('6', '6'));
		thisList.add(new SelectOption('1', '1'));
		
		//invoke
		thisList = QuickSort.sortOptionList(thisList);
		
		//check
		System.assert(thisList.size() == 8);
		System.assert(thisList.get(0).getLabel() == '1');
		System.assert(thisList.get(1).getLabel() == '2');
		System.assert(thisList.get(2).getLabel() == '3');
		System.assert(thisList.get(3).getLabel() == '4');
		System.assert(thisList.get(4).getLabel() == '5');
		System.assert(thisList.get(5).getLabel() == '6');
		System.assert(thisList.get(6).getLabel() == '7');
		System.assert(thisList.get(7).getLabel() == '8');
				
	}
	
	@IsTest
	static void testQuickSort_MultipleEntries() {
		//create
		List<SelectOption> thisList = new List<SelectOption>();
		thisList.add(new SelectOption('E', 'E'));
		thisList.add(new SelectOption('B', 'B'));
		thisList.add(new SelectOption('A', 'A'));
		thisList.add(new SelectOption('C', 'C'));
		thisList.add(new SelectOption('B', 'B'));
		thisList.add(new SelectOption('D', 'D'));
		thisList.add(new SelectOption('F', 'F'));
		thisList.add(new SelectOption('F', 'F'));
		
		//invoke
		thisList = QuickSort.sortOptionList(thisList);
		
		//check
		System.assert(thisList.size() == 8);
		System.assert(thisList.get(0).getLabel() == 'A');
		System.assert(thisList.get(1).getLabel() == 'B');
		System.assert(thisList.get(2).getLabel() == 'B');
		System.assert(thisList.get(3).getLabel() == 'C');
		System.assert(thisList.get(4).getLabel() == 'D');
		System.assert(thisList.get(5).getLabel() == 'E');
		System.assert(thisList.get(6).getLabel() == 'F');
		System.assert(thisList.get(7).getLabel() == 'F');
				
	}
}