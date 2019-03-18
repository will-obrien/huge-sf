public class InfoClass{
    public String Id {get; set;}
    public String Email {get; set;}
    public String Firstname {get; set;}
    public String Middlename {get; set;}
    public String Lastname {get; set;}
    public String DeviceToken {get; set;}
    public String OS {get; set;}    

    public InfoClass(String id, String email, String fname, String mname, String lname,  String deviceToken, String os){
        this.Id = id;
        this.Email = email;
        this.Firstname = fname;
        this.Middlename = mname;
        this.Lastname = lname;
        this.DeviceToken = deviceToken;
        this.OS = os;
    }
}