@isTest(SeeAllData=true)
public class TestSSEArticleList {

	static testMethod void testArticleCase() {
		
		Case c = [select id from Case where id =: '500G000000L3t4N'];

		KnowledgeArticle art = [select id from KnowledgeArticle where id=: 'kA0G0000000TrYV'];

	    ApexPages.currentPage().getParameters().put('caseId', c.Id);

		Test.startTest();


			// List<String> getIds(String caseId) {
			// global String getCaseId() {
			// attachToCase(String artId, String cId) {	
			// unAttachToCase(String artId, String caseId) {	

			List<String> idList = SSEAttachToCaseExt.getIds(c.Id);
			SSEAttachToCaseExt.attachToCase(art.Id,c.Id);
			SSEAttachToCaseExt.unAttachToCase(art.Id,c.Id);


		Test.stopTest();
	}
}