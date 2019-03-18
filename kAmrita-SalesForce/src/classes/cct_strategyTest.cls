@isTest
public class cct_strategyTest {
	@isTest static void testEvaluate(){
		// Implement test code

		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
		
		// Given
		Product__c prod1 = cct_ObjectCreator.createProduct();
		EvaluationCriterion__c eval1 = cct_ObjectCreator.createEvaluationCriterion();
		Stratergy__c strategy1 = cct_ObjectCreator.createStrategy();
		
		List<Stratergy__c> testSList = new List<Stratergy__c> { strategy1 };
		cct_Application.UnitOfWork.setMock(uowMock);
		
		// When
		cct_iEvaluate strategies = cct_Evaluate.newInstance(testSList);
		strategies.evaluate(uowMock);
		
		
		// Then
		((fflib_ISObjectUnitOfWork) 
				mocks.verify(uowMock, 0)).registerDirty(strategy1);
        	System.debug(strategy1.Name__c);
			System.assertEquals('Car Loan', strategy1.Name__c);
	}
}