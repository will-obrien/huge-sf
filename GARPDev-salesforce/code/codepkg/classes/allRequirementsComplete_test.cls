@isTest
public class allRequirementsComplete_test {

    Static Account acc;
    Static contract c;
    static void testdata()
    {
        	        	
        	acc = new Account(name = 'Test Account1', CurrencyIsoCode = 'USD', Calculated_Expire_Date__c = system.today(), Last_Contract_Exp_Calc__c = system.today());
        	insert acc;
        
        	Account a1 = new Account(name = 'Test Account1', Profile_ID__c = 'RP0000041014');
            insert a1;
        
            Contact c1 = new contact(lastname = 'Test Contact1', AccountID = a1.ID, email = 'testcontact1@contact.com', KPI_Member__c = True );
            insert c1;
        
            ChargentBase__Gateway__c chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'test-4',ChargentBase__Active__c = true );
            insert chrgGtway;
        
            insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
            opportunity o1 = new Opportunity(ChargentSFA__Gateway__c = chrgGtway.id, amount = 123,Name = 'Test', CurrencyIsoCode = 'USD', Eligible_for_Membership_Extension__c = false,Company__c = 'GARP', accountId = a1.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15,Pay_By_Wire_Check__c=false);        
            insert o1;
        
        	c = new contract(Accountid = acc.id,Status = 'Draft',CurrencyIsoCode = 'USD',All_Requirements_Completed__c = False);
        	insert c;
        	c.Status = 'Activated';
        	update c;
        
        	contract con = new contract(StartDate = system.today(),Opportunity__c = o1.id,Accountid = acc.id,Status = 'Draft',CurrencyIsoCode = 'USD',All_Requirements_Completed__c = False,Membership_type__C ='Individual');
        	insert con;
        	con.Status = 'Activated ( Auto-Renew )';
        	con.ContractTerm = 12;
        	con.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
        	update con; 
        
        	contract con1 = new contract(StartDate = system.today(),Opportunity__c = o1.id,Accountid = acc.id,Status = 'Draft',CurrencyIsoCode = 'USD',All_Requirements_Completed__c = False,Membership_type__C ='Student');
        	insert con1;
        	con1.Status = 'Activated ( Auto-Renew )';
        	con1.ContractTerm = 12;
        	con1.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
        	update con1;
        	con1.Status = 'Activated';
        	update con1;
        
        	Candidate_Requirement__c cr = new Candidate_Requirement__c(Name='FRM Pass 1',Candidate_Commitment__c = c.id);
        	insert cr;

        
    }
    
    static testMethod void myUnitTest() {
		testData();
        test.startTest();
        c.All_Requirements_Completed__c = True;
        update c;
        test.stopTest();
    }
}