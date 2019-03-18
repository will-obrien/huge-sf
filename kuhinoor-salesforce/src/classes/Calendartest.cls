Public class Calendartest{
    Public List<weekmodel> weeks{get;set;}
    Public set<Integer> holidaysList{get;set;}
    Public Integer valmonth{get;set;}
    Public Integer valYear{get;set;}
    public Calendartest(){      
       weeks = new  List<weekmodel>(); 
       holidaysList = new set<Integer>{12,3,15,27};   
    }
    Public List<weekmodel> getDemo(){
         Date startdate = Date.newInstance(valYear,valmonth,1);
       //startdate = startdate.toStartofweek()+1;
       startdate = startdate.toStartofweek();
       //String dayOfWeek=startdate.format('EEEE');
       //System.debug('######'+dayOfWeek);

        for(Integer i=0;i<6;i++){         
         weekmodel weekobj = new weekmodel();
         List<Daymodel> tempdayList= new List<Daymodel>();
         for(Integer j=0;j<7;j++){
           Daymodel daymodelobj = new Daymodel(null, null);
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
    // wrapper Class 
    Public class weekmodel{
       Public  List<Daymodel> dayList{get;set;}
    }
    Public Class Daymodel{
        Public Date d{get;set;}
        Public Boolean holiday{get;set;}
        public Daymodel(Date d, boolean holiday){
            this.d=d;
            this.holiday=holiday;
        }
    }
}