public with sharing class AccountController {
	public List<Contact> getContacts(){
		List<Contact> listOfContacts = [Select c.Name, c.Phone, c.Id From Contact c];
		return listOfContacts;
	}
}