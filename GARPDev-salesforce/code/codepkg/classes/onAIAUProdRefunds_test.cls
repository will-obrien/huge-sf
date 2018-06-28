@isTest(seeAllData=true)
private class onAIAUProdRefunds_test {

    static Account account ;
    static Account account1;
    static Account account2;
    static Account account3;
    static Account account4;
    static Account account5;
    static Opportunity opportunity1; 
    static Opportunity opportunity2;
    static Opportunity opportunity3;
    static Opportunity opportunity4;
    static Opportunity opportunity5;
    static Opportunity opportunity6;
    static Opportunity opportunity7;
    static Opportunity opportunity8;
    static Opportunity opportunity9;
    static ChargentBase__Gateway__c chrgGtway;
    static Product_Refunds__c refund1;
    static Product_Refunds__c refund2;
    static Product_Refunds__c refund3;
    static Product_Refunds__c refund4;
    static Product_Refunds__c refund5;
    static Product_Refunds__c refund6;
    static Product_Refunds__c refund7;
    static Product_Refunds__c refund8;
    static Product_Refunds__c refund9;
    static ChargentSFA__Transaction__c payment;
    static OpportunityLineItem lineItem ;
    Static contract contract;
    Static contract contract1;
    
    static void testData(){
        
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        //insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
        
        account1 = new Account(Name = 'test');
        insert account1;
        
        account2 = new Account(Name = 'test');
        insert account2;
        
        account3 = new Account(Name = 'test');
        insert account3;
        
        account4 = new Account(Name = 'test');
        insert account4;
        
        account5 = new Account(Name = 'test');
        insert account5;
         
        opportunity1 = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity1; 
        
        opportunity2 = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account1.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity2; 
        
        opportunity3 = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account2.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity3;
        
        opportunity4 = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account3.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity4;
        
        opportunity5 = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account4.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity5;
        
        opportunity6 = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account5.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity6;
         
         opportunity7 = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account5.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity7;

         opportunity8 = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account5.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity8;
         
         opportunity9 = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account5.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity9;

        payment = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c = opportunity1.id,ChargentSFA__Type__c = 'Charge', ChargentSFA__Response_Status__c= 'Approved');
        insert payment;
        
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'MEMI',GL_Code__c = '4999',Family = 'Hardware');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        lineItem = new OpportunityLineItem(Quantity = 12,unitPrice = 12,OpportunityId = opportunity1.id,PricebookEntryId = standardPrice.id);
        insert lineItem;
        
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Contract; 
        Map<String,Schema.RecordTypeInfo> ContractRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id rtId = ContractRecordTypeInfo .get('Membership').getRecordTypeId();
        contract = new Contract(Opportunity__c = opportunity1.id,AccountId = Account.id,recordTypeId = rtId);
        insert contract;
        
        Contract  = new Contract(recordTypeId = rtId,Opportunity__c = opportunity1.id, AccountId = opportunity1.AccountId ,ContractTerm = 12     ,StartDate = opportunity1.CloseDate        );
        insert contract;
        
        contract.Status = 'Activated';
        update contract;
        
        Id erpRecType = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
        contract1 = new Contract(Status = 'Draft',Opportunity__c = opportunity2.id,AccountId = Account2.id,recordTypeId = erpRecType,ContractTerm = 12,StartDate = opportunity2.CloseDate);
        insert contract1;

        contract1.Status = 'Activated ( Auto-Renew )';
        update contract1;
        
        
        refund1 = new Product_Refunds__c (Status__c='Completed',Cancel_E_book__c = True,Take_Membership__c = true,Refund_amount__c =123,opportunity__c = opportunity1.id,product__c = prod.id,Payment_Transaction__c = payment.id);
        insert refund1;
        
        refund2 = new Product_Refunds__c (Status__c='Completed',Cancel_ERP_Enrollment__c = True,Take_Membership__c = true,Refund_amount__c =123,opportunity__c = opportunity2.id,product__c = prod.id,Payment_Transaction__c = payment.id);
        insert refund2;
        
        refund3 = new Product_Refunds__c (Status__c='Completed',Cancel_FRM_Enrollment__c = True,Take_Membership__c = true,Refund_amount__c =123,opportunity__c = opportunity3.id,product__c = prod.id,Payment_Transaction__c = payment.id);
        insert refund3;
        
        refund4 = new Product_Refunds__c (Status__c='Completed',Cancel_FRM1__c  = True,Take_Membership__c = true,Refund_amount__c =123,opportunity__c = opportunity4.id,product__c = prod.id,Payment_Transaction__c = payment.id);
        insert refund4;
        
        refund5 = new Product_Refunds__c (Status__c='Completed',Cancel_FRM2__c = True,Take_Membership__c = true,Refund_amount__c =123,opportunity__c = opportunity5.id,product__c = prod.id,Payment_Transaction__c = payment.id);
        insert refund5;
        
        refund6 = new Product_Refunds__c (Status__c='Completed',Cancel_ERP__c = True,Take_Membership__c = true,Refund_amount__c =123,opportunity__c = opportunity6.id,product__c = prod.id,Payment_Transaction__c = payment.id);
        insert refund6;
        
        refund7 = new Product_Refunds__c (Status__c='Completed',Cancel_ERP1__c = True,Take_Membership__c = true,Refund_amount__c =123,opportunity__c = opportunity7.id,product__c = prod.id,Payment_Transaction__c = payment.id);
        insert refund7;

        refund8 = new Product_Refunds__c (Status__c='Completed',Cancel_ERP2__c = True,Take_Membership__c = true,Refund_amount__c =123,opportunity__c = opportunity8.id,product__c = prod.id,Payment_Transaction__c = payment.id);
        insert refund8;

        refund9 = new Product_Refunds__c (Status__c='Completed',Charge_Back__c = True,Take_Membership__c = true,Refund_amount__c =123,opportunity__c = opportunity9.id,product__c = prod.id,Payment_Transaction__c = payment.id);
        insert refund9;

      

        eBook_Key__c ebook = new eBook_Key__c(Name = 'FRM Part 1', CurrencyIsoCode = 'USD', Cancelled__c = false, Opportunity__c = opportunity1.id);
        insert ebook;
        
    }
    
    static testMethod void unitTest_1(){
        
        testData();
        test.startTest();
        refund1.Refund_amount__c = 1000;
        update refund1;
        refund2.Refund_amount__c = 1000;
        update refund2;
        refund3.Refund_amount__c = 1000;
        update refund3;
        refund4.Refund_amount__c = 1000;
        update refund4;
        refund5.Refund_amount__c = 1000;
        update refund5;
        refund6.Refund_amount__c = 1000;
        update refund6;
        refund7.Refund_amount__c = 1000;
        update refund7;
        refund8.Refund_amount__c = 1000;
        update refund8;
        refund9.Refund_amount__c = 1000;
        update refund9;
        test.stopTest();
    }
    
    
    
}