trigger onUpdateAttchment on Attachment (before insert) {
    
    List<Id> ids = new List<Id>();
    
	for(Attachment obj : trigger.New) {
        ids.add(obj.ParentId);
    }
    
    Id jobRecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c','Job Experience');
    
    List<Candidate_Requirement__c> creqs = [select Id, Name, Status__c, RecordTypeId from Candidate_Requirement__c where Id in :ids];
    List<Candidate_Requirement__c> creqsUpdate = new List<Candidate_Requirement__c>();
    for(Candidate_Requirement__c cr :creqs) {
        if(cr.RecordTypeId == jobRecordTypeID && cr.Status__c != 'Completed') {
            cr.Status__c = 'Ready For Review';
            creqsUpdate.add(cr);
        }
    }
    update creqsUpdate;
}