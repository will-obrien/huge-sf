public class ContactAndLeadSearch {
    public static List<List< SObject>> searchContactsAndLeads(String Name){
        List<List< SObject>> searchList = 
            [FIND 'Smith' IN NAME FIELDS RETURNING Contact(FirstName,LastName),Lead(FirstName,LastName)];
        
        List<Contact> contacts = (List<Contact>)searchList[0];
        List<Lead> leads = (List<Lead>)searchList[1];
        
        System.debug('Contacts having name Smith');
        for(Contact c: contacts) {
            System.debug(c.LastName);
        }
        
        System.debug('Leads having name Smith');
        for(Lead l: leads) {
            System.debug(l.LastName);
        }
        
        return searchList;
    }
}