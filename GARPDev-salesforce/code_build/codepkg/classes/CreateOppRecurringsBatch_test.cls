@isTest
private class CreateOppRecurringsBatch_test {
	static Account account ;
    static Opportunity opportunity; 
    static ChargentBase__Gateway__c chrgGtway;
    
    static ChargentSFA__Transaction__c chargentTrans;
    
    static void testData(){
        
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
         
        opportunity = new Opportunity(ChargentSFA__Payment_Frequency__c = 'Once',ChargentSFA__Payment_Status__c = 'Recurring',amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 10,ChargentSFA__Payment_Method__c = 'Credit Card');        
        insert opportunity;
         
        chargentTrans = new ChargentSFA__Transaction__c();
           
        chargentTrans.ChargentSFA__Opportunity__c = opportunity.iD;
        chargentTrans.ChargentSFA__Response_Status__c = 'Approved';
        chargentTrans.ChargentSFA__Amount__c = 123;
        chargentTrans.ChargentSFA__Type__c = 'Charge';
        chargentTrans.ChargentSFA__Recurring__c = true;
        chargentTrans.ChargentSFA__Gateway_Date__c = system.today()+1 ;
        insert chargentTrans;
    }
    static testMethod void myUnitTest() {
    	testdata();
    	CreateOppRecurringsBatch batch  = new CreateOppRecurringsBatch();
    	database.executebatch(batch);
    }
}