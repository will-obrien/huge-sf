public with sharing class test1 
{
    set<String> s1 = new set<String>{'harsha','vardhan','sandeep','sankhla','mohammad','naved'};
    set<String> s2 = new set<String>{'vardhan','sandeep','sankhla','mohammad','naved' };
    public void compareSets()
    {
        for(Integer i=0;i<10;i++){
            system.debug('test--->>'+i);
         } 
        
        if(s1.containsAll(s2) && s2.containsAll(s1))
        {
            system.debug('Both are equal');
        }
        else
        {
            system.debug('Both the sets are not equal');
        }
    }
}