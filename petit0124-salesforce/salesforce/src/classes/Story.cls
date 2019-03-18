/*******************************************************************
 * Custom class for the "News Ticker" recipe.
 * Encapsulate details of a news ticker story
 *******************************************************************/
public with sharing class Story 
{
	// the story publication date
	public Date pubDate {get; set;}
	
	//the story headline
	public String headline {get; set;}
	
	// a snippet of the story
	public String snippet {get; set;}
	
	// the main body of a story
	public String body {get; set;}
	
	// where the story happened
	public String location {get; set;}
	
	// the id of the Salesforce record associated with the story
	public Id id {get; set;}
	
	// the image associated with the story
	public String image {get; set;}
}