@isTest
public class UpdateKPI_test {
    static Contact contact;
    static Account acc ;
    
    static void testData(){
        Acc = new Account(Name = 'test');
        insert acc;
        
        contact = new Contact(KPI_Last_Updated_Date__c = system.today() - 2,lastname = 'Test',AccountId = acc.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
    }
    
    static testMethod void unitTest_1(){
        testData();
        UpdateKPI kpi = new UpdateKPI(NULL);
        database.executeBatch(kpi);
        
    }
    
        static testMethod void unitTest_2(){
        testData();
        UpdateKPI kpi = new UpdateKPI('clear');
        database.executeBatch(kpi);
        
    }

}