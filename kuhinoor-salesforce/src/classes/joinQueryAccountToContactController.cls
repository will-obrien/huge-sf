public class joinQueryAccountToContactController{
    public list<Account> acc{get;set;}
    public joinQueryAccountToContactController(){
        acc = [ select name,(select firstname,lastname,email from contacts) from account ];
    }
}