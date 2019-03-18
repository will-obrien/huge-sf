trigger TweetMyChatterPost on FeedItem (after insert) {

    for(FeedItem f : trigger.new) {
      //Check if the size is null
      if(f.Body != null){       
        if(f.Body.contains(TwitterClient.hashTag)) {
            
            String post = f.Body.replaceAll(TwitterClient.hashTag, '');
            
            //Check if the post if of type 'Link'
            if(f.Type.equals('LinkPost')) {
                
                if(post.trim().length()>0) {
                    post = post + '- ' + f.LinkUrl;
                }
                else {
                    post = f.LinkUrl;
                }
                
                TwitterClient.tweet(post);
            }
            //Check if the post is of type 'Content' i.e. Picture
            else if(f.Type.equals('ContentPost') || f.Type.equals('TextPost')) {
                //String filename = f.ContentFileName.toLowerCase();
                //if(filename.endsWith('.jpg') || filename.endsWith('.jpeg') || filename.endsWith('.png') || filename.endsWith('.gif')) {
                    //TwitterClient.tweet(post, f.ContentData, f.ContentFileName);  
                    TwitterClient.tweet(post);
            	//}
            }                      
         }
      }
   }
}