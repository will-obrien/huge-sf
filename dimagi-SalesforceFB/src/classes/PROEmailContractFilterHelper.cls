public class PROEmailContractFilterHelper {

    public integer FirstNagDays{
        get; set;
    }

    public integer SecondNagDays{
        get; set;
    }

    public integer ThirdNagDays{
        get; set;
    }

    public integer FourthNagDays{
        get; set;
    }

    public PROEmailContractFilterHelper() {
        FirstNagDays = 4;
        SecondNagDays = 1;
        ThirdNagDays = 3;
        FourthNagDays = 7;
    }

    public List<DContract__c> filter(List<DContract__c> contracts, PROEmailContractFilterType filterType) {
        Date currentDate = Date.Today();
        List<DContract__c> filteredContract = new List<DContract__c>();

        if (filterType == PROEmailContractFilterType.FirstNag) {
            Date latestPRODueDate = GetLatestPRODueDate();
            Date lastAllowedDate = latestPRODueDate.addDays(FirstNagDays);

            for(DContract__c contract: contracts){
                if((contract.Last_Report_Out_Date__c!=null && contract.Last_Report_Out_Date__c<latestPRODueDate) 
                || (contract.Last_Report_Out_Date__c==null && contract.CreatedDate<latestPRODueDate)){
                    if(currentDate>=lastAllowedDate && !contract.Is_First_Nag_Sent__c){
                        if(!contract.Is_Snooze__c || contract.Is_Snooze__c &&  
                            (contract.Snooze_Date__c.addDays(Integer.valueOf(contract.Snooze_Days__c))<currentDate)){
                            filteredContract.add(contract);
                            
                        }
                    }
                }
            }
        }
        else if(filterType==PROEmailContractFilterType.SecondNag){
             for(DContract__c contract: contracts){
                 if(contract.Last_Report_Out_Status__c!='Red' && contract.Is_First_Nag_Sent__c && !contract.Is_Snooze__c && contract.First_Nag_Sent_Date__c.addDays(SecondNagDays)==currentDate){
                     filteredContract.add(contract);
                 }
             }
        }
        else if(filterType==PROEmailContractFilterType.ThirdNag){
             for(DContract__c contract: contracts){
                 if(contract.Last_Report_Out_Status__c!='Red' && contract.Is_First_Nag_Sent__c && !contract.Is_Snooze__c && contract.First_Nag_Sent_Date__c.addDays(ThirdNagDays)==currentDate){
                         filteredContract.add(contract);
                 }
   
             }
        }
        else if(filterType==PROEmailContractFilterType.FourthNag){
             for(DContract__c contract: contracts){
                 if(contract.Last_Report_Out_Status__c!='Red' && contract.Is_First_Nag_Sent__c && !contract.Is_Snooze__c && contract.First_Nag_Sent_Date__c.addDays(FourthNagDays)==currentDate){
                     filteredContract.add(contract);
                 }
             }
        }
        
        return filteredContract;
    }
        /*
        Get latest PRO Due Date.
        PRO is due every Second and fourth Thursday.
    */
    public Date GetLatestPRODueDate(){
        
        Date latestPRODueDate=null;
        
        Date currentDate=Date.today();

        integer currentMonth=currentDate.month();
        integer currentYear=currentDate.year();
        
        List<Date> currentMonthThursDayList=GetAllThursDayOfMonth(currentYear,currentMonth);
        
        //Current Date is less then second Thursday of month, 
        //then used fourth Thursday of previous month.
        if(currentDate<currentMonthThursDayList[1]){
             Date previousMonthDate=currentDate.addMonths(-1);
             integer previousMonth=previousMonthDate.month();
             integer previousYear=previousMonthDate.year();
             //Get previous Month Thursday.
             List<Date> previousMonthThursDayList=GetAllThursDayOfMonth(previousYear,previousMonth);
             
             return previousMonthThursDayList[3];
        }
        else{
            if(currentDate<currentMonthThursDayList[3]){
                latestPRODueDate=currentMonthThursDayList[1];
            }   
            else{
                latestPRODueDate=currentMonthThursDayList[3];
            }
        }
        
        
        return latestPRODueDate;
    }
    /*
        Get List of Thursday of current month.
    */
    private List<Date> GetAllThursDayOfMonth(integer year,integer month){
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
}