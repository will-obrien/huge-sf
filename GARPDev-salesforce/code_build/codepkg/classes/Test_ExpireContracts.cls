@isTest
private class Test_ExpireContracts {

	static Account acc ;
    static Opportunity opp; 
    static Contract contract;
    static Contact contact;
	static Candidate_Requirement__c reqt;
	
	static void testData(){
	
		insert new UpdateIds__c(Name='Payment', Record_Id__c='a0cf00000041nXB');
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');        
        ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        Acc = new Account(Name = 'test');
        insert acc;
         
        opp = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opp;
	
		Contract  = new Contract(Opportunity__c = opp.id, AccountId = opp.AccountId ,ContractTerm = 12 ,StartDate = opp.CloseDate );
        insert contract;
		
		reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        reqt.status__c = 'Initial';
        reqt.Exam__c = 'FRM Full';
        insert reqt;
        
        
	}
    static testMethod void myUnitTest() {
        testData();
        
        test.startTest();
        database.executeBatch(new expireContracts());
        test.stopTest();
        
    }
}