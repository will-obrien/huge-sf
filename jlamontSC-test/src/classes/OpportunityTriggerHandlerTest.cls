//*********************************************************************
// (c) 2014 Appirio, Inc.
//
//	Test Class for OpportunityTriggerHandler 
//	8 March 2014    Virendra (Appirio)     Original
//	Last Updated:   March 21, 2014  : KapiL Choudhary(Appirio India) Rename field for the task T-264724
//	Feb 9, 2014  	Vernon Baas: 	Broke out tests, added more tests for Account donor population.
//											Added new tests for Donor Contact population
//**********************************************************************/
@isTest
private class OpportunityTriggerHandlerTest {
	
	@IsTest
    static void testOpprtunityProductTypes () {
    	TestDataUtility testData = new TestDataUtility();
    	
    	Forecasting__c fc = new Forecasting__c();
    	fc.Beginning_Yr_Forecast_Final_Date__c = Date.newInstance(Date.Today().year(), 1, 1);
    	fc.Year__c = '' + Date.today().year();
    	fc.Name = 'test';
    	insert fc;
    	
    	Campaign cmp = new Campaign();
   	  cmp.Name = 'Mytest opp camp';
   	  cmp.Type = 'Promotion';
   	  cmp.Status = 'Planned';
   	  insert cmp;
   	  
    	Opportunity opp = testData.createNewGivingOpportunity();
    	opp.CampaignId = cmp.id;
    	opp.rC_Giving__Closed_Amount__c = opp.rC_Giving__Giving_Amount__c;
    	insert opp;  
        	
       opp = [Select id, GivingType__c,Recipient__c,FundType__c from Opportunity where id =: opp.Id];
       System.assertEquals(opp.GivingType__c, 'Donations');
       System.assertEquals(opp.Recipient__c, 'Club');
       System.assertEquals(opp.FundType__c, 'Chapter Funds');
       
       opp.GivingType__c = 'MemberShip';
       opp.Recipient__c = 'Senior';
       opp.FundType__c = 'Joint';
       
       update opp;
    	
       opp = [Select id, GivingType__c,Recipient__c,FundType__c from Opportunity where id =: opp.Id];
       System.assertEquals(opp.GivingType__c, 'Donations');
       System.assertEquals(opp.Recipient__c, 'Club');
       System.assertEquals(opp.FundType__c, 'Chapter Funds');
       
       delete opp;
       
    }
    
    // To Test GivingGAUTrigger and GivingGAUTriggerHandler
    @IsTest
    static void testProductTypesUpdate () {
    	TestDataUtility testData = new TestDataUtility();
    	Opportunity opp = testData.createNewGivingOpportunity();
    	Campaign cmp = new Campaign();
   	  	cmp.Name = 'Mytest opp camp';
   	  	cmp.Type = 'Promotion';
   	  	cmp.Status = 'Planned';
   	    insert cmp;
    	opp.CampaignId = cmp.id;
    	opp.rC_Giving__Closed_Amount__c = opp.rC_Giving__Giving_Amount__c;
    	insert opp;  
        	
       opp = [Select id,rC_Giving__GAU__c, GivingType__c,Recipient__c,FundType__c from Opportunity where id =: opp.Id];
       System.assertEquals(opp.GivingType__c, 'Donations');
       System.assertEquals(opp.Recipient__c, 'Club');
       System.assertEquals(opp.FundType__c, 'Chapter Funds');
       
       
       rC_Giving__GAU__c gau = [Select id , GivingType__c,Recipient__c,FundType__c from rC_Giving__GAU__c where id =:opp.rC_Giving__GAU__c limit 1];
       gau.GivingType__c = 'Donations';
       gau.Recipient__c = 'Legal Defense Fund';
       gau.FundType__c = 'Restricted National Funds';
       
       update gau;
    	
		opp = [Select id, GivingType__c,Recipient__c,FundType__c, AccountId, Proposal_Account__c from Opportunity where id =: opp.Id];
		System.assertEquals(opp.GivingType__c, 'Donations');
		System.assertEquals(opp.Recipient__c, 'Legal Defense Fund');
		System.assertEquals(opp.FundType__c, 'Restricted National Funds');
       
		System.assertEquals(opp.Proposal_Account__c, opp.AccountId);
		
		Opportunity opp2 = testData.createNewGivingOpportunity();
		opp2.rC_Giving__Closed_Amount__c = opp2.rC_Giving__Giving_Amount__c;
		opp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
		opp2.GivingType__c = 'Donation';
		insert opp2;
		
		// Confirm the Other Giving Account field gets populated
		opp2 = [SELECT Id, AccountId, Other_Giving_Account__c, Proposal_Account__c FROM Opportunity where id = :opp2.Id];
		System.assertEquals(opp2.Other_Giving_Account__c, opp2.AccountId);

    }

    // To Test Account & Contact lookup fields for related lists
    @IsTest
    static void testGivingDonorA () {
    	TestDataUtility testData = new TestDataUtility();
	
		Opportunity opp2 = testData.createNewGivingOpportunity();
		opp2.rC_Giving__Closed_Amount__c = opp2.rC_Giving__Giving_Amount__c;
		opp2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
		opp2.GivingType__c = 'Donation';
		insert opp2;
		
		// Confirm the Other Giving Account field gets populated
		opp2 = [SELECT Id, AccountId, Other_Giving_Account__c, Proposal_Account__c FROM Opportunity where id = :opp2.Id];
		System.assertEquals(opp2.Other_Giving_Account__c, opp2.AccountId);
		       
    }

    // To Test Account & Contact lookup fields for related lists
    @IsTest
    static void testGivingDonorB () {
    	TestDataUtility testData = new TestDataUtility();
	
		// VB: Test for Other Giving Contact populated
		Opportunity opp3 = testData.createNewGivingOpportunity();
		opp3.rC_Giving__Closed_Amount__c = opp3.rC_Giving__Giving_Amount__c;
		opp3.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
		opp3.GivingType__c = 'Donation';
		insert opp3;

		// Create the Contact and set it as the Donor Contact on the Opportunity
		Contact con3 = testData.createNewContact(true, 'Contact3FN', 'Contact3LN', 'Household', opp3.AccountId);
		//insert con3; 
		opp3.Donor_Contact__c = con3.Id;
		update opp3;
		
		// Confirm the Other Giving Account field gets populated
		opp3 = [SELECT 	Id, 
						AccountId, 
						Other_Giving_Account__c, 
						Proposal_Account__c,
						Donor_Contact__c,
						Proposal_Contact__c,
						Other_Giving_Contact__c 
					FROM Opportunity 
					WHERE id = :opp3.Id];
		// Does the Other Account match the opp Account
		System.assertNotEquals(opp3.Proposal_Account__c, opp3.AccountId);
		System.assertEquals(opp3.Other_Giving_Account__c, opp3.AccountId);

		// Does the Other Contact match the Donor Contact?		
		System.assertNotEquals(opp3.Proposal_Contact__c , opp3.Donor_Contact__c);
		System.assertEquals(opp3.Other_Giving_Contact__c, opp3.Donor_Contact__c);
		
    }

    // To Test Account & Contact lookup fields for related lists
    @IsTest
    static void testGivingDonorC () {
    	TestDataUtility testData = new TestDataUtility();
	
		// VB: Test for Proposal Giving Contact populated
		Opportunity opp4 = testData.createNewGivingOpportunity();
		opp4.rC_Giving__Closed_Amount__c = opp4.rC_Giving__Giving_Amount__c;
		opp4.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Proposal').getRecordTypeId();
		opp4.GivingType__c = 'Donation';
		insert opp4;

		// Create the Contact and set it as the Donor Contact on the Opportunity
		Contact con4 = testData.createNewContact(true, 'Contact3FN', 'Contact3LN', 'Household', opp4.AccountId);
		//insert con4; 
		opp4.Donor_Contact__c = con4.Id;
		update opp4;
		
		// Confirm the Other Giving Account field gets populated
		opp4 = [SELECT 	Id, 
						AccountId, 
						Other_Giving_Account__c, 
						Proposal_Account__c,
						Donor_Contact__c, 
						Proposal_Contact__c,
						Other_Giving_Contact__c 
					FROM Opportunity 
					WHERE id = :opp4.Id];
					
		// Does the Proposal Account match the opp Account
		System.assertEquals(opp4.Proposal_Account__c, opp4.AccountId);					// Reversed from above class
		System.assertNotEquals(opp4.Other_Giving_Account__c, opp4.AccountId);			// Reversed from above class

		// Does the Proposal Contact match the Donor Contact?		
		System.assertEquals(opp4.Proposal_Contact__c , opp4.Donor_Contact__c);			// Reversed from above class
		System.assertNotEquals(opp4.Other_Giving_Contact__c, opp4.Donor_Contact__c);	// Reversed from above class
		       
    }

}