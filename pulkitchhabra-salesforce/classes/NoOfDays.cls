public class NoOfDays {
    public static Integer main(DateTime startDate, DateTime endDate){						// Find the active days
        Integer elapsedDays = totalDays(startDate, endDate)-weekends(startDate, endDate);
        System.debug(elapsedDays);
        return elapsedDays;
    }
    public static Integer weekends(DateTime s_date, DateTime e_date){						//No. of weekend days
        Integer i = 0;
        while(s_date < e_date){
            if(s_date.format('u')=='6' || s_date.format('u')=='7'){
                i=i+1;
            }
            s_date = s_date.addDays(1);
        }
        return i;
    }
    public static Integer totalDays(DateTime s_date, DateTime e_date){						//Total no of days
        Date s = s_date.date();
        Date e = e_date.date();
        Integer totalNumberOfDays = s.daysBetween(e);
        return totalNumberOfDays;
    }
}