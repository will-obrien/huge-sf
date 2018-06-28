public class StringArrayTest {
    public static List<String> generateStringArray(Integer count){
        List<String> stringArray = new List<String>();
        for(Integer i=0;i<count;i++){
            stringArray.add('Test '+i);
                System.debug(stringArray.get(i));
        }
        return stringArray;
    }

}