/*******************************************************************
 * Custom controller for the "Working with dialogs" recipe. 
 * Manages a list of of the 10 top value accounts. 
 *******************************************************************/
public with sharing class MobileAccountsController {
	// the list of accounts
	public List<Account> accs {get; set;}
	
	// constructor
	public MobileAccountsController()
	{
		accs=[select id, Name from Account order by Name desc limit 10];
	}
}