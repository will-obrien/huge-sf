/*
@author: raip
Modification History:
    raip - test test
    more comments
*/
public class AccountHandler {
    public static Account insertNewAccount(String strName){
        try{
        Account acct = new Account(Name=strName);
        insert acct;
        return acct;
        }
        catch(DmlException e){
            System.debug('A DML exception has occured: ' + e.getMessage());
            return null;
        }
        
    }
}