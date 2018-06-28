global with sharing class InvoiceUtilities {
   // Class method to renumber Line Items for a given Invoice number. 
   // Returns a string that indicates success or failure. 
   webservice static String renumberLineItems(String invoiceName) {

      // Create a copy of the target Invoice object and its Line Items.
      Invoice_Statement__c invoice = [Select i.Name, (Select Name From Line_Item__r ORDER BY Name) 
                                      From Invoice_Statement__c i 
                                      Where i.Name = :invoiceName LIMIT 1];

      // Loop through each Line Item, re-numbering as you go 
      Integer i = 1; 
      for (Line_Item__c item : invoice.Line_Item__r) { 
         item.Name = String.valueOf(i); 
         System.debug(item.Name);
         i++; 
      }
       
      // Update the Line Items in one transaction, rollback if any problems 
      // and return error messages to the calling environment. 
      try { 
         Database.update(invoice.Line_Item__r); 
      } 
      catch (DmlException e) { 
         return e.getMessage(); 
      } 
       
      // On success, return a message to the calling program. 
      return 'Line items renumbered successfully.'; 
   }
}