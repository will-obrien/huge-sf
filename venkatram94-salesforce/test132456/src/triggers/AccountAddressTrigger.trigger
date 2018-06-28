trigger AccountAddressTrigger on Account (before insert,before update) {
    
   // if(Trigger.isInsert) {
        
        for(Account a: Trigger.new) {
            
            if(a.BillingPostalCode !=null && a.Match_Billing_Address__c==true) {
               a.ShippingPostalCode = a.BillingPostalCode ;
                System.debug('===in if'+a.ShippingPostalCode);
            }
          
        }	 
  //  }
    /*
    if(Trigger.isUpdate) {
        
        set<Id> accIds = new set<Id> ();
        for(Account acc: Trigger.old) {
            accIds.add(acc.id);
        }
        
        List<Account> acList = [Select BillingPostalCode,Match_Billing_Address__c From Account where id In: accIds];
        for(Account a:acList) { 
     
            if(a.BillingPostalCode !=null && a.Match_Billing_Address__c==true) {
               a.ShippingPostalCode = a.BillingPostalCode ;
                System.debug('===in if'+a.ShippingPostalCode);
            }
        }	 
        
        update acList; 
    }
     */
}