public class jsonDemoController{
    public String con{get;set;}
        public jsonDemoController(){
            
        }
        public void demo(){
            list<contact> contacts= [ select firstname,lastname from contact];
            con= JSON.serialize(contacts);
        }
}