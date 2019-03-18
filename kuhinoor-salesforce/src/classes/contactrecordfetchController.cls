public class contactrecordfetchController{
    public List<contact> record{get;set;}
    public contactrecordfetchController(){
        record = [select firstname,lastname from contact limit 100];
    }
}