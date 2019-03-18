@isTest
private class Test_LeadHandler {

	private static testMethod void testDuplicateLeadInsert(){
		
		Lead lead = new Lead();
    	lead.FirstName = 'Clark';
    	lead.LastName = 'Kent';
   		lead.leadSource = 'Newspaper';
    	lead.Email = 'clark.kent@smallville.com';
    	lead.leadSource = 'test lead source';
    	lead.Lead_Source_Detail__c = 'test lead source detail';
    	lead.Lead_Source_Date__c = Date.today();
    	Database.insert(lead);
    	
    	list<Lead> leads = [SELECT id,FirstName,LastName FROM Lead];
		system.assertEquals(1,leads.size());
		
		Lead dupeLead = new Lead();
    	dupeLead.FirstName = 'Bizarro';
    	dupeLead.LastName = 'Kent';
   		dupeLead.leadSource = 'Newspaper';
    	dupeLead.Email = 'clark.kent@smallville.com';
    	
    	Lead_Merger__c leadMerger = new Lead_Merger__c();
    	leadMerger.Name = 'FirstName';
    	leadMerger.Field_Name__c = 'FirstName';
    	leadMerger.Order__c = 0;
    	Database.insert(leadMerger);

    	test.startTest();
    		Database.insert(dupeLead); 
		test.stopTest();
		
		leads = [SELECT id,FirstName,LastName FROM Lead WHERE isDeleted = false];
		//system.assertEquals(1,leads.size());
		//system.assertEquals('Clark',leads[0].FirstName);
		
	}
	
	private static testMethod void testDuplicateLeadUpdate(){
		
		Lead lead = new Lead();
    	lead.FirstName = 'Clark';
    	lead.LastName = 'Kent';
   		lead.leadSource = 'Newspaper';
    	lead.Email = 'clark.kent@smallville.com';
    	lead.leadSource = 'test lead source';
    	lead.Lead_Source_Detail__c = 'test lead source detail';
    	lead.Lead_Source_Date__c = Date.today();
    	Database.insert(lead);
    	
    	list<Lead> leads = [SELECT id,FirstName,LastName FROM Lead];
		system.assertEquals(1,leads.size());
		
		Lead dupeLead = new Lead();
    	dupeLead.FirstName = 'Bizarro';
    	dupeLead.LastName = 'Kent';
   		dupeLead.leadSource = 'Newspaper';
    	dupeLead.Email = 'clark1.kent@smallville.com';
    	Database.insert(dupeLead); 
    	
    	leads = [SELECT id,FirstName,LastName FROM Lead];
		system.assertEquals(2,leads.size());
    	
    	Lead_Merger__c leadMerger = new Lead_Merger__c();
    	leadMerger.Name = 'FirstName';
    	leadMerger.Field_Name__c = 'FirstName';
    	leadMerger.Order__c = 0;
    	Database.insert(leadMerger);

    	test.startTest();
    		dupeLead.LeadSource = 'testing history';
    		dupeLead.Phone = '34234234234234';
    		Database.update(dupeLead);
    		dupeLead.Email = 'clark.kent@smallville.com';
    		Database.update(dupeLead);
		test.stopTest();
		
		leads = [SELECT id,FirstName,LastName FROM Lead WHERE isDeleted = false];
		//system.assertEquals(1,leads.size());
		//system.assertEquals('Clark',leads[0].FirstName);
		
	}
	
	private static testMethod void testMergeLeadFailure(){

    	test.startTest();
    		LeadMerger.mergeLead(null,null);
		test.stopTest();

		
	}

}