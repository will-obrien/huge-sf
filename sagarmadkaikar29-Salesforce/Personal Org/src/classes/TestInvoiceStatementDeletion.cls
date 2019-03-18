@isTest
public class TestInvoiceStatementDeletion 
{
    static testmethod void testDeleteInvoiceWithLineItem()
    {
        Invoice__c inv = TestDataFactory.createOneInvoice(true);
        Test.startTest();
        Database.DeleteResult result = Database.delete(inv,false);
        Test.stopTest();
        
        system.assert(!result.isSuccess());
    }
    
    static testmethod void testDeleteInvoiceWithoitLineItem()
    {
        Invoice__c inv = TestDataFActory.createOneInvoice(false);
        Test.startTest();
        Database.DeleteResult result = Database.delete(inv, false);
        Test.stopTest();
        
        system.assert(result.isSuccess());
    }
    
    static testmethod void testBulkDeleteInvoices()
    {
        LIST<Invoice__c> invList = new LIST<Invoice__c>();
        invList.add(TestDataFactory.createOneInvoice(true));
        invList.add(TestDataFactory.createOneInvoice(false));
        
        Test.startTest();
        Database.DeleteResult[] results = Database.delete(invList,false);
        Test.stopTest();
        
        system.assert(!results[0].isSuccess());
        
        system.assert(results[1].isSuccess());
    }

}