@isTest
public class DigitalBadge_test {

    static contact contact;
    static Account account;
    static void testData(){
        test.startTest();
        account = new Account(Name = 'test');
        insert account;
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        DigitalBadge badge = new DigitalBadge();
        ApexPages.currentPage().getParameters().put('id',contact.id);
        test.stopTest();
    }

}