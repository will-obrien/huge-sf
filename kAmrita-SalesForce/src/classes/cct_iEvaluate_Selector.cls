public interface cct_iEvaluate_Selector {
		 List<EvaluationCriterion__c> selectByName(String name,String strategyName);
		 List<StrategyEvaluator> selectByScore(String name, String strategyName);
}