trigger CaseTrend on Case (before insert)
{
    LIST<Trend__c> trend = new LIST<Trend__c>();
    for(Case cs : Trigger.new)
    {
        
        AggregateResult[] groupedResults = [SELECT  COUNT(ID)  FROM Case c WHERE c.Product__c=:cs.Product__c and c.Type=:cs.Type and c.Reason=:cs.Reason];
        for (AggregateResult ar : groupedResults)  
        {
        	Integer count = Integer.valueOf(ar.get('expr0'));
            if(count<2)
            {
                if(count==1)
                {
                    
                    String tName = cs.Type+'_'+cs.Reason+'_'+cs.Product__c;
                    trend.add(new Trend__c(Name=tName));
                }
               
            }
            
        }
    }
    insert trend;

}