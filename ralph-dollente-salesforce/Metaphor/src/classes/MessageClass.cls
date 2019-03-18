public class MessageClass{
    public String total {get; set;}
    public String page {get; set;}
    public String total_page {get; set;}
    public String limits {get; set;}
    public List<Records> records {get;set;} 
    
    public MessageClass(String total, String page, String total_page, String limits, List<Records> records){
        this.total = total;
        this.page = page;
        this.total_page = total_page;
        this.limits = limits;
        this.records = records;
    }

    public class Records{    
        public String id {get;set;} 
        public String account_id {get;set;} 
        public String type_Z {get;set;} // in json: type
        public String name {get;set;} 
        public String message {get;set;} 
        public Details details {get;set;} 
        public String reference_number {get;set;} 
        public String timestamp {get;set;} 
    }
        
    public class Details{    
        public Peso peso {get;set;} 
        public Peso open_data {get;set;} 
        public Peso smart_life_data {get;set;}    
    }
        
    public class Peso{
        public String display {get;set;} 
        public String expiration {get;set;}     
    }
}