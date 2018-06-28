/*
   Name        :    
   Date        :
   Auther      :
   Description :
*/
public class timeSheetController{
public  date dt;
public list<date> dateList{get;set;}
public list<lightingprefix__Log_hours__c> conlist{get;set;}
public map<String,map<Date,decimal>> hoursMap;
public list<model> modelslist{get;set;}
    public timeSheetController(){
        modelslist = new list<model>();
        hoursMap = new map<String,map<Date,decimal>>();
        Date selectedDate =  Date.today(); //Give your date
        Date firstDate = selectedDate.toStartOfMonth();
        Date lastDate = firstDate.addDays(date.daysInMonth(selectedDate.year() , selectedDate.month())  - 1);
        system.debug(firstDate  + ' **** ' +lastDate );
        dateList = new list<date>();
        conlist = new list<lightingprefix__Log_hours__c>();
        for(dt=firstDate;dt<=lastDate;dt=dt.adddays(1)){
           dateList.add(dt);
        }
        
        list<contact> tempconlist = [select id,name,(SELECT Id, lightingprefix__Name__c,lightingprefix__Name__r.name,  lightingprefix__Hour_s__c, lightingprefix__Date__c FROM lightingprefix__Log_hours__r) from contact];
        //conlist =[SELECT Id, Name,name__r.name, lightingprefix__Name__c, lightingprefix__Date__c,lightingprefix__Hour_s__c  FROM lightingprefix__Log_hours__c where CALENDAR_Month(lightingprefix__Date__c ) =2 And CALENDAR_YEAR(lightingprefix__Date__c ) =2016];
        for(contact c : tempconlist ){
            map<date,decimal> tempmap = new map<date,decimal>();
            if(c.lightingprefix__Log_hours__r != null){
               // temploghours.addAll(c.lightingprefix__Log_hours__r);
            }
            for(lightingprefix__Log_hours__c log : c.lightingprefix__Log_hours__r){
                tempmap.put(log.lightingprefix__Date__c,log.lightingprefix__Hour_s__c);
            }
            hoursMap.put(c.id,tempmap);
        }
        for(contact c : tempconlist ){
            if(c.lightingprefix__Log_hours__r != null && c.lightingprefix__Log_hours__r.size()>0){
                map<date,decimal> dthours = new map<date,decimal>();
                dthours = hoursMap.get(c.id);
                model md = new model();
                for(dt=firstDate;dt<=lastDate;dt=dt.adddays(1)){
                    modelhours mdh = new modelhours();
                    mdh.count= dthours.get(dt);
                    //dateList.add(dt);           
                    md.hourslist.add(mdh);          
                }
                md.name = c.name;       
                modelslist.add(md);
            }
        } 
           
          
 }
 public class model{
     public String name{get;set;}
     public list<modelhours> hourslist{get;set;}
     public model(){
         hourslist = new list<modelhours>();
     }
 }
 public class modelhours{
    public decimal count{get;set;}
 }
}