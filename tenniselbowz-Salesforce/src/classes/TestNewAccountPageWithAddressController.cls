@isTest
public class TestNewAccountPageWithAddressController {
    /* TO BE DELETED
    static testmethod void runTest(){
        
        //Setting the page to visualfroce page.
        PageReference pageRef = Page.NewAccountPageWithAddress;
        Test.setCurrentPage(pageRef);
        
        //Test Data.
        Account account = new Account(Name = 'Test Account', Type = 'Architect');
        Address__c address = new Address__C(Address_Line_1__c = 'line1',  City__c = 'City', Country__c = 'United States', State_Province__c = 'Minnesota');
        
        
        //Calling Controller.
        ApexPages.StandardController contr = new ApexPages.StandardController(account);
        NewAccountPageWithAddressController ctl = new NewAccountPageWithAddressController(contr);
        
        //Setting account in controller.
        ctl.account = account;
        //Inserting address to get Id.
        insert address;
        
        Account_Address__c accountAddress = new Account_Address__c();
        //Setting address in controller.
        ctl.address = address;
        //Setting junction AccountAddress.Address lookup.
        ctl.accountAddress.Address__c = address.id;
        //calling selectAddress method where Address Id is not blank.
        ctl.selectAddress();
        //Setting accountaddress.Address__c to null value to test it.
        ctl.accountAddress.Address__c = NULL;
        //calling selectaddress method where Address Id is blank.
        ctl.selectAddress();
        //calling SaveAndNew method which calls save method.
        ctl.saveAndNew();
        
        
        
        
    }
    */
}