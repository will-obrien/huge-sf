public class OlderAccountsUtility {
 // Get the 5 oldest accounts
  public static void updateOlderAccounts() {
    Account[] oldAccounts = [SELECT Id, Description FROM Account ORDER BY CreatedDate ASC LIMIT 5];
    // loop through them and update the Description field
    for(Account acct : oldAccounts) {
        acct.Description = 'Heritage Account';
   }
   // save the change you made
   update oldAccounts;
  }
}