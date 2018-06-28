@isTest
public class onTaskInsert_test {

    static testMethod void unitTest_1(){
        
        test.startTest();
        Account acc = new Account(name = 'test');
        insert acc;
        Contact contact = new Contact(CVent_Contact_Type__c = 'Non-Member',lastname = 'Test11',AccountId = acc.id,email='test@test1.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        Contact contact1 = new Contact(CVent_Contact_Type__c = 'Non-Member' ,lastname = 'Test',AccountId = acc.id,email='test@test11.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact1;
        
        try{
        task task = new task(whoid = contact.id,subject = 'Registration: '+'Member'+':'+'Member'+':'+'Member');
        insert task;
        }catch(Exception ex){}
        test.stopTest();
    }
}