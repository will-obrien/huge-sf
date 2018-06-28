public class ContactAndLeadSearch {
    
    public static List<List<SObject>> searchContactsAndLeads(String keyword)
    {
        List<List<SObject>> contactSearch = [FIND :keyword IN ALL FIELDS RETURNING lead(FirstName, LastName), contact(firstname, lastname)];
        
        return contactSearch;
    }

}