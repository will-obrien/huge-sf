public class ContactAndLeadSearch {
    
    public static List<List<SObject>> searchContactsAndLeads(String s){
        LIST<List<SObject>>mylist=[FIND 'Smith'IN all fields RETURNING Contact(LastName,firstname),Lead(Lastname,firstname)];
        return mylist;
    }
}