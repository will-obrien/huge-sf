@isTest
private class TestTweetMyChatterTriggers {
	
	public static testMethod void testTweetPost() {
		GNationLive__c GNationLive = new GNationLive__c(Name='GStock13',Group_Id__c='0F9e0000000Ccgd',refresh_time__c=10);
		insert GNationLive;
		FeedItem f = new FeedItem();
		f.Body = 'Test a tweet ' + TwitterClient.hashTag;
		f.ParentId = UserInfo.getUserId();
		insert f;
	}

	public static testMethod void testTweetLink() {
		GNationLive__c GNationLive = new GNationLive__c(Name='GStock13',Group_Id__c='0F9e0000000Ccgd',refresh_time__c=10);
		insert GNationLive;
		FeedItem f = new FeedItem();
		f.Body = 'Test a tweet ' + TwitterClient.hashTag;
		f.ParentId = UserInfo.getUserId();
		f.LinkUrl = 'http://gadventures.com';
		insert f; 
	}

	public static testMethod void testTweetContent() {
		GNationLive__c GNationLive = new GNationLive__c(Name='GStock13',Group_Id__c='0F9e0000000Ccgd',refresh_time__c=10);
		insert GNationLive;
		FeedItem f = new FeedItem();
		f.Body = 'Test a tweet ' + TwitterClient.hashTag;
		f.ContentData = Blob.valueOf('Test Picture');
		f.ContentFileName = 'TestPicture.jpg';
		f.ParentId = UserInfo.getUserId();
		insert f; 
	}	
	
	public static testMethod void testTweetComment() {
		GNationLive__c GNationLive = new GNationLive__c(Name='GStock13',Group_Id__c='0F9e0000000Ccgd',refresh_time__c=10);
		insert GNationLive;
		FeedItem f = new FeedItem();
		f.Body = 'Test a tweet ' + TwitterClient.hashTag;
		f.ParentId = UserInfo.getUserId();
		insert f;
		
		FeedComment fc = new FeedComment();
		fc.CommentBody = 'Test a tweet ' + TwitterClient.hashTag;
		fc.FeedItemId = f.Id;
		insert fc;
	}
}