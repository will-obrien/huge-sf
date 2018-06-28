public class TransientExample {
    transient integer asdf;
    static transient integer asdf2;

    private static void method(){
        transient integer x = 0;
        transient dateTime y = System.now();
    }
}