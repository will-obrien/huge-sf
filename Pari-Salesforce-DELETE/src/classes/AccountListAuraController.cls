public class AccountListAuraController {
	@AuraEnabled
    public static List<Account> getAccounts(){
      return [SELECT ID, Name, Description FROM Account ORDER By Name];
    }
	
}