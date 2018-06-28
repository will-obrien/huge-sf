public class PROHelper{
    /*
        Get List of Thursday of current month.
    */
    public static List<Date> GetAllThursDayOfMonth(integer year,integer month){
        List<Date> thuDayDateList=new List<Date>();
        
        Date startDate=date.newInstance(year,month, 1);
        Date endDate=startDate.addMonths(1).addDays(-1);
        
        do{
            Datetime myDateTime = DateTime.newInstance(startDate, Time.newInstance(0, 0, 0, 0));
            String dayOfWeek = myDateTime.format('E');
            if(dayofWeek=='Thu'){
                thuDayDateList.add(startDate);
            }
            startDate=startDate.AddDays(1);
        }while(startDate<endDate);
    
        return thuDayDateList;
    }
    public static boolean IsThursDay(Date currentDate){
        Datetime myDateTime = DateTime.newInstance(currentDate, Time.newInstance(0, 0, 0, 0));
        String dayOfWeek = myDateTime.format('E');
        if(dayofWeek=='Thu'){
            return true;
        }
        return false;
    }
}