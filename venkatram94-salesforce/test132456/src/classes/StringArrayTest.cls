public class StringArrayTest {
    public static List<String> generateStringArray(integer n) {
        List<String> sList = new List<String>();
        for(integer i=0;i<n;i++) {
            
            //System.debug('Test '+i);
            sList.add('Test '+i);
        }
        return sList;
    }
}