@isTest
public class calcMembershipExpirationDate_Test{
    
     Static Account acc;
        
     static void testData()
     {
            acc = new Account(name = 'Test Account1', Calculated_Expire_Date__c = system.today(), Last_Contract_Exp_Calc__c = system.today());
            insert acc;
         
            ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'test-4',ChargentBase__Active__c = true );
            insert chrgGtway;
        
            insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
         
            opportunity opp = new Opportunity(ChargentSFA__Gateway__c = chrgGtway.id, Name = 'Test', accountId = acc.id, amount = 123, closedate = system.today(),  LEGACY_Purchase_Date__c = system.today() - 15, StageName = 'Closed');        
            insert opp;
         
            Product2 prod = new Product2(Name = 'New York Convention', Product_ID__c= '6', GL_Code__c = '4040');
            insert prod;
         
            Id pricebookId = Test.getStandardPricebookId();
            
            Pricebook2 pricebook2 = new Pricebook2(Name='GARP 2015/2016', isActive=true);
            insert pricebook2;
         
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 250.00, IsActive = true);
            insert standardPrice;
            
            PricebookEntry Price = new PricebookEntry(Pricebook2Id = pricebook2.Id, Product2Id = prod.Id,UnitPrice = 250, IsActive = true);
            insert Price;
         
            OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = opp.id,PricebookEntryId = standardPrice.id, Quantity = 1, TotalPrice = 250.00);
            insert lineitem;
         
            Product_Refunds__c prodrefund = new Product_Refunds__c(Refund_amount__c=250,Opportunity__c = opp.id, Product__c = prod.Id, Status__c = 'Completed');
            insert prodrefund;
         
            
     }
    
    static testMethod void UnitTest_1()
    {
        testData();
        test.startTest();
        calcMembershipExpirationDate b = new calcMembershipExpirationDate('null');
        calcMembershipExpirationDate b1 = new calcMembershipExpirationDate('date');
        calcMembershipExpirationDate b2 = new calcMembershipExpirationDate(acc.Id);
        database.executeBatch(b);
        database.executeBatch(b1);
        database.executeBatch(b2);
        test.stopTest();
    }
    
}