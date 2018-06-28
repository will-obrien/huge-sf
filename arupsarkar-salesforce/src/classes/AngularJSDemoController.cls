public with sharing class AngularJSDemoController{ 
    
    public String AccountList { get; set; }
    
    //Subclass : Wrapper Class 
    public class Accountwrap {
        //Static Variables 
        public string id;
        public string name;
        public string Phone;
        public string BillingPostalCode;
        
        //Wrapper  Class Controller
        Accountwrap() {
            Phone = '';
            BillingPostalCode = '';
            
        }
        
    }
       
    //Method to bring the list of Account and Serialize Wrapper Object as JSON
    public  static String getlstAccount() {
        List < Accountwrap > lstwrap = new List < Accountwrap > ();
        List < account > lstacc = [SELECT Id, Name, Phone, BillingPostalCode
                                   FROM Account
                                  ];
        for (Account a: lstacc) {
            Accountwrap awrap = new Accountwrap();
            awrap.id = a.id;
            awrap.name = a.name;

            
            if(a.BillingPostalCode != null){
                awrap.BillingPostalCode = a.BillingPostalCode;
            }
            
            
            if (a.Phone != null) {
                awrap.Phone = a.Phone;
            }
            lstwrap.add(awrap);
        }
        return JSON.serialize(lstwrap);
     }
    
}