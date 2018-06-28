public class ContactManager {
    public static ID addContact(String lastNameToInsert, String firstNameToInsert) {
        Contact contactToAdd = new Contact(FirstName=firstNameToInsert,
                                           LastName=lastNameToInsert);
        insert(contactToAdd);
        System.debug('contactToAdd recordID is: ' + contactToAdd.Id);
        return contactToAdd.Id;
    }
}