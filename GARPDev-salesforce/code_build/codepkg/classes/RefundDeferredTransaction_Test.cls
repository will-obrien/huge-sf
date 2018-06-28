@isTest
private class RefundDeferredTransaction_Test {

	static Account acc ;
    static Opportunity opp; 
    static ChargentSFA__Transaction__c obj;     
        
    static void testData() {
    	ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
    	insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        Acc = new Account(Name = 'test');
        insert acc;
         
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
        
        obj = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c=opp.Id,ChargentSFA__Type__c='Charge',ChargentSFA__Response_Status__c='Approved');
        insert obj;
        
    }
    
    static testMethod void unitTest_1(){
    	testData();
    	Apexpages.StandardController std = new Apexpages.StandardController(obj);
    	RefundDeferredTransaction transaction1 = new RefundDeferredTransaction(std);
    	transaction1.bPaidInFull = true;
    	transaction1.saveTransaction();
    	transaction1.CancelTransaction();
    	transaction1.getItems();
    }}