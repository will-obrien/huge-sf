public class AccountHandler {

    public static Account insertNewAccount(String accountName){
        
        Account accountName1 = new Account();
        accountName1.Name = accountName;
        try{
        INSERT accountName1;
        }
        catch (Exception e) {
            return Null;
        }
    return accountName1;
    }
}