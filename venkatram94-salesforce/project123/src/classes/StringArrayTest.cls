public class StringArrayTest {
    public static String[] generateStringArray(Integer m){
        LIST<String> mylist= new LIST<String>();
        Integer i;
        for(i=0;i<m;i++)
        {
            mylist.add('Test '+i);
            System.debug('list is'+mylist[i]);
        }
         return mylist;
    }
    
}