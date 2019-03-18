@isTest
public class TestVerifyDate {
@isTest
static void unit(){
     date d1 = date.today();
     date d2 = date.today().adddays(30);
     VerifyDate.CheckDates(d1,d2);
     } 
     
     @isTest
     static void unit2(){
     date d1 = date.today();
     date d2 = date.today().adddays(3);
     VerifyDate.CheckDates(d1,d2);
     } 
}