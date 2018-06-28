global class StrategyWebService{
    
        global class StrategyDetail{
            webservice String productName;
            webservice String strategyName;
            webservice String evaluationCriterion;
        }
        
        webservice static StrategyDetail getDetails(StrategyDetail strategyDetail){
           // call the StrategyServiceController
           Set<ID> ids = new Set<Id>();
          
            cct_Strategy_Service.setStrategy(ids,strategyDetail.productName,strategyDetail.strategyName,strategyDetail.evaluationCriterion);
            
            
            
            
            return strategyDetail;
        }
}