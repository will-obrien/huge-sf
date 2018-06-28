@isTest
public class TestDeleteRestrictInvoice{
	
    static Invoice__c createNewInvoice(Boolean withLineItem) {
        Merchandise__c merchandise = new Merchandise__c(Name = 'Test Laptop', Quantity__c = 1000, Price__c = 500);
        insert merchandise;
        
        Invoice__c invoice = new Invoice__c();
        insert invoice;
        
        if(withLineItem) {
            Line_Item__c lineItem = new Line_Item__c(name = '1', Quantity__C = 1, Merchandise__c = merchandise.id, Invoice__c = invoice.id);
           	insert lineItem;
        }
        
        return invoice;
    }
    
    static testMethod void verifyInvoiceNoLineItemsDelete() {
        
        Invoice__c invoice = createNewInvoice(false);
        
        Database.DeleteResult result = Database.delete(invoice, false);
        System.assert(result.isSuccess());
    }
    
    static testMethod void verifyInvoiceLineItemRestrict() {
        Invoice__c invoice = createNewInvoice(true);
        
        Database.DeleteResult result = Database.delete(invoice, false);
        System.assert(!result.isSuccess());
    }
    
    static testMethod void verifyBulkInvoiceDeleteRecordRestrict() {
        Invoice__c[] invoices = new List<Invoice__c>();
        invoices.add(createNewInvoice(false));
        invoices.add(createNewInvoice(true));
        
        Database.DeleteResult[] results = Database.delete(invoices, false);
        
        System.assert(results[0].isSuccess());
        System.assert(!results[1].isSuccess());
    }
    
}