/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_OpportunityWrapper {
	
	static testMethod void myUnitTest() {
		
		Account a = new Account();
        a.FirstName = 'test';
        a.LastName = 'acc';
        a.pb_SubBegin_Charting__c = Date.today(); 
        a.pb_CurrSubBeg_Charting__c = Date.today(); 
        a.pb_SubEnd_Charting__c = Date.today(); 
        a.pb_PrevSubEnd_Charting__c = Date.today(); 
        insert a;

        Account a2 = new Account();
        a2.FirstName = 'test';
        a2.LastName = 'acc';
        a2.pb_SubBegin_Charting__c = Date.today(); 
        a2.pb_CurrSubBeg_Charting__c = Date.today(); 
        a2.pb_SubEnd_Charting__c = Date.today(); 
        a2.pb_PrevSubEnd_Charting__c = Date.today(); 
        insert a2;
         
        Opportunity o = New  Opportunity();
        o.Name = 'Test opp';
        o.Product__c = 'Charting';
        o.StageName = 'Closed Lost';
        o.Sale_Invoice_First_Date_After_Down__c = Date.today();
        o.Sale_Invoice_Qty_Payments_After_Down__c = 1;
        o.Sub_Stage__c = 'Cancelled';
        o.Amount = 200.00;
        o.AccountId = a.id;
        o.CloseDate = Date.today();
        o.Charting_Start__c = Date.today(); 
        o.Charting_Expiration__c = Date.today(); 
        o.Purchase_Amount__c = 1234.56; 
        
        map<String,String> ownerIds = new map<String,String>{'00560000000mIAO'=>'Financial Holdings, Next Step'};
        
        test.startTest();
        	OpportunityWrapper wrapper = new OpportunityWrapper(o,ownerIds);
        	wrapper.getOwners();
        	wrapper.selectedOwnerId = '00560000000mIAO';
        	wrapper.setOpportunityOwnerId();
        	wrapper = new OpportunityWrapper(ownerIds);
        	wrapper.setOpportunity(o);
        test.stopTest();
        
	}

}