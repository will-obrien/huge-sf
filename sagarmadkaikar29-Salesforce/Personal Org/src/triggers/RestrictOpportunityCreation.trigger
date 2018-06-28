trigger RestrictOpportunityCreation on Opportunity (before insert)
{
    for(Opportunity opp : Trigger.new)
    {
        
        AggregateResult[] groupedResults = [SELECT  COUNT(ID)  FROM Opportunity WHERE Account.ID=:opp.AccountId and CreatedDate = TODAY];
        for (AggregateResult ar : groupedResults)  
        {
        	Integer count = Integer.valueOf(ar.get('expr0'));
            if(count>=3)
            {
                opp.addError('Error!!!...You can create only Three opportunities in a day');
            }
            
        }
    }

}