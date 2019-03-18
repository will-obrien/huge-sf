@isTest
public class TestDataFactory
{
	public static Invoice__c createOneInvoice(Boolean withLineItem)
    {
        Invoice__c testInvoice = createInvoice();
        if(withLineItem == true)
        {
            Merchandise__c m = createMerchandiseItem('Orange Juice');
            AddLineItem(testInvoice, m);
        }
        return testInvoice;
    }
    
    private static Merchandise__c createMerchandiseItem(String merchName)
    {
       
        
        Merchandise__c m = new Merchandise__c( Name = merchName, Quantity__c=1,Price__c = 2, Warehouse__c='a0E280000004fpg');
        insert m;
        return m;
    }
    
    private static Invoice__c createInvoice()
    {
    	Invoice__c inv = new Invoice__c(Status__c='Open') ;   
        insert inv;
        return inv;
    }
    
    private static Line_Item__c AddLineItem(Invoice__c inv , Merchandise__c m)
    {
        Line_Item__c lineItem = new Line_Item__c(Invoice__c = inv.Id,
                                                 Merchandise__c = m.Id,
                                                 Unit_Price__c = m.Price__c
                                                );
        insert lineItem;
        return lineItem;
    }
}