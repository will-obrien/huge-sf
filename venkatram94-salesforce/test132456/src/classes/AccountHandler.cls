public class AccountHandler {
    public static Account insertNewAccount(String Name) {
        Account a = new Account();
        try{
            a.Name = Name;
            insert a;
        	return a;
        }catch(DmlException e) {
            a.Name = null;
            System.debug('Name is empty' +e.getMessage());
            return null;
        }
        
    }
}