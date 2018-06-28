@isTest
private class Benchmarking {

	@istest
    public static void TestNewAllocate()
    {
        for(Integer x = 0; x<10000; x++) 
            ReturnNewMap();
    }
    
    private static Map<Integer,String> ReturnNewMap()
    {
        Map<Integer,String> result = new Map<Integer,String>();
        return result;
    }
    
   @istest
    public static void TestSorts()
    {
        List<Integer> unsorteddata = new List<Integer>();
        for(Integer x = 0; x<500; x++)
        {
            unsorteddata.add(x); unsorteddata.add(x+500);
        }
		for(Integer x = 0; x< 10000; x++)
        {
            ReturnSorted(unsorteddata);
        }

    }

    private static List<Integer> ReturnSorted(List<Integer> inputlist)
    {
        List<Integer> sortedlist1 = inputlist.clone();
        sortedlist1.sort();
        return sortedlist1;
    }
    
}