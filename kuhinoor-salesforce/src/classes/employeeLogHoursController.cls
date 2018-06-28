public class employeeLogHoursController{
    public map<String ,map<date,Decimal>>  hoursMap;
    public List<Date> dateList{get;set;}
    Private Date startDate;
    Private Date EndDate;
    public Decimal hrs;
    public list<model> modelLst{get;set;}
    
    //CONSTRUCTOR
    public employeeLogHoursController(){
        hrs =0;
        startDate = Date.today();
        EndDate = Date.today().addDays(12);   
        dateList = new List<Date>();     
        modelLst = new List<model>();
        hoursMap = new map<String ,map<date,decimal>>();
        
        list<Working_Hours__c> workingHrsLst =  [ SELECT lightingprefix__Name__r.id,Id,lightingprefix__Name__r.Name,lightingprefix__Name__c, lightingprefix__Date__c, lightingprefix__Hours__c FROM lightingprefix__Working_Hours__c];
        
        for(Working_Hours__c whs : workingHrsLst ){
            map<date,Decimal> tempMap = hoursMap.get(whs.lightingprefix__Name__c);
            if(tempMap  == null){
                tempMap  = new   map<date,Decimal>();                  
            }          
            tempMap.put(whs.lightingprefix__Date__c,whs.lightingprefix__Hours__c );
            String key = whs.lightingprefix__Name__r.Name+'-'+whs.lightingprefix__Name__c;
            hoursMap.put(key ,tempMap);            
        }        
        system.debug('******'+hoursMap);        
       for(Date dt =startDate ; dt<= EndDate  ; dt = dt.addDays(1) ){
           dateList.add(dt);  
       } 
      
        for(String  whobj : hoursMap.keySet()){
           map<date,decimal> tempMap  =  hoursMap.get(whobj);
           tempmap =  hoursMap.get(whobj);                                       
           model md = new Model();            
           for(Date dt =startDate ; dt<= EndDate  ; dt = dt.addDays(1) ){
                    loghours lg = new loghours();   
                    if( tempmap  != null){
                           lg.Hours  =  tempMap.get(dt);
                    }                 
                    md.housList.add(lg);
              }
           String [] str =  whobj.split('-');     
           md.Name = str[0];
             modelLst.add(md); 
        }   
    }    
        
    //WRAPPER CLASS
    public class model{
      public String Name{get;set;}
      public list<loghours> housList{get;set;}
      public model(){
          housList = new list<loghours>();
      }
    }
    
    //wrapper class
    public class loghours{
        public Decimal Hours{get;set;}
    }
}