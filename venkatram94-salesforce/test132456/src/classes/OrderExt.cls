public with sharing class OrderExt {

    public Order oe {get;set;}
   
    public OrderExt(ApexPages.StandardController controller) {
       
        oe = (Order)controller.getRecord();
        
    }
    
    public List<Container__c> showQuantity() {
        List<Container__c> res= [Select QuantityAvailble__c from Container__c where Category__c =: oe.Category__c];
         
       return res;
   }
  }