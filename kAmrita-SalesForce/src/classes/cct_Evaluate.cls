public class cct_Evaluate  extends fflib_SObjectDomain  implements cct_iEvaluate{
            public static cct_iEvaluate newInstance(List<Stratergy__c> sObjectList)
            {
                return (cct_iEvaluate) cct_Application.Domain.newInstance(sObjectList);
            }

            public cct_Evaluate(List<Stratergy__c> sObjectList)
            {
                super(sObjectList);
            }
            
            private Boolean checkCriterionValue(String value1, String operator, String value2){
            	Integer v1 = Integer.ValueOf(value1);
            	Integer v2 = Integer.ValueOf(value2);
            	if(operator == '>'){
            		if(v1>v2){
            			return true;
            		}
            	}else if(operator == '<'){
            		if(v1<v2){
            			return true;
            		}
            	}else if(operator == '>='){
            		if(v1>=v2){
            			return true;
            		}
            	}else if(operator == '<='){
            		if(v1<=v2){
            			return true;
            		}
            	}else if(operator == '='){
            		if(v1 == v2){
            			return true;
            		}
            	}else if(operator == '!='){
            		if(v1 != v2){
            			return true;
            		}
            	}
            	
            	return false;
            }
                
            public void evaluate(fflib_ISObjectUnitOfWork uow){
                String evaluation = null;
                Decimal score = 0.00;
                String name = null;
                String strategyName = null;
                
                for(Stratergy__c strategy : (List<Stratergy__c>)Records){
                    strategyName = strategy.Name;
                    name = strategy.Name__c;
                }
                
                //get the product selling details in a map
                List<Product__c> productsList = ((cct_iProduct_Selector)cct_Application.Selector.newInstance(Product__c.sobjectType)).selectByName(name);
               // List<EvaluationCriterion__c> evaluationCriterionList = ((cct_iEvaluate_Selector)cct_Application.Selector.newInstance(EvaluationCriterion__c.sobjectType)).selectByName(name,strategyName);
                 cct_Evaluate_Selector selector = new cct_Evaluate_Selector();
                 List<StrategyEvaluator> evaluationCriterionList = selector.selectByScore(name,strategyName);
                    for(Product__c product : productsList){
                        if(product.Name.equals(name)){
                            evaluation = product.SellingCriterion__c;
                            JSONParser parser = JSON.createParser(evaluation);
                            while (parser.nextToken() != null) {
                                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                                    String fieldName = parser.getText();
                                    String fieldValue = null;
                                    parser.nextToken();
                                   
                                     for(StrategyEvaluator criterion : evaluationCriterionList){
                                        if(criterion.getName().equals(name) && criterion.getStrategyName().equals(strategyName)){
                                            if(criterion.getMatchingType().equalsIgnoreCase(fieldName)){
                                                fieldValue = parser.getText();
                                                Boolean isValueValid = checkCriterionValue(criterion.getMatchingValue(),criterion.getOperator(),fieldValue);
                                                if(isValueValid){
                                                    score += criterion.getScore()*criterion.getWeight();
                                                }
                                            }
                                        }
                                       
                                    }
                                }
                            }
                            product.ScoreCard__c = ''+strategyName+' : '+score;
                            uow.registerDirty(product);
                        }
                    }
                   
            }
            public class Constructor implements fflib_SObjectDomain.IConstructable
                {
                    public fflib_SObjectDomain construct(List<SObject> sObjectList)
                    {
                        return new cct_Evaluate(sObjectList);
                    }
                }
}