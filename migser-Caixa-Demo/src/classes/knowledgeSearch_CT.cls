public with sharing class knowledgeSearch_CT {
 
    @AuraEnabled
    public static ArticlePagedResult searchAll(String searchKey, Decimal pageNumber) {
        Integer pageSize = 5;
        String key = '%' + searchKey + '%';
        Integer offset = ((Integer)pageNumber - 1) * pageSize;
        
        ArticlePagedResult a =  new ArticlePagedResult();
        a.pageSize = pageSize;
        a.page = (Integer) pageNumber;
        a.total = [SELECT count() FROM KnowledgeArticleVersion 
                      WHERE (title LIKE :key OR summary LIKE :key) AND (publishStatus = 'Online' AND language ='en_US') ];
        a.articles = [SELECT Id, title, summary, UrlName, articleType FROM KnowledgeArticleVersion 
                      WHERE (title LIKE :key OR summary LIKE :key) AND (publishStatus = 'Online' AND language ='en_US') LIMIT 5 OFFSET :offset];
        System.debug(a);
        return a;
    }
    
  
}