public class ContactSearch {
    
     public static List<Contact> searchForContacts(String lastname,String Postalcode)
     {
        List<Contact> Contacts = [Select ID,Name from Contact where LastName = :lastname AND MailingPostalCode = :Postalcode ];
        return Contacts;
     }

}