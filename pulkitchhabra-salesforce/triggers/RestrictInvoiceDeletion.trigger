trigger RestrictInvoiceDeletion on Invoice_Statement__c (before delete) {
    for (Invoice_statement__c inv:[Select id from invoice_statement__C where id in(Select invoice_statement__c from Line_Item__c) and id in :trigger.old]){
        trigger.oldmap.get(inv.id).status__c.addError('Cannot delete invoice statement with line items');  
    }
}