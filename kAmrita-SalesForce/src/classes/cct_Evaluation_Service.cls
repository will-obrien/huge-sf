global with sharing class cct_Evaluation_Service implements cct_iEvaluation_Service{
        global static void evaluate(Set<ID> strategy){
            service().evaluate(strategy);
        }
        
        private static cct_iEvaluation_Service service()
        {
            return (cct_iEvaluation_Service) cct_Application.Service.newInstance(cct_iEvaluation_Service.class);
        }
}