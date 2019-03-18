global with sharing class cct_Evaluation_ServiceImpl implements cct_iEvaluation_Service{
            global static void evaluate(Set<ID> strategy){
                fflib_ISObjectUnitOfWork uow = cct_Application.UnitOfWork.newInstance();
                //get the evaluation criterion object here and call the domain 
                
                cct_iEvaluate criterion = 
                (cct_iEvaluate)cct_Application.Domain.newInstance(
                                        cct_Strategy_Selector.newInstance().selectById(strategy) );
                criterion.evaluate(uow);
                uow.commitWork();
            }
            
}