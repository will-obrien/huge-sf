public class ContactSearch {
    public static LIST<Contact> searchForContacts(String lastname, String postalcode){
    LIST<Contact> mylist=new LIST<Contact>();
    mylist=[Select ID,Name from Contact where LastName=:lastname and MailingPostalCode=:postalcode];
    return mylist;
}
}