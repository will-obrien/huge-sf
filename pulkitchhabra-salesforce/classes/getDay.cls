public class getDay {
    public static void main(){
        DateTime dt = DateTime.newInstance(2015, 11, 23);
        String dayOfWeek = dt.format('EEEE');
        System.debug(dayOfWeek);
    }
}