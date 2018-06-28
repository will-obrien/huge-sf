@isTest
Public class testleadController{
    private Static testMethod void demo(){
        leadController led = new leadController();
        Lead lead = new Lead(LastName='Doe',FirstName='John',Company='Test',Status='Inquiry');        
        led.leaddata = lead;  
        led.save();
        
        leadController led2 = new leadController();
        Lead lead2 = new Lead(LastName='Doe',FirstName='John',Company='Test',Status='Inquiry');   
        led2.leaddata =lead2;
         
        led2.convert();
    }     
}