global with sharing class cct_Strategy_Service implements cct_iStrategy_Service {
		
		global static void setStrategy(Set<ID> id, String productName, String strategyName, String evaluationCrriterion){
			service().setStrategy(id, productName, strategyName, evaluationCrriterion);
		}
		
		
		
		private static cct_iStrategy_Service service()
			{
				return (cct_iStrategy_Service) cct_Application.Service.newInstance(cct_iStrategy_Service.class);
			}
}