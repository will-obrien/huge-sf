public class ContactAndLeadSearch{
    
    public static List<List<sObject>> searchContactsAndLeads(String strName){
        List<List<sObject>> searchList = [FIND :strName IN ALL FIELDS RETURNING Contact(FirstName, LastName), Lead(FirstName, LastName)];
        return searchList;
    }
}