public class RecordClass{
    public String id {get; set;}
    public String account_id {get; set;}
    public String type {get; set;}
    public String name {get; set;}
    public String message {get; set;}
    public DetailClass details {get; set;}
    public String timestamp {get; set;}

    public RecordClass(String id, String acct, String type, String name, String msg, DetailClass d, String ts){
        this.id = id;
        this.account_id = acct;
        this.type = type;
        this.name = name;
        this.message = msg;
        this.details = d;
        this.timestamp = ts;   
    }
}