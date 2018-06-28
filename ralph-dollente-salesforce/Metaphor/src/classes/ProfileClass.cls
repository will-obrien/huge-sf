global class ProfileClass{

    public String first_name {get; set;}
    public String middle_name {get; set;}
    public String last_name {get; set;}
    public String msisdn {get; set;}
    public String role {get; set;}
    public String activated {get; set;}
    public String load_protected {get; set;}
    public String pesoBalance {get; set;}
    public String serviceType {get; set;}
    public String email {get; set;}
    public String picture_url {get; set;} 
    
    global ProfileClass(String firstname, String middlename, String lastname, String msisdn, 
                        String role, String activated, String loadProtected, 
                        String pesoBalance, String serviceType, String email, String picture_url){
        this.first_name = firstname;
        this.middle_name = middlename;
        this.last_name = lastname;
        this.email = email;
        this.msisdn = msisdn;
        this.role = role;
        this.activated = activated;
        this.load_protected = loadProtected;
        this.pesoBalance = pesoBalance;    
        this.serviceType = serviceType;  
        this.picture_url = picture_url;              
    }

}