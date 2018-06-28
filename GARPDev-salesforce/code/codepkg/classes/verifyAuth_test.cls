@isTest
public class verifyAuth_test {
 
    static Account acc ;
    static Contact contact;
    
    static void testData(){
        
        Acc = new Account(Name = 'test');
        insert acc;
        
        contact = new Contact(GARP_Member_ID__c  = 'fsad3829',lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;        
    }
        
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        verifyAuth.authResponse response = new verifyauth.authResponse();
        verifyAuth.echoMyType(contact.GARP_Member_ID__c);
        test.stopTest();  
    }
}