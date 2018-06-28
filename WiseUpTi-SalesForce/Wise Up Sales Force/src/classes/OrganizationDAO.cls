public class OrganizationDAO {

    public static Boolean IsSandbox(){
        return [select Id, IsSandbox from Organization limit 1].IsSandbox;
    }

    
}