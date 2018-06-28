public class DE_mss{
    public Site mss {get;set;}
    public user myuser {get;set;}
    
    public DE_mss(){
        mss=[SELECT Id,Name,SiteType,Status,Subdomain,UrlPathPrefix FROM Site where Name='Mobile_Self_Service' limit 1];
        myuser=[SELECT id, Email,Username FROM User where alias='bhodg' limit 1];
    }
}