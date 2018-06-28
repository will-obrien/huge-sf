public class ManageAccounts {
/*PNC April 2015
Adding code to update Contacts when standard address fields on Account are updated

MM May 2015
Check size of accountstoupdate to see if call to UpdateContacts is needed. There is no point in issuing a SOQL query if the list is empty, 
but it still counts against SOQL limits, which was causing tests to fail.
*/

public static void afterUpdate(List<Account> newAccounts, Map<Id, Account> oldAccounts) {

List<Account> accountstoupdate = new List<Account>();

for (Account anew: newAccounts) {

    if (
        anew.BillingStreet != oldAccounts.get(anew.Id).BillingStreet ||
        anew.BillingCity != oldAccounts.get(anew.Id).BillingCity ||
        anew.BillingState != oldAccounts.get(anew.Id).BillingState ||
        anew.BillingPostalCode != oldAccounts.get(anew.Id).BillingPostalCode ||
        anew.BillingCountry != oldAccounts.get(anew.Id).BillingCountry ||
        
        anew.ShippingStreet != oldAccounts.get(anew.Id).ShippingStreet ||
        anew.ShippingCity != oldAccounts.get(anew.Id).ShippingCity ||
        anew.ShippingState != oldAccounts.get(anew.Id).ShippingState ||
        anew.ShippingPostalCode != oldAccounts.get(anew.Id).ShippingPostalCode ||
        anew.ShippingCountry != oldAccounts.get(anew.Id).ShippingCountry )
        
        
        {
            accountstoupdate.add(anew);
        }
    }    
    if(accountstoupdate.size() > 0) {
        UpdateContacts(accountstoupdate);
    }
}

private static void UpdateContacts(List<Account> newAccountstoUpdate) {
Map<Id, Account> AccountMap = new Map<Id, Account> (newAccountstoUpdate);
List<Contact> consttoupdate = new List<Contact> ();
for (Contact c: [Select Id, AccountId from Contact WHERE AccountId in :AccountMap.KeySet()] ) {
    if (AccountMap.containskey(c.AccountId) ) {
        Account a = AccountMap.get(c.AccountId);
        Contact tempc = new Contact(Id = c.Id);
        tempc.MailingStreet = a.BillingStreet;
        tempc.MailingCity = a.BillingCity;
        tempc.MailingState = a.BillingState;
        tempc.MailingPostalCode = a.BillingPostalCode;
        tempc.MailingCountry = a.BillingCountry;
        
        tempc.OtherStreet = a.ShippingStreet;
        tempc.OtherCity = a.ShippingCity;
        tempc.OtherState = a.ShippingState;
        tempc.OtherPostalCode = a.ShippingPostalCode;
        tempc.OtherCountry = a.ShippingCountry;
        
        consttoupdate.add(tempc);
    }    
}

database.update(consttoupdate, false);

}

}