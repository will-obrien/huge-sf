trigger FeedCommentAfterInsert on FeedComment (after insert) {
	List<Chatter_Post_Comment_Table__c> chatterposts = new List<Chatter_Post_Comment_Table__c>();
	GNationLive__c GNationLive = [Select Group_Id__c, Refresh_Time__c from GNationLive__c Limit 1];
	User adminUser = [Select Id from user where IsActive = true and firstName = 'Ricky' and lastName = 'Li' limit 1]; 
    Id GNationGroup = GNationLive.Group_Id__c;
	Set<Id> fiId = new Set<Id>();	

	for(FeedComment fc: trigger.new){
		if(fc.ParentId == GNationGroup){
			fiId.add(fc.FeedItemId);
		}
	}
	
	Map<Id, FeedItem> fiBody = new Map<Id, FeedItem>([SELECT Id, Body, RelatedRecordId, Type, Title, LinkUrl FROM FeedItem WHERE Id in: fiId]);
	
	for(FeedComment fc: trigger.new){
		if(fc.ParentId == GNationGroup){
			String Post_RelatedRecordId = '';
			String Type = '';
			String Post_Body = '';
			String Title = '';
			if(fiBody.get(fc.FeedItemId) != null){
				if(fiBody.get(fc.FeedItemId).Type == 'LinkPost'){
					Post_RelatedRecordId = fiBody.get(fc.FeedItemId).LinkUrl;					
				}else{
					Post_RelatedRecordId = fiBody.get(fc.FeedItemId).RelatedRecordId;
				}
				Title = fiBody.get(fc.FeedItemId).Title;
				Type = fiBody.get(fc.FeedItemId).Type;
				Post_Body = fiBody.get(fc.FeedItemId).body;
			}
			Chatter_Post_Comment_Table__c post = new Chatter_Post_Comment_Table__c(
				Body__c = fc.CommentBody,
				CreatedById__c = fc.CreatedById,
				CreatedDate__c = fc.CreatedDate,
				RelatedRecordId__c = fc.RelatedRecordId,
				ContentType__c = fc.CommentType,
				FeedItemId__c = fc.FeedItemId,				
				Post_RelatedRecordId__c = Post_RelatedRecordId,
				isComment__c = true,
				Type__c = Type,
				Title__c = Title,
				Post_Body__c = Post_Body,
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