/*
   Name        :    
   Date        :
   Auther      :
   Description :
*/
public class timeSheetController2{
public  date dt;
public list<date> dateList{get;set;}
public map<id,list<lightingprefix__Log_hours__c>> loghoursMap{get;set;}
public set<id> conids{get;set;}
    public timeSheetController2(){       
        loghoursMap= new map<id,list<lightingprefix__Log_hours__c>>();
        Date selectedDate =  Date.today(); //Give your date
        Date firstDate = selectedDate.toStartOfMonth();
        Date lastDate = firstDate.addDays(date.daysInMonth(selectedDate.year() , selectedDate.month())  - 1);
        system.debug(firstDate  + ' **** ' +lastDate );
        dateList = new list<date>();
         conids= new set<id>();
    
        for(contact c: [select id,name,(SELECT Id,Name,lightingprefix__Name__c, lightingprefix__Hour_s__c, lightingprefix__Date__c FROM lightingprefix__Log_hours__r where CALENDAR_Month(lightingprefix__Date__c ) =2 And CALENDAR_YEAR(lightingprefix__Date__c ) =2016 ) from contact  where Id In (select lightingprefix__Name__c FROM lightingprefix__Log_hours__c) ]){
            loghoursMap.put(c.id,c.lightingprefix__Log_hours__r);
            conids.add(c.id);
        }          
           for(dt=firstDate;dt<=lastDate;dt=dt.adddays(1)){           
             dateList.add(dt);  
             
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