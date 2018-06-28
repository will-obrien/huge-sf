/**************************************************
Class Name: OpportunityContractControllerTest
Class Description: Class for Contract creating from an Opportunity Testing and Coverage
Author: Virginia Fernández (vfernandez@adooxen.com)
Update Date: 2013-04-10
Additional Comments: 
**************************************************/
@isTest(SeeAllData=true)
private class OpportunityContractControllerTest {

    static testMethod void testNewContract() {
    	Account account = new Account();
	    account.Name = 'Test';
	    insert account;
	    
	    Business_Unit__c bunit = new Business_Unit__c();
	    bunit.Name = 'Test';
	    insert bunit; 
	    
    	Opportunity opp = new Opportunity();
    	opp.Name = 'Test';
    	opp.StageName = 'Stage 1 - Connect';
    	opp.CloseDate = Date.newInstance(2013, 4, 9);
    	opp.Area__c = 'Health';
        opp.Sub_Area__c = 'Food Security';
        opp.AccountId = account.Id;
        opp.Funder_Account__c = account.Id;
        opp.Implementing_Business_Unit__c = bunit.Id;
        opp.Proposal_Dropbox_Location__c = 'proposal';
        opp.X7_Long_term_partnership_or_one_off__c = 'long term';
        opp.X10_Major_component_risks__c = 'risk';
    	insert opp;
    	
    	Country__c country = new Country__c();
    	country.Name = 'Test';
    	insert country;
    	
    	OpportunityCountry__c oppcountry = new OpportunityCountry__c();
    	oppcountry.Country__c = country.id;
    	oppcountry.Opportunity__c = opp.id;
    	insert oppcountry;
    	
    	Product2 product = new Product2();
    	product.Name = 'Product';
    	insert product;
    	
    	Pricebook2 pb = [select id from PriceBook2 where isStandard = true limit 1];
    	
    	PricebookEntry pricebook = new PricebookEntry();
    	pricebook.Product2Id = product.id;
    	pricebook.UnitPrice = 1;
    	pricebook.Pricebook2Id = pb.Id;
    	pricebook.IsActive = true;
    	insert pricebook;
    	
    	OpportunityLineItem lineItem = new OpportunityLineItem();
    	lineItem.OpportunityId = opp.id;
    	lineItem.PricebookEntryId = pricebook.id;
    	lineItem.Quantity = 1;
    	lineItem.TotalPrice = 1;
    	insert lineItem;
    	
    	
    	ApexPages.StandardController sc = new ApexPages.standardController(opp);
    	PageReference oppPage = sc.view();
        Test.setCurrentPageReference(oppPage);
    	
        OpportunityContractController opportunityContract = new OpportunityContractController(sc);
        Test.startTest();
        
        PageReference contrPage = opportunityContract.createContract();
        String contrId = contrPage.getUrl().substring(1);
        
        DContract__c contract = [select Name,
                                        Funder_Account__c,
                                        Account__c,
                                        Area__c,
                                        Sub_Area__c,
                                        Prime_Contracting_Business_Unit__c,
                                        Proposal_Dropbox_Location__c,
                                        Long_term_partnership_or_one_off__c,
                                        Major_Component_Risks__c,
                                        (select Product__c from Products__r),
                                        (select Country__c from Contract_Countries__r),
                                        (select Opportunity__c from Opportunity_Contract__r)
                                 from DContract__c
                                 where Id =: contrId
                                 limit 1];
                                 
        System.assertEquals(contract.Name, opp.Name);
        System.assertEquals(contract.Funder_Account__c, opp.Funder_Account__c);
        System.assertEquals(contract.Account__c, opp.AccountId);
        System.assertEquals(contract.Area__c, opp.Area__c);
        System.assertEquals(contract.Sub_Area__c, opp.Sub_Area__c);
        System.assertEquals(contract.Prime_Contracting_Business_Unit__c, opp.Implementing_Business_Unit__c);
        System.assertEquals(contract.Proposal_Dropbox_Location__c, opp.Proposal_Dropbox_Location__c);
        System.assertEquals(contract.Long_term_partnership_or_one_off__c, opp.X7_Long_term_partnership_or_one_off__c);
        System.assertEquals(contract.Major_Component_Risks__c, opp.X10_Major_component_risks__c);
        System.assertEquals(contract.Products__r.size(), 1);
        System.assertEquals(contract.Products__r[0].Product__c, product.Id);
        System.assertEquals(contract.Contract_Countries__r.size(), 1);
        System.assertEquals(contract.Contract_Countries__r[0].Country__c, country.Id);
        System.assertEquals(contract.Opportunity_Contract__r.size(), 1);
        System.assertEquals(contract.Opportunity_Contract__r[0].Opportunity__c, opp.Id);
        
        Test.stopTest();
    }
}