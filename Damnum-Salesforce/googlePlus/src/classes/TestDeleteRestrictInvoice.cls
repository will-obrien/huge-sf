@isTest
private class TestDeleteRestrictInvoice {

   // Invoice generator, with or without a Line Item
   static Invoice_Statement__c createNewInvoice(Boolean withLineItem) {
       // Create test Merchandise
       Merchandise__c merchandise = new Merchandise__c(
           Name = 'Test Laptop',
           Quantity__c = 1000,
           Price__c = 500,
           Description__c = 'Merchendise',
           Inventory__c = 400,
           Total_Inventory__c = 20000
       );
       insert merchandise;

       // Create test Invoice
       Invoice_Statement__c invoice = new Invoice_Statement__c();
       insert invoice;

       // Create test Line Item and insert it into the database, if withLineItem == true
       if (withLineItem) {
           Line_Item__c item = new Line_Item__c(
               name = '1',
               Quantity__c = 1,
               Merchandise__c = merchandise.Id,
               Invoice_Statement__c = invoice.Id
           );
           insert item;
       }
       return invoice;
   }

   // Single row Invoice with no Line Items => delete
   static testMethod void verifyInvoiceNoLineItemsDelete(){
       // Create test Invoice and insert it
       Invoice_Statement__c invoice = createNewInvoice(false);

       // Delete the Invoice, capture the result
       Database.DeleteResult result = Database.delete(invoice, false);

       // Assert success, because target Invoice doesn't have Line Items
       System.assert(result.isSuccess());
      }

   // Single row Invoice with Line Items => delete restrict
   static testMethod void verifyInvoiceLineItemsRestrict(){
       // Create test Invoice and Line Item and insert them
       Invoice_Statement__c invoice = createNewInvoice(true);

       // Delete the Invoice, capture the result
       Database.DeleteResult result = Database.delete(invoice, false);

       // Assert failure-not success, because target Invoice has tracks
       System.assert(!result.isSuccess());
   }

   // Bulk delete of Invoice, one without Line Items, another with
   static testMethod void verifyBulkInvoiceDeleteRestrict(){
       // Create two test Invoices, one with and without a Line Item
       Invoice_Statement__c[] invoices = new List<Invoice_Statement__c>();
       invoices.add(createNewInvoice(false));
       invoices.add(createNewInvoice(true));

       // Delete the Invoices, opt_allOrNone = false, capture the results.
       Database.DeleteResult[] results = Database.delete(invoices, false);

       // Assert success for first Invoice
       System.assert(results[0].isSuccess());
       // Assert not success for second Invoice
       System.assert(!results[1].isSuccess());
   }
}