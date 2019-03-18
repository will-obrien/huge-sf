trigger RestrictInvoiceDeletion on Invoice__c (before delete)
{
	for(Invoice__c invoice : 
        					[ Select Id from Invoice__c where Id IN (Select Invoice__c from Line_Item__c)
                            	AND Id IN :Trigger.old])
    {
        Trigger.oldMap.get(invoice.Id).addError('Cannot delete invoice statement with line items');
    }
}