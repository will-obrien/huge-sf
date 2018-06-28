public class ContactSearch {
    public static List<Contact> searchForContacts(String lName, String mPostalCode){
        List<Contact> c = new List<Contact>();
        c=[SELECT Id,Name FROM Contact where LastName = 'Smith' AND MailingPostalCode ='123456'];
           /* for(integer i=0;i<c.size();i++) {
                System.debug('test '+c.get(i));
            }*/
        return c;
    }
}