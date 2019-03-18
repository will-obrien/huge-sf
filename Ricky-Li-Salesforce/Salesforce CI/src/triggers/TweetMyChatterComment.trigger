trigger TweetMyChatterComment on FeedComment (after insert) {
    for(FeedComment f : trigger.new) {
        if(f.CommentBody != null){
            if(f.CommentBody.contains(TwitterClient.hashTag)) {
                TwitterClient.tweet(f.CommentBody.replaceAll(TwitterClient.hashTag, ''));
            }
        }
    }
}