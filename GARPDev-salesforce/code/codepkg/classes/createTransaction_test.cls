@isTest
private class createTransaction_test {

	static Account acc ;
    static Opportunity opp; 
    
        
        
    static void testData() {
    	ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
    	insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        Acc = new Account(Name = 'test');
        insert acc;
         
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
    }
    
    static testMethod void unitTest_1(){
    	testData();
    	Apexpages.StandardController std = new Apexpages.StandardController(opp);
    	createTransaction transaction1 = new createTransaction(std);
    	transaction1.bPaidInFull = true;
    	transaction1.saveTransaction();
    	transaction1.CancelTransaction();
    	transaction1.getItems();
    }
}