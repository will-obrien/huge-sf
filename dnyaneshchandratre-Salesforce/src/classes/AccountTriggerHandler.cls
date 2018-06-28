public with sharing class AccountTriggerHandler 
{
    public static void triggerNew(List<Account> a)
    {
        for(Account ac: a)
            System.debug('***The new record has values*** :\n' + ac);
    }
}