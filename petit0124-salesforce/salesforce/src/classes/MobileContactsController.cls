/*******************************************************************
 * Custom controller for the "Listing records" recipe. 
 * Manages a list of of the 10 top value contacts. 
 *******************************************************************/
public with sharing class MobileContactsController {
	// the list of accounts
	public List<Contact> contacts {get; set;}
	
	// constructor
	public MobileContactsController()
	{
		contacts=[select LastName, FirstName, Title, Department, LastModifiedDate from Contact order by Name desc limit 10];
	}
}