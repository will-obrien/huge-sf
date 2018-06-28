public class MessageMaker{
    public static string helloMsg(){
    return('You say "Goodbye," I say "Hello."');
    }
    public void call(){
        System.debug(MessageMaker.helloMsg());
    }
}