public class ContactSearch{
	public static List<Contact> searchForContacts(String strLastName, String mailingPostalCode){
		Contact[] contact = [SELECT FirstName FROM contact WHERE lastName=:strLastName AND mailingPostalCode = :mailingPostalCode];
		return contact;

	}
}