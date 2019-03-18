public class JoinQueryController{
    public list<Account>ptocListForAccounttoContact{get;set;}
    public JoinQueryController(){
        ptocListForAccounttoContact = new list<account>();
        ptocListForAccounttoContact = [Select name,(Select firstname,lastname,email from contacts)from account];
    }
}