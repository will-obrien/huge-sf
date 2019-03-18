public class JoinQueryChildToParentController{
    public list<contact>childToParentforContactToAccount{get;set;}
    public JoinQueryChildToParentController(){
        childToParentforContactToAccount = [Select firstname,lastname,Account.name from Contact];
    }
}