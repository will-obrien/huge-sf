public class AccountListAuraController1 {
	@AuraEnabled
    public static List<Account> getAccounts(){
      return [SELECT ID, Name, Description FROM Account ORDER By Name Limit 4];
    }
	
}