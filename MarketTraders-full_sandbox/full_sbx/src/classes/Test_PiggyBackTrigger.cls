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
@isTest(seeAllData=true)
private class Test_PiggyBackTrigger {

    static testMethod void testInsertOpportunity() {
        Account a = new Account();
        a.FirstName = 'test';
        a.LastName = 'acc';
        a.Country_List__c = 'United States Of America';
        a.Phone = '4078835257'; 
        insert a;
                
        Opportunity o = New  Opportunity();
        o.Name = 'Test opp';
        o.CloseDate = Date.today();
        o.Product__c = 'Charting';
        o.StageName = 'New Deal';
        o.AccountId = a.id;
        
        test.startTest();
        	Database.insert(o);
        test.stopTest();
    }
    
    static testMethod void testInsertUCPOpportunity() {
        Account a = new Account();
        a.FirstName = 'test';
        a.LastName = 'acc';
        a.Country_List__c = 'United States Of America';
        a.Phone = '4078835257'; 
        insert a;
                
        List<Opportunity> ucpOpps = new List<Opportunity>();
        Opportunity o = New  Opportunity();
        o.Name = 'Test opp';
        o.CloseDate = Date.today();
        o.Product__c = 'Ultimate Charting Pro (Forex Feed)';
        o.Charting_Expiration__c = Date.today();
        o.StageName = 'New Deal';
        o.AccountId = a.id;
        ucpOpps.add(o);
        
        o = New  Opportunity();
        o.Name = 'Test opp';
        o.CloseDate = Date.today();
        o.Product__c = 'Ultimate Charting Pro (Stocks Feed)';
        o.Charting_Expiration__c = Date.today();
        o.StageName = 'New Deal';
        o.AccountId = a.id;
        ucpOpps.add(o);
        
        test.startTest();
        	Database.insert(ucpOpps);
        test.stopTest();
    }
    
    static testMethod void testUpdateOpportunityNewDealToAttempted() {
        Account a = new Account();
        a.FirstName = 'test';
        a.LastName = 'acc';
        a.Country_List__c = 'United States Of America';
        a.Phone = '4078835257'; 
        insert a;
                
        Opportunity o = New  Opportunity();
        o.Name = 'Test opp';
        o.CloseDate = Date.today();
        o.Product__c = 'Charting';
        o.StageName = 'New Deal';
        o.AccountId = a.id;
        Database.insert(o);
        
        test.startTest();
        	o.Stagename = 'Attempted 1';
        	Database.update(o);
        test.stopTest();
    }
    
    static testMethod void testUpdateOpportunityNewDealToClosedLost() {
        Account a = new Account();
        a.FirstName = 'test';
        a.LastName = 'acc';
        a.Country_List__c = 'United States Of America';
        a.Phone = '4078835257'; 
        insert a;
                
        Opportunity o = New  Opportunity();
        o.Name = 'Test opp';
        o.CloseDate = Date.today();
        o.Product__c = 'Charting';
        o.StageName = 'New Deal';
        o.AccountId = a.id;
        Database.insert(o);
        
        test.startTest();
        	o.Stagename = 'Closed Lost';
        	Database.update(o);
        test.stopTest();
    }
    
    static testMethod void testUpdateOpportunityClosedLostToNewDeal() {
        Account a = new Account();
        a.FirstName = 'test';
        a.LastName = 'acc';
        a.Country_List__c = 'United States Of America';
        a.Phone = '4078835257'; 
        insert a;
                
        Opportunity o = New  Opportunity();
        o.Name = 'Test opp';
        o.CloseDate = Date.today();
        o.Product__c = 'Charting';
        o.StageName = 'Closed Lost';
        o.AccountId = a.id;
        Database.insert(o);
        
        test.startTest();
        	o.Stagename = 'New Deal';
        	Database.update(o);
        test.stopTest();
    }
    
    static testMethod void testOver5Opportunities() {
        Account a = new Account();
        a.FirstName = 'test';
        a.LastName = 'acc';
        a.Country_List__c = 'United States Of America';
        a.Phone = '4078835257'; 
        insert a;
        
        list<Opportunity> opportunities = new list<Opportunity>();
        for(integer x = 0; x < 200; x++){        
	        Opportunity o = New  Opportunity();
	        o.Name = 'Test opp';
	        o.CloseDate = Date.today();
	        o.Product__c = 'Charting';
	        o.StageName = 'New Deal';
	        o.AccountId = a.id;
	        opportunities.add(o);
        }
        
        
        test.startTest();
        	Database.insert(opportunities);
        	for(Opportunity opp : opportunities){
        		opp.Stagename = 'Closed Lost';
        	}
        	Database.update(opportunities);
        test.stopTest();
    }
    
    /*
    static testMethod void testUpdateOpportunityChangeOwner() {
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
		UserRole r = [SELECT Id FROM UserRole WHERE Name = 'Entire Org'];
		
      	User u1 = new User(
      		Alias = 'jhmtix', Email='jhmti1@testorg.com', 
      		EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      		LocaleSidKey='en_US', ProfileId = p.Id, UserRoleId = r.Id,
      		TimeZoneSidKey='America/Los_Angeles', UserName='jhmti1@testorg.com'
      	);
      	Database.insert(u1);
      	
      	User u2 = new User(
      		Alias = 'jhmtixx', Email='jhmti2@testorg.com', 
      		EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
      		LocaleSidKey='en_US', ProfileId = p.Id, 
      		TimeZoneSidKey='America/Los_Angeles', UserName='jhmti2@testorg.com'
      	);
      	Database.insert(u2);
      	
      	Account a = new Account();
        a.FirstName = 'test';
        a.LastName = 'acc';
        a.Country_List__c = 'United States Of America';
        a.Phone = '4078835257'; 
        insert a;
                
        Opportunity o = New  Opportunity();
        o.Name = 'Test opp';
        o.CloseDate = Date.today();
        o.Product__c = 'Charting';
        o.StageName = 'New Deal';
        o.AccountId = a.id;
        o.OwnerId = u1.Id;
        Database.insert(o);
        
        test.startTest();
        	o.OwnerId = u2.Id;
        	Database.update(o);
        test.stopTest();
      	
    }
    */
}