@isTest(seeAllData=true)
private class onAIAUProdRefunds_test {

    static Account account ;
    static Opportunity opportunity; 
    static ChargentBase__Gateway__c chrgGtway;
    static Product_Refunds__c refund;
    static ChargentSFA__Transaction__c payment;
    static OpportunityLineItem lineItem ;
    Static contract contract;
    
    static void testData(){
        
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        //insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 

        payment = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c = opportunity.id,ChargentSFA__Type__c = 'Charge', ChargentSFA__Response_Status__c= 'Approved');
        insert payment;
        
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'MEMI',GL_Code__c = '4999',Family = 'Hardware');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        lineItem = new OpportunityLineItem(Quantity = 12,unitPrice = 12,OpportunityId = opportunity.id,PricebookEntryId = standardPrice.id);
        insert lineItem;
        
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contract; 
        Map<String,Schema.RecordTypeInfo> ContractRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = ContractRecordTypeInfo .get('Membership').getRecordTypeId();
        contract = new Contract(Opportunity__c = opportunity.id,AccountId = Account.id,recordTypeId = rtId);
        insert contract;
        
        Contract  = new Contract(recordTypeId = rtId,Opportunity__c = opportunity.id, AccountId = opportunity.AccountId ,ContractTerm = 12     ,StartDate = opportunity.CloseDate        );
        insert contract;

        contract.Status = 'Activated';
        update contract;
        
        refund = new Product_Refunds__c (Status__c='Completed',Take_Membership__c = true,Refund_amount__c =123,opportunity__c = opportunity.id,product__c = prod.id,Payment_Transaction__c = payment.id);
        insert refund;
    }
    
    static testMethod void unitTest_1(){
    	
    	testData();
    	
    }
    
    
    
}