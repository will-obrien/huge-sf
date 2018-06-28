public class AccountOpenContactsController {
	
	public Contact contact;
	
	public AccountOpenContactsController() {
		
		contact = [SELECT Id, Name FROM Contact WHERE Id = '003g000000250sJ'];
		
	}
	
	public Contact getContact() {
		return contact;
	}

}