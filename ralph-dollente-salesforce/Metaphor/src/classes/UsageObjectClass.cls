public with sharing class UsageObjectClass{
    public SharedClass shared {get; set;}
    public PersonalClass personal {get; set;}
    
    /********************************* MAIN *********************************/
    public UsageObjectClass(SharedClass shared, PersonalClass personal){ 
        this.shared = shared;
        this.personal = personal;    
    }        
    /********************************* SHARED *********************************/
    
    public class SharedClass{            
        public Shared_OpenDataClass open_data {get; set;}
        public Shared_SmartLifeDataClass smart_life_data {get; set;}    
        public SharedClass(Shared_OpenDataClass openData, Shared_SmartLifeDataClass smartLifeData){
            this.open_data = openData;
            this.smart_life_data = smartLifeData;
        }
    }
        
    public class Shared_SmartLifeDataClass{    
        public List<SubscribersClass> subscribers {get; set;}
        public TotalClass total {get; set;}
        public Shared_BalanceClass balance {get; set;}    
        public Shared_SmartLifeDataClass(List<SubscribersClass> subscribers, TotalClass total, Shared_BalanceClass balance){
            this.subscribers = subscribers;
            this.total = total;
            this.balance = balance;        
        }
    }
    
    /********************************* PERSONAL *********************************/
    public class PersonalClass{
        public List<CategoriesClass> categories {get; set;}
        public List<Personal_BoosterClass> boosters {get; set;}
        public Personal_PesoClass peso {get; set;}
        public Personal_OpenDataClass open_data {get; set;} 
        public Personal_SmartLifeDataClass smart_life_data {get; set;}
        public PersonalClass(List<CategoriesClass> categories, List<Personal_BoosterClass> boosters, Personal_PesoClass peso, 
                            Personal_OpenDataClass open_data, Personal_SmartLifeDataClass smart_life_data){
            this.categories = categories;
            this.open_data = open_data;
            this.boosters = boosters;
            this.peso = peso;
            this.smart_life_data = smart_life_data;            
        }
    }
}