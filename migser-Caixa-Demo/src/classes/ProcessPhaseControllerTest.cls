@isTest
private class ProcessPhaseControllerTest {

    static testMethod void opportunityPhaseTest() {
        Opportunity opp = new Opportunity(Name = 'MyOpp', CloseDate=Date.today());
        List<OpportunityStage> stageNameList = [select MasterLabel from OpportunityStage];
        if(stageNameList!=null && stageNameList.size()>0){
            opp.StageName = stageNameList.get(0).MasterLabel;
        }
        insert opp; 
        Test.startTest();
        List<ProcessPhaseController.PhaseContainer> phList1 = ProcessPhaseController.getPhaseList('Opportunity', 'StageName', opp.Id);
        List<ProcessPhaseController.PhaseContainer> phList2 = ProcessPhaseController.getPhaseList('Opportunity', 'RecordType', opp.Id);
        System.assert(phList1.size()>0);
        Test.stopTest();
    }    
}