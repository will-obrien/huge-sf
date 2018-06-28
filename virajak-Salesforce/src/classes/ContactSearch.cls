public class ContactSearch {
    public static List<Contact> searchForContacts(String lastName, String  mailingPostalCode){
        Contact[] contactList = [Select ID, Name from Contact where 
                                  LastName =:lastName 
                                  AND MailingPostalCode =:mailingPostalCode];
        for(Contact con:contactList){
            System.debug('Name:'+con.Name);
            
        }
        
        return contactList;
        
    }

}