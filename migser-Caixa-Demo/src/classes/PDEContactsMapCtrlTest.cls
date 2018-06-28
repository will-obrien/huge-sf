@isTest(seeAllData=true)
private class PDEContactsMapCtrlTest {

    static testMethod void myTestMethod() {
        
        Account acc = new Account(name='Test Account');
        insert acc;
        
        Contact con = new Contact(FirstName='John',LastName='Babidoo', Display_On_Power_Map__c=true, AccountId=acc.Id);
        insert con;
        
        List<Contact> cons = PDEContactsMapCtrl.getAccountContacts(acc.Id);   
        
        List<PDEContactsMapCtrl.MapItem> MIs = PDEContactsMapCtrl.getMapItems(acc.Id);
        
    }
    
}