@isTest
public class CommunityUtils_test {
    
    static Account account;
    static Contact contact;
    static Contact contact1;
    
    static void testData(){
        account = new Account(Name = 'test');
        insert account;
        Id busRedcordtype = RecordTypeHelper.GetRecordTypeId('Contact','Business Relationship');
        contact = new Contact(recordtypeId = busRedcordtype,lastname = 'Test',GARP_Member_ID__c ='45678',AccountId = account.id,email='test@gdsfatest.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;   
        
        contact1 = new Contact(lastname = 'Test',AccountId = account.id, GARP_Member_ID__c ='12345',email='test@gdsfatest.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact1; 
    } 
    
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        CommunityUtils.createCommunityUser(new contact[]{contact});
        test.stopTest();
        
    }
    
    
}