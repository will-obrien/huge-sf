@isTest(SeeAllData=true)
public class CopyChatterFeedsTest
{
    static testMethod void runTest()
    {
        CopyChatterFeeds cpfeeds = new CopyChatterFeeds();
        cpfeeds.setIncrementTime(5);
        
        Chatter_Story__c chatterStory = new Chatter_Story__c();
        chatterStory.name = 'test chatter story';
        chatterStory.active__c = true;
        chatterStory.Watch_Word__c = '#test';
        chatterStory.Seconds_Apart_For_Posting__c = 10;
        insert chatterStory;
            
        FeedItem f = new FeedItem();
        f.parentId = [select id from Account Limit 1].id;
        f.body = '#competitive';
        f.type = 'TextPost';
        insert f;
        FeedComment fc = new FeedComment();
        fc.CommentBody = '#competitive';
        fc.FeedItemId = f.id;
        insert fc;
    }
}