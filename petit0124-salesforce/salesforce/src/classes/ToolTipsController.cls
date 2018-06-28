public with sharing class ToolTipsController 
{
	public List<Opportunity> getOpportunities()
	{
		return [select id, Name, StageName, CloseDate from Opportunity order by CreatedDate limit 10];
	}
}