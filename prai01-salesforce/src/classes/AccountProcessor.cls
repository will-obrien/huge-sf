public class AccountProcessor {
    @future(callout=true)
    public static void countContacts(list<Id> acctId)
    {

        List<Account> acctToUpdate = [SELECT Id, Number_of_Contacts__c, (SELECT Id FROM contacts) FROM Account WHERE Id IN :acctId];

        for(Account acct: acctToUpdate){
           
           List<Contact> cont = acct.contacts;
           acct.Number_of_Contacts__c = cont.size();
        }

        update acctToUpdate;

    }


}