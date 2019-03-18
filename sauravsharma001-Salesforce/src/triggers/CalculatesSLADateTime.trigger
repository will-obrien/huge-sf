trigger CalculatesSLADateTime on Case (before insert, before update) 
{
    BusinessHours stdBusinessHours = [select id from businesshours where isDefault = true];
    integer sla = 0, noOfHolidays=0;
    Datetime createdDate, dateCreated;
    DateTime dateToUpdate = null;
    Date slaDate = null ;
    public List<Holiday> holi=[select RecurrenceInstance,RecurrenceDayOfWeekMask,RecurrenceMonthOfYear,RecurrenceDayOfMonth from Holiday];
    for (Case c : Trigger.new) 
    {   
        if(c.CreatedDate == null)
            dateCreated= System.now();
        else 
            dateCreated = c.CreatedDate;  
        if(c.SLA_number__c != null && c.SLA_number__c != 0 )    {
            sla = Integer.ValueOf(c.SLA_number__c); 
            dateToUpdate = BusinessHours.add(stdBusinessHours.id, dateCreated , sla*9* 60 * 60 * 1000L);
            noOfHolidays = calculateHolidaysBetweenTwoDates(dateCreated ,dateToUpdate);
            dateToUpdate.addDays(weekDayOfMonth(dateCreated,dateToUpdate));
            dateToUpdate = BusinessHours.add(stdBusinessHours.id, dateToUpdate , noOfHolidays*9* 60 * 60 * 1000L);
            String dayOfWeek = dateToUpdate.format('E');
            if(dayOfWeek == 'Sat' || dayOfWeek == 'Sun' )
                dateToUpdate.addDays(2);  
            c.SLA_date__c =dateToUpdate.Date();
        }  
    }
    
     public integer calculateHolidaysBetweenTwoDates(Datetime date1,Datetime date2)
    {
        List<String> hDays = new List<String>();
        String year = String.valueOf(date1.year());
        integer month = date1.month();
        String day = String.valueOf(date1.day()); 
        integer numberOfHolidays = 0;
        String mnth;
        integer d1,w;
        List<String> monthName = new List<String>{'null','January','February','March','April','May','June','July','August','September','October','November','December'};
        String newDate = year+'-'+ monthName.get(month) +'-'+day;
        //List<Holiday> holi=[select RecurrenceInstance,RecurrenceDayOfWeekMask,RecurrenceMonthOfYear,RecurrenceDayOfMonth from Holiday];
        for(Holiday h : holi)
        {
            for(integer i=0 ; i< monthName.size();i++)
            {
                if(monthName.get(i).equals(h.RecurrenceMonthOfYear))
                   mnth = String.valueOf(i);
            }           
            if(h.RecurrenceDayOfMonth != null )
            {
                hDays.add(String.valueOf(date1.year())+'-'+h.RecurrenceMonthOfYear+'-'+ String.valueOf(h.RecurrenceDayOfMonth));
            }
            else 
            {
                if(h.RecurrenceInstance=='First')
                   w = 1;
                else if(h.RecurrenceInstance=='Second')
                   w = 2;
                else if(h.RecurrenceInstance=='Third')
                   w = 3;
                else if(h.RecurrenceInstance=='Fourth')
                   w = 4;         
                else
                   w = 5;  
                if(h.RecurrenceDayOfWeekMask == 2)
                    d1=0;
                else if(h.RecurrenceDayOfWeekMask == 4)
                    d1=1;    
                else if(h.RecurrenceDayOfWeekMask == 8)
                    d1=2;    
                else if(h.RecurrenceDayOfWeekMask == 16)
                    d1=3;    
                else if(h.RecurrenceDayOfWeekMask == 32)
                    d1=4;        
                else if(h.RecurrenceDayOfWeekMask == 64)
                    d1=5;    
                else
                    d1=6;    
                hDays.add(weekDayOfMonth(mnth,w,d1));
            }    
        }  
        integer z=0;
        integer w1 = date1.date().daysBetween(date2.date());
        for(integer i = 0; i< w1;i++)
        {
             newDate = date1.format('YYYY-MMMM-d');
             for(integer j=0; j<hDays.size();j++)
             {
                if(hDays.get(j).trim().equals(newDate.trim()))
                {
                    numberOfHolidays++;
                    hDays.remove(j);
                }   
             }
             date1 = date1.addDays(1);    
        }
        return numberOfHolidays;
    }
    String weekDayOfMonth(String month, Integer week, Integer day) 
    {
        Datetime dt = date.valueOf('2014-'+month+'-01').addDays(1);
        String wee = dt.format('E');
        integer i , j,k;
        if(wee == 'Mon') 
         j = 0;
        else if(wee == 'Tue') 
         j = 1;
        else if(wee == 'Wed') 
         j = 2;
        else if(wee == 'Thu') 
         j = 3;
        else if(wee == 'Fri') 
         j = 4;
        else if(wee == 'Sat') 
         j = 5;    
        else
         j = 6;
        if(day<j)
           k = 7+ day-j;
        else
           k = day-j;  
        i = (week - 1)*7 + k; 
        dt = dt.addDays(i);
        return dt.format('YYYY-MMMM-d');
    }
    
    integer weekDayOfMonth(DateTime d1, DateTime d2) {
       integer noOfDays = d1.Date().daysBetween(d2.Date());
       integer day = 0;
       while(noOfDays >0)    {
            d1.addDays(1);
            if(d1.format('E') == 'Sat' || d1.format('E') == 'Sun')
                day++;
            noOfDays --;
       }
       return day;
    }
}