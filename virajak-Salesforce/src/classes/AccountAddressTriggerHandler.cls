public class AccountAddressTriggerHandler {
    public static void doCheckboxMatchBillingAddress(List<Account> account){
        if(account[0].Match_Billing_Address__c){
            account[0].ShippingPostalCode = account[0].BillingPostalCode;
        }
    }
}