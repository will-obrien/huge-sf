/*
    Name        : CalendarController
    Date        : 8-JAN-2016
    Auther      : Kuhinoor Alam
    Description : 
*/
Public class CalendarController{
    Public List<weekmodel> weeks{get;set;}
    Public set<Integer> holidaysList{get;set;}
    Public Integer valmonth{get;set;}
    Public Integer valYear{get;set;}
    public CalendarController(){      
       weeks = new  List<WeekModel>(); 
       holidaysList = new set<Integer>{12,3,15,27};   
    }
    
    Public Boolean isValid(){
        if(valmonth<1 || valyear<1990){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'invalid inputs');
           ApexPages.addMessage(myMsg);
           return false;
        }
        return true;
    }
    
    Public List<WeekModel> getWeek(){
    try{
       if(isValid()){       
        Date startdate = Date.newInstance(valYear,valmonth,1);
        //startdate = startdate.toStartofweek()+1;
        startdate = startdate.toStartofweek();
        //String dayOfWeek=startdate.format('EEEE');
        //System.debug('######'+dayOfWeek);
        
        for(Integer i=0;i<6;i++){         
            WeekModel weekobj = new WeekModel();
            List<Daymodel> tempdayList= new List<Daymodel>();
            for(Integer j=0;j<7;j++){
                    DayModel daymodelobj = new DayModel(null, null); // never used 
                    if(startdate.month()== valmonth){
                    daymodelobj.d=startdate;
                    daymodelobj.holiday= holidaysList.contains(startdate.day());                
                }
                tempdayList.add(daymodelobj); 
                startdate = startdate.adddays(1);      
                }
                weekobj.dayList=tempdayList;
                weeks.add(weekobj);
            }
            return weeks;
         }
            
       }catch(Exception e){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'invalid Inputs..');
           ApexPages.addMessage(myMsg);
           system.debug('**************'+e.getMessage());
       } 
       return null;
    }
    
    //------Wrapper Class ---------------
    Public class WeekModel{
        Public  List<Daymodel> dayList{get;set;}
    }
    Public Class DayModel{
        Public Date d{get;set;} //full name of variables
        Public Boolean holiday{get;set;}
        public DayModel(Date day, boolean holiday){
            this.d=day;
            this.holiday=holiday;
        }
    }
}