@isTest
private class PostNewIdeaOnChatterTestClass {
    static testMethod void validatePost() {
        GNationLive__c GNationLive = new GNationLive__c(Name='GStock13',Group_Id__c='0F9e0000000Ccgd',refresh_time__c=10);
        insert GNationLive;
        //Create new idea
        Idea i = new Idea();
        i.CreatedById = UserInfo.getUserId();
        i.Title = 'TestIdea Title';
        i.Body = 'Test Idea Body';
        i.CommunityId = '09a30000000J5qh';
        insert i;
        
        //Validate a new Chatter FeedItem was entered
        List<NewsFeed> myfeed = [SELECT Id,CreatedById, Body, Title, LinkUrl
                         FROM NewsFeed
                         ORDER BY CreatedDate DESC, Id DESC
                         LIMIT 1];
                         
        for(NewsFeed nf : myfeed) {
            System.assertEquals(nf.Title, 'TestIdea Title');
            System.assertEquals(nf.Body, 'I just posted a new idea.  Please vote! #ideas');
            System.assertEquals(nf.CreatedById, UserInfo.getUserId());
        }
    }
}