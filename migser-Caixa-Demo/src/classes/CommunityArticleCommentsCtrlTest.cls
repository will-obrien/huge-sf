@isTest(SeeAllData=true)
public class CommunityArticleCommentsCtrlTest {

    public static testmethod void controllerTest() {
        List<KnowledgeArticleVersion> kList = [SELECT ArticleType,Id,KnowledgeArticleId,Title,UrlName FROM KnowledgeArticleVersion 
                                                   WHERE PublishStatus = 'Online' AND Language = 'en_US'];
        KnowledgeArticleVersion k = kList.get(0);
        String urlName = k.UrlName;
        CommunityArticleCommentsCtrl.getArticleFeedItems(urlName, '/article/test');
        CommunityArticleCommentsCtrl.postToChatter('test', urlName);
        
    }
    
    
}