public class joinQueryDemoController{
    public list<Contact> contacts{get;set;}
    public joinQueryDemoController(){
        contacts =[ select firstname,lastname,email,account.name from contact];
    }

}