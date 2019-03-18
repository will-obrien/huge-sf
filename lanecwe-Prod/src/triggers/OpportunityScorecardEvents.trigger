trigger OpportunityScorecardEvents on GCS_Acq_Opportunity_Scorecard__c (before insert, before update) {
	if(Trigger.isBefore){
		if(Trigger.isInsert){
			OpportunityScorecardHelper.validateDuplicateOppScorecard(Trigger.new);
			Map<Id, Integer> mapTotalQuestionsAnswered = OpportunityScorecardHelper.countTotalScore(Trigger.new);
			OpportunityScorecardHelper.countCompletionPercent(Trigger.new,mapTotalQuestionsAnswered);
			OpportunityScorecardHelper.setOwner(Trigger.new);
		}
		else if (Trigger.isUpdate){
			Map<Id, Integer> mapTotalQuestionsAnswered = OpportunityScorecardHelper.countTotalScore(Trigger.new);
			OpportunityScorecardHelper.countCompletionPercent(Trigger.new,mapTotalQuestionsAnswered);
			OpportunityScorecardHelper.setOwner(Trigger.new);
		}
	}
}