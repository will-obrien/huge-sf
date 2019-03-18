public class remoteActionDemoController{
    public remoteActionDemoController(){
    
    }    
    @RemoteAction
    public static void getContact(){
        contact con = new Contact();
    }
}