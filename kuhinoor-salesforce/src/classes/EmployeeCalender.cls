public class EmployeeCalender{
    private date startDate;
    private date endDate;
    public list<date> dateLst{get;set;}
    public list<String> employeeHrsLst{get;set;}   
    public list<model> modelLst{get;set;}
    public  map<date,lightingprefix__Employee_Calendar__c> listHoursMap;
    public map<String,map<date,decimal>> hourMap;
    
    //CONSTRUCTOR
    public EmployeeCalender(){   
        hourMap = new map<String,map<date,decimal>>();
        
        listHoursMap = new  map<date,lightingprefix__Employee_Calendar__c>();    
        modelLst = new list<model>();
        employeeHrsLst = new list<String>();     
        dateLst = new list<date>();
        startDate = date.today();
        endDate = date.today().adddays(10);
        
      
        for(Employee_Calendar__c obj : [SELECT Name,date__c,hour__c FROM Employee_Calendar__c]){
          map<date,decimal> tempMap = new map<date,decimal>();
          tempMap.put(obj.date__c,obj.hour__c);
          hourMap.put(obj.id,tempMap);
        }
         
        
        for( date dt=startDate ; dt<=endDate; dt=dt.adddays(1)){
            dateLst.add(dt); 
         } 
         
         for(Employee_Calendar__c obj : [SELECT id,Name,date__c,hour__c FROM Employee_Calendar__c]){      
          map<date,decimal> temMap2 = new map<date,decimal>(); 
          temMap2 = hourMap.get(obj.id);       
          model md = new model();
            for( date dt=startDate ; dt<=endDate; dt=dt.adddays(1)){            
               modelHours mdhr = new modelHours();                
                   mdhr.hour =   temMap2.get(dt); 
                   md.hourLst.add(mdhr);
            }             
            md.name = obj.name;             
            modelLst.add(md);           
            }        
    }    
    public class model{
        public String Name{get;set;}
        public list<modelHours> hourLst{get;set;}
        public model(){
            hourLst = new List<modelhours>();
        }
    }    
    public class modelHours{
        public decimal hour{get;set;}        
    }
}