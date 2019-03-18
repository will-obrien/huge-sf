trigger AddressFilling on Account (before insert ,before update) {
      Map<Id,List<contact>> accContactMap = new Map<Id,List<Contact>>();
      List<contact> contactsToUpdateList = new List<contact>();
      for(Account acc : [SELECT id,(select MailingStreet , mailingcity, mailingstate FROM contacts) FROM account WHERE Id IN : trigger.new]){
          accContactMap.put(acc.id, acc.contacts);
      }

     for(Account acc : Trigger.new){
        // Copy shipping address from billing address
        if(acc.Billing_and_Shiping_address_same__c == true){
                  
             acc.ShippingCity = acc.BillingCity;
             acc.ShippingStreet = acc.BillingStreet;
             acc.ShippingState= acc.BillingState;
             acc.ShippingPostalCode= acc.BillingPostalCode;
             acc.ShippingCountry = acc.BillingCountry;
             
          }
          // Copy billing address to related contacts
          if(acc.Billing_and_Contacts_address_same__c == true && Trigger.isUpdate){        
             for(contact con : accContactMap.get(acc.id)){
                con.MailingCity = acc.BillingCity;
                con.MailingStreet = acc.BillingStreet;
                con.MailingState= acc.BillingState;
                con.MailingPostalCode= acc.BillingPostalCode;
                con.MailingCountry = acc.BillingCountry;
                contactsToUpdateList.add(con);
             } 
           }    
     }
     
    if(contactsToUpdateList.size()>0){
        update contactsToUpdateList;
    }
}