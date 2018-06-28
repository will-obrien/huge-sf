/*******************************************************************
 * Custom controller for the "Mobilizing a Visualforce Page" recipe. 
 * Manages a list of of the 10 top value opportunities. 
 *******************************************************************/
public with sharing class MobileOppsController 
{
	// the list of opportunities
	public List<Opportunity> opps {get; set;}
	
	// constructor
	public MobileOppsController()
	{
		opps=[select Name, Amount from Opportunity where Amount != null order by Amount desc limit 10];
	}
}