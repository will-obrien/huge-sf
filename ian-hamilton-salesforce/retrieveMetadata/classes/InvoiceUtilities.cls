global with sharing class InvoiceUtilities{

    webservice static String renumberLineItems(String invoiceName) {
        Invoice__c invoice = [Select i.Name, (Select Name from Line_Items__r ORDER BY Name)
                                              from Invoice__c i
                                              Where i.Name = :invoiceName LIMIT 1];
        
        Integer i = 1;
        for(Line_Item__c item : invoice.Line_Items__r) {
            item.Name = String.valueOf(i);
            System.debug(item.Name);
            i++;
        }
        
        try {
            Database.update(invoice.Line_Items__r);
        } catch (DmlException e) {
            return e.getMessage();
        }
        
        return 'Line Items renumbered successfully.';
    }
    
}