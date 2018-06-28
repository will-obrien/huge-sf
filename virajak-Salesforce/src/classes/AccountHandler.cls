public class AccountHandler {
    public static Account insertNewAccount(String accountName){
        Account account;
       
        try{
            account = new Account(Name=accountName);
            insert(account);
          return account;
        }catch(DmlException dmlException){
            System.debug('DML Exp: '+dmlException.getMessage());
            account = null;
             return account;
        }
       
        
    }

}