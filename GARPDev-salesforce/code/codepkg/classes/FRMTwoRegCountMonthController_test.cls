@isTest
public class FRMTwoRegCountMonthController_test {

    
    static Account account;
    static Contact contact;
    
    static void testData(){
        
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(KPI_Current_Exam_Registration__c = 'FRM Part 2',lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
    }
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        FRMTwoRegCountMonthController cntrl = new FRMTwoRegCountMonthController();
        test.stopTest();
    }
    
}