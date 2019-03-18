Global class remoteController{
      public String accountName { get; set; }
    public static Account account { get; set; }
    public remoteController() { }
    
    @RemoteAction
    global static Account getAccount(String accountName) 
    {
        account = [select id, name, phone, type, numberofemployees from Account where name = :accountName ];
        return account;
    }
}