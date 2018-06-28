public with sharing class InvoiceListController {

    public list<Line_Item__c> listOfLineItems;
    public Id idOfInvoice {get;set;}
    public Boolean clickFlag = false;

    public list<Line_Item__c> getlistOfLineItems() {
        if(clickFlag) {
            return [SELECT l.Unit_Sold__c,
                           l.Unit_Price__c,
                           l.Name,
                           l.Merchandise_Name__r.Name,
                           l.Merchandise_Name__c,
                           l.Invoice_Statement__r.Email_Address__c,
                           l.Invoice_Statement__r.Phone__c,
                           l.Invoice_Statement__r.State__c,
                           l.Invoice_Statement__r.Zip__c,
                           l.Invoice_Statement__r.City__c,
                           l.Invoice_Statement__r.Street_Address__c,
                           l.Invoice_Statement__r.Company_Name__c,
                           l.Invoice_Statement__r.Description__c,
                           l.Invoice_Statement__r.Name__c,
                           l.Invoice_Statement__r.CreatedDate,
                           l.Invoice_Statement__r.Name,
                           l.Invoice_Statement__c
                    FROM Line_Item__c l where l.Invoice_Statement__c =: idOfInvoice];
        } else {
            return [SELECT l.Invoice_Statement__r.Zip__c,
                           l.Invoice_Statement__r.City__c,
                           l.Invoice_Statement__r.Name__c,
                           l.Invoice_Statement__r.Name,
                           l.Invoice_Statement__c
                    FROM Line_Item__c l];
        }
    }

    public pageReference generate() {
        idOfInvoice = ApexPages.currentPage().getParameters().get('id');
        PageReference pageRef = Page.GeneratedInvoice;
        clickFlag = true;
        getlistOfLineItems();
        return pageRef;
    }

    
}