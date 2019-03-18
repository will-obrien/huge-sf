trigger CusObjRecursiveTriggers on Custom_Account__c (after insert, after update) 
{
    List<Account> custacc=new List<Account>();

    for(Custom_Account__c acc:Trigger.New)
    {
        custacc.add(new Account(name=acc.name,Phone=acc.Phone__c,Website=acc.Website__c));

    }
    insert custacc;
}