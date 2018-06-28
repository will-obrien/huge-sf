trigger FeedItemAfterInsert on FeedItem (after insert) {
	List<Chatter_Post_Comment_Table__c> chatterposts = new List<Chatter_Post_Comment_Table__c>();
	GNationLive__c GNationLive = [Select Group_Id__c, Refresh_Time__c from GNationLive__c Limit 1];
	User adminUser = [Select Id from user where IsActive = true and firstName = 'Ricky' and lastName = 'Li' limit 1]; 
    Id GNationGroup = GNationLive.Group_Id__c;
    
	for(FeedItem fi: trigger.new){
		if(fi.ParentId == GNationGroup){
			Chatter_Post_Comment_Table__c post = new Chatter_Post_Comment_Table__c(
				Body__c = fi.Body,
				CreatedById__c = fi.CreatedById,
				CreatedDate__c = fi.CreatedDate,
				RelatedRecordId__c = fi.RelatedRecordId,
				ContentType__c = fi.ContentType,
				FeedItemId__c = fi.Id,
				Post_RelatedRecordId__c = null,
				isComment__c = false,
				Type__c = fi.Type,
				Title__c = fi.Title,
				Post_Body__c = fi.LinkUrl,
				OwnerId = adminUser.Id	
			);		
			chatterposts.add(post);
		}
	}
	if(!chatterposts.isEmpty()){
		try{
			insert(chatterposts);
		}catch(exception e){			
		}
	}
}