@isTest
private class Test_MergeHistory{
	
    private static testMethod void unitTest(){
        
        MergeHistory mhEmpty = new MergeHistory();
        
        MergeHistory mh = new MergeHistory('01/03/1986','testfield','new value','oldvalue');
        system.assertEquals('01/03/1986',mh.createdDate);
        
    }
    
}