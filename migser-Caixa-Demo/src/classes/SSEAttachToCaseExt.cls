global class SSEAttachToCaseExt {

    global SSEAttachToCaseExt(ApexPages.StandardController stdController) {
        //this.kAv = (KnowledgeArticleVersion)stdController.getRecord();
        //caseId = ApexPages.currentPage().getParameters().get('caseId');
    }


    @remoteAction
    global static List<String> getIds(String caseId) {
        List<CaseArticle> cAList = [select id, CaseId,KnowledgeArticleId from CaseArticle where CaseId =: caseId]; 
        List<String> listIds = new List<String>();

        for(CaseArticle cA : cAList) {
            listIds.add(cA.KnowledgeArticleId);
        }
        return listIds;
    } 


    global String getCaseId() {
        String caseId = ApexPages.currentPage().getParameters().get('caseId');
        return caseId;
    }


    @remoteAction
    global static void attachToCase(String artId, String cId) {
        CaseArticle cA = new CaseArticle(CaseId = cId, KnowledgeArticleId = artId);
        insert cA; 
    }

    @remoteAction
    global static void unAttachToCase(String artId, String caseId) {

        List<CaseArticle> cATmpL = [select id from CaseArticle where KnowledgeArticleId =: artId AND CaseId =: caseId limit 1];
        if(!cATmpL.isEmpty()) {
        	CaseArticle cA = cATmpL[0];
        	delete cA;
        }
    }
}