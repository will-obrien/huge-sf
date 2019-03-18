@isTest(SeeAllData = TRUE)
public class OpportunityAddressDetailControllerTest {
	static testmethod void runTest(){
      
		//Create Opportunity.
      	Opportunity opportunityAddress = TestDataFactory.createOpportunities(1)[0];
      	// start the test execution context
        Test.startTest();
        // set the test's page to your VF page (or pass in a PageReference)
        Test.setCurrentPage(Page.OpportunityAddressDetail);
        // call the constructor
        OpportunityAddressDetailController testOpp = new OpportunityAddressDetailController(new ApexPages.StandardController(opportunityAddress));
        Address__c address = new address__c();
      	address.Address_Line_1__c = 'Line 1';
        address.City__c = 'City'; 
        address.Country__c = 'United States'; 
        address.State_Province__c = 'Alaska'; 
        address.Postal_Code__c = '55447';
        testOpp.selectAddress();
        testOpp.save();
               
       	insert address;
    	Opportunity opportunityAddress1 = TestDataFactory.createOpportunities(1)[0];
      	opportunityAddress1.Job_Address__c = Address.Id;
      	update opportunityAddress1;
        // set the test's page to your VF page (or pass in a PageReference)
        Test.setCurrentPage(Page.OpportunityAddressDetail);
        // call the constructor
        OpportunityAddressDetailController testOpp1 = new OpportunityAddressDetailController(new ApexPages.StandardController(opportunityAddress1));
        testOpp1.selectAddress();
        testOpp1.save();
        
        
        Opportunity opportunityAddress2 = TestDataFactory.createOpportunities(1)[0];
      	opportunityAddress2.Job_Address__c = Address.Id;
      	update opportunityAddress2;
        // set the test's page to your VF page (or pass in a PageReference)
        Test.setCurrentPage(Page.OpportunityAddressDetail);
		// call the constructor
        OpportunityAddressDetailController testOpp2 = new OpportunityAddressDetailController(new ApexPages.StandardController(opportunityAddress2));
        address.Postal_Code__c = '554471';
        testOpp2.selectAddress();
        testOpp2.save();
        // stop the test
        Test.stopTest();
      
   }  
}