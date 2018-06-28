@isTest
public class onChapterMemberInsertUpdate_test {

    static testMethod void unitTest_1(){
        test.startTest();
        Account acc = new Account(name = 'test');
        insert acc;
        Contact contact = new Contact(lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        Chapter_Member__c member = new Chapter_Member__c(Director__c = true,IsPrimary__c = true,Contact__c = contact.id);
        insert member;
        test.stopTest();
    }
}