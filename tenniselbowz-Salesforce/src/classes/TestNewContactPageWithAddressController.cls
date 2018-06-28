@isTest
public class TestNewContactPageWithAddressController {
/* TO BE DELETED
    static testMethod void runTest(){
        
        //Step1: Set the visualforce page as current page
        PageReference pageRef = page.NewContactPageWithAddress;
        Test.setCurrentPage(pageRef);
        
        //Step 2: Create Data for testing
        Account account = new account(Name = 'New Account');
        insert account;
        
        Contact contact = new contact(LastName = 'Test LastName');
        
        Address__c address = New Address__c(Address_Line_1__c = 'line1',  City__c = 'City', Country__c = 'United States', State_Province__c = 'Minnesota');
        insert address; //inserting address to assign the id to junction object ContactAddress.Address__c field in the controller to test SelectAddress() method.
        
        //Step 3: instantiate the controller
        ApexPages.StandardController sCtrl = new ApexPages.StandardController(contact);
        NewContactPageWithAddressController ctl = new NewContactPageWithAddressController(sCtrl);
        
        //Step 4: Pass variables to controller
        ctl.Cancel();   //Calling Cancel method
        ctl.contact = contact;  //assigning contact to contact in the controller;
        ctl.contactAddress.address__c = address.id; //assigning address id to contactAddress.address__c lookup field to test selectAddress() method.
        ctl.address = address;  //assigning address to address in the controller;
        ctl.selectAddress();    //Calling selectAddress method.
        ctl.contactAddress.address__c = NULL;   //assigning NULL to contactAddress.address__c lookup field to test selectAddress() method.
        ctl.selectAddress();    //Calling selectAddress method.
        ctl.saveAndNew();   //Calling SaveAndNew method.
           
    }
 */
}