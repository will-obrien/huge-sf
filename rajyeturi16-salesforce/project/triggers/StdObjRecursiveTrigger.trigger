trigger StdObjRecursiveTrigger on Account (after insert, after update) 
{    
    if(Trigger.isInsert){
   
    if(p.firstRun)
    {
        
    List<Custom_Account__c> custacc=new List<Custom_Account__c>();
    
    for(Account acc:Trigger.New)
        {
        custacc.add(new Custom_Account__c(name=acc.name,Phone__c=acc.Phone,Website__c=acc.Website));

        }
         System.debug('p.firstRun@@@@@ tr1'+p.firstRun);
           p.firstRun=false;
        insert custacc;
        }
    }
}