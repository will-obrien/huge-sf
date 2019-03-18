global class OpportunityPhaseController{    
    public OpportunityPhaseController(ApexPages.StandardController stdController){
    }
        
    @RemoteAction
    global static List<PhaseContainer> getPhaseList(String currentPhase) {
        List<PhaseContainer> phaseList = new List<PhaseContainer>();
        for(OpportunityStage os : [select MasterLabel from OpportunityStage 
            where IsActive=true and DefaultProbability!=null and DefaultProbability!=0.0 order by SortOrder]){
            phaseList.add(new PhaseContainer(os.MasterLabel, os.MasterLabel.equals(currentPhase)));
        }
        return phaseList;
    }
    
    global class PhaseContainer{
        public String phase{get; set;}
        public Boolean isActive{get; set;}
        public PhaseContainer(String phase, Boolean isActive){
            this.phase = phase;
            this.isActive = isActive;
        }
        
    }
}