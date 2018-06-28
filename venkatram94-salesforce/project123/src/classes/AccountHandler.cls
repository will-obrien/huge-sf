public class AccountHandler {
    
    public static Account insertNewAccount(String name){
    Account acc= new Account();
        if(name=='')
        {
            return null;
        }
        else
        {
            acc.Name = name;
             insert acc;
             return acc;
        }
         
        }  
}