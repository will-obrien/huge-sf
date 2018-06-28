@isTest
private class listsTest {
    static testMethod void testList(){
        // Create an empty list of String
        List<String> first_list = new List<String>();

        // creation of a nested list
        List<List<Set<Integer>>> second_list = new List<List<Set<Integer>>>(); 
        
        // new list
        List<Integer> testList = new List<Integer>();
        testList.add(47); // add 47 to the end of the list //
        Integer i = testList.get(0);
        System.debug('First element of the list: ' + i);
		
        // size of the list //
        System.debug('First test: Size of the list: ' + testList.size());
        
        // adding a second element to the list //
		testList.add(20); // add 20 to the end of the list //
        
        // we check the elements of the list //
        System.debug('List elements: ' + testList);
        
        testList.set(0, 1); // Adds the integer 1 to the list at index 0, removing the 47
        
        // Checking the list //
        System.debug('List elements after set method: ' + testList);
        
        testList.clear(); // we delete the content of the list //
        
        System.assertEquals(0, testList.size());
        
        /***************/
        String[] colors = new String[1]; 
        colors[0] = 'Red';
        //colors[1] = 'Blue'; // index out of bonds //
        colors.add('Blue'); // avoid index out of bonds
        System.debug('List of colors: ' + colors + ', size: ' + colors.size());
        
     }
}
