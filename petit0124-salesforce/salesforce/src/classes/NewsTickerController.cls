/*******************************************************************
 * Custom controller for the "News Ticker" recipe.
 * Creates a list of stories based on the oldest 10 opportunities.
 *******************************************************************/
public with sharing class NewsTickerController 
{
	// the stories
	public List<Story> stories {get; set;}
	
	// the constructor
	public NewsTickerController()
	{
		stories=new List<Story>();
		for (Opportunity opp  : [select id, Name, CloseDate, Amount, StageName, Description, Account.Name 
							 	 from Opportunity 
						 		 where IsClosed=true
								 order by CreatedDate asc
								 limit 10])
		{
			Story story=new Story();
			story.headline='Opportunity Closed';
			story.pubDate=opp.CloseDate;
			story.snippet=opp.Name + ', ' + opp.Amount;
			story.body=opp.description;
			story.location=opp.Account.Name;
			story.id=opp.id;
			story.image='/img/icon/products24.png';
			stories.add(story);
		}
	}
}