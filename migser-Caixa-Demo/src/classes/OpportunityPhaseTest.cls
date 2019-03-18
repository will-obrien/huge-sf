@isTest
private class OpportunityPhaseTest{
    static testMethod void opportunityPhaseTest() {
        Opportunity opp = new Opportunity(Name = 'test opp', CloseDate=Date.today());
        
        List<OpportunityStage> stageNameList = [select MasterLabel from OpportunityStage 
            where IsActive=true and DefaultProbability!=null and DefaultProbability!=0.0];
        if(stageNameList!=null && stageNameList.size()>0){
            opp.StageName = stageNameList.get(0).MasterLabel;
        }
        upsert opp;
        
        ApexPages.StandardController sc = new ApexPages.standardController(opp);
        OpportunityPhaseController ctrl = new OpportunityPhaseController(sc);
        System.assertEquals(stageNameList.size(), OpportunityPhaseController.getPhaseList('currentPhase').size());
    }    
}