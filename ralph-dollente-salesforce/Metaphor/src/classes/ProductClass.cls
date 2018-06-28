public class ProductClass{
    public String total {get; set;}
    public String page {get; set;}
    public String limits {get; set;}
    public List<RecordClass> records {get; set;}

    public ProductClass(String total, String page, String limits, List<RecordClass> records){
        this.total = total;
        this.page = page;
        this.limits = limits;
        this.records = records;    
    }
    
    public class RecordClass{
    
        public String id {get; set;}
        public String name {get; set;}
        public String category {get; set;}
        public AmountClass amount {get; set;}
        public String description {get; set;}
        public String image_url {get; set;}
        public DataPlanClass data_plan {get; set;}
    
        public RecordClass(String id, String name, String category, AmountClass amount, String description, String imageUrl, DataPlanClass data_plan){
            this.id = id;
            this.name = name;
            this.category = category;
            this.amount = amount; 
            this.description = description;
            this.image_url = imageUrl; 
            this.data_plan = data_plan;      
        }    
    }
    
    public class AmountClass{
        
        public String value {get; set;}
        public String unit {get; set;}
    
        public AmountClass(String value, String unit){
            this.value = value;
            this.unit = unit;        
        }        
    }
    
    public class DataPlanClass{
    
        public OpenDataPlanClass open_data {get; set;}
        public SmartLifeDataPlanClass smart_life_data {get; set;}
    
        public DataPlanClass(OpenDataPlanClass open_data, SmartLifeDataPlanClass smart_life_data){
            this.open_data = open_data;
            this.smart_life_data = smart_life_data;        
        }    
    }
    
    public class SmartLifeDataPlanClass{
    
        public String value {get; set;}
        public String unit {get; set;}
        public String validity {get; set;}
        public List<String> free_apps {get; set;}
        public String display {get; set;}
    
        public SmartLifeDataPlanClass(String value, String unit, String validity, List<String> free_apps, String display){
            this.value = value;
            this.unit = unit;
            this.validity = validity;
            this.free_apps = free_apps;
            this.display = display;
        }
    }
    
    
    public class OpenDataPlanClass{
    
        public String value {get; set;}
        public String unit {get; set;}
        public String validity {get; set;}
        public List<String> free_apps {get; set;}
        public String display {get; set;}
    
        public OpenDataPlanClass(String value, String unit, String validity, List<String> free_apps, String display){
            this.value = value;
            this.unit = unit;
            this.validity = validity;
            this.free_apps = free_apps;
            this.display = display;
        }
    }
}