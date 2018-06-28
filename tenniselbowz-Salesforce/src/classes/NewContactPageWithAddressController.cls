public with sharing class NewContactPageWithAddressController {
    public Contact contact{get;set;}
    public ApexPages.StandardController standardController {get;set;}
    
    public NewContactPageWithAddressController(ApexPages.StandardController controller) {
        standardController = controller;
        this.contact = new contact();
        this.contact.accountId = ApexPages.currentPage().getParameters().get('accid');
    }   
}