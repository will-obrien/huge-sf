global class samplecontrollernew
{
    public String accountName { get; set; }
    public static Account account { get; set; }
    public samplecontrollernew() { }
    
    @RemoteAction
    global static Account getAccount(String accountName) 
    {
        account = [select id, name from Account where name = :accountName ];
        return account;
    }
}