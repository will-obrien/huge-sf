trigger VS_CustomAccountRecursive on Custom_Account__c (after insert, after update)
{
    
    if(Trigger.isInsert){
    if(p.firstRun)
    {
    system.debug('=======account=====');
     List<Account> AccountInsertList = new List<Account>();
    for(Custom_Account__c obj: Trigger.new)
        {
        system.debug('=======account====='+Trigger.new);
        Account acc = new Account();
        acc.name= obj.name;
        acc.Phone=obj.Phone__c;
        acc.Website=obj.Website__c;
        AccountInsertList.add(acc);
         system.debug('=======before account====='+AccountInsertList);
        }
         system.debug('p.firstRun@@@@@ tr1'+p.firstRun);
        p.firstRun=false;
        Insert AccountInsertList;
    }
    }
    
}