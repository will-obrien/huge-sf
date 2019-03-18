public class cct_Evaluate_Selector extends fflib_SObjectSelector implements cct_iEvaluate_Selector{
	
		public cct_Evaluate_Selector(){
			super(false);
		}
		public static cct_Evaluate_Selector newInstance()
                {
                    return (cct_Evaluate_Selector) cct_Application.Selector.newInstance(EvaluationCriterion__c.SObjectType);
                }

            public List<Schema.SObjectField> getSObjectFieldList()
            {
                return new List<Schema.SObjectField> {
                        EvaluationCriterion__c.Name,
                        EvaluationCriterion__c.Matching_Type__c,
                        EvaluationCriterion__c.Matching_Value__c,
                        EvaluationCriterion__c.Score__c,
                        EvaluationCriterion__c.Strategy_Name__c,
                        EvaluationCriterion__c.Weight__c,
                        EvaluationCriterion__c.Operator__c
                        
                    };
            }
        
            public Schema.SObjectType getSObjectType()
            {
                return EvaluationCriterion__c.sObjectType;
            }
        
            public List<EvaluationCriterion__c> selectByName(String name,String strategyName)
            {
                String query = newQueryFactory(false)
                .assertIsAccessible()
                .selectFields( this.getSObjectFieldList() )
                .setCondition('Name = :name AND Strategy_Name__c = :strategyName')
                .toSOQL();
        
                return Database.query( query );
            }  
            
            public List<StrategyEvaluator> selectByScore(String name, String strategyName){
            	
            	// write the logic to return list of normal java class objects
            	List<EvaluationCriterion__c> evaluationCriterion = Database.query(newQueryFactory(false)
                .assertIsAccessible()
                .selectFields( this.getSObjectFieldList() )
                .setCondition('Name = :name AND Strategy_Name__c = :strategyName')
                .toSOQL());
            		List<StrategyEvaluator> strategyEvaluator = new List<StrategyEvaluator>();
            		for(EvaluationCriterion__c criterion : evaluationCriterion){
            			StrategyEvaluator evaluator = new StrategyEvaluator();
            			evaluator.setName(criterion.Name);
            			evaluator.setMatchingType(criterion.Matching_Type__c);
            			evaluator.setMatchingValue(criterion.Matching_Value__c);
            			evaluator.setStrategyName(criterion.Strategy_Name__c);
            			evaluator.setScore(criterion.Score__c);
            			evaluator.setWeight(criterion.Weight__c);
            			evaluator.setOperator(criterion.Operator__c);
            			
            			strategyEvaluator.add(evaluator);
            		}
            	return strategyEvaluator;
            }
}