@isTest
public class TestCleanUpBatchClass 
{
    
    static testmethod void test()
    {
        String query = 'SELECT Id,CreatedDate FROM Merchandise__c WHERE Id NOT IN (SELECT Merchandise__c FROM Line_Item__c)';
        
        Merchandise__c[] m1 =new LIST<Merchandise__c>();
        
        for(Integer i=0;i<10;i++)
        {
            Merchandise__c m = new Merchandise__c(Name='Merchandise ' + i,
                                                  Quantity__c=1,
                                                  Price__c = 2,
                                                  Warehouse__c='a0E280000004fpg');
            m1.add(m);
        }
        insert m1;
        Test.startTest();
        CleanUpRecords c = new CleanUpRecords(query);
        Database.executeBatch(c);
        Test.stopTest();
        
        Integer i = [SELECT COUNT() FROM Merchandise__c];
        System.assertEquals(i, 0);
    }

}