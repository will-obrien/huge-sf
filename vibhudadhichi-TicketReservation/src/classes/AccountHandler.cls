public class AccountHandler {
    
    public static Account insertNewAccount(String AccountName)
    {
        Account act = new Account(Name=AccountName);
        try{
            insert act;
        }
        catch(DMLException dmle)
        {
            return null;
        }
        return act;
    }
//First Commdnmg
}