public with sharing class NewAccountPageWithAddressController {

    Public Account account {get; set;}
    
    public NewAccountPageWithAddressController(ApexPages.StandardController controller) {
        this.account = new Account();
    }
}