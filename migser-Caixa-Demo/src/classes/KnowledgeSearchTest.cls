@isTest
private class KnowledgeSearchTest {
    static testMethod void myTest() {
        ArticlePagedResult result = knowledgeSearch_CT.searchAll('', 1);
        System.assert(result != null);
     }
}