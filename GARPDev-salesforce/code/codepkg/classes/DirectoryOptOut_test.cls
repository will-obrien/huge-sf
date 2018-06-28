@isTest
public class DirectoryOptOut_test {
    static contact contact;
    static Account account;
    static void testData(){
        account = new Account(Name = 'test');
        insert account;
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
    }
    
    static testMethod void unitTest_1(){
        testdata();
        test.startTest();
        ApexPages.currentPage().getParameters().put('id',contact.id);
        DirectoryOptOut output = new DirectoryOptOut();
        output.DirectoryOptOut();
        test.stopTest();
    }
}