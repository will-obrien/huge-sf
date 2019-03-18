Public class CalendarClass{
    Public List<weekmodel> weeks{get;set;}
    Public Integer month{get;set;}
    Public Integer Year{get;set;}
    public CalendarClass(){
       weeks = new  List<weekmodel>();       
      
    }
    Public List<weekmodel> getweek(){
         Date startdate = Date.newInstance(2016,1,1);
       //startdate = startdate.toStartofweek()+1;
         startdate = startdate.toStartofweek();
       //String dayOfWeek=startdate.format('EEEE');
       //System.debug('######'+dayOfWeek);

        for(Integer i=0;i<5;i++){         
         weekmodel weekobj = new weekmodel();
         List<Daymodel> tempdayList= new List<Daymodel>();
         for(Integer j=0;j<7;j++){
           Daymodel daymodelobj = new Daymodel(null);
           if(startdate.month()== month){
               daymodelobj.d=startdate;
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
        public Daymodel(Date d){
            this.d=d;
        }
    }
}