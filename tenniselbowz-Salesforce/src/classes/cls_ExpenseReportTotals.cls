public class cls_ExpenseReportTotals {


Public String MondayLabel;
Public String TuesdayLabel;
Public String WednesdayLabel;
Public String ThursdayLabel;
Public String FridayLabel;
Public String SaturdayLabel;
Public String SundayLabel;
private final Expense_Report__c expense;


Public Expense_Report__c getexpense(){
    
    
    return expense;
    }


public void setMonday(String s){
    
     MondayLabel='MON:' + s;
    }

    Public String getMonday(){
    
    return MondayLabel;
    
    }
    
    
    public void setTuesday(String s){
    
     TuesdayLabel='TUE:' + s;
    }

    Public String getTuesday(){
    
    return TuesdayLabel;
    
    }
    
    
    public void setWednesday(String s){
    
     WednesdayLabel='WED:' + s;
    }

    Public String getWednesday(){
    
    return WednesdayLabel;
    
    }
    
    public void setThursday(String s){
    
     ThursdayLabel='THU:' + s;
    }

    Public String getThursday(){
    
    return ThursdayLabel;
    
    }
    
    
    public void setFriday(String s){
    
     FridayLabel='FRI:' + s;
    }

    Public String getFriday(){
    
    return FridayLabel;
    
    }
    
    public void setSaturday(String s){
    
     SaturdayLabel='SAT:' + s;
    }

    Public String getSaturday(){
    
    return SaturdayLabel;
    
    }
    
    
    public void setSunday(String s){
    
     SundayLabel='SUN:' + s;
    }

    Public String getSunday(){
    
    return SundayLabel;
    
    }
    
    
    


    public cls_ExpenseReportTotals(ApexPages.StandardController controller) {

       this.expense = (Expense_Report__c)controller.getRecord();
     
       String Id=ApexPages.currentPage().getParameters().get('Id');
       system.debug(Id);
       //system.debug(expense.Start_of_Week__C);
       
       Expense_Report__C exp=[Select Id,Name,Start_Of_Week__C from Expense_Report__C where Id=:Id];
      
       String StrDate=String.ValueOf(exp.Start_of_Week__C);
       List<String> datepart;
       datepart=StrDate.split(' ',2);
       List <String> dateelements=datepart[0].split('-',3);
        //Date DateSet=date.valueOf(strDate);
       system.debug('dateelements  '+dateelements);
       Date Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
        //Date Dateset=Date.newInstance(2010,03,29
        String d=dateelements[2]+ '-'+dateelements[1]+ '-' +dateelements[0];
        system.debug('My name is Earl 2' + d);
        //dateSelected=Date.newInstance(2010,03,29);//DateSet;
            //dateSelected=Dateset;
       MondayLabel='MON : '+ d;
       
       exp.Start_of_Week__C=exp.Start_of_Week__C.addDays(1);
       StrDate=String.ValueOf(exp.Start_of_Week__C);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
        //Date DateSet=date.valueOf(strDate);
       system.debug('dateelements  '+dateelements);
       Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
        
       d=dateelements[2]+ '-'+dateelements[1]+ '-' +dateelements[0];
       system.debug('My name is Earl 2' + d);
        
       TuesdayLabel='TUE : '+ d ;
       
       exp.Start_of_Week__C=exp.Start_of_Week__C.addDays(1);
       StrDate=String.ValueOf(exp.Start_of_Week__C);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
        //Date DateSet=date.valueOf(strDate);
       system.debug('dateelements  '+dateelements);
       Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
        
       d=dateelements[2]+ '-'+dateelements[1]+ '-' +dateelements[0];
       system.debug('My name is Earl 2' + d);
       
       WednesdayLabel='WED : '+ d;
       
       exp.Start_of_Week__C=exp.Start_of_Week__C.addDays(1);
       StrDate=String.ValueOf(exp.Start_of_Week__C);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
        //Date DateSet=date.valueOf(strDate);
       system.debug('dateelements  '+ dateelements);
       Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
        
       d=dateelements[2]+ '-'+ dateelements[1] + '-' +dateelements[0];
       system.debug('My name is Earl 2' + d);
       
       Thursdaylabel='THU : '+ d;
       
       exp.Start_of_Week__C=exp.Start_of_Week__C.addDays(1);
       StrDate=String.ValueOf(exp.Start_of_Week__C);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
        //Date DateSet=date.valueOf(strDate);
       system.debug('dateelements  '+dateelements);
       Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
        
       d=dateelements[2]+ '-'+dateelements[1]+ '-' +dateelements[0];
       system.debug('My name is Earl 2' + d);
       
       FridayLabel='FRI : '+ d;
       
       exp.Start_of_Week__C=exp.Start_of_Week__C.addDays(1);
       StrDate=String.ValueOf(exp.Start_of_Week__C);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
        //Date DateSet=date.valueOf(strDate);
       system.debug('dateelements  '+dateelements);
       Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
        
       d=dateelements[2]+ '-'+dateelements[1]+ '-' +dateelements[0];
       system.debug('My name is Earl 2' + d);
       
       
       SaturdayLabel='SAT : '+ d;
       
       
       exp.Start_of_Week__C=exp.Start_of_Week__C.addDays(1);
       StrDate=String.ValueOf(exp.Start_of_Week__C);
       
       datepart=StrDate.split(' ',2);
       dateelements=datepart[0].split('-',3);
        //Date DateSet=date.valueOf(strDate);
       system.debug('dateelements  '+dateelements);
       Dateset=Date.newInstance(integer.valueof(dateelements[0]),integer.valueof(dateelements[1]),integer.valueof(dateelements[2]));
        
       d=dateelements[2]+ '-'+dateelements[1]+ '-' +dateelements[0];
       system.debug('My name is Earl 2' + d);
       
       SundayLabel='SUN : '+ d;
       
      

    
    }

}