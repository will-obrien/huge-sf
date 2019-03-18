public class CommunityArticleCommentsCtrl {
    
    @AuraEnabled
    public static List<SObject> getArticleFeedItems(String title,String theUrl) {
        List<SObject> fList = new List<SObject>();
        //parse theUrl
        System.debug(theUrl);
        Boolean isArticle = theUrl.contains('article');
        if(isArticle) {
            System.debug('lets do it: '+title);
            List<KnowledgeArticleVersion> kList = [SELECT ArticleType,Id,KnowledgeArticleId,Title,UrlName FROM KnowledgeArticleVersion 
                                                   WHERE PublishStatus = 'Online' AND Language = 'en_US' AND UrlName=:title];
            if(kList != null && kList.size() > 0) {
                System.debug('kList: '+title);
                KnowledgeArticleVersion ka = kList.get(0);
                Id theId = ka.KnowledgeArticleId;
                //Pull from specific article feed table
                String aType = ka.ArticleType;
                String obj = aType.replace('__kav', '__Feed');
                fList = Database.query('SELECT Body,ContentType,Id,InsertedById,InsertedBy.Name,CreatedDate,ParentId,Title,Type From '+obj+' WHERE Type =\'TextPost\' AND ParentId = \''+theId+'\' ORDER BY CreatedDate DESC Limit 3');
                
                
                return fList;
            }
        }
        
        return fList;
    }
    
    @AuraEnabled
    public static void postToChatter(String comment, String title) {
        //get id for article from title
        System.debug('post to chatter');
        List<KnowledgeArticleVersion> kList = [SELECT Id,KnowledgeArticleId,ArticleType FROM KnowledgeArticleVersion 
                                               WHERE PublishStatus = 'Online' AND Language = 'en_US' AND UrlName=:title];
        if(kList != null && kList.size() > 0) {
            System.debug('found article');
            KnowledgeArticleVersion ka = kList.get(0);
            if(comment.length() > 0){
                FeedItem post = new FeedItem();
                post.ParentId = ka.KnowledgeArticleId;
                post.Body = comment;
                post.Visibility = 'AllUsers';
                
                
                try{
                    insert post;
                } catch(Exception e) {
                    System.debug(e.getMessage());
                }
            }
        }
        
    }
}