@isTest (seeAllData=true)
private class OpportunityProductTriggerTest {
	
	public static testmethod void opportunityProductTriggerTest() {
		
		Pricebook2 standardPb = [select id, name, isActive from Pricebook2 where isStandard = true limit 1];
		
		Pricebook2 pb = new Pricebook2(Name='Test PB', isActive=true);
		insert pb;
		
		Product2 prod = new Product2(Name='Test Product', ProductCode='TEST', isActive=true);
		insert prod;
		
		PricebookEntry pbe = new PricebookEntry(Product2ID=prod.Id, Pricebook2Id=standardPb.id, UnitPrice=50, isActive=true);
		insert pbe;
		
		Opportunity opp = new Opportunity(Name='Test Opp', CloseDate=date.today(), StageName='Stage 1 - Connecting');
		insert opp;
		
		OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=opp.Id, PricebookEntryId=pbe.Id, Quantity=1, totalPrice=50 );
		insert oli;
		
		OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId=opp.Id, PricebookEntryId=pbe.Id, Quantity=1, totalPrice=50 );
        insert oli2;
	}	
	
	public static testmethod void tagsUpdateTest() {
		Pricebook2 pb = [select id, name, isActive from Pricebook2 where isStandard = true limit 1];
        
        Product2 prod = new Product2(Name='CommCare', ProductCode='TEST', isActive=true);
        insert prod;
        
        Product2 prod2 = new Product2(Name='CommConnect', ProductCode='TEST', isActive=true);
        insert prod2;
        
        Product2 prod3 = new Product2(Name='CommTrack', ProductCode='TEST', isActive=true);
        insert prod3;
        
        PricebookEntry pbe = new PricebookEntry(Product2ID=prod.Id, Pricebook2Id=pb.id, UnitPrice=50, isActive=true);
        insert pbe;
        
        PricebookEntry pbe2 = new PricebookEntry(Product2ID=prod2.Id, Pricebook2Id=pb.id, UnitPrice=50, isActive=true);
        insert pbe2;
        
        PricebookEntry pbe3 = new PricebookEntry(Product2ID=prod3.Id, Pricebook2Id=pb.id, UnitPrice=50, isActive=true);
        insert pbe3;
        
        Opportunity opp = new Opportunity(Name='Test Opp', CloseDate=date.today(), StageName='Stage 1 - Connecting');
        insert opp;
        
        List<OpportunityLineItem> prods = new List<OpportunityLineItem>();
        OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=opp.Id, PricebookEntryId=pbe.Id, Quantity=1, totalPrice=50 );
        
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId=opp.Id, PricebookEntryId=pbe2.Id, Quantity=1, totalPrice=50 );
        prods.add(oli2);
        
        OpportunityLineItem oli3 = new OpportunityLineItem(OpportunityId=opp.Id, PricebookEntryId=pbe3.Id, Quantity=1, totalPrice=50 );
        prods.add(oli3);
        
        Test.startTest();
        
        insert oli;
        insert prods;
        
        delete prods;
        
        Test.stopTest();
        
        
	}
	
}