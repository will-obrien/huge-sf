global with sharing class cct_Strategy_ServiceImpl implements cct_iStrategy_Service{
		global static void setStrategy(Set<ID> id, String productName, String strategyName, String evaluationCriterion){
		fflib_ISObjectUnitOfWork uow = cct_Application.UnitOfWork.newInstance();
		
		/*cct_iStrategy strategy = 
		(cct_iStrategy)cct_Application.Domain.newInstance(
								cct_Strategy_Selector.newInstance().selectById(id) );
								
		strategy.setStrategy(uow,name,evaluationCriterion);*/
		Stratergy__c strategy = new Stratergy__c();
		List<EvaluationCriterion__c> listOfCriterion = new List<EvaluationCriterion__c>();
		strategy.Name = strategyName;
		strategy.Name__c = productName;
		strategy.Description__c = evaluationCriterion;
		uow.registerNew(strategy);
		
		JSONParser parser = JSON.createParser(evaluationCriterion);
                            while (parser.nextToken() != null) {
                                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)){
                                    String fieldName = parser.getText();
                                    String fieldValue = null;
                                    parser.nextToken();
                                    if(fieldName == 'criteria'){
                                    	if(parser.getCurrentToken() == JSONToken.START_ARRAY){
                                    		while (parser.nextToken() != null) {
                                    			if(parser.getCurrentToken() == JSONToken.START_OBJECT){
                                    				EvaluationCriterion__c criteria = new EvaluationCriterion__c();
                                					criteria.Name = productName;
                                					criteria.Strategy_Name__c = strategyName;
                                    			while (parser.nextToken() != null) {
                                				if (parser.getCurrentToken() == JSONToken.FIELD_NAME){
                                					String field = parser.getText();
                                					parser.nextToken();
                                					
                                					if(field == 'Attribute'){
                                						criteria.Matching_Type__c = parser.getText();
                                					}
                                					else if(field == 'operator'){
                                						criteria.Operator__c = parser.getText();
                                					}
                                					else if(field == 'Value'){
                                						criteria.Matching_Value__c = parser.getText();
                                					}
                                					else if(field == 'Score'){
                                						criteria.Score__c = parser.getDecimalValue();
                                					}
                                					else if(field == 'Weightage'){
                                						criteria.Weight__c = parser.getDecimalValue();
                                					}
                                					
                                					
                                				}else if(parser.getCurrentToken() == JSONToken.END_OBJECT ){
                                						break;
                                					}
                                    		}
                                    		listOfCriterion.add(criteria);
                                    		}
                                    		}
                                    	}
                                    	else if(parser.getCurrentToken() == JSONToken.END_ARRAY){
                                    		break;
                                    	}
                                    }
                                }
                            }
                            uow.registerNew(listOfCriterion);
		uow.commitWork();
	}
}