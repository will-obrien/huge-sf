trigger DeleteRestrictInvoice on Invoice_Statement__c (before delete) {

    // create a list of Invoices in Trigger.oldMap along with their Line Items
    List<Invoice_Statement__c> invoices = [Select i.Name, (Select Name From Line_Item__r)
                                        From Invoice_Statement__c i
                                        Where i.Id IN :Trigger.oldMap.keySet()];

    // loop through the Invoices, attaching errors to those that have Line Items
    for (Invoice_Statement__c invoice : invoices) {
       if (!invoice.Line_Item__r.isEmpty()) {
      Trigger.oldMap.get(invoice.id).addError('Cannot delete Invoice with Line Items');
      }
   }
}