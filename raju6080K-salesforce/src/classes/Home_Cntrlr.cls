public class Home_Cntrlr {
   
    public String Test { get; set; }
    public CustomerOrder__c CustOrd { get; set; }

    public Home_Cntrlr(){
        CustOrd = new CustomerOrder__c();
        
    }
}