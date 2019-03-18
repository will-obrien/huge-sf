trigger PostNewIdeaOnChatter on Idea (after insert) {

    Idea[] ideas = Trigger.new;
    List<FeedItem> posts = new List<FeedItem>();
    
    for(Idea i : ideas) {
        FeedItem post = new FeedItem();
        post.ParentId = UserInfo.getUserId();
        post.CreatedById = UserInfo.getUserId();
        post.Title = i.Title;
        post.Body = 'I just posted a new idea.  Please vote! #ideas';
        post.LinkUrl = '/ideas/viewIdea.apexp?id=' + i.Id;
        posts.add(post);
    }
    insert posts;
}