@isTest
private class Test_Extension_LeadMergeReader {
	
	private static testMethod void unitTest() {
		
		Lead lead = new Lead();
    	lead.FirstName = 'Clark';
    	lead.LastName = 'Kent';
   		lead.leadSource = 'Newspaper';
    	lead.Email = 'clark.kent@smallville.com';
    	Database.insert(lead);
		
		Lead dupeLead = new Lead();
    	dupeLead.FirstName = 'Bizarro';
    	dupeLead.LastName = 'Kent';
   		dupeLead.leadSource = 'Newspaper';
    	dupeLead.Email = 'clark.kent@smallville.com';
    	Database.insert(dupeLead);

		Attachment duplicateLeadAttachment = new Attachment();
		duplicateLeadAttachment.ContentType = '.json';
		duplicateLeadAttachment.Description = 'This document contains the values of a merged lead';
		duplicateLeadAttachment.Name = 'Merged Lead:' + DateTime.now();
		duplicateLeadAttachment.ParentId = lead.id;
		duplicateLeadAttachment.body = Blob.valueOf(JSON.serialize(dupeLead));
		Database.insert(duplicateLeadAttachment);
		
	    list<LeadHistory> leadHistory = [SELECT Id,NewValue,OldValue,LeadId,Field,CreatedDate FROM LeadHistory WHERE LeadId = :dupeLead.Id ORDER BY CreatedDate limit 50000];
		Attachment duplicateLeadHistoryAttachment = new Attachment();
		duplicateLeadHistoryAttachment.ContentType = '.json';
		duplicateLeadHistoryAttachment.Description = 'This document contains the history of a merged lead';
		duplicateLeadHistoryAttachment.Name = 'Merged Lead History:' + duplicateLeadAttachment.Id;
		duplicateLeadHistoryAttachment.ParentId = lead.id;
		duplicateLeadHistoryAttachment.body = Blob.valueOf(JSON.serialize(leadHistory));
		Database.insert(duplicateLeadHistoryAttachment);

		ApexPages.StandardController controller = new ApexPages.StandardController(lead);
				
		Lead_Merger__c mergerSetting = new Lead_Merger__c();
		mergerSetting.Name = 'Email';
		mergerSetting.Field_Name__c = 'Email';
		Database.insert(mergerSetting);
		
		test.startTest();

			Extension_LeadMergeReader reader = new Extension_LeadMergeReader(controller);
			reader.getLeadMergerSettings();
        	reader.getMergedLeadSection();
        	reader.getMergedLeadHistorySection();
        
        	reader.getPageNumber();
        	boolean hasNext = reader.hasNext;
        	boolean hasPrevious = reader.hasPrevious;
        	reader.next();	
        	reader.previous();
        	reader.first();
        	reader.last();
        	reader.getNumberOfPages();
        	reader.getResultSize();
        
        
        	reader.selectedMergedLeadId = 'abacac';
        	reader.setLead();
        	reader.selectedMergedLeadId = null;
        	reader.setLead();
			
		test.stopTest();
		
	}

}