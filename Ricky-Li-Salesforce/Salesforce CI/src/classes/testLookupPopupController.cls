@isTest
Public Class testLookupPopupController{

    static testMethod void testLookup(){
         LookupPopupController lpc = new LookupPopupController();
         lpc.Query = 'Abhi';
         lpc.runQuery();
         
         //Create a golden ticket
         Golden_Ticket__c gt = new GOlden_Ticket__c(Name=userInfo.getName(), User__c=userinfo.getUserId(), Arrival_Date__c = Date.parse('18/09/2013'), 
                                                   Departure_Date__c = Date.parse('27/09/2013'), Date_Change_Reason__c = 'Testing', 
                                                   ownerId=userinfo.getUserId(), isComing__c = true, Nights_Staying_in_Niagara__c ='');
        
         insert gt;
                                                    
         lpc.SaveRoomieName();
    }
    
    //Fail
        static testMethod void testLookup_Fail(){
         LookupPopupController lpc = new LookupPopupController();
         lpc.Query = '';
         lpc.runQuery();
         
         //Create a golden ticket
         Golden_Ticket__c gt = new Golden_Ticket__c(Name=userInfo.getName(), User__c=userinfo.getUserId(), Arrival_Date__c = Date.parse('18/09/2013'), 
                                                   Departure_Date__c = Date.parse('27/09/2013'), Date_Change_Reason__c = 'Testing', 
                                                   ownerId=userinfo.getUserId(), isComing__c = true, Nights_Staying_in_Niagara__c ='');
        
         insert gt;
                                                    
         lpc.SaveRoomieName();
    }
    
  //Person Does not work here  
      static testMethod void testLookup_DoesNotWorkHere(){
          LookupPopupController lpc = new LookupPopupController();
          lpc.Query = 'A A';
          lpc.runQuery();
          
          //Create a golden ticket
          Golden_Ticket__c gt = new Golden_Ticket__c(Name=userInfo.getName(), User__c=userinfo.getUserId(), Arrival_Date__c = Date.parse('18/09/2013'), 
                                                   Departure_Date__c = Date.parse('27/09/2013'), Date_Change_Reason__c = 'Testing', 
                                                   ownerId=userinfo.getUserId(), isComing__c = true, Nights_Staying_in_Niagara__c ='');
          insert gt;
          
          lpc.SaveRoomieName();                                         
                                                   
      }
}