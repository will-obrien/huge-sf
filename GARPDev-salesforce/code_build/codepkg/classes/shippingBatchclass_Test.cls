@isTest(SeeAllData=true)
private class shippingBatchclass_Test {
    static ChargentBase__Gateway__c chrgGtway;
    static Account account ;
    static Opportunity opportunity;
    static Contact contact;
    
    static void testData() {
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'Payment', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(Shipping_Street__c ='test\n test',amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
    }
    
    static testMethod void unitTest_1(){
        
        //testData();
        test.startTest();
        shippingBatchclass datapoint = new shippingBatchclass();
         ID batchprocessid  = Database.executeBatch(datapoint);      
        test.stopTest();
         System.abortJob(batchprocessid);     
        
    }
}