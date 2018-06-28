/*******************************************************************
 * Custom controller for the "Carousel Messages" recipe.
 *******************************************************************/
public with sharing class BannerController 
{
	// retrieves the 5 top value opportunities
	public List<Opportunity> getOpps()
	{
		return [select id, Name, Amount, Owner.Name, CloseDate from Opportunity order by CreatedDate, Amount desc limit 5];
	}
}