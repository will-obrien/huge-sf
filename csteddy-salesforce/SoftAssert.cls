public with sharing class SoftAssert 
{
    private static Boolean SOFTASSERT = false;
     
    public static void softAssertEquals(Object o1, Object o2)
    {
        if(o1 == o2) return;
         
        system.debug('Soft Assert Failed: (' + o1 + ' != ' + o2 + ')');
        if(!SOFTASSERT)
            system.assert(o1 == o2);
    }
}
