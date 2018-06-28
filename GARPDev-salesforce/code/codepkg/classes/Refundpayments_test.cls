@isTest
public class Refundpayments_test {

    static Account account ;
    static Opportunity opportunity; 
    static ChargentBase__Gateway__c chrgGtway;
    static Product_Refunds__c refund;
    static ChargentSFA__Transaction__c payment;
    static OpportunityLineItem lineItem ;
    static Contract contract;
    
    static void testData(){
        
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 

        payment = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c = opportunity.id,ChargentSFA__Type__c = 'Charge', ChargentSFA__Response_Status__c= 'Approved');
        insert payment;
        
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'FRM1',GL_Code__c = '4999',Family = 'Hardware');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        lineItem = new OpportunityLineItem(Quantity = 12,unitPrice = 12,OpportunityId = opportunity.id,PricebookEntryId = standardPrice.id);
        insert lineItem;
        
        refund = new Product_Refunds__c (Refund_amount__c =123,opportunity__c = opportunity.id,product__c = prod.id,Payment_Transaction__c = payment.id,Status__c='Completed',Take_Membership__c = true);
        insert refund;
    }
    
    static testMethod void unitTest_1(){
        
        test.startTest();
        testData();
        Apexpages.StandardController std = new Apexpages.StandardController(payment);
        refundPayments wrpr = new refundPayments(std);
        
        refundPayments.wrapperOpps opps = new refundPayments.wrapperOpps(lineItem,payment);
        opps.isSelected = true;
        opps.objProductRefund = refund;
        opps.dAmount = 123;
        wrpr.lstWrapper = new refundPayments.wrapperOpps[]{opps};
        wrpr.saveData();
        wrpr.loadLineItems(payment );
        test.stopTest();
    }
}