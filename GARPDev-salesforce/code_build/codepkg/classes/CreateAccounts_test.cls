@isTest(seeAllData=true)
public class CreateAccounts_test {

    
    static testMethod void unitTest_1(){
        //Account account = new Account(Name = 'test',ownerId='005f0000000zV71');
        //insert account;
        //test.startTest();
        //insert new Updateids__c(Name='User',Record_id__c = '005f0000000zV71'); 
         
        //Contact contact = new Contact(GARP_Member_ID__c = '1233212',LEGACY_PK_PID__c  = '123',lastname = 'Test',email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        //insert contact;
        
       
        
        Datacompletionbatch11 c = new Datacompletionbatch11();
        Database.executeBatch(c,100); 
           
        //test.stoptest();
        
    }
    
            
    
}